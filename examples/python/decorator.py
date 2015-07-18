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

def my_decorator(function_to_decorate):

	def wrapper():
		
		print("This is part of the decorator!")
		function_to_decorate()
		print("This is still part of the decorator!")
	
	return wrapper

@my_decorator
def do_things():
	print("I'm doing something!")

do_things()
