---
title: "Semantic actions"
description: "A grammar rule can have an action made up of Ocaml statements. Each time the parser recognizes a match for that rule, the action is executed."
weight: 40
---

In order to be useful, a program must do more than parse input; it must also produce some output based on the input. In a Ocamlyacc grammar,
a grammar rule can have an action made up of Ocaml statements. Each time the parser recognizes a match for that rule, the action is executed.
See Actions,

Most of the time, the purpose of an action is to compute the semantic value of the whole construct from the semantic values of its parts. For example, suppose we have a rule which says an expression can be the sum of two expressions. When the parser recognizes such a sum, each of the subexpressions has a semantic value which describes how it was built up. The action for this rule should create a similar sort of value for the newly recognized larger expression.


For example, here is a rule that says an expression can be the sum of two subexpressions:

```
expr: expr PLUS expr   { $1 + $3 }
        ;
```

The action says how to produce the semantic value of the sum expression from the values of the two subexpressions.
