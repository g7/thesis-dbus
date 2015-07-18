/*
* thesis-dbus - thesis on DBus by Eugenio "g7" Paolantonio
* Copyright (C) 2015  Eugenio "g7" Paolantonio <me@medesimo.eu>
*
* This program is free software and it's distributed under the terms of
* the Creative Commons Attribution-ShareAlike 4.0 International License.
*
* For more details, see the toplevel file COPYING or
* http://creativecommons.org/licenses/by-sa/4.0/
*
* Authors:
*    Eugenio "g7" Paolantonio <me@medesimo.eu>
*/

CREATE TABLE Accounts (
	ID INTEGER PRIMARY KEY NOT NULL,
	Name VARCHAR(50) NOT NULL,
	Address VARCHAR(50) NOT NULL,
	Server VARCHAR(50) NOT NULL,
	Username VARCHAR(50) NOT NULL,
	Password VARCHAR(200) NOT NULL,
	Port int NOT NULL,
	Type int references ServerType(ID) NOT NULL,
	SSL BOOLEAN NOT NULL
);

CREATE TABLE ServerType (
	ID INTEGER PRIMARY KEY NOT NULL,
	Type VARCHAR(50) NOT NULL
);

CREATE TABLE Emails (
	ID INTEGER PRIMARY KEY NOT NULL,
	Account int references Accounts(ID) NOT NULL,
	Title VARCHAR(50) NOT NULL,
	Content TEXT NOT NULL,
	Sender VARCHAR(50) NOT NULL,
	Read BOOLEAN NOT NULL,
	Date DATE NOT NULL
);

/* Sample data */
INSERT INTO ServerType (Type) VALUES ("IMAP");
INSERT INTO ServerType (Type) VALUES ("POP3");
INSERT INTO ServerType (Type) VALUES ("MOCK");

/* Mock account */
INSERT INTO Accounts (Name,Address,Server,Username,Password,Port,Type,SSL)
VALUES ("MockAccount1", "ser@ver", "ser.ver", "hey", "ya", "120", 3, 0);
