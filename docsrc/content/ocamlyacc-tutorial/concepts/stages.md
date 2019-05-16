---
title: "Stages in use ocamlyacc"
description: "The actual language-design process using Ocamlyacc, from grammar specification to a working compiler or interpreter, has these parts:"
weight: 70
---

The actual language-design process using Ocamlyacc, from grammar specification to a working compiler or interpreter, has these parts:


 Formally specify the grammar in a form recognized by Ocamlyacc (see Ocamlyacc Grammar Files). For each grammatical rule in the language, describe the action that is to be taken when an instance of that rule is recognized. The action is described by a sequence of Ocaml statements.


 Write a lexical analyzer to process input and pass tokens to the parser. The lexical analyzer may be written by hand in Ocaml (see The Lexical Analyzer Function). It could also be produced using ocamllex, but the use of ocamllex is not discussed in this manual.


 Write a controlling function that calls the Ocamlyacc-produced parser.


 Write error-reporting routines.


To turn this source code as written into a runnable program, you must follow these steps:


 Run Ocamlyacc on the grammar to produce the parser.


 Compile the code output by Ocamlyacc, as well as any other source files.


 Link the object files to produce the finished product.
