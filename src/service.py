#!/usr/bin/python3
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

import core.email_object

import core.database as database

from dbus.mainloop.glib import DBusGMainLoop

from gi.repository import GLib

BUS_NAME = "eu.medesimo.thesis"
BUS = dbus.SessionBus
DATABASE_PATH = "./database.db"

class MainService(core.objects.BaseObject):
	
	"""
	This is the DBus service.
	"""
	
	path = "/eu/medesimo/thesis"
	
	current = {}
	
	def __init__(self):
		"""
		Initializes the object.
		"""
		
		self.bus_name = dbus.service.BusName(
			BUS_NAME,
			bus=BUS()
		)
		
		super().__init__(self.bus_name)
		
		# Open the database
		self.db = database.Database(DATABASE_PATH)
		
		self.update_accounts()
	
	@dbus.service.signal(
		"eu.medesimo.thesis",
		signature="i"
	)
	def NewEmail(self, id):
		"""
		Signal emitted whenever a new email has arrived.
		"""
		
		pass
	
	def add_email(self, email, caller):
		"""
		Adds an email to the database.
		"""
		
		# Get caller id
		id = self.get_account_id(caller)

		content = email.get_payload() if not email.is_multipart() else email.get_payload()[0]
		if type(content) != str: content = content.as_string()

		print(id)
		print(email)
		print(type(email["From"]))
		print(type(content))

		self.db.insert(
				"Emails",
				Account=id,
				Title=email["Subject"] if email["Subject"] else "",
				Content=content if content else "",
				Sender=email["From"],
				Read=False,
				Date=email["Date"]
		)
		last_id = self.db.get_last_rowid()
		self.db.commit()

		# Fire signal
		self.NewEmail(last_id)
		
		
		#try:
		#	self.db.insert(
		#		"Email",
		#		id,
		#		email["Subject"],
		#		email.get_payload() if not email.is_multipart() else email.get_payload()[0],
		#		email["From"],
		#		False,
		#		None
		#	)
		#except:
		#	pass
	
	def update_accounts(self):
		"""
		Generates EmailBoxes for the accounts in the database.
		"""
		
		for account in self.get_accounts():
			if account["Name"] in self.current:
				# Already present
				continue
			
			print("Creating object for account %s" % account["Name"])
			
			self.current[account["Name"]] = core.email_object.EmailBox(
				self,
				self.bus_name,
				self.get_servertype_type(account["Type"]),
				account
			)
	
	def get_account_id(self, account):
		"""
		Returns the account id.
		"""
		
		id = self.db.select(
			"Accounts",
			attributes="ID",
			conditions=database.EqualCondition("Name", account)
		).fetchone()
		
		return None if not id else id[0]
	
	def get_servertype_id(self, servertype):
		"""
		Returns the ServerType ID given a type.
		"""
		
		real = self.db.select(
			"ServerType",
			attributes="ID",
			conditions=database.EqualCondition("Type", servertype)
		).fetchone()
		
		return None if not real else real[0]
	
	def get_servertype_type(self, id):
		"""
		Returns the ServerType string given an id.
		"""
		
		servertype = self.db.select(
			"ServerType",
			attributes="Type",
			conditions=database.EqualCondition("ID", id)
		).fetchone()
		
		return None if not servertype else servertype[0]

	def get_accounts(self):
		"""
		Returns a list of available accounts with all required informations.
		
		NOTE: This returns also login data, so it's not exported via DBus.
		"""
		
		columns = ("Name", "Address", "Server", "Username", "Password", "Port", "Type", "SSL")
		
		result = []
		
		for row in self.db.select("Accounts", attributes=columns):
			dct = {}
			for num in range(len(columns)):
				dct[columns[num]] = row[num]
			
			result.append(dct)
		
		return result
	
	@dbus.service.method(
		"eu.medesimo.thesis",
		out_signature="a{si}"
	)
	def GetServerTypes(self):
		"""
		Returns a dictionary of server types, where the key is the Type Description
		and the value is the numeric ID.
		"""
		
		return {key: value for key, value in self.db.select("ServerType", attributes=("Type", "ID"))}

	@dbus.service.method(
		"eu.medesimo.thesis",
		in_signature="sssssisb",
		out_signature="b"
	)
	def AddAccount(self, name, address, server, username, password, port, servertype, ssl):
		"""
		Adds an account.
		
		Returns True if everything suceeded, False otherwise.
		"""
		
		# Get the type id
		servertype_real = self.get_servertype_id(servertype)
		
		if not servertype_real:
			return False
	
		# Finally insert
		try:
			self.db.insert(
				"Accounts",
				Name=name,
				Address=address,
				Server=server,
				Username=username,
				Password=password,
				Port=port,
				Type=servertype_real,
				SSL=ssl
			)
		except:
			return False
		
		# Save
		self.db.commit()
		
		self.update_accounts()
		return True
	
	@dbus.service.method(
		"eu.medesimo.thesis",
		in_signature="i",
		out_signature="as" # Returning an array is _not_ the best decision to make, but it's simpler to handle in the other side
	)
	def GetEmailDetails(self, id):
		"""
		Given an e-mail id, returns its details.
		"""
		
		return self.db.select(
			"Emails",
			attributes=("Title", "Sender", "Content", "Date"),
			conditions=database.EqualCondition("ID", id)
		).fetchone()
	
	@dbus.service.method(
		"eu.medesimo.thesis",
		out_signature="a(ss)"
	)
	def GetAccounts(self):
		"""
		Returns a list of accounts, by name.
		"""
		
		return [(x["Name"], x["Address"]) for x in self.get_accounts()]
	
	@dbus.service.method(
		"eu.medesimo.thesis"
	)
	def CheckAll(self):
		"""
		Checks an email on all accounts.
		"""
				
		for account in self.current:
			self.current[account].Check()
	
	@dbus.service.method(
		"eu.medesimo.thesis",
		out_signature="s"
	)
	def return_string(self):
		"""
		Returns a string.
		"""
		
		return "Ciao!"

if __name__ == "__main__":
	
	DBusGMainLoop(set_as_default=True)
	clss = MainService()
	
	GLib.MainLoop().run()
