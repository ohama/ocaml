---
title: "Translate"
pre: "12.1 "
weight: 1
---

This example translates the text "current_directory" to the current directory.

``` ocaml
{ }

rule translate = parse
  | "current_directory"	{ print_string (Sys.getcwd ()) }
  | _ as c		{ print_char c }
  | eof			{ exit 0 }

{
  let main () =
    let lexbuf = Lexing.from_channel stdin in
    while true do
      translate lexbuf
    done

  let _ = Printexc.print main ()
}
```
