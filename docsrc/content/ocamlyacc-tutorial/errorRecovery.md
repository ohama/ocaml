---
title: "Error Recovery"
pre: "7. "
weight: 70
description: "It is not usually acceptable to have a program terminate on a parse error. For example, a compiler should recover sufficiently to parse the rest of the input file and check it for errors; a calculator should accept another expression."
---


It is not usually acceptable to have a program terminate on a parse error. For example, a compiler should recover sufficiently to parse the rest of the input file and check it for errors; a calculator should accept another expression.


In a simple interactive command parser where each input is one line, it may be sufficient to have the caller catch the exception and ignore the rest of the input line when that happens (and then call parse function again). But this is inadequate for a compiler, because it forgets all the syntactic context leading up to the error. A syntax error deep within a function in the compiler input should not cause the compiler to treat the following line like the beginning of a source file.


You can define how to recover from a syntax error by writing rules to recognize the special token error. This is a terminal symbol that is reserved for error handling. The Ocamlyacc parser generates an error token whenever a syntax error happens; if you have provided a rule to recognize this token in the current context, the parse can continue.


For example:


stmnts:  /* empty string */		{}
        | stmnts NEWLINE		{}
        | stmnts exp NEWLINE	{}
        | stmnts error NEWLINE	{}

The fourth rule in this example says that an error followed by a newline makes a valid addition to any stmnts.


What happens if a syntax error occurs in the middle of an exp? The error recovery rule, interpreted strictly, applies to the precise sequence of a stmnts, an error and a newline. If an error occurs in the middle of an exp, there will probably be some additional tokens and subexpressions on the stack after the last stmnts, and there will be tokens to read before the next newline. So the rule is not applicable in the ordinary way.


But Ocamlyacc can force the situation to fit the rule, by discarding part of the semantic context and part of the input. First it discards states and objects from the stack until it gets back to a state in which the error token is acceptable. (This means that the subexpressions already parsed are discarded, back to the last complete stmnts.) At this point the error token can be shifted. Then, if the old look-ahead token is not acceptable to be shifted next, the parser reads tokens and discards them until it finds a token which is acceptable. In this example, Ocamlyacc reads and discards input until the next newline so that the fourth rule can apply.


The choice of error rules in the grammar is a choice of strategies for error recovery. A simple and useful strategy is simply to skip the rest of the current input line or current statement if an error is detected:


stmnt: error SEMICOLON	{}	/* on error, skip until SEMICOLON is read */

It is also useful to recover to the matching close-delimiter of an opening-delimiter that has already been parsed. Otherwise the close-delimiter will probably appear to be unmatched, and generate another, spurious error message:


primary:  LPAREN expr RPAREN	{}
        | LPAREN error RPAREN	{}
        ...
        ;

Error recovery strategies are necessarily guesses. When they guess wrong, one syntax error often leads to another. In the above example, the error recovery rule guesses that an error is due to bad input within one stmnt. Suppose that instead a spurious semicolon is inserted in the middle of a valid stmnt. After the error recovery rule recovers from the first error, another syntax error will be found straightaway, since the text following the spurious semicolon is also an invalid stmnt.


To prevent an outpouring of error messages, the parser will output no error message for another syntax error that happens shortly after the first; only after three consecutive input tokens have been successfully shifted will error messages resume.
