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

namespace Thesis {

	[DBus (name = "eu.medesimo.thesis")]
	public interface ThesisInterface : Object {
		
		/**
		 * DBus interface to the thesis service.
		*/
		
		public signal void NewEmail(int id);
		
		public abstract void AddAccount(
			string name,
			string address,
			string server,
			string username,
			string password,
			int port,
			string servertype,
			bool ssl
		) throws IOError;
		public abstract HashTable<string, int> GetServerTypes() throws IOError;
		public abstract string[] GetEmailDetails(int id) throws IOError;
		public abstract void CheckAll() throws IOError;
		public abstract void GetAccounts() throws IOError;
	
	}
	
	[DBus (name = "eu.medesimo.thesis.email")]
	public interface EmailInterface : Object {
		
		/**
		 * DBus interface to the Email object.
		*/
		
		public abstract void Check() throws IOError;
		public abstract bool GetStatus() throws IOError;
		
	}

}
