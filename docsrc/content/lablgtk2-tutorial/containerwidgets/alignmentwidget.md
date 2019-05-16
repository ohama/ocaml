---
title: "Alignment widget"
description: "The alignment widget allows you to place a widget within its window at a position and size relative to the size of the Alignment widget itself."
weight: 20
---

The alignment widget allows you to place a widget within its window at a position and size relative to the size of the Alignment widget itself.
For example, it can be very useful for centering a widget within the window.

GBin.alignment is the function associated with the Alignment widget:

``` ocaml
val GBin.alignment :
	?xalign:Gtk.clampf ->
	?yalign:Gtk.clampf ->
	?xscale:Gtk.clampf ->
	?yscale:Gtk.clampf ->
	?border_width:int ->
	?width:int ->
	?height:int ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> alignment
```
This function creates a new Alignment widget with the specified parameters.

The parameters of Gtk.clampf type are floating point numbers which can range from 0.0 to 1.0. The xalign and yalign arguments affect the position of the widget placed within the Alignment widget. The xscale and yscale arguments effect the amount of space allocated to the widget.

A child widget can be added to this Alignment widget using:

``` ocaml
method add : GObj.widget -> unit
```
For an example of using an Alignment widget, refer to the example for the Progress Bar widget.


