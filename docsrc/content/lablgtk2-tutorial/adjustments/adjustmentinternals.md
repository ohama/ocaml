---
title: "Adjustment internals"
description: "Using adjustments"
weight: 30
---

Ok, you say, that's nice, but what if I want to create my own handlers to respond when the user adjusts a range widget or a spin button, and how do I get at the value of the adjustment in these handlers?

You can use the following accessor to inspect the value of an adjustment:

``` ocaml
method value : float
```

Since, when you set the value of an Adjustment, you generally want the change to be reflected by every widget that uses this adjustment, GTK provides this convenience function to do this:

``` ocaml
method set_value : float -> unit
```

As mentioned earlier, Adjustment is a subclass of Object just like all the various widgets, and thus it is able to emit signals. This is, of course, why updates happen automagically when you share an adjustment object between a scrollbar and another adjustable widget; all adjustable widgets connect signal handlers to their adjustment's value_changed signal, as can your program. Here's the definition of this signal:

``` ocaml
method value_changed : callback:(unit -> unit) -> GtkSignal.id
```
The various widgets that use the Adjustment object will emit this signal on an adjustment whenever they change its value. This happens both when user input causes the slider to move on a range widget, as well as when the program explicitly changes the value with set_value method. So, for example, if you have a scale widget, and you want to change the rotation of a picture whenever its value changes, you would create a callback like this:

``` ocaml
let cb_rotate_picture adj picture () =
  picture#set_rotation adj#value;
  ...
```
and connect it to the scale widget's adjustment like this:

``` ocaml
adj#connect#value_changed ~callback:(cb_rotate_picture adj picture);
```
What about when a widget needs to reconfigure the upper or lower fields of its adjustment, such as when a user adds more text to a text widget? In this case, you can use

``` ocaml
method set_bounds :
	?lower:float ->
	?upper:float ->
	?step_incr:float ->
	?page_incr:float ->
	?page_size:float -> unit -> unit
```
When an adjustment is reconfigured, it emits the changed signal, which looks like this:

``` ocaml
method changed : callback:(unit -> unit) -> GtkSignal.id
```
Range widgets typically connect a handler to this signal, which changes their appearance to reflect the change - for example, the size of the slider in a scrollbar will grow or shrink in inverse proportion to the difference between the lower and upper values of its adjustment.

Now go forth and adjust!
