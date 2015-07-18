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

TARGET = "ipc-with-dbus_eugenio-paolantonio_snapshot"

TARGET_ZIP = "ipc-with-dbus_eugenio-paolantonio_snapshot_full"

TARGET_SPELLCHECK = "spellcheck"

COVER = "cover.md"

PAGES = \
	italian_introduction.md \
	introduction.md \
	project.md \
	python.md \
	database.md \
	interfacing_database.md \
	service.md \
	email.md \
	vala.md \
	client.md \
	links.md

CSS = "style.css"

pdf: clean
	mkdir -p build
	
	cp -R img/ build
	
	count=0; \
	for file in $(PAGES); do \
		if [ "$$count" -lt "10" ]; then target_count="0$$count"; else target_count=$$count; fi; \
		cp $$file $$(printf "%s%s" build/page$$target_count ".md"); \
		count=$$(($$count+1)); \
	done
	
	gimli \
	-merge \
	-stylesheet $(CSS) \
	-outputfilename $(TARGET) \
	-w '--toc --footer-right "Page [page] of [toPage]"' \
	-recursive \
	-file ./build/ \
	-cover $(COVER) 

spellcheck:
	echo -n "" > $(TARGET_SPELLCHECK).md
	for file in $(PAGES); do \
		echo "\n\n\n$$file\n==========" >> $(TARGET_SPELLCHECK).md; \
		spell $$file >> $(TARGET_SPELLCHECK).md; \
	done

zip:
	zip -r $(TARGET_ZIP).zip . -x build/\* $(TARGET).pdf

clean:
	-rm -rf build
	-rm -rf $(TARGET_SPELLCHECK).md
	-rm -rf $(TARGET).pdf
	-rm -rf $(TARGET_ZIP).zip

all: pdf zip
