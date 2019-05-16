---
title: "Tracking Locations"
description: "Though grammar rules and semantic actions are enough to write a fully functional parser, it can be useful to process some additionnal informations, especially symbol locations."
weight: 60
---

Though grammar rules and semantic actions are enough to write a fully functional parser, it can be useful to process some additionnal informations, especially symbol locations.


The way locations are handled is defined by providing a data type, and actions to take when rules are matched.

### Data Type of Locations

The data type for locations has the following type:

```
type position = {
   pos_fname : string;	(* file name *)
   pos_lnum : int;		(* line number *)
   pos_bol : int;		(* the offset of the beginning of the line *)
   pos_cnum : int;		(* the offset of the position *)
} 
```

The value of pos_bol field is the number of characters between the beginning of the file and the beginning of the line while the value of pos_cnum field is the number of characters between the beginning of the file and the position.


The lexing engine manages only the pos_cnum field of lexbuf.lex_curr_p with the number of characters read from the start of lexbuf. So you are reponsible for the other fields to be accurate. Before using the location in the parser, you have to set Lexing.lexbuf.lex_curr_p correctly in lexer, using such a function like this:

```
let incr_linenum lexbuf =
  let pos = lexbuf.Lexing.lex_curr_p in
  lexbuf.Lexing.lex_curr_p <- { pos with
    Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
    Lexing.pos_bol = pos.Lexing.pos_cnum;
  }
;;
```

### Actions and Locations

Actions are not only useful for defining language semantics, but also for describing the behavior of the output parser with locations. The most obvious way for building locations of syntactic groupings is very similar to the way semantic values are computed. In a given rule, several constructs can be used to access the locations of the elements being matched. The location of the nth component of the right hand side can be obtained with:

```
val Parsing.rhs_start : int -> int
val Parsing.rhs_end : int -> int
```

Parsing.rhs_start n returns the offset of the first character of the nth item on the right-hand side of the rule, while Parsing.rhs_end n returns the offset after the last character of the item. are to be called in the action part of a grammar rule only. n is 1 for the leftmost item and the first character in a file is at offset 0.


Or you can use the following functions:

```
val Parsing.rhs_start_pos : int -> Lexing.position
val Parsing.rhs_end_pos : int -> Lexing.position
```

> (Since Ocaml 3.08) These functions return a position instead of an offset (see Data Type of Locations).


The location of the left hand side grouping can be referred by

```
val Parsing.symbol_start : unit -> int
val Parsing.symbol_end : unit -> int
```

The _symbol_start ()_ returns the offset of the first character of the left-hand side of the rule while _symbol_end ()_ returns the offset after the last character.


(Since Ocaml 3.08) The following functions are same as symbol_start and symbol_end, except returning a position instead of an offset (see Data Type of Locations).


```
val Parsing.symbol_start_pos : unit -> Lexing.position
val Parsing.symbol_end_pos : unit -> Lexing.position
```

Here is a basic example using the default data type for locations:


```
exp:	...
	| exp DIVIDE exp
		{ if $3 <> 0.0 then $1 /. $3
		  else (
		    let start_pos = Parsing.rhs_start_pos 3 in
		    let end_pos = Parsing.rhs_end_pos 3 in
		    printf "%d.%d-%d.%d: division by zero"
		      start_pos.pos_lnum (start_pos.pos_cnum - start_pos.pos_bol)
		      end_pos.pos_lnum (end_pos.pos_cnum - end_pos.pos_bol);
		    1.0
		  )
		}
```
