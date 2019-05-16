---
title: "Packing using tables"
description: "Another way of packing - Tables."
weight: 40
---

Let's take a look at another way of packing - Tables. These can be extremely useful in certain situations.

Using tables, we create a grid that we can place widgets in. The widgets may take up as many spaces as we specify.

The first thing to look at, of course, is the GPack.table function:

``` ocaml
val GPack.table :
	?columns:int ->
	?rows:int ->
	?homogeneous:bool ->
	?row_spacings:int ->
	?col_spacings:int ->
	?border_width:int ->
	?width:int ->
	?height:int ->
	?packing:(GObj.widget -> unit) ->
	?show:bool -> unit -> table
```

The ?rows specifies the number of rows to make in the table, while the ?columns, obviously, is the number of columns.

The ?homogeneous argument has to do with how the table's boxes are sized. If homogeneous is true, the table boxes are resized to the size of the largest widget in the table. If homogeneous is false, the size of a table boxes is dictated by the tallest widget in its same row, and the widest widget in its column.

The rows and columns are laid out from 0 to n, where n was the number specified in the call to GPack.table. So, if you specify rows = 2 and columns = 2, the layout would look something like this:

``` ocaml
 0          1          2
0+----------+----------+
 |          |          |
1+----------+----------+
 |          |          |
2+----------+----------+
```

Note that the coordinate system starts in the upper left hand corner. To place a widget into a box, use the following function:

``` ocaml
method attach :
	left:int ->
	top:int ->
	?right:int ->
	?bottom:int ->
	?expand:Gtk.Tags.expand_type ->
	?fill:Gtk.Tags.expand_type ->
	?shrink:Gtk.Tags.expand_type ->
	?xpadding:int ->
	?ypadding:int -> GObj.widget -> unit

left : column number to attach the left side of the widget to
top : row number to attach the top of the widget to
right : default value is left+1
bottom : default value is top+1
expand : default value is `NONE
fill : default value is `BOTH
shrink : default value is `NONE
```

The left and right attach arguments specify where to place the widget, and how many boxes to use. If you want a button in the lower right table entry of our 2x2 table, and want it to fill that entry only, left would be = 1, right = 2, top = 1, bottom = 2.

Now, if you wanted a widget to take up the whole top row of our 2x2 table, you'd use left = 0, right = 2, top = 0, bottom = 1.

The other options are:

- `?fill`: If the table box is larger than the widget, and ?fill is specified, the widget will expand to use all the room available.

- `?shrink`: If the table widget was allocated less space then was requested (usually by the user resizing the window), then the widgets would normally just be pushed off the bottom of the window and disappear. If ?shrink is specified, the widgets will shrink with the table.

- `?expand`: This will cause the table to expand to use up any remaining space in the window.

Padding is just like in boxes, creating a clear area around the widget specified in pixels.

We also have set_row_spacing and set_col_spacing meethods. These places spacing between the rows at the specified row or column.

``` ocaml
method set_row_spacing : int -> int -> unit
```

and

``` ocaml
method set_col_spacing : int -> int -> unit
```

Note that for columns, the space goes to the right of the column, and for rows, the space goes below the row.

You can also set a consistent spacing of all rows and/or columns with:

``` ocaml
method set_row_spacings : int -> unit
```

And,

``` ocaml
method set_col_spacings : int -> unit
```

Note that with these calls, the last row and last column do not get any spacing.
