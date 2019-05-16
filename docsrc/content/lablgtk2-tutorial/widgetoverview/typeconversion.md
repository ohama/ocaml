---
title: "Type conversion"
description: "Type conversion"
weight: 10
---

You'll notice as you go on that you need a type conversion. What you will see are:

``` ocaml
method as_widget : Gtk.widget Gtk.obj
method coerce : widget
```

These are all used to cast arguments in functions. You'll see them in the examples, and can usually tell when to use them simply by looking at the function's declaration.

For example:

``` ocaml
box#pack button#corece;
```

This casts the button into a widget.
