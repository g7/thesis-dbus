Thesis on DBus - Eugenio Paolantonio
====================================

This repository contains the source code of the thesis I made for my 2015 High School exams,
taken at the ITT "Leonardo da Vinci" of Viterbo.

Pre-requisites
--------------

To generate the pdf:

* make
* [gimli](https://github.com/walle/gimli)
* ispell (for spellchecking, not required)

To use the DBus service:

* Python 3 (tested on 3.4)
* python3-dbus
* [faker](https://github.com/joke2k/faker) (Required to generate fake emails for demo purposes)
* sqlite3

To compile the client:

* make
* valac (tested with valac-0.26)
* Gtk+ 3.0 (3.10+)

Generate the pdf
----------------

Execute

	make pdf

to generate the pdf. It's possible to create a zipfile containing both the pdf
and the source code with

	make zip

To spellcheck, issue

	make spellcheck

Launch the service
------------------

The service is contained into the `src/` directory.  
You may first need to create the database. You can do so with

	cd src/
	sqlite3 database.db < setup.sql

To actually launch the service, use

	python3 ./service.py

Compile the client
------------------

The client is contained into the `src/client` directory. You can use make to compile it:

	cd src/client
	make

The target executable is named `thesis_client`.

Compile the examples
--------------------

The examples written in python (`examples/python`) do not require compilation.

To compile the examples written in vala, you can use make:

	cd examples/vala
	make

