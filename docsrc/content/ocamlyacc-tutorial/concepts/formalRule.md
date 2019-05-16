---
title: "From Foraml Rules to Ocamlyacc Input"
description: "A formal grammar is a mathematical construct. To define the language for Ocamlyacc, you must write a file expressing the grammar in Ocamlyacc syntax."
weight: 20
---

A formal grammar is a mathematical construct. To define the language for Ocamlyacc, you must write a file expressing the grammar in Ocamlyacc syntax: a Ocamlyacc grammar file. See [Ocamlyacc Grammar Files](../grammar/).

A nonterminal symbol in the formal grammar is represented in Ocamlyacc input as an identifier, like an identifier in Ocaml. It is like regular Caml symbol, except that it cannot end with ' (single quote). It should start in lower case, such as expr, stmt or declaration.

The Ocamlyacc representation for a terminal symbol is also called a token types. Token typess should be declared in Ocamlyacc Declaration Section and they are added as constructors for the token concrete type. As constructors, they should start with upper case: for example, Integer, Identifier, IF or RETURN. The terminal symbol error is reserved for error recovery. See [Symbols](../../grammar/symbols/).

The grammar rules also have an expression in Ocamlyacc syntax. For example, here is the Ocamlyacc rule for a C return statement.

```
stmt:   RETURN expr SEMICOLON
        ;
```

See [Syntax of Grammar Rules](../).

