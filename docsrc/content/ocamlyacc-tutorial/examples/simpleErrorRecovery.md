---
title: "Simple Error Recovery"
description: "Simple Error Recovery"
weight: 30
---

Up to this point, this manual has not addressed the issue of error recovery---how to continue parsing after the parser detects a syntax error. All we have handled is error reporting with parse_error. Recall that by default, the parser function raises exception after calling parse_error. This means that an erroneous input line causes the calculator program to raise exception and exit. Now we show how to rectify this deficiency.


The Ocamlyacc language itself includes the reserved word error, which may be included in the grammar rules. In the example below it has been added to one of the alternatives for line:

```
line:     NEWLINE
        | exp NEWLINE		{ printf "\t%.10g\n" $1; flush stdout }
        | error NEWLINE		{ }
;
```

This addition to the grammar allows for simple error recovery in the event of a parse error. If an expression that cannot be evaluated is read, the error will be recognized by the third rule for line, and parsing will continue. (The parse_error function is still called.) The action executes the statement and continues to parse.


This form of error recovery deals with syntax errors. There are other kinds of errors; for example, division by zero, which raises an exception that is normally fatal. A real calculator program must handle this exception and resume parsing input lines; it would also have to discard the rest of the current line of input. We won't discuss this issue further because it is not specific to Ocamlyacc programs.
