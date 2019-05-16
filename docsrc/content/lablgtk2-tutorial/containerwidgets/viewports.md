---
title: "View ports"
description: "It is unlikely that you will ever need to use the Viewport widget directly. You are much more likely to use the Scrolled Window widget which itself uses the Viewport."
weight: 80
---

It is unlikely that you will ever need to use the Viewport widget directly. You are much more likely to use the Scrolled Window widget which itself uses the Viewport.

A viewport widget allows you to place a larger widget within it such that you can view a part of it at a time. It uses Adjustments to define the area that is currently in view.

A Viewport is created with the function GBin.viewport

``` ocaml
val GBin.viewport :
	?hadjustment:GData.adjustment ->
	?vadjustment:GData.adjustment ->
	?shadow_type:Gtk.Tags.shadow_type ->
	?border_width:int ->
	?width:int ->
	?height:int ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> viewport
```
As you can see you can specify the horizontal and vertical Adjustments that the widget is to use when you create the widget. It will create its own if you don't pass the arguments.

You can get and set the adjustments after the widget has been created using the following four functions:

``` ocaml
method hadjustment : GData.adjustment
method vadjustment : GData.adjustment
method set_hadjustment : GData.adjustment -> unit
method set_vadjustment : GData.adjustment -> unit
```
The other viewport function is used to alter its appearance:

``` ocaml
method set_shadow_type : Gtk.Tags.shadow_type -> unit
```
Possible values for the Gtk.Tags.shadow_type parameter are:

``` ocaml
  `NONE,
  `IN,
  `OUT,
  `ETCHED_IN,
  `ETCHED_OUT
```
