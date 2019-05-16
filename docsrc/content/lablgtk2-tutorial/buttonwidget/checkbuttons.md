---
title: "Check buttons"
description: "Check buttons inherit many properties and functions from the the toggle buttons."
weight: 30
---

Check buttons inherit many properties and functions from the the toggle buttons above,
but look a little different. Rather than being buttons with text inside them, they are small squares with the text to the right of them. These are often used for toggling options on and off in applications.

The creation functions are similar to those of the normal button. See GButton.check_button.

``` ocaml
val GButton.check_button :
	?label:string ->
	?use_mnemonic:bool ->
	?stock:GtkStock.id ->
	?relief:Gtk.Tags.relief_style ->
	?active:bool ->
	?draw_indicator:bool ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> toggle_button
```

This function call with ~lablel option creates a check button with a label beside it.

Checking the state of the check button is identical to that of the toggle button.
