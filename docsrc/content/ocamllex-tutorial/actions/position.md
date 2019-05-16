---
title: "Position"
pre: "6.1 "
weight: 1
---

> Since Ocaml 3.08

The position information on scanning the input text is recorded
in the _lexbuf_
which has a field _lex\_curr\_p_ of the type _position_:

``` ocaml
  type position = {
     pos_fname : string;		(* file name *)
     pos_lnum : int;		(* line number *)
     pos_bol : int;		(* the offset of the beginning of the line *)
     pos_cnum : int;		(* the offset of the position *)
  } 
```

The value of _pos\_bol_ field is the number of characters between the beginning of the file and the beginning of the line
while the value of _pos\_cnum_ field is the number of characters between the beginning of the file and the position.

The lexing engine manages only the _pos\_cnum_ field of
_lexbuf.lex\_curr\_p_ with the number of characters read
from the start of _lexbuf_. So you are reponsible for the other fields to be accurate.
Typically, whenever the lexer meets a newline character,
the action contains a call to the following function:

``` ocaml
  let incr_linenum lexbuf =
    let pos = lexbuf.Lexing.lex_curr_p in
    lexbuf.Lexing.lex_curr_p &lt;- { pos with
      Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
      Lexing.pos_bol = pos.Lexing.pos_cnum;
    }
  ;;
```

