---
title: "Toggle buttons"
description: "Toggle buttons are derived from normal buttons and are very similar, except they will always be in one of two states, alternated by a click."
weight: 20
---

Toggle buttons are derived from normal buttons and are very similar, except they will always be in one of two states, alternated by a click. They may be depressed, and when you click again, they will pop back up. Click again, and they will pop back down.

Toggle buttons are the basis for check buttons and radio buttons, as such, many of the calls used for toggle buttons are inherited by radio and check buttons. I will point these out when we come to them.

Creating a new toggle button; see GButton.toggle_button:

``` ocaml
val GButton.toggle_button :
	?label:string ->
	?use_mnemonic:bool ->
	?stock:GtkStock.id ->
	?relief:Gtk.Tags.relief_style ->
	?active:bool ->
	?draw_indicator:bool ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> toggle_button
```

As you can imagine, these work identically to the normal button widget calls. You can create a blank toggle button, and with ~lablel or ~use_mnemonic, a button with a label widget already packed into it. The use_mnemonic variant additionally parses the label for '_'-prefixed mnemonic characters.

To retrieve the state of the toggle widget, including radio and check buttons, we use a construct as shown in our example below. This tests the state of the toggle button, by calling the active method of the toggle widget's structure. The signal of interest to us emitted by toggle buttons (the toggle button, check button, and radio button widgets) is the "toggled" signal. To check the state of these buttons, set up a signal handler to catch the toggled signal, and get its state. The callback will look something like:

``` ocaml
method toggled : callback:(unit -> unit) -> GtkSignal.id
```

To force the state of a toggle button, and its children, the radio and check buttons, use this method:

``` ocaml
method set_active : bool -> unit
```

The above call can be used to set the state of the toggle button, and its children the radio and check buttons. Passing a true or false as the argument to specify whether it should be down (depressed) or up (released). Default is up, or false.

Note that when you use the set_active method, and the state is actually changed, it causes the "clicked" and "toggled" signals to be emitted from the button.

method active : bool
This returns the current state of the toggle button.
