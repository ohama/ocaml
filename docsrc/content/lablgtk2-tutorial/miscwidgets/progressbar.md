---
title: "Progress bars"
description: "Progress bars are used to show the status of an operation."
weight: 40
---

Progress bars are used to show the status of an operation. They are pretty easy to use, as you will see with the code below. But first lets start out with the calls to create a new progress bar using GRange.progress_bar.

``` ocaml
val GRange.progress_bar:
	?orientation:Gtk.Tags.progress_bar_orientation ->
	?pulse_step:float ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> progress_bar

orientation : default value is `LEFT_TO_RIGHT
pulse_step : default value is 0.1
```
Now that the progress bar has been created we can use it.

``` ocaml
method set_fraction : float -> unit
```
The argument is the amount "completed", meaning the amount the progress bar has been filled from 0-100%. This is passed to the method as a float number ranging from 0.0 to 1.0

GTK v1.2 has added new functionality to the progress bar that enables it to display its value in different ways, and to inform the user of its current value and its range.

A progress bar may be set to one of a number of orientations using the function

``` ocaml
method set_orientation : Gtk.Tags.progress_bar_orientation -> unit
```
The orientation argument may take one of the following values to indicate the direction in which the progress bar moves:

``` ocaml
  `LEFT_TO_RIGHT
  `RIGHT_TO_LEFT
  `BOTTOM_TO_TOP
  `TOP_TO_BOTTOM
```
As well as indicating the amount of progress that has occured, the progress bar may be set to just indicate that there is some activity. This can be useful in situations where progress cannot be measured against a value range. The following function indicates that some progress has been made.

``` ocaml
method pulse : unit -> unit
```
The step size of the activity indicator is set using the following function.

``` ocaml
method set_pulse_step : float -> unit
```
When not in activity mode, the progress bar can also display a configurable text string within its trough, using the following function.

``` ocaml
method set_text : string -> unit
```
You can turn off the display of the string by calling set_text method again with empty string as an argument.

The current text setting of a progressbar can be retrieved with the following function.

``` ocaml
method text : string
```
Progress Bars are usually used with timeouts or other such functions (see section on Timeouts and Idle Functions) to give the illusion of multitasking. All will employ the set_fraction or pulse methods in the same manner.

Here is an example of the progress bar, updated using timeouts. This code also shows you how to reset the Progress Bar.


``` ocaml
(* file: progressbar.ml *)

let pulse_mode = ref false

(* Update the value of the progress bar so that we get
 * some movement *)
let progress_timeout pbar () =
  if !pulse_mode
  then pbar#pulse ()
  else (
    (* Calculate the value of the progress bar using the
     * value range set in the adjustment object *)
    let new_val =
      let v = pbar#fraction +. 0.01 in
      if v > 1.0 then 0.0 else v
    in
      pbar#set_fraction new_val
  );

  (* As this is a timeout function, return true so that it
   * continues to get called *)
  true

(* Callback that toggles the text display with the progress bar trough *)
let toggle_show_text pbar () =
  let text = pbar#text in
  if text = ""
  then pbar#set_text "some text"
  else pbar#set_text ""

(* Callback that toggles the activity mode of the progress bar *)
let toggle_activity_mode pbar () =
  pulse_mode := not !pulse_mode;
  if !pulse_mode
  then pbar#pulse ()
  else pbar#set_fraction 0.0

(* Callback that toggles the orientation of the progress bar *)
let toggle_orientation pbar () =
  match pbar#orientation with
  | `LEFT_TO_RIGHT -> pbar#set_orientation `RIGHT_TO_LEFT
  | `RIGHT_TO_LEFT -> pbar#set_orientation `LEFT_TO_RIGHT
  | _ -> ()

(* Remove timer and quit *)
let destroy_progress timer () =
  GMain.Timeout.remove timer;
  GMain.Main.quit ()

let main () =
  let window = GWindow.window ~title:"ProgressBar" () in

  let vbox = GPack.vbox ~border_width:10 ~packing:window#add () in

  (* Create a centering alignment object *)
  let align = GBin.alignment ~xalign:0.5 ~yalign:0.5
    ~xscale:0.0 ~yscale:0.0 ~packing:vbox#add ()
  in

  (* Create the progressbar *)
  let pbar = GRange.progress_bar ~packing:align#add () in

  (* Add a timer callback to update the value of the progress bar *)
  let timer = GMain.Timeout.add ~ms:100 ~callback:(progress_timeout pbar) in
  GMisc.separator `HORIZONTAL ~packing:vbox#add ();

  let table = GPack.table ~rows:3 ~columns:1 ~homogeneous:false
    ~packing:vbox#add ()
  in

  (* Add a check button to select displaying of trough text *)
  let check = GButton.check_button ~label:"Show text"
    ~packing:(table#attach ~left:0 ~top:0) ()
  in
  check#connect#clicked ~callback:(toggle_show_text pbar);
  
  (* Add a check button to toggle activity mode *)
  let check = GButton.check_button ~label:"Activity mode"
    ~packing:(table#attach ~left:0 ~top:1) ()
  in
  check#connect#clicked ~callback:(toggle_activity_mode pbar);

  (* Add a check button to toggle orientation *)
  let check = GButton.check_button ~label:"Right to Left"
    ~packing:(table#attach ~left:0 ~top:2) ()
  in
  check#connect#clicked ~callback:(toggle_orientation pbar);

  (* Add a buton to exit the program *)
  let button = GButton.button ~label:"Close" ~packing:vbox#add () in
  button#connect#clicked ~callback:(destroy_progress timer);

  window#connect#destroy ~callback:(destroy_progress timer);
  window#show ();
  GMain.Main.main ()

let _ = main ()
```
