---
title: "Arrows"
description: "The Arrow widget draws an arrowhead, facing in a number of possible directions and having a number of possible styles."
weight: 20
---

The Arrow widget draws an arrowhead, facing in a number of possible directions and having a number of possible styles.
It can be very useful when placed on a button in many applications. Like the Label widget, it emits no signals.

GMisc.arrrow is the function for creating an Arrow widget:

``` ocaml
val GMisc.arrow :
	?kind:Gtk.Tags.arrow_type ->
	?shadow:Gtk.Tags.shadow_type ->
	?xalign:float ->
	?yalign:float ->
	?xpad:int ->
	?ypad:int ->
	?width:int ->
	?height:int ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> arrow

	kind : default value is `RIGHT
	shadow : default value is `OUT
```
This creates a new arrow widget with the indicated type and appearance. The second allows these values to be altered retrospectively. The ?kind argument may take one of the following values:

``` ocaml
  `UP
  `DOWN
  `LEFT
  `RIGHT
```
These values obviously indicate the direction in which the arrow will point. The ?shadow argument may take one of these values:

``` ocaml
  `IN
  `OUT (the default)
  `ETCHED_IN
  `ETCHED_OUT
  `NONE
```
Here's a brief example to illustrate their use.

![arrow](../arrow.jpg)


``` ocaml
(* file: arrow.ml *)

(* Create an Arrow widget with the specified parameters
 * and pack in into a button *)
let create_arrow_button ~kind ~shadow ~packing () =
  let button = GButton.button ~packing () in
  let arrow = GMisc.arrow ~kind ~shadow ~packing:button#add () in
  button

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Arrow Buttons" ~border_width:10 () in

  (* Set a handler for destroy event that immediately exits GTK. *)
  window#connect#destroy ~callback:GMain.Main.quit;

  (* Create a box to hold the arrow/buttons *)
  let box = GPack.hbox ~border_width:2 ~packing:window#add () in

  let f (kind, shadow) =
    create_arrow_button ~kind ~shadow ~packing:box#add ();
    ()
  in
  List.iter f [(`UP, `IN); (`DOWN, `OUT); (`LEFT, `ETCHED_IN);
    (`RIGHT, `ETCHED_OUT) ];

  window#show ();
  (* Rest in main and wait for the fun to begin! *)
  GMain.Main.main ()

let _ = Printexc.print main ()
```
