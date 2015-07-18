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

HELLOWORLD_SOURCES = \
	helloworld.vala

HELLOWORLD_TARGET = helloworld

HELLOWORLD_CLASS_SOURCES = \
	helloworld-class.vala

HELLOWORLD_CLASS_TARGET = helloworld-class

all: helloworld helloworld-class

clean: helloworld-clean helloworld-class-clean

helloworld:
	valac $(HELLOWORLD_SOURCES) -o $(HELLOWORLD_TARGET)

helloworld-clean:
	-rm $(HELLOWORLD_TARGET)

helloworld-class:
	valac $(HELLOWORLD_CLASS_SOURCES) -o $(HELLOWORLD_CLASS_TARGET)

helloworld-class-clean:
	-rm $(HELLOWORLD_CLASS_TARGET)
