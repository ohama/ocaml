---
title: "Toolbar"
description: "Toolbars are usually used to group some number of widgets in order to simplify customization of their look and layout."
weight: 110
---

Toolbars are usually used to group some number of widgets in order to simplify customization of their look and layout.
Typically a toolbar consists of buttons with icons, labels and tooltips, but any other widget can also be put inside a toolbar. Finally, items can be arranged horizontally or vertically and buttons can be displayed with icons, labels, or both.

Creating a toolbar is (as one may already suspect) done with the function GButton.toolbar:

``` ocaml
val GButton.toolbar :
	?orientation:Gtk.Tags.orientation ->
	?style:Gtk.Tags.toolbar_style ->
	?tooltips:bool ->
	?border_width:int ->
	?width:int ->
	?height:int ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> toolbar
```
After creating a toolbar one can insert button, radio_button, toggle_button or any widget types into the toolbar. To describe an item we need a label text, a tooltip text, a private tooltip text, an icon for the button and a callback function for it. For example, to insert an item you may use the following functions:

``` ocaml
method insert_button :
	?text:string ->
	?tooltip:string ->
	?tooltip_private:string ->
	?icon:GObj.widget ->
	?pos:int ->
	?callback:(unit -> unit) -> unit -> button

method insert_radio_button :
	?text:string ->
	?tooltip:string ->
	?tooltip_private:string ->
	?icon:GObj.widget ->
	?pos:int ->
	?callback:(unit -> unit) -> unit -> radio_button

method insert_toggle_button :
	?text:string ->
	?tooltip:string ->
	?tooltip_private:string ->
	?icon:GObj.widget ->
	?pos:int ->
	?callback:(unit -> unit) -> unit -> toggle_button

method insert_widget :
	?tooltip:string ->
	?tooltip_private:string ->
	?pos:int ->
	GObj.widget -> unit

pos: default value is (-1)
```
If pos is 0 the item is prepended to the start of the toolbar. If pos is negative, the item is appended to the end of the toolbar. It's default value is -1.

To simplify adding spaces between toolbar items, you may use the following function:

``` ocaml
method insert_space : ?pos:int -> unit -> unit
```
If it's required, the orientation of a toolbar and its style can be changed "on the fly" using the following functions:

``` ocaml
method set_orientation : Gtk.Tags.orientation -> unit
method set_style : Gtk.Tags.toolbar_style -> unit
method set_tooltips : bool -> unit
```
Where orientation is one of \`HORIZONTAL or \`VERTICAL. The style is used to set appearance of the toolbar items by using one of \`ICONS, \`TEXT, or \`BOTH.

To show some other things that can be done with a toolbar, let's take the following program (we'll interrupt the listing with some additional explanations):

``` ocaml
(* file: toolbar.ml *)

(* that's easy... when one of the buttons is toggled,
 * set the style of the toolbar accordingly *)
let radio_event toolbar style () =
  toolbar#set_style style

(* just check given toggle button and enable/disable
 * tooltips *)
let toggle_event toolbar button () =
  toolbar#set_tooltips button#active
```
The above are just two callback functions that will be called when one of the buttons on a toolbar is pressed. You should already be familiar with things like this if you've already used toggle buttons (and radio buttons).

``` ocaml
let main () =
  (* Create a new window with a given title, and nice size *)
  let dialog = GWindow.dialog ~title:"Toolbar Tutorial" () in

  (* typically we quit if someone tries to close us *)
  dialog#connect#destroy ~callback:GMain.Main.quit;

  (* we neecd to realize the window because we use pixmaps for
   * items on the toolbar in the context of it *)
  dialog#misc#realize ();

  (* to make it nice we'll put the toolbar into the handle box,
   * so that it can be detached from the main window *)
  let handlebox = GBin.handle_box ~packing:dialog#vbox#add () in
