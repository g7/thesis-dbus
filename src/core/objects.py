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

# This file contains the base object of the service.

import dbus
import dbus.service

from gi.repository import GLib, Polkit

class BaseObject(dbus.service.Object):
	"""
	A base object!
	"""
	
	# The DBus object path
	path = "/eu/medesimo/thesis"
	
	# The DBus interface name
	interface_name = "eu.medesimo.thesis"

	def __init__(self, bus_name):
		"""
		Initializes the object.
		"""
		
		super().__init__(bus_name, self.path)
