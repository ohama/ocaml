---
title: "Drawing"
description: "We now turn to the process of drawing on the screen."
weight: 20
---

We now turn to the process of drawing on the screen.
The widget we use for this is the DrawingArea widget. A drawing area widget is essentially an X window and nothing more. It is a blank canvas in which we can draw whatever we like. A drawing area is created using the call:

``` ocaml
val GMisc.drawing_area :
	?width:int ->
	?height:int ->
	?packing:(GObj.widget -> unit) ->
	?show:bool ->
	unit -> drawing_area
```
The arguments width and height specifies the default size of the drawing area.

The default size can be overridden, as is true for all widgets, by calling misc#set_size_request method, and that, in turn, can be overridden if the user manually resizes the the window containing the drawing area.

It should be noted that when we create a DrawingArea widget, we are completely responsible for drawing the contents. If our window is obscured then uncovered, we get an exposure event and must redraw what was previously hidden.

Having to remember everything that was drawn on the screen so we can properly redraw it can, to say the least, be a nuisance. In addition, it can be visually distracting if portions of the window are cleared, then redrawn step by step. The solution to this problem is to use an offscreen backing pixmap. Instead of drawing directly to the screen, we draw to an image stored in server memory but not displayed, then when the image changes or new portions of the image are displayed, we copy the relevant portions onto the screen.

To create an offscreen pixmap, we call the function:

``` ocaml
val GDraw.pixmap :
	width:int ->
	height:int ->
	?mask:bool ->
	?window:< misc : #misc_ops; .. > ->
	?colormap:Gdk.colormap ->
	unit -> pixmap
```
The window parameter specifies a GDK window that this pixmap takes some of its properties from. width and height specify the size of the pixmap. colormap tells the color depth, that is the number of bits per pixel, for the new window. If the colormap is not specified, default_colormap() is used.

We create the pixmap in our "configure" handler. This event is generated whenever the window changes size, including when it is originally created.

``` ocaml
(* Backing pixmap for drawing area *)
let backing = ref (GDraw.pixmap ~width:200 ~height:200 ())

(* Create a new backing pixmap of the appropriate size *)
let configure window backing ev =
  let width = GdkEvent.Configure.width ev in
  let height = GdkEvent.Configure.height ev in
  let pixmap = GDraw.pixmap ~width ~height ~window () in
  pixmap#set_foreground `WHITE;
  pixmap#rectangle ~x:0 ~y:0 ~width ~height ~filled:true ();
  backing := pixmap;
  true
```
The call to rectangle method clears the pixmap initially to white. We'll say more about that in a moment.

Our exposure event handler then simply copies the relevant portion of the pixmap onto the screen (we determine the area we need to redraw by using GdkEvent.Expost.area method to the exposure event):

``` ocaml
(* Redraw the screen from the backing pixmap *)
let expose (drawing_area:GMisc.drawing_area) (backing:GDraw.pixmap ref) ev =
  let area = GdkEvent.Expose.area ev in
  let x = Gdk.Rectangle.x area in
  let y = Gdk.Rectangle.y area in
  let width = Gdk.Rectangle.width area in
  let height = Gdk.Rectangle.width area in
  let drawing =
    drawing_area#misc#realize ();
    new GDraw.drawable (drawing_area#misc#window)
  in
  drawing#put_pixmap ~x ~y ~xsrc:x ~ysrc:y ~width ~height !backing#pixmap;
  false
```
We've now seen how to keep the screen up to date with our pixmap, but how do we actually draw interesting stuff on our pixmap? There are a large number of calls in GTK's GDK library for drawing on drawables. A drawable is simply something that can be drawn upon. It can be a window, a pixmap, or a bitmap (a black and white image). We've already seen two such calls above, rectangle and put_pixmap methods. The some of them are: see GDraw.drawable

``` ocaml
method arc :
	x:int ->
	y:int ->
	width:int ->
	height:int ->
	?filled:bool ->
	?start:float ->
	?angle:float ->
	unit -> unit
method line :
	x:int ->
	y:int ->
	x:int ->
	y:int -> unit
method point :
	x:int ->
	y:int -> unit
method polygon :
	?filled:bool ->
	(int * int) list -> unit
method rectangle :
	x:int ->
	y:int ->
	width:int ->
	height:int ->
	?filled:bool ->
	unit -> unit
method string :
	string ->
	font:Gdk.font ->
	x:int ->
	y:int -> unit
method points : (int * int) list -> unit
method lines : (int * int) list -> unit
method segments : ((int * int) * (int * int)) list -> unit

method put_layout :
	x:int ->
	y:int ->
	?fore:color ->
	?back:color ->
	Pango.layout -> unit
method put_image :
	x:int ->
	y:int ->
	?xsrc:int ->
	?ysrc:int ->
	?width:int ->
	?height:int ->
	Gdk.image -> unit
method put_pixmap :
	x:int ->
	y:int ->
	?xsrc:int ->
	?ysrc:int ->
	?width:int ->
	?height:int ->
	Gdk.pixmap -> unit
method put_rgb_data :
	width:int ->
	height:int ->
	?x:int ->
	?y:int ->
	?dither:Gdk.Tags.rgb_dither ->
	?row_stride:int ->
	Gpointer.region -> unit
method put_pixbuf :
	x:int ->
	y:int ->
	?width:int ->
	?height:int ->
	?dither:Gdk.Tags.rgb_dither ->
	?x_dither:int ->
	?y_dither:int ->
	?src_x:int ->
	?src_y:int ->
	GdkPixbuf.pixbuf -> unit
```
All of these functions uses graphics context (GC). A graphics context encapsulates information about things such as foreground and background color and line width. GDK has a full set of functions for creating and modifying graphics contexts. GDraw.drawable has the default GC and you can change it using:

``` ocaml
method set_background : color -> unit
method set_foreground : color -> unit
method set_clip_region : Gdk.region -> unit
method set_clip_origin : x:int -> y:int -> unit
method set_clip_mask : Gdk.bitmap -> unit
method set_clip_rectangle : Gdk.Rectangle.t -> unit
method set_line_attributes :
	?width:int ->
	?style:Gdk.GC.gdkLineStyle ->
	?cap:Gdk.GC.gdkCapStyle ->
	?join:Gdk.GC.gdkJoinStyle ->
	unit -> unit
```
Our function draw_brush, which does the actual drawing on the screen, is then:

``` ocaml
(* Draw a rectangle on the screen *)
let draw_brush (area:GMisc.drawing_area) (backing:GDraw.pixmap ref) x y =
  let x = x - 5 in
  let y = y - 5 in
  let width = 10 in
  let height = 10 in
  let update_rect = Gdk.Rectangle.create ~x ~y ~width ~height in
  !backing#set_foreground `BLACK;
  !backing#rectangle ~x ~y ~width ~height ~filled:true ();
  area#misc#draw (Some update_rect)
```
After we draw the rectangle representing the brush onto the pixmap, we call the method:

``` ocaml
method misc#draw : Gdk.Rectangle.t option -> unit
```
which notifies X that the given area needs to be updated. X will eventually generate an expose event (possibly combining the areas passed in several calls to misc#draw) which will cause our expose event handler to copy the relevant portions to the screen.

We have now covered the entire drawing program except for a few mundane details like creating the main window.


