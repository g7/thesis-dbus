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

	
	public class AddAccountDialog : Gtk.Dialog {
		
		/**
		 * The "Add a new account" dialog.
		 * 
		 * This is actually pretty simplistic and the dialog design can
		 * be improved.
		*/
		
		public Gtk.Box box;
		
		public Gtk.Revealer error;
		public Gtk.InfoBar bar;
		
		public Gtk.Entry name;
		public Gtk.Entry address;
		public Gtk.Entry server;
		public Gtk.Entry username;
		public Gtk.Entry password;
		public Gtk.Entry port;
		
		public Gtk.ListStore server_type_model;
		public Gtk.ComboBox server_type;
		
		public Gtk.CheckButton ssl;
		
		/* Signals */
		public signal void new_account_request(
			string name,
			string address,
			string server,
			string username,
			string password,
			int port,
			string server_type,
			bool ssl
		);
		
		public AddAccountDialog() {
			/**
			 * Constructor.
			*/
			
			Object();
			
			/* Setup */
			this.title = "Add a new e-mail account";
			this.icon_name = "email";
			//this.default_height = 500;
			//this.default_width = 600;
			this.window_position = Gtk.WindowPosition.CENTER_ON_PARENT;
			
			/* Content */
			//this.box = new Gtk.Box(Gtk.Orientation.VERTICAL, 2);
			//this.get_content_area().pack_start(this.box);
			this.box = this.get_content_area();
			
			/* Error revealer */
			this.error = new Gtk.Revealer();
			this.error.transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN;
			this.bar = new Gtk.InfoBar();
			this.bar.get_content_area().add(new Gtk.Label("Please complete the entire form."));
			this.error.add(this.bar);
			this.box.pack_start(this.error);
			
			this.name = new Gtk.Entry();
			this.name.placeholder_text = "Account name";
			this.box.pack_start(this.name, true, true, 2);
			
			this.address = new Gtk.Entry();
			this.address.placeholder_text = "E-Mail address";
			this.box.pack_start(this.address, true, true, 2);
			
			this.server = new Gtk.Entry();
			this.server.placeholder_text = "Server";
			this.box.pack_start(this.server, true, true, 2);
			
			this.username = new Gtk.Entry();
			this.username.placeholder_text = "Username";
			this.box.pack_start(this.username, true, true, 2);
			
			this.password = new Gtk.Entry();
			this.password.placeholder_text = "Password";
			this.box.pack_start(this.password, true, true, 2);
			
			this.port = new Gtk.Entry();
			this.port.placeholder_text = "Port";
			this.box.pack_start(this.port, true, true, 2);
			
			/* ServerType combobox */
			this.server_type_model = new Gtk.ListStore(
				2,
				typeof(string),
				typeof(int)
			);
			this.server_type = new Gtk.ComboBox.with_model(this.server_type_model);
			Gtk.CellRendererText renderer = new Gtk.CellRendererText();
			this.server_type.pack_start(renderer, true);
			this.server_type.add_attribute(renderer, "text", 0); /* string */
			/* Generate content */
			Common.available_servertypes.foreach(
				(key, value) => {
					Gtk.TreeIter iter;
					this.server_type_model.append(out iter);
					this.server_type_model.set(iter, 0, key, 1, value);
				}
			);
			this.server_type.active = 0; /* Set first */
			this.box.pack_start(this.server_type, true, true, 2);
			
			this.ssl = new Gtk.CheckButton.with_label("Use SSL");
			this.ssl.active = true; /* Use it by default */
			this.box.pack_start(this.ssl, true, true, 2);
			
			/* Buttons */
			this.add_buttons(
				"_Cancel", Gtk.ResponseType.CANCEL,
				"_OK", Gtk.ResponseType.OK,
				null
			);
			this.set_default_response(Gtk.ResponseType.OK);
			
			/* Connect response */
			this.response.connect(this.on_response);
			
			/* Don't destroy window on delete_event */
			this.delete_event.connect(() => { return true; });
		
		}
		
		private void on_response(int response) {
			/**
			 * Fired on a response.
			*/
			
			Gtk.Entry[] entries = {
				this.name,
				this.address,
				this.server,
				this.username,
				this.password,
				this.port
			};
			
			if (response == Gtk.ResponseType.OK) {
				
				/* Fail if an Entry is empty */
				foreach (Gtk.Entry entry in entries) {
					message("Meh %s", entry.text);
					if (entry.text == "") {
						this.error.set_reveal_child(true);
						return;
					}
				}
				
				Gtk.TreeIter iter;
				Value val;
				this.server_type.get_active_iter(out iter);
				this.server_type_model.get_value(iter, 0, out val);	
				
				this.new_account_request(
					this.name.text,
					this.address.text,
					this.server.text,
					this.username.text,
					this.password.text,
					int.parse(this.port.text),
					(string)val,
					this.ssl.active
				);
			}
			
			/* Cleanup */
			foreach (Gtk.Entry entry in entries) {
				entry.text = "";
			}
			this.server_type.active = 0;
			this.ssl.active = true;
			this.error.set_reveal_child(false);
			
			this.hide();
		}
		
	}


}
