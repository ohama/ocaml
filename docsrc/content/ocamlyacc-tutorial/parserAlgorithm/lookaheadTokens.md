---
title: "Lookahead Tokens"
description: "The Ocamlyacc parser does not always reduce immediately as soon as the last n tokens and groupings match a rule."
weight: 10
---

The Ocamlyacc parser does not always reduce immediately as soon as the last n tokens and groupings match a rule.
This is because such a simple strategy is inadequate to handle most languages. Instead, when a reduction is possible, the parser sometimes "**looks ahead**" at the next token in order to decide what to do.


When a token is read, it is not immediately shifted; first it becomes the look-ahead token, which is not on the stack. Now the parser can perform one or more reductions of tokens and groupings on the stack, while the look-ahead token remains off to the side. When no more reductions should take place, the look-ahead token is shifted onto the stack. This does not mean that all possible reductions have been done; depending on the token type of the look-ahead token, some rules may choose to delay their application.


Here is a simple case where look-ahead is needed. These three rules define expressions which contain binary addition operators and postfix unary factorial operators (FACTORIAL for '!'), and allow parentheses for grouping.

```
expr:     term PLUS expr
        | term
        ;

term:     LPAREN expr RPAREN
        | term FACTORIAL
        | NUMBER
        ;
```

Suppose that the tokens 1 + 2 have been read and shifted; what should be done? If the following token is RPAREN, then the first three tokens must be reduced to form an expr. This is the only valid course, because shifting the RPAREN would produce a sequence of symbols term RPAREN, and no rule allows this.


If the following token is FACTORIAL, that is '!', then it must be shifted immediately so that 2 ! can be reduced to make a term. If instead the parser were to reduce before shifting, 1 + 2 would become an expr. It would then be impossible to shift the ! because doing so would produce on the stack the sequence of symbols expr FACTORIAL. No rule allows that sequence.