```
The above should be similar to any other GTK application. Just initialization of GTK, creating the window, etc. There is only one thing that probably needs some explanation: a handle box. A handle box is just another box that can be used to pack widgets in to. The difference between it and typical boxes is that it can be detached from a parent window (or, in fact, the handle box remains in the parent, but it is reduced to a very small rectangle, while all of its contents are reparented to a new freely floating window). It is usually nice to have a detachable toolbar, so these two widgets occur together quite often.

``` ocaml
  (* toolbar will be horizontal, with both icons and text, and
   * with 5pxl spaces between items and finally,
   * we'll also put it into our handlebox *)
  let toolbar = GButton.toolbar
    ~orientation:`HORIZONTAL
    ~style:`BOTH
    ~border_width:5 (* ~space_size:5 *)
    ~packing:handlebox#add () in

  (* we need icon for toolbar buttons *)
  let icon () =
    let info = GDraw.pixmap_from_xpm ~file:"gtk.xpm" () in
    (GMisc.pixmap info ())#coerce
  in
```
Well, what we do above is just a straightforward initialization of the toolbar widget.

``` ocaml
  (* our first item is "close" button *)
  let button = toolbar#insert_button
    ~text:"Close"
    ~tooltip:"Close this app"
    ~tooltip_private:"Private"
    ~icon:(icon ())
    ~callback:GMain.Main.quit () in
  toolbar#insert_space (); (* space after item *)
```
In the above code you see the simplest case: adding a button to toolbar. Just before appending a new item, we have to construct an image widget to serve as an icon for this item; this step will have to be repeated for each new item. Just after the item we also add a space, so the following items will not touch each other. As you see toolbar#insert_button returns a our newly created button widget, so that we can work with it in the normal way.

``` ocaml
  (* now, lets make our radio buttons group... *)
  let icon_button = toolbar#insert_radio_button
    ~text:"Icon"
    ~tooltip:"Only icons in toolbar"
    ~tooltip_private:"Private"
    ~icon:(icon ())
    ~callback:(radio_event toolbar `ICONS) () in
  toolbar#insert_space ();
```
Here we begin creating a radio buttons group. To do this we use toolbar#insert_radio_button. In the above case we start creating a radio group. In creating other radio buttons for this group the previous button in the group is required, so that a list of buttons can be easily constructed (see the section on Radio Buttons earlier in this tutorial).

``` ocaml
  (* following radio buttons refer to previous ones *)
  let text_button = toolbar#insert_radio_button
    ~text:"Text"
    ~tooltip:"Only texts in toolbar"
    ~tooltip_private:"Private"
    ~icon:(icon ())
    ~callback:(radio_event toolbar `TEXT) () in
  text_button#set_group icon_button#group;
  toolbar#insert_space ();

  let both_button = toolbar#insert_radio_button
    ~text:"Both"
    ~tooltip:"Icons and text in toolbar"
    ~tooltip_private:"Private"
    ~icon:(icon ())
    ~callback:(radio_event toolbar `BOTH) () in
  both_button#set_group text_button#group;
  both_button#set_active true;
  toolbar#insert_space ();
```
In the end we have to set the state of one of the buttons manually.

``` ocaml
  (* here we have just a simple toggle button *)
  let tooltip_button = toolbar#insert_toggle_button
    ~text:"Tooltips"
    ~tooltip:"Toolbar with or without tips"
    ~tooltip_private:"Private"
    ~icon:(icon ()) () in
  tooltip_button#connect#clicked ~callback:(toggle_event toolbar tooltip_button);
  tooltip_button#set_active true;
  toolbar#insert_space ();
```
A toggle button can be created in the obvious way (if one knows how to create radio buttons already).

``` ocaml
  (* to pack a widget into toolbar, we only have to
   * create it and append it with appropriate tooltip *)
  let entry = GEdit.entry () in
  toolbar#insert_widget 
    ~tooltip:"This is just an entry"
    ~tooltip_private:"Private"
    entry#coerce;
```
As you see, adding any kind of widget to a toolbar is simple.

``` ocaml
  (* that's it! let's show everything *)
  dialog#show ();
  (* rest in GMain.Main.main () and wait for the fun to begin! *)
  GMain.Main.main ()

let _ = Printexc.print main ()
```
So, here we are at the end of toolbar tutorial. Of course, to appreciate it in full you need also this nice XPM icon, so here it is:

> The following xpm file is c style but it's ok in ocaml too.

``` ocaml
/* XPM */
static char * gtk_xpm[] = {
"32 39 5 1",
".      c none",
"+      c black",
"@      c #3070E0",
"#      c #F05050",
"$      c #35E035",
"................+...............",
"..............+++++.............",
"............+++++@@++...........",
"..........+++++@@@@@@++.........",
"........++++@@@@@@@@@@++........",
"......++++@@++++++++@@@++.......",
".....+++@@@+++++++++++@@@++.....",
"...+++@@@@+++@@@@@@++++@@@@+....",
"..+++@@@@+++@@@@@@@@+++@@@@@++..",
".++@@@@@@+++@@@@@@@@@@@@@@@@@@++",
".+#+@@@@@@++@@@@+++@@@@@@@@@@@@+",
".+##++@@@@+++@@@+++++@@@@@@@@$@.",
".+###++@@@@+++@@@+++@@@@@++$$$@.",
".+####+++@@@+++++++@@@@@+@$$$$@.",
".+#####+++@@@@+++@@@@++@$$$$$$+.",
".+######++++@@@@@@@++@$$$$$$$$+.",
".+#######+##+@@@@+++$$$$$$@@$$+.",
".+###+++##+##+@@++@$$$$$$++$$$+.",
".+###++++##+##+@@$$$$$$$@+@$$@+.",
".+###++++++#+++@$$@+@$$@++$$$@+.",
".+####+++++++#++$$@+@$$++$$$$+..",
".++####++++++#++$$@+@$++@$$$$+..",
".+#####+++++##++$$++@+++$$$$$+..",
".++####+++##+#++$$+++++@$$$$$+..",
".++####+++####++$$++++++@$$$@+..",
".+#####++#####++$$+++@++++@$@+..",
".+#####++#####++$$++@$$@+++$@@..",
".++####++#####++$$++$$$$$+@$@++.",
".++####++#####++$$++$$$$$$$$+++.",
".+++####+#####++$$++$$$$$$$@+++.",
"..+++#########+@$$+@$$$$$$+++...",
"...+++########+@$$$$$$$$@+++....",
".....+++######+@$$$$$$$+++......",
"......+++#####+@$$$$$@++........",
".......+++####+@$$$$+++.........",
".........++###+$$$@++...........",
"..........++##+$@+++............",
"...........+++++++..............",
".............++++..............."};
```
