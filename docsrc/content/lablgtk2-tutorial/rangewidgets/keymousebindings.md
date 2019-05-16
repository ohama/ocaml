---
title: "Key and mouse bindings"
description: "All of the GTK range widgets react to mouse clicks in more or less the same way."
weight: 40
---

All of the GTK range widgets react to mouse clicks in more or less the same way. Clicking button-1 in the trough will cause its adjustment's page_increment to be added or subtracted from its value, and the slider to be moved accordingly. Clicking mouse button-2 in the trough will jump the slider to the point at which the button was clicked. Clicking button-3 in the trough of a range or any button on a scrollbar's arrows will cause its adjustment's value to change by step_increment at a time.

Scrollbars are not focusable, thus have no key bindings. The key bindings for the other range widgets (which are, of course, only active when the widget has focus) are do not differentiate between horizontal and vertical range widgets.

All range widgets can be operated with the left, right, up and down arrow keys, as well as with the Page Up and Page Down keys. The arrows move the slider up and down by step_increment, while Page Up and Page Down move it by page_increment.

The user can also move the slider all the way to one end or the other of the trough using the keyboard. This is done with the Home and End keys.
