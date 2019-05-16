---
title: "Automatic menu generation"
description: "You can generate menu automatically using GToolbox.build_menu."
weight: 30
---

You can generate menu automatically using GToolbox.build_menu.

``` ocaml
val GToolbox.build_menu :
	GMenu.menu ->
	entries:menu_entry list -> unit
```
The first argument of this function is the GMenu.menu with which various menu entries will be associated. And the function takes a value of GToolbox.menu_entry type as the second argument:

``` ocaml
type menu_entry =
  [ `I of string * (unit -> unit)
  | `C of string * bool * (bool -> unit)
  | `R of (string * bool * (bool -> unit)) list
  | `M of string * menu_entry list
  | `S ]
```
- \`I: means GMenu.menu_item. It takes as arguments the label of menu_item and the callback function which is called when the menu_item is selected.

- \`C: means GMenu.check_menu_item. It takes as arguments the label of check_menu_item, the default state value, and the callback function which is called when the menu_item is selected.

- \`R: means GMenu.radio_menu_item. It takes a radio_menu_item description list as an argument. Each radio_menu_item description consists of (label, default state, callback function).

- \`M: means GMenu.menu. It takes as arguments the label of menu and the list of menu_entry which will be associated with this menu.

- \`S: means GMenu.separator_item.

You can use GToolbox.menu_entry for popup menu using GToolbox.popup_menu:

``` ocaml
val GToolbox.popup_menu :
	entries:menu_entry list ->
	button:int ->
	time:int32 -> unit
```

### Automatic Menu Generation Example

``` ocaml
(* file: menu_entry.ml *)

let print msg () =
  print_endline msg;
  flush stdout

let print_toggle selected =
  if selected
  then print_endline "On"
  else print_endline "Off";
  flush stdout

let print_selected n selected =
  if selected then (
    print_endline (string_of_int n);
    flush stdout
  )

let file_entries = [
  `I ("New", print "New");
  `I ("Open", print "Open");
  `I ("Save", print "Save");
  `I ("Save As", print "Save As");
  `S;
  `I ("Quit", GMain.Main.quit)
]

let option_entries = [
  `C ("Check", false, print_toggle);
  `S;
  `R [("Rad1", true, print_selected 1);
      ("Rad2", false, print_selected 2);
      ("Rad3", false, print_selected 3)]
]

let help_entries = [
  `I ("About", print "About");
]

let entries = [
  `M ("File", file_entries);
  `M ("Options", option_entries);
  `M ("Help", help_entries)
]

let create_menu label menubar =
  let item = GMenu.menu_item ~label ~packing:menubar#append () in
  GMenu.menu ~packing:item#set_submenu ()

let main () =
  (* Make a window *)
  let window = GWindow.window ~title:"Menu Entry" ~border_width:10 () in
  window#connect#destroy ~callback:GMain.Main.quit;
  
  let main_vbox = GPack.vbox ~packing:window#add () in

  let menubar = GMenu.menu_bar ~packing:main_vbox#add () in

  let menu = create_menu "File" menubar in
  GToolbox.build_menu menu ~entries:file_entries;

  let menu = create_menu "Options" menubar in
  GToolbox.build_menu menu ~entries:option_entries;

  let menu = create_menu "Help" menubar in
  GToolbox.build_menu menu ~entries:help_entries;

  (* Popup menu *)
  let button = GButton.button ~label:"Popup" ~packing:main_vbox#add () in
  button#connect#clicked ~callback:(fun () ->
    GToolbox.popup_menu ~entries ~button:0
	  ~time:(GtkMain.Main.get_current_event_time ())
    );

  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
```
