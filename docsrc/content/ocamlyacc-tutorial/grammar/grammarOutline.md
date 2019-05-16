---
title: "Grammar outline"
description: "A Ocamlyacc grammar file has four main sections, shown here with the appropriate delimiters:"
weight: 10
---

A Ocamlyacc grammar file has four main sections, shown here with the appropriate delimiters:

```
%{
	Header - Ocaml declarations (Ocaml code)
%}
	Ocamlyacc declarations
%%
	Grammar rules
%%
	Trailer - Additional Ocaml code (Ocaml code)
```

By default, comments are enclosed between /* and */ (as in C) except in Ocaml code. So use /* and */ in the declarations and rules sections, (* and *) in header and trailer sections.

### The Header Section

The header section contains declarations of functions and variables that are used in the actions in the grammar rules. These are copied to the beginning of the parser file so that they precede the definition of the parser function. You can open the other module in this area. If you don't need any Ocaml declarations, you may omit the %{ and %} delimiters that bracket this section.

### The Ocamlyacc Declarations Section

The ocamlyacc declarations section contains declarations that define terminal and nonterminal symbols, specify precedence, and so on. At least, there must be one %start and the corresponding %type directives. See Ocamlyacc declarations.

### The Grammar Rules Section

The grammar rules section contains one or more Ocamlyacc grammar rules, and nothing else. See Syntax of Grammar Rules.


There must always be at least one grammar rule, and the first %% (which precedes the grammar rules) may never be omitted even if it is the first thing in the file.

### The Trailer Section

The trailer section is copied verbatim to the end of the parser file, just as the header section is copied to the beginning. This is the most convenient place to put anything that you want to have in the parser file but which need not come before the definition of the parse function. See Parser Interface.


If the last section is empty, you may omit the %% that separates it from the grammar rules.
