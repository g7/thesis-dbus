An introduction to Vala
=======================

Vala is a new programming language that leverages the power of [GLib](https://developer.gnome.org/glib/)
on an easy-to-use syntax inspired by C#.

One of the main selling points of Vala is that the compiler simply translates the code to C, and then compiles it
using the standard toolchain.

GLib already provides a relatively simple to use Object and Type systems, bringing some bit of Object-Oriented Programming to C, too.  
Vala builds over it and permits to easily create high-performance and memory-safe applications using the widely used C# syntax.

As C# was in my course of study, I won't do an in-depth introduction to Vala like I did with Python some pages back.  
What's different are, obviously, the underlying libraries. It's possible to learn more about them on Valadoc: http://valadoc.org/.

Hello, world!
-------------

It's possible to compile this example by going to `examples/vala` and issuing:

	make helloworld

The code is available at `examples/vala/helloworld.vala`.

```Java
int main(string[] args) {
	print("Hello, world!\n");
	
	return 0;
}
```

It's of course possible to put it in a class, like the standard "Hello, world!"s in C# do:

```Java
namespace HelloWorld {

	class Hello {
		
		static int main(string[] args) {
		
			print("Hello, world!\n");
			
			return 0;
		
		}
		
	}

}
```

Compile with

	make helloworld-class

The code is available at `examples/vala/helloworld-class.vala`.

Other examples
--------------

A good tutorial with lots of examples is located here: https://wiki.gnome.org/Projects/Vala/Tutorial.
