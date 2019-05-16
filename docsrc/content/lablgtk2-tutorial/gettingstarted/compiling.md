---
title: "Compiling hello world"
description : "Compiling hello world"
weight: 20
---

To compile use:

``` ocaml
ocamlc -I +lablgtk2 -o helloworld lablgtk.cma gtkInit.cmo helloworld.ml
```

The options are:

- `-I +lablgtk2`: adds the subdirectory lablgtk2 of the standard library to the search path. In that directory, there are compiled interface files (.cmi), compiled object code files (.cmo), libraries (.cma) related with lablgtk2.

- `-o helloworld`: specify the name of the output file produced by the linker.

The library and object that are usually linked in are:

- The LablGtk library (lablgtk.cma), the GTK+ widget library.

- gtkInit object(gtkInit.cmo), containing gtkInit function. If you use this object code, you don't have to call GtkMain.Main.init () function before any lablgtk functions.

There are many other options and libraries very useful, please refer the ocaml manual.
