---
title: "Error Functions"
description: "The Ocamlyacc parser detects a parse error or syntax error whenever it reads a token which cannot satisfy any syntax rule."
weight: 30
---

The Ocamlyacc parser detects a parse error or syntax error whenever it reads a token which cannot satisfy any syntax rule.
An action in the grammar can also explicitly proclaim an error, using the raise Parsing.Parse_error.


The Ocamlyacc parser expects to report the error by calling an error reporting function named parse_error, which is optional. The default parse_error function does nothing and returns. It is called by the parser function whenever a syntax error is found, and it receives one argument. For a parse error, the string is normally "syntax error".


The following definition suffices in simple programs:

```
let parse_error s = print_endline s
```

After parse_error returns to the parse function, the latter will attempt error recovery if you have written suitable error recovery grammar rules (see Error Recovery). If recovery is impossible, the parse function will raise Parsing.Parse_error exception.
