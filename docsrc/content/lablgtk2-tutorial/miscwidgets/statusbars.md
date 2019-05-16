---
title: "Statusbars"
description: "Statusbars are simple widgets used to display a text message."
weight: 70
---

Statusbars are simple widgets used to display a text message.
They keep a stack of the messages pushed onto them, so that popping the current message will re-display the previous text message.

In order to allow different parts of an application to use the same statusbar to display messages, the statusbar widget issues Context Identifiers which are used to identify different "users". The message on top of the stack is the one displayed, no matter what context it is in. Messages are stacked in last-in-first-out order, not context identifier order.

A statusbar is created with a call to GMisc.status_bar :

``` ocaml
val GMisc.statusbar :
	?border_width:int ->
	?width:int ->
	?height:int ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> statusbar
```
A new Context Identifier is requested using a call to the following function with a short textual description of the context:

``` ocaml
method new_context : name:string -> statusbar_context
```
There are three functions that can operate on statusbar_contexts:

``` ocaml
method push : string -> Gtk.statusbar_message
method pop : unit -> unit
method remove : Gtk.statusbar_message -> unit
```
The first, push method, is used to add a new message to the statusbar. It returns a Message Identifier, which can be passed later to the remove method to remove the message with the given Message Identifiers and Context from the statusbar's stack.

The method pop removes the message highest in the stack with the given Context.

The following example creates a statusbar and two buttons, one for pushing items onto the statusbar, and one for popping the last item back off.

![statusbar](../statusbar.jpg)

``` ocaml
(* file: statusbar.ml *)

let count = ref 0

let push_item context () =
  incr count;
  context#push (Printf.sprintf "item %d" !count);
  ()

let pop_item context () =
  context#pop ();
  ()

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Statusbar" () in

  (* Set a handler for destroy event that immediately exits GTK. *)
  window#connect#destroy ~callback:GMain.Main.quit;

  let vbox = GPack.vbox ~packing:window#add () in

  let statusbar = GMisc.statusbar ~packing:vbox#add () in
  let context = statusbar#new_context ~name:"Statusbar example" in

  let button = GButton.button ~label:"push item" ~packing:vbox#add () in
  button#connect#clicked ~callback:(push_item context);

  let button = GButton.button ~label:"pop last item" ~packing:vbox#add () in
  button#connect#clicked ~callback:(pop_item context);

  (* always display the window as the last step so it all splashes on
   * the screen at once. *)
  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
```
