An introduction to Python
=========================

[Python](http://python.org) is an object-oriented and interpreted programming language, created by Guido van Rossum in 1991.

<div class="box-container">
	<div class="info-header">
		Object oriented programming
	</div>
	<div class="info">
		Object-oriented programming (OOP) is a programming paradigm based on the concept of "objects", which are data structures that contain data,
		in the form of attributes; and code, in the form of methods. <br />
		An object's procedures can access and often modify the data fields of the object with which they are associated. <br />
		In OO programming, computer programs are designed by making them out of objects that interact with one another. <br /><br/>
		
		
		Most popular languages are class-based, meaning that objects are instances of classes, which typically also determines their type.
	</div>
</div>

<div class="box-container">
	<div class="info-header">
		Interpreted programming language
	</div>
	<div class="info">
		An interpreted language is a programming language for which most of its implementations execute instructions directly,
		without previously compiling a program into machine-language instructions. <br />
		The interpreter executes the program directly, translating each statement into a sequence of one or more subroutines
		already compiled into machine code.
	</div>
</div>

Get Python
----------

Python is bundled with the majority of the GNU/Linux distributions out there.  
In its [website](http://python.org) it's possible to download source code and installers for Windows and OSX.

In this thesis I'll use Python **version 3.4.2**.

If you don't have Python installed in your GNU/Linux distribution, you can most of the time install the interpreter
from a package manager.

On Debian and Ubuntu based systems, you can install the package from apt-get or another graphical interface such as synaptic:

	sudo apt-get install python3.4

Many distributions have packages for both Python version 2 and version 3. In the most of them, the symlink `/usr/bin/python` points
to python2, while `/usr/bin/python3` points to python3.  
Some distributions such as Arch Linux do the inverse thing, so it's better to actually check the version of the installed interpreter:

	g7@meddle:~$ python --version
	Python 2.7.8
	g7@meddle:~$ python3 --version
	Python 3.4.2
	g7@meddle:~$ 

I'll use the `/usr/bin/python3` executable through the whole document.

Hello, world!
-------------

Our first program in Python is the classic `Hello, world!`:

Let's create a file called `hello.py` in a directory of our preference and put there the following header:

```python
#!/usr/bin/python3
# -*- coding: utf-8 -*-
```

The first line specifies the interpreter to use when executing the program.
The second line specifies the coding the interpreter should use when reading the file.
I always use `utf-8` because it can handle language-specific characters.

Let's now put the actual `Hello, world!` line in there:

```python
print("Hello, world!")
```

And now, execute the thing:

	g7@meddle:~/tesina/examples/python$ chmod +x hello.py
	g7@meddle:~/tesina/examples/python$ ./hello.py
	Hello, world!
	g7@meddle:~/tesina/examples/python$ 

The `chmod +x` command set the executable bit on the program we just created, so that the Operating System could correctly execute it
(by looking at the `#!` header present in the first line).

The end result is something like this:

```python
#!/usr/bin/python3
# -*- coding: utf-8 -*-

print("Hello, world!")
```

Someone familiar with other programming languages can note the fact that the program is missing the common `main()` function,
used by many programming languages as the main entry point of the program, and that handles the final exit code as well as the arguments.

Python, being born as a scripting language, doesn't need the `main()` function to work.


Imports, Arguments, Exit codes and Tracebacks
---------------------------------------------

Let's try now with something a bit more complicated (`hello_with_arguments.py`):

```python
#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys

name = sys.argv[1]

print("Hello, %s!" % name)

sys.exit(1)
```

	g7@meddle:~/tesina/examples/python$ chmod +x hello_with_arguments.py 
	g7@meddle:~/tesina/examples/python$ ./hello_with_arguments.py Eugenio
	Hello, Eugenio!
	g7@meddle:~/tesina/examples/python$ ./hello_with_arguments.py
	Traceback (most recent call last):
	  File "./hello_with_arguments.py", line 6, in <module>
		name = sys.argv[1]
	IndexError: list index out of range
	g7@meddle:~/tesina/examples/python$

Ok, so a lot happened there!

Command line arguments are handled via the `sys.argv` list (more on that later), which is present on the package `sys`.

<!-- Next page -->
<br />
<div class="box-container">
	<div class="info-header">
		Modules and Packages
	</div>
	<div class="info">
		A Python script can be imported into another using the 'import' directive. <br />
		Multiple modules into a single directory form a Package, which can be imported (like the 'sys' package above).
		<br /><br />
		Python has built-in an huge number of packages. If you want to do something, 
		probably the Python standard library has you covered.<br />
		And if it doesn't, there is the community package repository.
	</div>
</div>


### String formatting

Those familiar with the C `printf` function will feel at home with Python's string formatting:
```python
print("Hello, %s!" % "Eugenio")
print("Hello, %s from %s!" % ("Eugenio", "The Machine"))
print("Hello %(person)s and thank you for choosing %(us)s. Thank you again %(person)s!" % {"person":"Eugenio", "us":"The Machine"})
```

The code is self-explanatory. Possibilities are endless with Python's string formatting!


### Tracebacks

Looking at the output of the last command, we can get some informations on why the program crashed:

	g7@meddle:~/tesina/examples/python$ ./hello_with_arguments.py
	Traceback (most recent call last):
	  File "./hello_with_arguments.py", line 6, in <module>
		name = sys.argv[1]
	IndexError: list index out of range
	g7@meddle:~/tesina/examples/python$

These informations are called `Tracebacks` and are, as Python is an interpreted language, thrown out whenever
the faulty code is executed (this means that if that piece of code is never executed, the program won't crash).

### Exit codes

If the program doesn't crash for other reasons (Tracebacks), the Python interpreter will exit with the status `0`.

It's possible to specify the exit status using `sys.exit()` like shown in the code above.

Tuples, Lists and Dictionaries
------------------------------

Now let's talk about the main data structures in Python: Tuples, Lists and Dictionaries.

To run these examples, you'll need to run the Python interpreter in the `interactive` mode, like this:

	g7@meddle:~/tesina$ python3
	Python 3.4.2 (default, Oct  8 2014, 10:45:20) 
	[GCC 4.9.1] on linux
	Type "help", "copyright", "credits" or "license" for more information.
	>>> print("Hello!")
	Hello!
	>>> 

(You can exit at any time by pressing CTRL+D)

### Tuples

A tuple is a finite ordered list of elements. In Python, they are defined with parentheses:

	>>> this_is_a_tuple = ("Element1", "Element2", "Element3")
	>>> this_is_a_tuple
	('Element1', 'Element2', 'Element3')
	>>> 

Obviously, tuples are immutable: I can't add another element to `this_is_a_tuple`:

	>>> this_is_a_tuple.append("Element4")
	Traceback (most recent call last):
	  File "<stdin>", line 1, in <module>
	AttributeError: 'tuple' object has no attribute 'append'
	>>> 

### Lists

A list, in Python, is a mutable set of elements. Given its interpreted nature, Python doesn't have arrays and Lists are used everywhere (using brackets):

	>>> this_is_a_list = ["One", "Two", "Three"]
	>>> this_is_a_list
	['One', 'Two', 'Three']
	>>> this_is_a_list.append("Four")
	>>> this_is_a_list
	['One', 'Two', 'Three', 'Four']
	>>> 

### Dictionaries

Dictionaries are too first class citizens in Python. A Dictionary permits to associate a value to a key, like this (using curly brackets):

	>>> this_is_a_dictionary = {"Eugenio":"me@medesimo.eu", "Root":"administrator@meddle"}
	>>> this_is_a_dictionary
	{'Eugenio': 'me@medesimo.eu', 'Root': 'administrator@meddle'}
	>>> this_is_a_dictionary["Eugenio"]
	'me@medesimo.eu'
	>>> 

Dictionaries are, like Lists, mutable:

	>>> this_is_a_dictionary["Guest"] = "guest@meddle"
	>>> this_is_a_dictionary["Guest"]
	'guest@meddle'
	>>> this_is_a_dictionary
	{'Eugenio': 'me@medesimo.eu', 'Root': 'administrator@meddle', 'Guest': 'guest@meddle'}
	>>> 

Conditions
----------

Like every other programming language, Python has the if condition to test for cases:

	>>> variable = "Hello"
	>>> if variable == "Hello":
	...    print("The variable is Hello, indeed.")
	... elif variable == "Bye":
	...    print("The variable is Bye!")
	... else:
	...    print("I don't know, really.")
	... 
	The variable is Hello, indeed.
	>>> 

Binary operators are, of course, supported:

	>>> team = "Inter"
	>>> if team == "Inter" or team == "Lazio":
	...    print("OK")
	... else:
	...    print("NO!")
	... 
	OK
	>>> 

You may have noticed that, unlike other famous programming languages, Python doesn't need special keywords to close if conditions (like `endif` or a curly bracket)
or loops.  
This is because Python relies on the code indentation to detect when a code block finishes.  

	>>> team = "Inter"
	>>> if team == "Inter" or team == "Lazio":
	... print("OK")
	  File "<stdin>", line 2
		print("OK")
			^
	IndentationError: expected an indented block
	>>> 

Loops
-----

Loops in Python are surprisingly few but, still, are enough.

### `for` loop

This really behaves like a `foreach` loop in other languages:

	>>> list = ["Inter", "Lazio", "Roma", "Milan"]
	>>> for team in list:
	...    print(team)
	... 
	Inter
	Lazio
	Roma
	Milan
	>>> 

### `while` loop

This behaves like a normal `while` loop:

	>>> count = 0
	>>> while count < 5:
	...    print("YE")
	...    count += 1
	... 
	YE
	YE
	YE
	YE
	YE
	>>> 

Mutable types
-------------

Being an interpreted language, Python can have mutable types. An example is worth a thousand words:

	>>> this_is_a_string = "Really!"
	>>> this_is_a_string = False
	>>> this_is_a_string
	False
	>>> this_is_a_string == "Really!"
	False
	>>> 

Also Lists, for example, can host objects of different type:

	>>> list = ["String", True, False, 0.2, 30]
	>>> list
	['String', True, False, 0.2, 30]
	>>> 

List and Dictionary comprehension
---------------------------------

A neat feature of Python are list comprehensions: it is possible to create a list from a conditioned loop with a single line of code.

Let's see an example:

	>>> all_groups = ["group1", "group2", "group3", "group4", "group5"]
	>>> memberships = {"Eugenio": ["group1", "group5"]}
	>>> groups_eugenio_is_not_in = [x for x in all_groups if x not in memberships["Eugenio"]]
	>>> groups_eugenio_is_not_in
	['group2', 'group3', 'group4']
	>>> 

The `groups_eugenio_is_not_in` list has been made using list comprehension.
It is composed by every group Eugenio is not in (the `if x not in memberships["Eugenio"]` bit).

This translates to

	>>> groups_eugenio_is_not_in = []
	>>> for x in all_groups:
	...    if x not in memberships["Eugenio"]:
	...       groups_eugenio_is_not_in.append(x)
	... 
	>>> groups_eugenio_is_not_in
	['group2', 'group3', 'group4']
	>>> 

We saved a lot of lines while still maintaining the code clean. Fantastic! :)

Similarly, we can create a dictionary using roughly the same syntax:

	>>> import random
	>>> 
	>>> what = {key: random.randint(1, 100) for key in ["A","B","C","D","E"]}
	>>> what
	{'C': 99, 'D': 81, 'B': 53, 'A': 2, 'E': 43}
	>>> 

Decorators
----------

Another nice feature of Python are decorators. With a decorator is possible to easily "modify" a function before executing it:

```python
@my_decorator
def do_things():
	print("I'm doing something!")
```

The decorator is specified by specifying just before the function declaration (`@my_decorator` in this case).

A decorator is a simple function:

```python
def my_decorator(function_to_decorate):

	def wrapper():
		print("This is part of the decorator!")
		function_to_decorate()
		print("This is still part of the decorator!")
	
	return wrapper
```

Executing the `do_things()` function will result in something like this (see `decorator.py` in the examples):

	g7@meddle:~/tesina/examples/python$ chmod +x decorator.py 
	g7@meddle:~/tesina/examples/python$ ./decorator.py 
	This is part of the decorator!
	I'm doing something!
	This is still part of the decorator!
	g7@meddle:~/tesina/examples/python$ 

In practice, a decorator "replaces" the function with a `wrapper`, that modifies it (or executes something, like in this case).  

Classes
-------

A class in Python is represented using the `class` keyword:

```python
class MyClass:
	
	def __init__(self):
		"""
		This is the class initializer, similar to the
		constructor used in other languages.
		"""
		
		print("Hey!")
		self.do_something()
	
	def do_something(self):
		"""
		Does something.
		"""
		
		print("Python rocks!")
```
