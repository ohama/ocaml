---
title: "Spin button"
description: "The Spin Button widget is generally used to allow the user to select a value from a range of numeric values."
weight: 90
---

The Spin Button widget is generally used to allow the user to select a value from a range of numeric values.
It consists of a text entry box with up and down arrow buttons attached to the side. Selecting one of the buttons causes the value to "spin" up and down the range of possible values. The entry box may also be edited directly to enter a specific value.

The Spin Button allows the value to have zero or a number of decimal places and to be incremented/decremented in configurable steps. The action of holding down one of the buttons optionally results in an acceleration of change in the value according to how long it is depressed.

The Spin Button uses an Adjustment object to hold information about the range of values that the spin button can take. This makes for a powerful Spin Button widget.

Recall that an adjustment widget is created with the function GData.adjustment, which illustrates the information that it holds:

``` ocaml
val GData.adjustment :
	?value:float ->
	?lower:float ->
	?upper:float ->
	?step_incr:float ->
	?page_incr:float ->
	?page_size:float -> unit -> adjustment

lower : default value is 0.
upper : default value is 100.
step_incr : default value is 1.
page_incr : default value is 10.
page_size : default value is 10.
```
These attributes of an Adjustment are used by the Spin Button in the following way:

- value: initial value for the Spin Button
- lower: lower range value
- upper: upper range value
- step_increment: value to increment/decrement when pressing mouse button 1 on a button
- page_increment: value to increment/decrement when pressing mouse button 2 on a button
- page_size: unused

Additionally, mouse button 3 can be used to jump directly to the upper or lower values when used to select one of the buttons. Lets look at how to create a Spin Button using GEdit.spin_button:

``` ocaml
val GEdit.spin_button :
	?adjustment:GData.adjustment ->
	?rate:float ->
	?digits:int ->
	?numeric:bool ->
	?snap_to_ticks:bool ->
	?update_policy:[ `ALWAYS | `IF_VALID ] ->
	?value:float ->
	?wrap:bool ->
	?width:int ->
	?height:int ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> spin_button
```
The rate argument take a value between 0.0 and 1.0 and indicates the amount of acceleration that the Spin Button has. The digits argument specifies the number of decimal places to which the value will be displayed.

A Spin Button can be reconfigured after creation using the following methods:

``` ocaml
method set_adjustment : GData.adjustment -> unit
method set_rate : float -> unit
method set_digits : int -> unit
```
The adjustment can be retrieved using the following function:

``` ocaml
method adjustment : GData.adjustment
```
The value that a Spin Button is currently displaying can be changed using the following function:

``` ocaml
method set_value : float -> unit
```
The current value of a Spin Button can be retrieved as either a floating point or integer value with the following functions:

``` ocaml
method value : float
method value_as_int : int
```
If you want to alter the value of a Spin Button relative to its current value, then the following function can be used:

``` ocaml
method spin : Gtk.Tags.spin_type -> unit
```
The argument can take one of the following values:

``` ocaml
  `STEP_FORWARD
  `STEP_BACKWARD
  `PAGE_FORWARD
  `PAGE_BACKWARD
  `HOME
  `END
  `USER_DEFINED of float
```
This function packs in quite a bit of functionality, which I will attempt to clearly explain. Many of these settings use values from the Adjustment object that is associated with a Spin Button.

- \`STEP_FORWARD and \`STEP_BACKWARD change the value of the Spin Button by the amount specified by increment, unless increment is equal to 0, in which case the value is changed by the value of step_increment in theAdjustment.
- \`PAGE_FORWARD and \`PAGE_BACKWARD simply alter the value of the Spin Button by increment.
- \`HOME sets the value of the Spin Button to the bottom of the Adjustments range.
- \`END sets the value of the Spin Button to the top of the Adjustments range.
- \`USER_DEFINED simply alters the value of the Spin Button by the specified amount.

We move away from functions for setting and retreving the range attributes of the Spin Button now, and move onto functions that effect the appearance and behaviour of the Spin Button widget itself.

The first of these functions is used to constrain the text box of the Spin Button such that it may only contain a numeric value. This prevents a user from typing anything other than numeric values into the text box of a Spin Button:

``` ocaml
method set_numeric : bool -> unit
```
You can set whether a Spin Button will wrap around between the upper and lower range values with the following function:

``` ocaml
method set_wrap : bool -> unit
```
You can set a Spin Button to round the value to the nearest step_increment, which is set within the Adjustment object used with the Spin Button. This is accomplished with the following function:

``` ocaml
method set_snap_to_ticks : bool -> unit
```
The update policy of a Spin Button can be changed with the following function:

``` ocaml
method set_update_policy : [ `ALWAYS | `IF_VALID ] -> unit
```
The possible values of policy are either \`ALWAYS or \`IF_VALID.

These policies affect the behavior of a Spin Button when parsing inserted text and syncing its value with the values of the Adjustment.

In the case of \`IF_VALID the Spin Button only value gets changed if the text input is a numeric value that is within the range specified by the Adjustment. Otherwise the text is reset to the current value.

In case of \`ALWAYS we ignore errors while converting text into a numeric value.

Finally, you can explicitly request that a Spin Button update itself:

``` ocaml
method update : unit
```
It's example time again.


![spinbutton](../spinbutton.jpg)

``` ocaml
(* file: spinbutton.ml *)

