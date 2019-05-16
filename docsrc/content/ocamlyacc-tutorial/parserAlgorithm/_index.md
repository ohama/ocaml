---
title: "Parser algorithm"
pre: "6. "
description: "As Ocamlyacc reads tokens, it pushes them onto a stack along with their semantic values."
weight: 60
---

As Ocamlyacc reads tokens, it pushes them onto a stack along with their semantic values.
The stack is called the parser stack. Pushing a token is traditionally called shifting.


For example, suppose the infix calculator has read 1 + 5 *, with a 3 to come. The stack will have four elements, one for each token that was shifted.


But the stack does not always have an element for each token read. When the last n tokens and groupings shifted match the components of a grammar rule, they can be combined according to that rule. This is called reduction. Those tokens and groupings are replaced on the stack by a single grouping whose symbol is the result (left hand side) of that rule. Running the rule's action is part of the process of reduction, because this is what computes the semantic value of the resulting grouping.


For example, if the infix calculator's parser stack contains this:

```
1 + 5 * 3
```

and the next input token is a newline character, then the last three elements can be reduced to 15 via the rule:


```
expr: expr MULTIPLY expr;
```

Then the stack contains just these three elements:


```
1 + 15
```

At this point, another reduction can be made, resulting in the single value 16. Then the newline token can be shifted.


The parser tries, by shifts and reductions, to reduce the entire input down to a single grouping whose symbol is the grammar's start-symbol (see Languages and Context-Free Grammars).


This kind of parser is known in the literature as a bottom-up parser.


{{%children style="h4" description="true" %}}
