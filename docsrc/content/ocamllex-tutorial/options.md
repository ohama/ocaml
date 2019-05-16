---
title: "Options"
pre: "10. "
weight: 10
description: "ocamllex has the following options: ..."
---

ocamllex has the following options:

* "-o output-file"

&nbsp;&nbsp;&nbsp;&nbsp;
By default, ocamllex produces lexer.ml, when ocamllex is invoked as "ocamllex lexer.mll". You can change the name of the output file using -o option.

* "-ml"

&nbsp;&nbsp;&nbsp;&nbsp;
By default, ocamllex produces code that uses the Caml built-in automata interpreter. Using this option, the automaton is coded as Caml functions. This option is useful for debugging ocamllex, but it's not recommended for production lexers.

* "-q"

&nbsp;&nbsp;&nbsp;&nbsp;
By default, ocamllex outputs informational messages to standard output. If you use -q option, they are suppressed.