let toggle checkbutton f () = f checkbutton#active

let get_value spinner label show_type () =
  let text =
    match show_type with
    | `INT -> Printf.sprintf "%d" spinner#value_as_int
    | _ -> Printf.sprintf "%0.*f" spinner#digits spinner#value
  in
  label#set_text text

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Spin Button" ~border_width:10 () in

  (* Set a handler for destroy event that immediately exits GTK. *)
  window#connect#destroy ~callback:GMain.Main.quit;

  let main_vbox = GPack.vbox ~border_width:10 ~packing:window#add () in

  let frame = GBin.frame ~label:"Not accelerated" ~packing:main_vbox#add () in
  let vbox = GPack.vbox ~border_width:5 ~packing:frame#add () in

  (* Day, month, year spinners *)
  let hbox = GPack.hbox ~packing:vbox#add () in

  let vbox2 = GPack.vbox ~packing:hbox#add () in
  let label = GMisc.label ~text:"Day :" ~xalign:0.0 ~yalign:0.5 ~packing:vbox2#add () in
  let adj = GData.adjustment ~value:1.0 ~lower:1.0 ~upper:31.0 ~step_incr:1.0 ~page_incr:5.0 ~page_size:0.0 () in
  let spinner = GEdit.spin_button ~adjustment:adj ~rate:0.0 ~digits:0 ~wrap:true ~packing:vbox2#add () in

  let vbox2 = GPack.vbox ~packing:hbox#add () in
  let label = GMisc.label ~text:"Month :" ~xalign:0.0 ~yalign:0.5 ~packing:vbox2#add () in
  let adj = GData.adjustment ~value:1.0 ~lower:1.0 ~upper:12.0 ~step_incr:1.0 ~page_incr:5.0 ~page_size:0.0 () in
  let spinner = GEdit.spin_button ~adjustment:adj ~rate:0.0 ~digits:0 ~wrap:true ~packing:vbox2#add () in

  let vbox2 = GPack.vbox ~packing:hbox#add () in
  let label = GMisc.label ~text:"Year :" ~xalign:0.0 ~yalign:0.5 ~packing:vbox2#add () in
  let adj = GData.adjustment ~value:1998.0 ~lower:0.0 ~upper:2100.0 ~step_incr:1.0 ~page_incr:100.0 ~page_size:0.0 () in
  let spinner = GEdit.spin_button ~adjustment:adj ~rate:0.0 ~digits:0 ~wrap:false ~width:55 ~packing:vbox2#add () in

  let frame = GBin.frame ~label:"Accelerated" ~packing:main_vbox#add () in
  let vbox = GPack.vbox ~border_width:5 ~packing:frame#add () in

  let hbox = GPack.hbox ~packing:vbox#add () in

  let vbox2 = GPack.vbox ~packing:hbox#add () in
  let label = GMisc.label ~text:"Value :" ~xalign:0.0 ~yalign:0.5 ~packing:vbox2#add () in
  let adj = GData.adjustment ~value:0.0 ~lower:(-10000.0) ~upper:10000.0 ~step_incr:0.5 ~page_incr:100.0 ~page_size:0.0 () in
  let spinner1 = GEdit.spin_button ~adjustment:adj ~rate:1.0 ~digits:2 ~width:100 ~packing:vbox2#add () in

  let vbox2 = GPack.vbox ~packing:hbox#add () in
  let label = GMisc.label ~text:"Digits :" ~xalign:0.0 ~yalign:0.5 ~packing:vbox2#add () in
  let adj = GData.adjustment ~value:2.0 ~lower:1.0 ~upper:5.0 ~step_incr:1.0 ~page_incr:1.0 ~page_size:0.0 () in
  let spinner2 = GEdit.spin_button ~adjustment:adj ~rate:0.0 ~digits:0 ~packing:vbox2#add () in
  adj#connect#value_changed ~callback:(fun () -> spinner1#set_digits spinner2#value_as_int);

  let button = GButton.check_button ~label:"Snap to 0.5-ticks" ~packing:vbox#add () in
  button#connect#clicked ~callback:(toggle button spinner1#set_snap_to_ticks);
  let button = GButton.check_button ~label:"Numeric only input mode" ~active:true ~packing:vbox#add () in
  button#connect#clicked ~callback:(toggle button spinner1#set_numeric);

  let hbox = GPack.hbox ~packing:vbox#add () in
  let val_label = GMisc.label ~text:"0" ~packing:vbox#add () in

  let button = GButton.button ~label:"Value as Int" ~packing:hbox#add () in
  button#connect#clicked ~callback:(get_value spinner1 val_label `INT);
  let button = GButton.button ~label:"Value as Float" ~packing:hbox#add () in
  button#connect#clicked ~callback:(get_value spinner1 val_label `FLOAT);

  let hbox = GPack.hbox ~packing:main_vbox#add () in
  let button = GButton.button ~label:"Close" ~packing:hbox#add () in
  button#connect#clicked ~callback:window#destroy;

  window#show ();

  (* Enter the event loop *)
  GMain.Main.main ()

let _ = Printexc.print main ()
```
