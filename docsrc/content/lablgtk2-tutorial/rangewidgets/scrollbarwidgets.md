---
title: "Scale widget"
description: "Scale widgets are used to allow the user to visually select and manipulate a value within a specific range."
weight: 20
---

Scale widgets are used to allow the user to visually select and manipulate a value within a specific range.
You might want to use a scale widget, for example, to adjust the magnification level on a zoomed preview of a picture, or to control the brightness of a color, or to specify the number of minutes of inactivity before a screensaver takes over the screen.

### Creating a Scale Widget
As with scrollbars, there is a widget type for horizontal and vertical scale widgets. (Most programmers seem to favour horizontal scale widgets.) The following function GRange.scale creates vertical or horizontal scale widgets according to the argument;\`VERTICAL or \`HORIZONTAL:

``` ocaml
val GRange.scale :
	Gtk.Tags.orientation ->
	?adjustment:GData.adjustment ->
	?digits:int ->
	?draw_value:bool ->
	?value_pos:Gtk.Tags.position ->
	?inverted:bool ->
	?update_policy:Gtk.Tags.update_type ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> scale

digits : default value is 1
draw_value : default value is false
value_pos : default value is `LEFT
inverted : default value is false
update_policy : default value is `CONTINUOUS
```

The adjustment argument may be given which has already been created with GData.adjustment, or may not, in which case, an anonymous Adjustment is created with all of its values set to 0.0 (which isn't very useful in this case). In order to avoid confusing yourself, you probably want to create your adjustment with a page_size of 0.0 so that its upper value actually corresponds to the highest value the user can select. (If you're already thoroughly confused, read the section on Adjustments again for an explanation of what exactly adjustments do and how to create and manipulate them.)

### Functions and Signals (well, functions, at least)
Scale widgets can display their current value as a number beside the trough. The default behaviour is to show the value, but you can change this with this function:

``` ocaml
method set_draw_value : bool -> unit
```
The value displayed by a scale widget is rounded to one decimal point by default, as is the value field in its Adjustment. You can change this with:

``` ocaml
method set_digits : int -> unit
```
where digits is the number of decimal places you want. You can set digits to anything you like, but no more than 13 decimal places will actually be drawn on screen.

Finally, the value can be drawn in different positions relative to the trough:

``` ocaml
method set_value_pos : Gtk.Tags.position -> unit
```
The argument can take one of the following values:

``` ocaml
  `LEFT
  `RIGHT
  `TOP
  `BOTTOM
```
If you position the value on the "side" of the trough (e.g., on the top or bottom of a horizontal scale widget), then it will follow the slider up and down the trough.
