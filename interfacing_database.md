Interfacing to the Database
===========================

Python provides a built-in module to interface with SQLite: [`sqlite3`](https://docs.python.org/3.4/library/sqlite3.html).

Its usage is pretty straightforward:

```python
import sqlite3

# Connect
connection = sqlite3.connect("mydatabase.db")

# Get the cursor, that permits us to execute commands
cursor = connection.cursor()

for row in cursor.execute("SELECT * FROM Emails"):
	print(row)
	# Yup, it's that simple!

# Save
connection.commit()

# Close
connection.close()
```

### Preventing SQL injections

SQL injection is a technique that permits to exploit poorly validated SQL commands. 
An example of a poor validated SQL command is the following:

```python
account_id = input("Insert the account id: ")
cursor.execute("SELECT * FROM Emails WHERE ACCOUNT=%s" % account)
```

Assuming that the user inserts `0` at the account id request, the resulting query would be:

```SQL
SELECT * FROM Emails WHERE ACCOUNT=0;
```

...which is correct. The fun part comes when a malicious user inputs something like `0 OR 1=1`:

```SQL
SELECT * FROM Emails WHERE ACCOUNT=0 OR 1=1;
```

...which is a security breach, because it will make the DBMS output every e-mail (`1=1` is always true).

We can avoid this by using `sqlite3`'s own parameter substitution:

```python
cursor.execute("SELECT * FROM Emails WHERE ACCOUNT=?", (account_id,))
```

By using this syntax, `sqlite3` will automatically validate the query and prevent eventual SQL injections.

Interfacing to the Database in a more Pythonic way
--------------------------------------------------

To interface the service to a database using a more Pythonic syntax (without using SQL), I made a database
wrapper (`src/core/database.py`).

<!-- Next page -->
<br />
```python
import core.database as database

db = database.Database("database.db")

# Select, this translates to
# SELECT Title, Sender, Content, Date FROM Emails WHERE ID = 0 OR ID = 1;
for email in db.select(
	"Emails",
	attributes=("Title", "Sender", "Content", "Date"),
	conditions=database.OrCondition(
		database.EqualCondition("ID", "0"),
		database.EqualCondition("ID", "1")
	)
):
	print(email)

# Insert, this translates to
# INSERT INTO Emails (Account,Title,Content,Sender,Read,Date) VALUES (...)
db.insert(
	"Emails",
	Account=0,
	Title="Hello!,
	Content="Hello, how are you?",
	Sender="fake@mail",
	Read=False,
	Date="2010-05-22"
)

db.commit()
```

The service uses exclusively this wrapper to interface itself with the database. Result queries are validated automatically against SQL injections.
