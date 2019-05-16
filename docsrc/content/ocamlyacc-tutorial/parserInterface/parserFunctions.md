---
title: "Parser Functions"
description: "To cause parsing to occur, you call the parser function with two parameters."
weight: 10
---

To cause parsing to occur, you call the parser function with two parameters. The first parameter is the lexical analyzer function of type

```
Lexing.lexbuf -> token
```

and the second is a value of Lexing.lexbuf type.


If the start symbol is parse in the file parser.mly and the lexer function is is token of the file lexer.mll, the typical usage is:

```
let lexbuf = Lexing.from_channel stdin in
...
let result = Parser.parse Lexer.token lexbuf in
...
```

This parser function reads tokens, executes actions, and ultimately returns when it encounters end-of-input or an unrecoverable syntax error.
