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
	
	public class EmailBox : Gtk.Box {
		
		/**
		 * Handles an e-mail in the ListBox.
		*/
		
		public Gtk.Box inner_box;
		public Gtk.Label title;
		public Gtk.Label sender;
		public Gtk.Label date;
		
		public Gtk.Revealer content_revealer;
		public Gtk.Label content;
		
		public EmailBox(string title, string sender, string content, string date) {
			/**
			 * Constructor
			*/
			
			Object(orientation: Gtk.Orientation.VERTICAL, spacing: 2);
			
			/* Inner box that contains email details */
			this.inner_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 2);
			this.pack_start(this.inner_box, true, true, 2);

			this.sender = new Gtk.Label(sender);
			this.sender.set_alignment(0, 0);
			this.inner_box.pack_start(this.sender, false, false, 2);

			this.title = new Gtk.Label("");
			this.title.set_markup("<b>%s</b>".printf(title));
			this.title.set_alignment(0, 0);
			this.title.set_ellipsize(Pango.EllipsizeMode.END);
			this.inner_box.pack_start(this.title, true, true, 2);
			
			this.date = new Gtk.Label(date);
			this.date.set_alignment(1, 1);
			this.inner_box.pack_start(this.date, false, false, 2);
			
			/* Content revealer */
			this.content_revealer = new Gtk.Revealer();
			this.content_revealer.transition_type = Gtk.RevealerTransitionType.SLIDE_DOWN;
			this.pack_start(this.content_revealer, true, true, 2);
			
			this.content = new Gtk.Label(content);
			this.content.set_alignment(0, 0);
			this.content.set_single_line_mode(false);
			this.content.set_line_wrap(true);
			this.content.set_line_wrap_mode(Pango.WrapMode.WORD);
			this.content_revealer.add(this.content);
			
		}
		
	}

	public class MainWindow : Gtk.Window {
		
		/**
		 * Main window
		*/
				
		public Gtk.Box main_container;
		
		public Gtk.Toolbar toolbar;
		public Gtk.ScrolledWindow scrolledwindow;
		public Gtk.Label no_email_label;
		
		public Gtk.ListBox listbox;
		
		public AddAccountDialog add_account;
		
		/* Current Selected EmailBox */
		private EmailBox? current_email = null;
		
		/* Signal */
		public signal void requires_check();
		
		/* Some properties */
		public bool empty { get; private set; default = false; }
		
		public class MainWindow() {
			
			/**
			 * Constructor.
			*/
			
			Object();
						
			/* Setup */
			this.title = "Client";
			this.icon_name = "email";
			this.default_height = 500;
			this.default_width = 600;
			this.window_position = Gtk.WindowPosition.CENTER;
			
			/* Create a new AddAccountDialog... */
			this.add_account = new AddAccountDialog();
			
			/* Main container */
			this.main_container = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
			this.add(this.main_container);
			
			/* Toolbar */
			this.toolbar = new Gtk.Toolbar();
			this.toolbar.toolbar_style = Gtk.ToolbarStyle.BOTH_HORIZ;
			this.main_container.pack_start(this.toolbar, false, false, 0);
			
			Gtk.ToolButton check = new Gtk.ToolButton(
				new Gtk.Image.from_icon_name("gtk-refresh", Gtk.IconSize.SMALL_TOOLBAR),
				"Check for new e-mails"
			);
			/* Fire the 'requires_check' signal when the button has been clicked */
			check.clicked.connect(() => { this.requires_check(); });
			this.toolbar.add(check);
			
			Gtk.ToolButton add = new Gtk.ToolButton(
				new Gtk.Image.from_icon_name("gtk-add", Gtk.IconSize.SMALL_TOOLBAR),
				"Add a new account"
			);
			/* Show the add_account dialog when the button has been clicked */
			add.clicked.connect(() => { this.add_account.show_all(); });
			this.toolbar.add(add);
			
			/* Scrolledwindow */
			this.scrolledwindow = new Gtk.ScrolledWindow(null, null);
			this.scrolledwindow.no_show_all = true;
			this.main_container.pack_start(this.scrolledwindow, true, true, 0);
			
			/* "No emails" label, that will be shown if there aren't any e-mails */
			this.no_email_label = new Gtk.Label("No e-mails yet.");
			this.main_container.pack_start(this.no_email_label, true, true, 0);
			
			/* Main listbox, which will house emails */
			this.listbox = new Gtk.ListBox();
			this.listbox.row_selected.connect(this.on_row_selected);
			this.scrolledwindow.add(this.listbox);
			
			/* Ensure that the main window is disabled when the AddAccountDialog is shown */
			this.add_account.bind_property(
				"visible",
				this,
				"sensitive",
				BindingFlags.INVERT_BOOLEAN
			);
			
			/* Hide the main listbox if there aren't any e-mails */
			this.bind_property(
				"empty",
				this.scrolledwindow,
				"visible",
				BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE
			);
			this.bind_property(
				"empty",
				this.no_email_label,
				"visible",
				BindingFlags.INVERT_BOOLEAN | BindingFlags.SYNC_CREATE
			);
			this.listbox.show_all();
		
		}
		
		public void on_row_selected(Gtk.ListBoxRow? row) {
			/**
			 * Fired when the row has been selected
			*/
			
			if (row == null)
				return;
			
			if (this.current_email != null)
				this.current_email.content_revealer.set_reveal_child(false);
			
			this.current_email = (EmailBox)row.get_child();
			
			this.current_email.content_revealer.set_reveal_child(true);
			
		}
		
		public void add_email(string title, string sender, string content, string date) {
			
			/**
			 * Adds a new email.
			*/
			
			if (!this.empty)
				/* Remove the empty flag */
				this.empty = true;
			
			EmailBox widget = new EmailBox(title, sender, content, date);
			
			this.listbox.prepend(widget);
			widget.show_all();
		}
		
	}


}
