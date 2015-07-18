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

	public class Client : Object {
		
		/**
		 * Main class for the client.
		*/
		
		public Cancellable cancellable;
		
		public ThesisInterface iface;
		
		public MainWindow main_window;
		
		public Client() {
			/**
			 * Constructor.
			*/
			
			this.cancellable = new Cancellable();
			
			/* Connect to DBus */
			this.iface = Bus.get_proxy_sync(
				BusType.SESSION,
				"eu.medesimo.thesis",
				"/eu/medesimo/thesis",
				DBusProxyFlags.NONE,
				this.cancellable
			);
			this.iface.NewEmail.connect(this.on_new_email);
			
			/* Get ServerTypes */
			Common.available_servertypes = this.iface.GetServerTypes();
			
			/* Create window */
			this.main_window = new MainWindow();
			
			/* Signal connections */
			this.main_window.requires_check.connect(() => { new Thread<void*>("check", this.do_check); });
			this.main_window.add_account.new_account_request.connect(this.on_new_account_request);
			this.main_window.destroy.connect(() => { this.exit(); });
			
			
			this.main_window.show_all();
			
		}
		
		public void* do_check() {
			/**
			 * Does the check.
			*/
			
			this.iface.CheckAll();
			
			return null;	
		}
		
		public void on_new_account_request(
			string name,
			string address,
			string server,
			string username,
			string password,
			int port,
			string server_type,
			bool ssl
		) {
			/**
			 * Fired when there is a new account request.
			*/
			
			this.iface.AddAccount(
				name,
				address,
				server,
				username,
				password,
				port,
				server_type,
				ssl
			);
			
		}
		
		public void on_new_email(int id) {
			/**
			 * Fired whenever a new email arrives.
			*/
			
			message("HEEYE %d", id);
			Idle.add(
				() => {
					/*
					 * The service returns a string array because it's
					 * easier to handle here (otherwise we should unpack the Variant).
					 * The program will treat it like a tuple:
					 * 
					 * Title, Sender, Content, Date
					*/
					string[] result = this.iface.GetEmailDetails(id);
					
					this.main_window.add_email(
						result[0], /* Title */
						result[1], /* Sender */
						result[2], /* Content */
						result[3]  /* Date */
					);
					
					return false;
				}
			);
			
		}
		
		public void exit() {
			/**
			 * Exits from the UI.
			*/
			
			this.cancellable.cancel();
			Gtk.main_quit();
			
		}
		
		public static int main(string[] args) {
			/**
			 * Main entrypoint.
			*/
			
			Gtk.init(ref args);
			
			Client client = new Client();
			
			Gtk.main();
			
			return 0;
		}
		
	}

}
