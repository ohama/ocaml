---
title: "Creating an adjustment"
description: "For many constructor or method arguments, default values are provided."
weight: 10
---


Many of the widgets which use adjustment objects do so automatically, but some cases will be shown in later examples where you may need to create one yourself. You create an adjustment using GData.adjustment:

``` ocaml
val GData.adjustment :
	?value:float ->
	?lower:float ->
	?upper:float ->
	?step_incr:float ->
	?page_incr:float ->
	?page_size:float -> unit -> adjustment

lower : default value is 0.
upper : default value is 100.
step_incr : default value is 1.
page_incr : default value is 10.
page_size : default value is 10.
```

The value argument is the initial value you want to give to the adjustment, usually corresponding to the topmost or leftmost position of an adjustable widget. The lower argument specifies the lowest value which the adjustment can hold. The step_increment argument specifies the "smaller" of the two increments by which the user can change the value, while the page_increment is the "larger" one. The page_size argument usually corresponds somehow to the visible area of a panning widget. The upper argument is used to represent the bottom most or right most coordinate in a panning widget's child. Therefore it is not always the largest number that value can take, since the page_size of such widgets is usually non-zero.
