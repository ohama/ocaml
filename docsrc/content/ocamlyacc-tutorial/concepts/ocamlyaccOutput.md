---
title: "Ocamlyacc output"
description: "When you run Ocamlyacc, you give it a Ocamlyacc grammar file as input. The output is a Ocaml source file that parses the language described by the grammar."
weight: 60
---

When you run Ocamlyacc, you give it a Ocamlyacc grammar file as input. The output is a Ocaml source file that parses the language described by the grammar.
This file is called a Ocamlyacc parser. Keep in mind that the Ocamlyacc utility and the Ocamlyacc parser are two distinct programs: the Ocamlyacc utility is a program whose output is the Ocamlyacc parser that becomes part of your program.


The job of the Ocamlyacc parser is to group tokens into groupings according to the grammar rules---for example, to build identifiers and operators into expressions. As it does this, it runs the actions for the grammar rules it uses.


The tokens come from a function called the lexical analyzer that you must supply in some fashion. The Ocamlyacc parser calls the lexical analyzer each time it wants a new token. It doesn't know what is ''inside'' the tokens (though their semantic values may reflect this). Typically the lexical analyzer makes the tokens by parsing characters of text, but Ocamlyacc does not depend on this. See The Lexical Analyzer Function.


The Ocamlyacc parser file is Ocaml code which defines functions which implements that grammar. Entry functions of the generated Ocaml code are named after the start symbols in grammar file. These functions do not make a complete Ocaml program: you must supply some additional functions. One is the lexical analyzer which should be given as an argument of the parser entry function. Another is an error-reporting function which the parser calls to report an error. In addition, a complete Ocaml program must has to call one (or more) of the generated entry functions or the parser will never run. See Parser Interface.

