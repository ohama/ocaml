---
title: "Interfacing with ocamlyacc"
pre: "9. "
weight: 9
description: "One of the main uses of ocamllex is as a companion to the ocamlyacc parser-generator. ocamlyacc parsers call one of the scanning functions to find the next input token."
---

One of the main uses of ocamllex is as a companion to the ocamlyacc parser-generator. ocamlyacc parsers call one of the scanning functions to find the next input token.
The routine is supposed to return the type of the next token with an associated value. To use ocamllex with ocamlyacc, scanner functions should use parser module to refer token types, which are defined in `%tokens' attributes appearing in the ocamlyacc input. For example, if input filename of ocamlyacc is parse.mly and one of the tokens is "NUMBER", part of the scanner might look like:

``` ocaml
{
  open Parse
}

rule token = parse
  ...
  | ['0'-'9']+ as num { NUMBER (int_of_string num) }
  ...
```
