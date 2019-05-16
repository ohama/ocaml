---
title: "The generted scanner"
pre: "7. "
weight: 7
description: "The output of ocamllex is the file lex.ml when it is invoked as `ocamllex lex.mll`.  The generated file contains the scanning functions, a number of tables used by it for matching tokens, and a number of auxiliary routines."
---

The output of _ocamllex_ is the file _lex_.ml when it is invoked as `ocamllex lex.mll`.  The generated file contains the _scanning functions_, a number of tables used by it for matching tokens, and a number of auxiliary routines.
The _scanning functions_ are declared as followings:

``` ocaml
let <entrypoint> [arg1... argn] lexbuf =
  ...
and ...
```

where the fuction _entrypoint_ has `n + 1`
arguments.
`n` arguments come from the definition of the _rules_ secton.
And the resulting scanning function has one more argument named _lexbuf_ of _Lexing.lexbuf_ type as the last one.

Whenever _entrypoint_ is called, it scans tokens from the _lexbuf_ argument.
When it finds a match in patterns, it executes the corresponding action and returns.
If you want to continue the lexical analyze
after evaluating of the action,
you must call the _scanning function_ recursively.


