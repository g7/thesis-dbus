Summary of the project
======================

In order to demonstrate D-Bus' capabilities, in this thesis I'll create 
a simple e-mail service that will download e-mails in the background and send
appropriate signals to connected clients whenever a new e-mail has been downloaded.

During the course of this document I'll also describe how the various programming languages
chosen work.

Service design
--------------

The service is the only piece of the application that is actually connected to the Internet.  
It checks for new e-mails and, if any, it will download them in the background.

The service is also the only part of the project that talks to the database.  
Information sharing (new e-mails signals, e-mail content and titles, etc) are shared via DBus.

### Language of choice

I chose [Python](http://python.org) to implement this service. The reasons of this choice are many:

 * It provides an easy-to-use and well-maintained IMAP library
 * The design of the language permits to create full featured applications using less code,
 thus reducing the number of possible bugs and having a cleaner codebase
 * It enforces indentation ("pretty-printing") resulting in a easier to read codebase
 * There are SQLite and DBus bindings for it
 * The majority of GNU/Linux distributions out there ship it by default
 * Last but not least, the author has lots of experience with it :)

### Database of choice

I chose [SQLite](http://sqlite.org) as the DBMS to use for this project.  
SQLite is lightweight and doesn't require a background server like [MySQL](http://mysql.org) or [MariaDB](http://mariadb.org) do.

SQLite database are stored in files and can be moved from a machine to another without problems.  
I think it's the best database to use for this simple project.

Client design
-------------

The client connects to the service and reacts to its signals to notify and show
newly downloaded e-mails.

### Language of choice

I decided to use [Vala](https://wiki.gnome.org/Projects/Vala/) for the client mainly
to show how D-Bus is language (and implementation) independent.

Vala is a new programming language that leverages the power of C and the GObject type system using
a syntax similar to C#.

Code written in Vala gets "translated" in C before the actual compilation and this permitted the
language designers to ease some tasks that would not be possible to simplify in a generic compiled or
interpreted programming language.

For this reason, Vala has, in my opinion, one of the best D-Bus implementations out there, leveraging the
GDBus bindings of [glib](https://developer.gnome.org/glib/).

### UI toolkit

Given the usage of Vala, the user interface of the client will use the [GTK+](http://gtk.org) UI toolkit.
