---
title: "More on signal handlers"
description: "Lets take another look at the #connect#signal_name declaration."
weight: 10
---

Lets take another look at the #connect#signal_name declaration.

``` ocaml
#connect#signal_name ~callback:(unit -> unit) -> GtkSignal.id
```
Notice the GtkSignal.id return value? This is a tag that identifies your callback function. As stated above, you may have as many callbacks per signal and per object as you need, and each will be executed in turn, in the order they were attached.

This tag allows you to remove this callback from the list by using #misc#disconnect method:

``` ocaml
#misc#disconnect: GtkSignal.id -> unit
```
So, by passing the tag returned by one of the connect functions to the #misc#disconnect method, you can disconnect a signal handler.

You can also temporarily disable signal handlers with the #misc#handler_block and #misc#handler_unblock family of functions.

``` ocaml
#misc#handler_block : GtkSignal.id -> unit
#misc#handler_unblock : GtkSignal.id -> unit
```
