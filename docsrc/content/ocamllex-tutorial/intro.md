---
title: "Introduction"
weight: 1
pre: "1. "
description: "ocamllex is a tool for generating scanners: programs which recognized lexical patterns in text."
---

_ocamllex_ is a tool for generating _scanners_:
programs which recognized lexical
patterns in text.
_ocamllex_ reads the given input files, for a description of
a scanner to generate. The description is in the form of pairs of regular
expressions and Ocaml code, called _rules_.
_ocamllex_ generates as output a Ocaml
source file which defines lexical analyzer functions.
This file is compiled and linked to produce an executable.
When the executable is run, it analyzes its input for occurrences
of the regular expressions. Whenever it finds one, it executes
the corresponding Ocaml code. 

If you execute the following command with the input file named
_lexer_.mll

``` ocaml
    ocamllex lexer.mll
```

you will get Caml code for a lexical analyzer in file
_lexer_.ml

