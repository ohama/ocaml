---
title: "Introduction"
description : "Introduction"
pre: "1. "
weight: 10
---

GTK (GIMP Toolkit) is a library for creating graphical user interfaces. It is licensed using the LGPL license, so you can develop open software, free software, or even commercial non-free software using GTK without having to spend anything for licenses or royalties.

It's called the GIMP toolkit because it was originally written for developing the GNU Image Manipulation Program (GIMP), but GTK has now been used in a large number of software projects, including the GNU Network Object Model Environment (GNOME) project. GTK is built on top of GDK (GIMP Drawing Kit) which is basically a wrapper around the low-level functions for accessing the underlying windowing functions (Xlib in the case of the X windows system), and gdk-pixbuf, a library for client-side image manipulation.

The primary authors of GTK are:

- Peter Mattis petm@xcf.berkeley.edu

- Spencer Kimball spencer@xcf.berkeley.edu

- Josh MacDonald jmacd@xcf.berkeley.edu

GTK is currently maintained by:

- Owen Taylor otaylor@redhat.com

- Tim Janik timj@gtk.org

GTK is essentially an object oriented application programmers interface (API). Although written completely in C, it is implemented using the idea of classes and callback functions (pointers to functions).

There is also a third component called GLib which contains a few replacements for some standard calls, as well as some additional functions for handling linked lists, etc. The replacement functions are used to increase GTK's portability, as some of the functions implemented here are not available or are nonstandard on other Unixes such as g_strerror(). Some also contain enhancements to the libc versions, such as g_malloc() that has enhanced debugging utilities.

In version 2.0, GLib has picked up the type system which forms the foundation for GTK's class hierarchy, the signal system which is used throughout GTK, a thread API which abstracts the different native thread APIs of the various platforms and a facility for loading modules.

As the last component, GTK uses the Pango library for internationalized text output.

The original tutorial describes the C interface to GTK. There are GTK bindings for many other languages including Ocaml, C++, Guile, Perl, Python, TOM, Ada95, Objective C, Free Pascal, Eiffel, Java and C#. If you intend to use another language's bindings to GTK, look at that binding's documentation first. In some cases that documentation may describe some important conventions (which you should know first) and then refer you back to the original tutorial. There are also some cross-platform APIs (such as wxWindows and V) which use GTK as one of their target platforms; again, consult their documentation first.

If you're developing your GTK application in C++, a few extra notes are in order. There's a C++ binding to GTK called GTK--, which provides a more C++-like interface to GTK; you should probably look into this instead. If you don't like that approach for whatever reason, there are two alternatives for using GTK. First, you can use only the C subset of C++ when interfacing with GTK and then use the C interface as described in the original tutorial. Second, you can use GTK and C++ together by declaring all callbacks as static functions in C++ classes, and again calling GTK using its C interface. If you choose this last approach, you can include as the callback's data value a pointer to the object to be manipulated (the so-called "this" value). Selecting between these options is simply a matter of preference, since in all three approaches you get C++ and GTK. None of these approaches requires the use of a specialized preprocessor, so no matter what you choose you can use standard C++ with GTK.

The original tutorial is an attempt to document as much as possible of GTK, but it is by no means complete. The tutorial assumes a good understanding of C, and how to create C programs. It would be a great benefit for the reader to have previous X programming experience, but it shouldn't be necessary. If you are learning GTK as your first widget set, please comment on how you found this tutorial, and what you had trouble with. There are also Ocaml, C++, Objective C, ADA, Guile and other language bindings available, but I don't follow these.

The original document is a "work in progress". Please look for updates on http://www.gtk.org/.

I would very much like to hear of any problems you have learning GTK from the original document, and would appreciate input as to how it may be improved. Please see the section on Contributing for further information.

### GTK+ 2.0 in Ocaml

[Ocaml](http://ocaml.org/) is a fantastic programming language which has the various modern features. Some of them are:

- Functional / Imperative features: It is a functional language, since the basic units of programs are functions. And it provides full imperative capabilities, including updatable arrays, imperative variables and records with mutable fields.

- Strongly-typed: It is a strongly-typed language; it means that the objects that you use belong to a set that has a name, called its type. In Caml, types are managed by the computer, the user has nothing to do about types (types are synthesized). And caml features "polymorphic typing": some types may be left unspecified, standing for "any type".

- Compiler / Interpreter: Caml provides an interpreter as well as compiler. An interactive top-level executes "read-eval-print" loop, that is convenient for both learning, or rapid testing and debugging of programs.

- Object oriented: Objective Caml features objects that give a fully fledged object oriented programming style in Caml programs.

[LablGTK](http://lablgtk.forge.ocamlcore.org/) is an Objective Caml interface to gtk+. It comes in two flavors: LablGTK1 for gtk+-1.2 and LablGTK2 for gtk+-2.0 to gtk+-2.4.

It is still under development, but already fully functional. All widgets (but one) are available, with almost all their methods. The GLArea widget is also supported in combination with LablGL. LibGlade and GdkPixbuf support is also included for both versions. LablGTK2 adds support for gnomecanvas, librsvg and libpanel Many examples are provided.

You can use LablGTK in win32 systems as well as in the unix like system.


#### Note

Some chapters of the original document have been omitted in ocaml version:

- GLib
- Tips For Writing GTK Applications
The chapters or sections with "(?)" at the end of the name is not translated part to ocaml language. It is waiting contributors.

The following chapters have only titles while the corresponding one in the C version tutorial has large contents:

- Writing Your Own Widgets
- GTK Signals

So, you have to read the [original](https://www.gtk.org/tutorial/) document to refer these chapters.


{{% notice note %}}
There are good example sources in lablgtk distribution and I borrowed some code from that.
{{% /notice %}}

{{% notice note %}}
Some part of this document came from LablGTK README files.
{{% /notice %}}
