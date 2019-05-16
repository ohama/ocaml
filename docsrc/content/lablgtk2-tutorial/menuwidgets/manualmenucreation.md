---
title: "Manual menu createion"
description: "At first glance, the EventBox widget might appear to be totally useless."
weight: 10
---

In the true tradition of teaching, we'll show you the hard way first. :)

There are three widgets that go into making a menubar and submenus:

- a menu item, which is what the user wants to select, e.g., "Save"

- a menu, which acts as a container for the menu items, and

- a menubar, which is a container for each of the individual menus.

This is slightly complicated by the fact that menu item widgets are used for two different things. They are both the widgets that are packed into the menu, and the widget that is packed into the menubar, which, when selected, activates the menu.

Let's look at the functions that are used to create menus and menubars. This first function GMenu.menu_bar is used to create a new menubar.

``` ocaml
GMenu.menu_bar : ?border_width:int ->
	?width:int ->
	?height:int ->
	?packing:(GObj.widget -> unit) ->
	?show:bool ->
	unit -> menu_shell
```
This rather self explanatory function creates a new menubar. You use gtk_container_add() to pack this into a window, or the box_pack functions to pack it into a box - the same as buttons: GMenu.menu.

``` ocaml
GMenu.menu : ?accel_path:string ->
	?border_width:int ->
	?packing:(menu -> unit) ->
	?show:bool ->
	unit -> menu
```
This function returns a new menu; it is never actually shown, it is just a container for the menu items. I hope this will become more clear when you look at the example below.

The next call GMenu.menu_item is used to create menu item that is packed into the menu (and menubar).

``` ocaml
GMenu.menu_item : ?use_mnemonic:bool ->
	?label:string ->
	?right_justified:bool ->
	?packing:(menu_item -> unit) ->
	?show:bool ->
	unit -> menu_item
```
This call is used to create a menu item that is to be displayed. Remember to differentiate between a "menu" as created with GMenu.menu () and a "menu item" as created by the GMenu.menu_item () functions. The menu item will be an actual button with an associated action, whereas a menu will be a container holding menu items.

The ~label option of GMenu.menu_item creates a new menu item with a label already packed into it.

Once you've created a menu item you have to put it into a menu. This is done using the function GMenu.menu#append. In order to capture when the item is selected by the user, we need to connect to the activate signal in the usual way. So, if we wanted to create a standard File menu, with the options Open, Save, and Quit, the code would look something like:

``` ocaml
let create_menu () =
  let file_menu = GMenu.menu () in
  let item = GMenu.menu_item ~label:"Open" ~packing:file_menu#append () in
  item#connect#activate ~callback:(uprint "Open");
  let item = GMenu.menu_item ~label:"Save" ~packing:file_menu#append () in
  item#connect#activate ~callback:(uprint "Save");
  let item = GMenu.menu_item ~label:"Quit" ~packing:file_menu#append () in
  item#connect#activate ~callback:GMain.Main.quit;
  file_menu
```
At this point we have our menu. Now we need to create a menubar and a menu item for the File entry, to which we add our menu. The code looks like this:

``` ocaml
  let file_menu = create_menu () in
  let menu_bar = GMenu.menu_bar ~packing:window#add () in
  let file_item = GMenu.menu_item ~label:"File" () in
```
Now we need to associate the menu with file_item. This is done with the function

``` ocaml
GMenu.menu_item#set_submenu : menu -> unit
```
So, our example would continue with

``` ocaml
  file_item#set_submenu file_menu;
```
All that is left to do is to add the menu to the menubar, which is accomplished using the function

``` ocaml
GMenu.menu_shell#append : GMenu.menu_item -> unit
```
which in our case looks like this:

``` ocaml
  menu_bar#append file_item;
```
The complete code looks like this:

``` ocaml
let uprint msg () =
  print_endline msg;
  flush stdout

let create_menu () =
  let file_menu = GMenu.menu () in
  let item = GMenu.menu_item ~label:"Open" ~packing:file_menu#append () in
  item#connect#activate ~callback:(uprint "Open");
  let item = GMenu.menu_item ~label:"Save" ~packing:file_menu#append () in
  item#connect#activate ~callback:(uprint "Save");
  let item = GMenu.menu_item ~label:"Quit" ~packing:file_menu#append () in
  item#connect#activate ~callback:GMain.Main.quit;
  file_menu

let main () =
  let window = GWindow.window () in
  window#connect#destroy ~callback:GMain.Main.quit;
  let file_menu = create_menu () in
  let menu_bar = GMenu.menu_bar ~packing:window#add () in
  let file_item = GMenu.menu_item ~label:"File" () in
  file_item#set_submenu file_menu;
  menu_bar#append file_item;
  window#show ();
  GMain.Main.main ()

let _ = main ()
```
The more compact code looks like this:

``` ocaml
let uprint msg () =
  print_endline msg;
  flush stdout

let create_menu ~packing () =
  let file_menu = GMenu.menu ~packing () in
  let item = GMenu.menu_item ~label:"Open" ~packing:file_menu#append () in
  item#connect#activate ~callback:(uprint "Open");
  let item = GMenu.menu_item ~label:"Save" ~packing:file_menu#append () in
  item#connect#activate ~callback:(uprint "Save");
  let item = GMenu.menu_item ~label:"Quit" ~packing:file_menu#append () in
  item#connect#activate ~callback:GMain.Main.quit

let main () =
  let window = GWindow.window () in
  window#connect#destroy ~callback:GMain.Main.quit;
  let menu_bar = GMenu.menu_bar ~packing:window#add () in
  let file_item = GMenu.menu_item ~label:"File" ~packing:menu_bar#append () in
  create_menu ~packing:file_item#set_submenu ();
  window#show ();
  GMain.Main.main ()

let _ = main ()
```
If we wanted the menu right justified on the menubar, such as help menus often are, we can use the ~right_justify option (again on file_item in the current example) on menu_item createion.

``` ocaml
  let item = GMenu.menu_item ~right_justify:true () in
  ...
```
Here is a summary of the top down steps needed to create a menu bar with menus attached:

- Create a new menubar using GMenu.menu_bar (). This step only needs to be done once when creating a series of menus on one menu bar.

- Create a menu item using GMenu.menu_item (). This will be the root of the menu, the text appearing here will be on the menubar itself.

- Use GMenu.menu_bar#append method to put the root menu item onto the menubar.

- Create a new menu using GMenu.menu ()

- Use GMenu.menu_item#set_submenu method to attach the menu to the root menu item (the one created in the above step).

- Use multiple calls to GMenu.menu_item () for each item you wish to have on your menu. And use GMenu.menu#append method to put each of these new items on to the menu.

Creating a popup menu is nearly the same. The difference is that the menu is not posted "automatically" by a menubar, but explicitly by calling the function GMenu.menu#popup method from a button-press event, for example. Take these steps:

- Create an event handling function. It needs to have the prototype

``` ocaml
let button_pressed ev =
  ...
```
But for poping up menu, you may give one more argument for the event handling function like this:

``` ocaml
let button_pressed menu ev =
  ...
  menu#popup ~button ~time:(GdkEvent.Button.time ev);
  ...
```
and it will use the event to find out where to pop up the menu.

- In the event handler, if the event is a mouse button press, treat event as a button event (which it is) and use it as shown in the sample code to pass information to GMenu.menu#popup method.

- Bind that event handler to a widget with

``` ocaml
  widget#event#connect#button_press ~callback:(button_pressed menu);
```
where widget is the widget you are binding to, handler is the handling function, and menu is a menu created with GMenu.menu (). This can be a menu which is also posted by a menu bar, as shown in the sample code.
