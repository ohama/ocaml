---
title: "Functions for rc files"
description: "When your application starts, it reads the default RC files."
weight: 10
---

When your application starts, it reads the default RC files. which are [SYSCONFDIR]/gtk-2.0/gtkrc and .gtkrc-2.0 in the users home directory. ([SYSCONFDIR] defaults to /usr/local/etc.) You can add default file:

``` ocaml
val GMain.Rc.add_default_file : string -> unit
```
If you wish to have a special set of widgets that can take on a different style from others, or any other logical division of widgets, use a call to:

``` ocaml
method misc#set_name : string -> unit
```
Passing your newly created widget as the first argument, and the name you wish to give it as the second. This will allow you to change the attributes of this widget by name through the rc file.

If we use a call something like this:

``` ocaml
let button = GButton.button ~label:"Special Button" in
button#misc#set_name "special button"
```
Then this button is given the name "special button" and may be addressed by name in the rc file as "special button.GtkButton". [<--- Verify ME!]

The example rc file below, sets the properties of the main window, and lets all children of that main window inherit the style described by the "main button" style. The code used in the application is:

``` ocaml
let window = GWindow.window () in
window#misc#set_name "main window"
```
And then the style is defined in the rc file using:

``` ocaml
widget "main window.*GtkButton*" style "main_button"
```
Which sets all the Button widgets in the "main window" to the "main_buttons" style as defined in the rc file.

As you can see, this is a fairly powerful and flexible system. Use your imagination as to how best to take advantage of this.

> I have also found, by experimentation, that you have to call this function (GMain.Rc.add_default_file) very early in the program for it to have any effect at all. I have now placed by call right at the very start of the program, before all other code, as that is seemingly the only way to get Gtk to actually read my local resource file. - Rich.
