---
title: "Introduction"
pre: "1. "
weight: 10
description: "`Ocamlyacc` is a general-purpose parser generator that converts a grammar description for an LALR(1) context-free grammar into a Ocaml program to parse that grammar."
---

`Ocamlyacc` is a general-purpose parser generator that converts a
grammar description for an LALR(1) context-free grammar into a Ocaml
program to parse that grammar.
 Once you are proficient with Ocamlyacc,
you may use it to develop a wide range of language parsers, from those
used in simple desk calculators to complex programming languages.

Ocamlyacc is very close to the well-known yacc (or bison) commands
that can be found in most C programming environments.
Anyone familiar with Yacc
should be able to use Ocamlyacc with little trouble.  You need to be fluent in
Ocaml programming in order to use Ocamlyacc or to understand this manual.

We begin with tutorial chapters that explain the basic concepts of using
Ocamlyacc and show three explained examples, each building on the last.  If you
don't know Ocamlyacc or Yacc, start by reading these chapters.  Reference
chapters follow which describe specific aspects of Ocamlyacc in detail.

Some explanation is not suitable for the earlier version than 3.08 of Ocaml (Ocamlyacc),
in that case, there will be comments like "_(Since Ocaml 3.08)_".

