---
title: "Semantic values"
description: "A formal grammar is a mathematical construct. To define the language for Ocamlyacc, you must write a file expressing the grammar in Ocamlyacc syntax."
weight: 30
---

A formal grammar selects tokens only by their classifications: for example, if a rule mentions the terminal symbol `integer constant', it means that any integer constant is grammatically valid in that position. The precise value of the constant is irrelevant to how to parse the input: if x+4 is grammatical then x+1 or x+3989 is equally grammatical.

But the precise value is very important for what the input means once it is parsed. A compiler is useless if it fails to distinguish between 4, 1 and 3989 as constants in the program! Therefore, each token in a Ocamlyacc grammar has both a token type and a semantic value. See Defining Language Semantics, for details.

The token type is a terminal symbol defined in the grammar, such as INTEGER, IDENTIFIER or SEMICOLON. It tells everything you need to know to decide where the token may validly appear and how to group it with other tokens. The grammar rules know nothing about tokens except their types.

The semantic value has all the rest of the information about the meaning of the token, such as the value of an integer, or the name of an identifier. (A token such as SEMICOLON which is just punctuation doesn't need to have any semantic value.)

For example, an input token might be classified as token type INTEGER and have the semantic value 4. Another input token might have the same token type INTEGER but value 3989. When a grammar rule says that INTEGER is allowed, either of these tokens is acceptable because each is an INTEGER. When the parser accepts the token, it keeps track of the token's semantic value.

Each grouping can also have a semantic value as well as its nonterminal symbol. For example, in a calculator, an expression typically has a semantic value that is a number. In a compiler for a programming language, an expression typically has a semantic value that is a tree structure describing the meaning of the expression.

