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

import core.database

from core.database import Database, OrCondition, AndCondition, AttributeEqualCondition, EqualCondition

db = Database("/home/g7/tesina/src/database.db")

db.select(
	["Accounts", "ServerType"],
	attributes=["Accounts.Name", "ServerType.Type"],
	conditions=OrCondition(
		AttributeEqualCondition("Accounts.Type", "ServerType.ID"),
		EqualCondition("Accounts.Username", "g7")
	)
)

db.select(
	["Tabella1", "Tabella2"],
	attributes=["Column1", "Column2", "Column3"],
	conditions=core.database.AndCondition(
		core.database.AttributeEqualCondition("Tabella2.ID_Tabella1", "Tabella1.ID"),
		core.database.EqualCondition("attribute", "hello"),
		core.database.AndCondition(
			core.database.EqualCondition("Hey", "Yay"),
			core.database.EqualCondition("BOH", "BUM")
		)
	)
)
