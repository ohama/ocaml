---
title: "Drag-and-drop"
pre: "18. "
weight: 180
description: "GTK+ has a high level set of functions for doing inter-process communication via the drag-and-drop system. GTK+ can perform drag-and-drop on top of the low level Xdnd and Motif drag-and-drop protocols."

---

GTK+ has a high level set of functions for doing inter-process communication via the drag-and-drop system. GTK+ can perform drag-and-drop on top of the low level Xdnd and Motif drag-and-drop protocols.

### Overview
An application capable of GTK+ drag-and-drop first defines and sets up the GTK+ widget(s) for drag-and-drop. Each widget can be a source and/or destination for drag-and-drop.

Source widgets can send out drag data, thus allowing the user to drag things off of them, while destination widgets can receive drag data. Drag-and-drop destinations can limit who they accept drag data from, e.g. the same application or any application (including itself).

Sending and receiving drop data makes use of GTK+ signals. Dropping an item to a destination widget requires both a data request (for the source widget) and data received signal handler (for the target widget). Additional signal handers can be connected if you want to know when a drag begins (at the very instant it starts), to when a drop is made, and when the entire drag-and-drop procedure has ended (successfully or not).

Your application will need to provide data for source widgets when requested, that involves having a drag data request signal handler. For destination widgets they will need a drop data received signal handler.

So a typical drag-and-drop cycle would look as follows:

1. Drag begins.

1. Drag data request (when a drop occurs).

1. Drop data received (may be on same or different application).

1. Drag data delete (if the drag was a move).

1. Drag-and-drop procedure done.

There are a few minor steps that go in between here and there, but we will get into detail about that later.

### Properties

Drag data has the following properties:

- Drag action type (ie \`COPY, \`MOVE).

- Client specified arbitrary drag-and-drop type (a name and number pair).

- Sent and received data format type.

Drag actions are quite obvious, they specify if the widget can drag with the specified action(s), e.g. \`COPY and/or \`MOVE. A \`COPY would be a typical drag-and-drop without the source data being deleted while \`MOVE would be just like \`COPY but the source data will be 'suggested' to be deleted after the received signal handler is called. There are additional drag actions including \`LINK which you may want to look into when you get to more advanced levels of drag-and-drop.

The client specified arbitrary drag-and-drop type is much more flexible, because your application will be defining and checking for that specifically. You will need to set up your destination widgets to receive certain drag-and-drop types by specifying a name and/or number. It would be more reliable to use a name since another application may just happen to use the same number for an entirely different meaning.

### Functions

You can find the full DragAndDrop specification in GObj.drag_ops. And you can use these functions(methods) and events like this:

``` ocaml
[widget]#drag#[method name]
[widget]#drag#connect#[event name]
```

#### Setting up the source widget
The method drag#source_set specifies a set of target types for a drag operation on a widget.

``` ocaml
method source_set :
	?modi:Gdk.Tags.modifier list ->
	?actions:Gdk.Tags.drag_action list ->
	Gtk.target_entry list -> unit
```
The parameters signify the following:

- modi specifies a list of buttons that can start the drag (e.g. `BUTTON1): see Gdk.Tags.modifier

- Gtk.target_entry list specifies a table of target data types the drag will support

- actions specifies a list of possible actions for a drag from this window

The Gtk.target_entry type is the following structure:

``` ocaml
type target_entry = {
	target : string; 
	flags : Tags.target_flags list; 
	info : int; 
} 

type target_flags = [ `SAME_APP | `SAME_WIDGET ] 
```

The fields specify a string representing the drag type, optional flags and application assigned integer identifier.

If a widget is no longer required to act as a source for drag-and-drop operations, the method drag#source_unset can be used to remove a set of drag-and-drop target types.

``` ocaml
method source_unset : unit -> unit
```

#### Signals on the source widget:
The source widget is sent the following signals during a drag-and-drop operation.

Table 1. Source widget signals

| 			| 				|
| --------------------	| ----------------------------|
| drag_begin		| method beginning : callback:(drag_context -> unit) -> GtkSignal.id |
| drag_motion		| method motion : callback:(drag_context -> x:int -> y:int -> time:int32 -> bool) -> GtkSignal.id |
| drag_data_get		| method data_get : callback:(drag_context -> selection_context -> info:int -> time:int32 -> unit) -> GtkSignal.id |
| drag_data_delete	| method data_delete : callback:(drag_context -> unit) -> GtkSignal.id |
| drag_drop		| method drop : callback:(drag_context -> x:int -> y:int -> time:int32 -> bool) -> GtkSignal.id |
| drag_end		| method ending : callback:(drag_context -> unit) -> GtkSignal.id |

#### Setting up a destination widget:

drag#dest_set specifies that this widget can receive drops and specifies what types of drops it can receive.

drag#dest_unset specifies that the widget can no longer receive drops.

``` ocaml
method dest_set :
	?flags:Gtk.Tags.dest_defaults list ->
	?actions:Gdk.Tags.drag_action list ->
	Gtk.target_entry list -> unit

method dest_unset : unit -> unit
```

#### Signals on the destination widget:
The destination widget is sent the following signals during a drag-and-drop operation.

Table 2. Destination widget signals

| 			| 				|
| --------------------	| ----------------------------|
| drag_data_received	| method data_received : callback:(drag_context -> x:int -> y:int -> selection_data -> info:int -> time:int32 -> unit) -> GtkSignal.id |
