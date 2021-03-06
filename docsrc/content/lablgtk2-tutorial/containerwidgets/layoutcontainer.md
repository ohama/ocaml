---
title: "Layout container"
description: "The Layout container is similar to the Fixed container except that it implements an infinite (where infinity is less than 2^32) scrolling area."
weight: 40
---

The Layout container is similar to the Fixed container except that it implements an infinite (where infinity is less than 2^32) scrolling area.
The X window system has a limitation where windows can be at most 32767 pixels wide or tall. The Layout container gets around this limitation by doing some exotic stuff using window and bit gravities, so that you can have smooth scrolling even when you have many child widgets in your scrolling area.

A Layout container is created using GPack.layout:
``` ocaml
val GPack.layout :
	?hadjustment:GData.adjustment ->
	?vadjustment:GData.adjustment ->
	?layout_width:int ->
	?layout_height:int ->
	?border_width:int ->
	?width:int ->
	?height:int ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> layout
```
As you can see, you can optionally specify the Adjustment objects that the Layout widget will use for its scrolling.

You can add and move widgets in the Layout container using the following two functions:

``` ocaml
method move : GObj.widget -> x:int -> y:int -> unit
method put : GObj.widget -> x:int -> y:int -> unit
```
The size of the Layout container can be set using the next functions:

``` ocaml
method set_height : int -> unit
method set_width : int -> unit
```
The final four functions for use with Layout widgets are for manipulating the horizontal and vertical adjustment widgets:

``` ocaml
method hadjustment : GData.adjustment
method vadjustment : GData.adjustment
method set_hadjustment : GData.adjustment -> unit
method set_vadjustment : GData.adjustment -> unit
```
