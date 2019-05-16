---
title: "Overall layout of grammar"
description: "The general form of a Ocamlyacc grammar file is as follows:"
weight: 80
---

The input file for the Ocamlyacc utility is a Ocamlyacc grammar file.
The general form of a Ocamlyacc grammar file is as follows:


%{
    Header (Ocaml code)
%}
    Ocamlyacc declarations
%%
    Grammar rules
%%
    Trailer (Additional Ocaml code)

The %%, %{ and %} are punctuation that appears in every Ocamlyacc grammar file to separate the sections.


The header may define types, variables and functions used in the actions.


The Ocamlyacc declarations declare the names of the terminal and nonterminal symbols, and may also describe operator precedence and the data types of semantic values of various symbols.


The grammar rules define how to construct each nonterminal symbol from its parts.


The Trailer can contain any Ocaml code you want to use.
