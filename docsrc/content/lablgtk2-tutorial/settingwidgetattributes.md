---
title: "Setting widget attributes"
pre: "14. "
weight: 140
description: "This describes the functions used to operate on widgets. These can be used to set style, padding, size, etc."
---

This describes the functions used to operate on widgets. These can be used to set style, padding, size, etc.
You can get access these method through misc method, for example, button#misc#hide ().

For full descriptions, see GObj.misc_ops.

(Maybe I should make a whole section on accelerators.)

``` ocaml
method activate : unit -> bool
method set_name : string -> unit
method name : string
method set_sensitive : bool -> unit
method set_style : style -> unit
method style : style
method set_size_request : ?width:int -> ?height:int -> unit -> unit
method set_can_focus : bool -> unit
method grab_focus : unit -> unit
method realize : unit -> unit
method show : unit -> unit
method hide : unit -> unit
```
