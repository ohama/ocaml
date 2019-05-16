---
title: "Tooltips object"
description: "The little text strings that pop up when you leave your pointer over a button or other widget for a few seconds."
weight: 30
---

These are the little text strings that pop up when you leave your pointer over a button or other widget for a few seconds. They are easy to use, so I will just explain them without giving an example. If you want to see some code, take a look at the testgtk.ml program distributed with LablGTK.

Widgets that do not receive events (widgets that do not have their own window) will not work with tooltips.

The first call you will use creates a new tooltip using GData.tooltips function. You only need to do this once for a set of tooltips as the GData.tooltips object this function returns can be used to create multiple tooltips.

``` ocaml
val GData.tooltips : ?delay:int -> unit -> tooltips
```
Once you have created a new tooltip, and the widget you wish to use it on, simply use this call to set it:

``` ocaml
method set_tip : ?text:string -> ?privat:string -> GObj.widget -> unit
```
The ?text argument is the text you with to say, which is followed by the widget you wish to have this tooltip pop up for wish it to say. The ?privat argument is a text string that can be used as an identifier when using GtkTipsQuery to implement context sensitive help. For now, you don't have to give it.

Here's a short example:

``` ocaml
let tooltips = GData.tooltips () in
let button = GButton.button ~label:"This is button1" () in
.
.
.
tooltips#set_tip button#coerce ~text:"This is button1";
```
There are other calls that can be used with tooltips. I will just list them with a brief description of what they do.

``` ocaml
method enable : unit -> unit
```
Enable a disabled set of tooltips.

``` ocaml
method disable : unit -> unit
```
Disable an enabled set of tooltips.
