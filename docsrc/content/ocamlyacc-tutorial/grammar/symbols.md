---
title: "Symbols, Terminal and Nonterminal"
description: "Symbols in Ocamlyacc grammars represent the grammatical classifications of the language. A terminal symbol (also known as a token type) represents a class of syntactically equivalent tokens. A nonterminal symbol stands for a class of syntactically equivalent groupings."
weight: 20
---

Symbols in Ocamlyacc grammars represent the grammatical classifications of the language.

A terminal symbol (also known as a token type) represents a class of syntactically equivalent tokens.
You use the symbol in grammar rules to mean that a token in that class is allowed. The symbol is represented in the Ocamlyacc parser by a value of variant type, and the lexer function function returns a token type to indicate what kind of token has been read.

A nonterminal symbol stands for a class of syntactically equivalent groupings.
The symbol name is used in writing grammar rules. It should start with lower case.

Symbol names can contain letters, digits (not at the beginning), underscores.

The terminal symbols in the grammar is a token type which is a value of variable type in Ocaml. So it should be start with upper case. Each such name must be defined with a Ocamlyacc declaration with %token. See [Token Type Names](../).

The value returned by the lexer function is always one of the terminal symbols. Each token type becomes a Ocaml value of variant type in the parser file, so lexer function can return one.

Because the lexer function is defined in a separate file, you need to arrange for the token-type definitions to be available there. After invoking "ocamlyacc filename.mly", the file filename.mli is generated which contains token-type definitions. It is used in lexer function.

The symbol error is a terminal symbol reserved for error recovery (see [Error Recovery](../); you shouldn't use it for any other purpose.
