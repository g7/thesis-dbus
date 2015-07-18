# -*- coding: utf-8 -*-
#
# thesis-dbus - thesis on DBus by Eugenio "g7" Paolantonio
# Copyright (C) 2015  Eugenio "g7" Paolantonio <me@medesimo.eu>
#
# This program is free software and it's distributed under the terms of
# the Creative Commons Attribution-ShareAlike 4.0 International License.
#
# For more details, see the toplevel file COPYING or
# http://creativecommons.org/licenses/by-sa/4.0/
#
# Authors:
#    Eugenio "g7" Paolantonio <me@medesimo.eu>
#

# This module contains support email classes.

from gi.repository import GObject

import imaplib

import random

import email
import email.utils
import email.mime.text

import datetime
import time

from faker import Factory
fake = Factory.create()

class BaseEmail(GObject.Object):
	
	"""
	The BaseEmail class provides the basic plumbing for the email handling
	on the DBus server.
	
	It's not meant to be used directly: use the ImapEmail or MockEmail subclasses
	instead.
	"""
	
	def __init__(self, infos):
		"""
		Initializes the class.
		"""
		
		super().__init__()
		
		self.infos = infos
		self.status = False
	
	def check(self):
		"""
		Override this method with instructions to execute the email check.
		"""
		
		return []

class ImapEmail(BaseEmail):
	
	"""
	The ImapEmail class provides an easy way to access to an IMAP server.
	"""
		
	def check(self):
		"""
		Checks for e-mails.
		"""

		# Login
		try:
			self.imap = (imaplib.IMAP4_SSL if self.infos["SSL"] else imaplib.IMAP4)(host=self.infos["Server"], port=self.infos["Port"])

			self.imap.login(self.infos["Username"], self.infos["Password"])
			
			self.status = True
		except imaplib.IMAP4.error:
			# DOH
			print("Unable to login :(")
			return
		
		new_mails = []
				
		self.imap.select(readonly=True)
		result, messages = self.imap.search(None, "(UNSEEN)")
		if result == "OK":
			# New emails!
			print(messages)
			for id in messages[0].split():
				typ, data = self.imap.fetch(id, '(RFC822)')
				new_mails.append(email.message_from_bytes(data[0][1]))

		self.imap.close()
		self.imap.logout()
		
		return new_mails

class MockEmail(BaseEmail):
	
	"""
	The MockEmail class provides a nice way to test the server functionality
	without actually downloading e-mails from a real server.
	"""
	
	def __init__(self, infos):
		"""
		Initializes the class.
		"""
		
		super().__init__(infos)
	
	def check(self):
		"""
		Generate e-mails on-the-fly for testing purposes.
		"""
		
		# Create fake emails
		new_mails = []
		for count in range(0, random.randint(1, 6)):
			msg = email.mime.text.MIMEText("\n".join(fake.paragraphs(random.randint(1, 6))))
			
			msg["Subject"] = fake.sentence(3)
			msg["From"] = fake.email()
			msg["Date"] = email.utils.formatdate(time.mktime(datetime.datetime.now().timetuple()))
			
			new_mails.append(msg)
		
		return new_mails
		
