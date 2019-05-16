---
title: "Format of the input file"
pre: "3. "
weight: 3
description: "The ocamllex input file consists of four sections; header, definitions, rules and trailer section: ..."
---

The _ocamllex_ input file consists of four sections;
_header_, _definitions_, _rules_ and _trailer_ section:

``` ocaml
(* header section *)
{ <header> }

(* definitions section *)
let <ident> = <regexp>
let ...	

(* rules section *)
rule <entrypoint_1> [arg1... argn] = parse
  | <pattern> { <action> }
  | ...
  | <pattern> { <action> }
and <entrypoint_2> [arg1... argn] = parse
   ...
and ...

(* trailer section *)
{ <trailer> }
```

Comments are delimited by (* and *), as in Caml.

The _header_ and _rules_ sections
are necessary
while _definitions_ and _trailer_
sections are optional.

The _header_ and _trailer_ sections are
enclosed in curly braces and they contain arbitrary Caml code.
At the beginning of the output file, the header text is copied as is
while the trailer text is copied at the end of the output file.
For example, you can code open directives and some auxiliary funtions
in the header section.

The _definitions_ section contains declarations of
simple _ident_
definitions to simplify the scanner specification.
Ident definitions have the form:

``` ocaml
let <ident> = <regexp>
let ...	
```

The "ident" must be valid identifiers for Caml values
(starting with a lowercase letter). 
For example,

``` ocaml
let _digit_ = ['0'-'9']
let _id_ = ['a'-'z']['a'-'z' '0'-'9']*
```

defines "digit" to be a regular expression which matches a single
digit, and "id" to be a regular expression which matches a letter
followed by zero-or-more letters-or-digits.  A subsequent reference to

``` ocaml
digit+ "." digit*
```

is identical to

``` ocaml
['0'-'9']+ "." ['0'-'9']*
```

and matches one-or-more digits followed by a '.' followed by
zero-or-more digits.

The _rules_ section of the _ocamllex_ input contains a series of entrypoints of the form:

``` ocaml
rule entrypoint [arg1... argn] = parse
  | <pattern> { <action> }
  | ...
  | <pattern> { <action> }
and ...
```

The first "|" (bar) after _parse_ is
optional.

Each entrypoint consists of a series of pattern-action:

``` ocaml
  | <pattern> { <action> }
```

where the action must be enclosed in curly braces.

See below for a further description of patterns and actions.

