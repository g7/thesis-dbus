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

import sqlite3

class DatabaseCondition:
	
	"""
	A DatabaseCondition() object provides a base condition.
	"""
	
	def __init__(self):
		
		pass
	
	def format_condition(self):
		
		return "", []
	
class EqualCondition(DatabaseCondition):
	
	"""
	An Equal condition.
	"""
	
	def __init__(self, attribute, target, sanitize=True):
		
		self.attribute = attribute
		self.target = target
		self.sanitize = sanitize
	
	def format_condition(self):
		
		if self.sanitize:
			return "%s=?" % self.attribute, [self.target]
		else:
			return "%s=%s" % (self.attribute, self.target), []

class AttributeEqualCondition(EqualCondition):
	
	"""
	An unsanitized EqualCondition.
	
	It's the equivalent of creating EqualCondition with sanitize=False.
	"""
	
	def __init__(self, attribute, target):
		
		super().__init__(attribute, target, sanitize=False)

class AndCondition(DatabaseCondition):
	
	"""
	AND
	"""
	
	def __init__(self, *args):
		
		self.args = args
	
	def format_condition(self):
		
		result_query = []
		tuple_list = []
		
		for condition in self.args:
			result, tple = condition.format_condition()
			
			result_query.append("(%s)" % result)
			tuple_list += tple
		
		return " AND ".join(result_query), tuple_list

class OrCondition(DatabaseCondition):
	
	"""
	OR
	"""
	
	def __init__(self, *args):
		
		self.args = args
	
	def format_condition(self):
		
		result_query = []
		tuple_list = []
		
		for condition in self.args:
			result, tple = condition.format_condition()
			
			result_query.append("(%s)" % result)
			tuple_list += tple
		
		return " OR ".join(result_query), tuple_list

class Database:
	
	"""
	A Database() object provides an easy way to interface with an sqlite3
	database, in a pythonic way.
	"""
	
	def __init__(self, path):
		"""
		Initializes the class.
		"""
		
		self.path = path
		self.connection = sqlite3.connect(self.path)
		
		# Get cursor
		self.cursor = self.connection.cursor()
	
	def select(self, tables, attributes=["*"], conditions=None, group_by=None, order_by=None):
		"""
		The select() method permits to select a tuple.
		
		NOTE: Conditions are sanitized-by-design (using the DatabaseCondition format): attributes
		and tables are not, because SQLite doesn't permit it.
		As attributes and table names are given programmatically, this shouldn't be an issue.
		"""
		
		result_query = []
		tuple_list = []
		
		# Parse attributes
		if type(attributes) == str:
			# The attribute is a string, so create a list around it...
			attributes = [attributes]
		
		result_query.append("SELECT %s" % ",".join(attributes))
		
		# Tables
		if type(tables) == str:
			# The attribute is a string, so create a list around it...
			tables = [tables]
		
		result_query.append("FROM %s" % ",".join(tables))
		
		# Conditions
		if conditions:
			result_query.append("WHERE")
			
			result, tple = conditions.format_condition()
			result_query.append("(%s)" % result)
			tuple_list += tple
		
		print (" ".join(result_query), tuple_list)
		return self.cursor.execute(" ".join(result_query), tuple_list)
	
	def get_last_rowid(self):
		"""
		Returns the last rowid inserted.
		"""
		
		return self.cursor.execute("SELECT last_insert_rowid()").fetchone()[0]
	
	def insert(self, table, **kwargs):
		"""
		The insert() method permits to insert a tuple into the database.
		
		Example:
			self.insert("Table", Attribute1="Hello", Attribute2="Hey")
		"""
		
		# This is why I love python
		
		print("INSERT INTO %(table)s (%(columns)s) VALUES (%(values)s)" %
				{"table":table, "columns":",".join(kwargs.keys()), "values":",".join(["?" for x in kwargs.values()])})
		
		return self.cursor.execute(
			"INSERT INTO %(table)s (%(columns)s) VALUES (%(values)s)" %
				{"table":table, "columns":",".join(kwargs.keys()), "values":",".join(["?" for x in kwargs.values()])},
			list(kwargs.values())
		)
	
	def commit(self):
		"""
		Saves the changes.
		"""
		
		self.connection.commit()
	
	def __del__(self):
		
		self.connection.close()
