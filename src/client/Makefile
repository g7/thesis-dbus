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

SOURCES = \
	common.vala \
	interface.vala \
	add_account.vala \
	window.vala \
	client.vala

TARGET = thesis_client

VALACC_OPTIONS = --target-glib=2.32

all: client

client:
	valac --thread $(VALACC_OPTIONS) --pkg pango --pkg glib-2.0 --pkg gio-2.0 --pkg gtk+-3.0 $(SOURCES) -o $(TARGET)

clean:
	-rm $(TARGET)
