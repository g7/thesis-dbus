Handling e-mails
================

The service only supports the retrieval of e-mails from IMAP servers. This has been chosen for a number of reasons,
where the most important is that implementing IMAP support is easier (and less of a burden, as there is no need for
underlying storage support) and fit better with the global goal of this project (which is not to create an e-mail client but to
demonstrate the capabilities of DBus).

There is also a "fake" `ServerType` called MOCK. This generates e-mails on-the-fly and thus is the best way to demonstrate
the project even when there isn't an Internet connection present.

Handling `IMAP`
---------------

<div class="box-container">
	<div class="info-header">
		IMAP
	</div>
	<div class="info">
		IMAP, or <strong>Internet Message Access Protocol</strong> is a communication protocol designed for e-mail retrieval. <br />
		Unlike its widely-used alternative POP, IMAP allows for e-mail messages to stay on server after they have been downloaded,
		and actually don't require for them to be downloaded at all. <br /> <br />
		
		IMAP also permits the usage of a single email box from multiple clients, and its adoption rate has grown rapidly since nowadays
		a single user has multiple devices connecting to the same e-mail account. <br /> <br />
		
		The protocol also permits, through the IMAP Idle extension, to notify connected clients of a new email, thus providing
		a real-time feedback to the user, without the need for it to explicitly check for new e-mails. <br /> <br />
		
		By default, IMAP daemons use port 143 (without SSL) or 993 (with SSL).
	</div>
</div>

IMAP support in Python is provided by the [`imaplib`](https://docs.python.org/3.4/library/imaplib.html) module.

The usage is pretty straightforward. Code is worth a thousand words (full source at `src/core/email.py`):

```python
	def check(self):
		"""
		Checks for e-mails.
		"""

		try:
			self.imap = (imaplib.IMAP4_SSL if self.infos["SSL"] else imaplib.IMAP4)(host=self.infos["Server"], port=self.infos["Port"])

			self.imap.login(self.infos["Username"], self.infos["Password"])
			
			self.status = True
		except imaplib.IMAP4.error:
			print("Unable to login :(")
			return
		
		new_mails = []
				
		self.imap.select(readonly=True)
		result, messages = self.imap.search(None, "(UNSEEN)")
		if result == "OK":
			# New emails!
			for id in messages[0].split():
				typ, data = self.imap.fetch(id, '(RFC822)')
				new_mails.append(email.message_from_bytes(data[0][1]))

		self.imap.close()
		self.imap.logout()
		return new_mails
```

First of all, the method picks up the right `imaplib` class based on the account settings.  
If SSL is enabled, the class will be `imaplib.IMAP4_SSL`. Otherwise, `imaplib.IMAP4` will be used.

After that, the method will login using the supplied informations (which are fetched from the database).

The fun part comes from line 22, where unread mails (the `(UNSEEN)` flag) are fetched and added to the new_mails list,
which is returned at the end of the routine.

Handling `MOCK`
---------------

```python
	def check(self):
		"""
		Generate e-mails on-the-fly for testing purposes.
		"""
		
		# Create fake emails
		new_mails = []
		for count in range(0, random.randint(1, 6)):
			msg = email.mime.text.MIMEText("\n".join(fake.paragraphs(random.randint(1, 6))))
			
			msg["Subject"] = fake.sentence(3)
			msg["From"] = fake.email()
			msg["Date"] = email.utils.formatdate(time.mktime(datetime.datetime.now().timetuple()))
			
			new_mails.append(msg)
		
		return new_mails
```

The mails are generated in a random quantity at every check.

Both the e-mail content and the subject are generated on-the-fly using the [`faker`](https://github.com/joke2k/faker) Python module,
as well as the e-mail address of the sender.
