---
title: "Actions"
pre: "6. "
weight: 6
description: "Each pattern in a rule has a corresponding action, which can be any arbitrary Ocaml expression."
---

Each pattern in a rule has a corresponding action, which can be any
arbitrary Ocaml expression.
For example, here is the specification for a program
which deletes all occurrences of "zap me" from its input:

``` ocaml
{}
rule token = parse
  | "zap me"	{ token lexbuf }	(* ignore this token: no processing and continue *)
  | _ as c	{ print_char c; token lexbuf }
```

Here is a program which compresses multiple blanks and tabs down to
a single blank, and throws away whitespace found at the end of a line:

``` ocaml
{}
rule token = parse
  | [' ' '\t']+		{ print_char ' '; token lexbuf }
  | [' ' '\t']+ '\n'	{ token lexbuf }      (* ignore this token *)
```

Actions can include arbitrary Ocaml code which returns a value.
Each time the lexical analyzer function is called
it continues processing tokens from where it last
left off until it either reaches the end of the file.

Actions are evaluated
after the _lexbuf_ is bound to the current lexer buffer and
the identifer following the keyword _as_ to the matched string.
The usage of _lexbuf_ is provided by the Lexing standard library module; 

- **Lexing.lexeme lexbuf**: Return the matched string.
- **Lexing.lexeme_char lexbuf n**: Return the _n_th character in the matched string.  The index number of the first character starts from 0.

- **Lexing.lexeme_start lexbuf**
- **Lexing.lexeme_end lexbuf**: Return the absolute position in the input text of the beginning/end of the matched string. The position of the first character is 0.

- **Lexing.lexeme_start_p lexbuf**
- **Lexing.lexeme_end_p lexbuf**: (Since Ocaml 3.08) Return the position of type _position (See [Position](./position)).

- **entrypoint [exp1... expn] lexbuf**: Call the other lexer on the given entry point.  Notice that _lexbuf_ is the last argument.

