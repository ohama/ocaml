---
title: "Common range functions"
description: "Common range functions"
weight: 30
---

The Range widget class is fairly complicated internally, but, like all the "base class" widgets, most of its complexity is only interesting if you want to hack on it. Also, almost all of the functions and signals it defines are only really used in writing derived widgets. There are, however, a few useful functions that will work on all range widgets.

### Setting the Update Policy
The "update policy" of a range widget defines at what points during user interaction it will change the value field of its Adjustment and emit the "value_changed" signal on this Adjustment. The update policies, defined as type Gtk.Tags.update_type, are:

- \`CONTINUOUS: This is the default. The "value_changed" signal is emitted continuously, i.e., whenever the slider is moved by even the tiniest amount.

- \`DISCONTINUOUS: The "value_changed" signal is only emitted once the slider has stopped moving and the user has released the mouse button.

- \`DELAYED: The "value_changed" signal is emitted when the user releases the mouse button, or if the slider stops moving for a short period of time.

The update policy of a range widget can be set by calling this function:

``` ocaml
method set_update_policy : Gtk.Tags.update_type -> unit
```

### Getting and Setting Adjustments
Getting and setting the adjustment for a range widget "on the fly" is done, predictably, with:

``` ocaml
method adjustment : GData.adjustment
method set_adjustment : GData.adjustment -> unit
```
adjustment method returns the adjustment to which range is connected.

set_adjustment method does absolutely nothing if you pass it the adjustment that range is already using, regardless of whether you changed any of its fields or not. If you pass it a new Adjustment, it will disconnect the old one if it exists, connect the appropriate signals to the new one, and call the private function gtk_range_adjustment_changed(), which will (or at least, is supposed to...) recalculate the size and/or position of the slider and redraw if necessary.
