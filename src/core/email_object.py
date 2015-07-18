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

import dbus

import core.objects
import core.email

types = {
	"IMAP":core.email.ImapEmail,
	"MOCK":core.email.MockEmail
}

class EmailBox(core.objects.BaseObject):
	
	"""
	An EmailBox() represents an e-mail address.
	"""
		
	def __init__(self, service, bus_name, typ, infos):
		"""
		Initializes the class.
		"""
		
		self.path = "/eu/medesimo/thesis/%s" % infos["Name"]
		
		super().__init__(bus_name)
		
		self.service = service
		self.typ = typ
		self.infos = infos
		
		# Create proper email fetcher object
		self.fetcher = types[typ](infos)
	
	@dbus.service.method(
		"eu.medesimo.thesis.email"
	)
	def Check(self):
		"""
		Checks for new e-mails.
		"""
		
		new_emails = self.fetcher.check()
		
		for email in new_emails:
			self.service.add_email(email, self.infos["Name"])
	
	@dbus.service.method(
		"eu.medesimo.thesis.email",
		out_signature="b"
	)
	def GetStatus(self):
		"""
		Returns the Status of the emailbox.
		"""
		
		return self.fetcher.status
