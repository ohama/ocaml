---
title: "Text entry"
description: "The Entry widget allows text to be typed and displayed in a single line text box."
weight: 80
---

The Entry widget allows text to be typed and displayed in a single line text box.
The text may be set with function calls that allow new text to replace, prepend or append the current contents of the Entry widget.

Create a new Entry widget with the function GEdit.entry.

``` ocaml
val GEdit.entry :
	?text:string ->
	?visibility:bool ->
	?max_length:int ->
	?activates_default:bool ->
	?editable:bool ->
	?has_frame:bool ->
	?width_chars:int ->
	?width:int ->
	?height:int ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> entry
```
The next method alters the text which is currently within the Entry widget.

``` ocaml
method set_text : string -> unit
```
The set_text method sets the contents of the Entry widget, replacing the current contents. Note that the class Entry implements the Editable interface (yes, gobject supports Java-like interfaces) which contains some more functions for manipulating the contents.

The contents of the Entry can be retrieved by using a call to the following method. This is useful in the callback functions described below.

``` ocaml
method text : string
```
If we don't want the contents of the Entry to be changed by someone typing into it, we can change its editable state.

``` ocaml
method set_editable : bool -> unit
```
The method above allows us to toggle the editable state of the Entry widget by passing in a true or false value as argument.

If we are using the Entry where we don't want the text entered to be visible, for example when a password is being entered, we can use the following method, which also takes a boolean flag.

``` ocaml
method set_visibility : bool -> unit
```
A region of the text may be set as selected by using the following method. This would most often be used after setting some default text in an Entry, making it easy for the user to remove it.

``` ocaml
method select_region : start:int -> stop:int -> unit
```
If we want to catch when the user has entered text, we can connect to the activate or changed signal. Activate is raised when the user hits the enter key within the Entry widget. Changed is raised when the text changes at all, e.g., for every character entered or removed.

The following code is an example of using an Entry widget.

![textentry](../textentry.jpg)

``` ocaml
(* file: entry.ml *)

let enter_cb entry () =
  let text = entry#text in
  Printf.printf "Entry contents: %s\n" text;
  flush stdout

let toggle checkbutton f () = f checkbutton#active

let main () =
  (* Create a new window; set title and border width *)
  let window = GWindow.window ~title:"Entry" 
    ~width:200 ~height:100 ~border_width:10 () in

  (* Set a handler for destroy event that immediately exits GTK. *)
  window#connect#destroy ~callback:GMain.Main.quit;

  let vbox = GPack.vbox ~packing:window#add () in

  let entry = GEdit.entry ~text:"hello" ~max_length:500 ~packing:vbox#add () in
  entry#connect#activate ~callback:(enter_cb entry);
  let tmp_pos = entry#text_length in
  entry#insert_text " world" tmp_pos;
  entry#select_region ~start:0 ~stop:entry#text_length;

  let hbox = GPack.hbox ~packing:vbox#add () in
  let check = GButton.check_button ~label:"Editable"
    ~active:true ~packing:hbox#add () in
  check#connect#toggled ~callback:(toggle check entry#set_editable);

  let check = GButton.check_button ~label:"Visible"
    ~active:true ~packing:hbox#add () in
  check#connect#toggled ~callback:(toggle check entry#set_visibility);

  let button = GButton.button ~stock:`CLOSE ~packing:vbox#add () in
  button#connect#clicked ~callback:window#destroy;

  button#misc#set_can_default true;
  button#misc#grab_default ();

  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
```
