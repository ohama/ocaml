---
title: "Idle functions"
description: "What if you have a function which you want to be called when nothing else is happening?"
weight: 20
---

What if you have a function which you want to be called when nothing else is happening?

``` ocaml
val GMain.Idle.add : callback:(unit -> bool) -> id
```
This causes GTK to call the specified function whenever nothing else is happening.

``` ocaml
val GMain.Idle.remove : id -> unit
```
I won't explain the meaning of the arguments as they follow very much like the ones above. The callback function of GMain.Idle.add will be called whenever the opportunity arises. As with the others, returning false will stop the idle function from being called.
