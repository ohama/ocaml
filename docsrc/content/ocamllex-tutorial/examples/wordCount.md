---
title: "Word count"
pre: "12.2 "
weight: 2
---

This example shows the number of lines, words and characters of the given file if the filename is given, or of the standard input if no command arguments are given.

``` ocaml
{ }

rule count lines words chars = parse
  | '\n'		{ count (lines+1) words (chars+1) lexbuf }
  | [^ ' ' '\t' '\n']+ as word
  		{ count lines (words+1) (chars+ String.length word) lexbuf }
  | _		{ count lines words (chars+1) lexbuf }
  | eof		{ (lines, words, chars) }

{
  let main () =
    let cin =
      if Array.length Sys.argv > 1
      then open_in Sys.argv.(1)
      else stdin
    in
    let lexbuf = Lexing.from_channel cin in
    let (lines, words, chars) = count 0 0 0 lexbuf in
    Printf.printf "%d lines, %d words, %d chars\n" lines words chars

  let _ = Printexc.print main ()
}
```
