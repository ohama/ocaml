---
title: "Defineing Language Semantics"
description: "The grammar rules for a language determine only the syntax. The semantics are determined by the semantic values associated with various tokens and groupings, and by the actions taken when various groupings are recognized."
weight: 50
---

The grammar rules for a language determine only the syntax. The semantics are determined by the semantic values associated with various tokens and groupings, and by the actions taken when various groupings are recognized.


For example, the calculator calculates properly because the value associated with each expression is the proper number; it adds properly because the action for the grouping x + y is to add the numbers associated with x and y.

### Data Types of Semantic Values

In a simple program it may be sufficient to use the same data type for the semantic values of all language constructs. But in most programs, you will need different data types for different kinds of tokens and groupings. For example, a numeric constant may need type int or float, while a string constant or an identifier might need type string.


To use more than one data type for semantic values in one parser, Ocamlyacc requires you to do: Choose one of those types for each symbol (terminal or nonterminal) for which semantic values are used. This is done for tokens with the %token Ocamlyacc declaration (see Token Type Names) and for groupings with the %type Ocamlyacc declaration (see Nonterminal Symbols).

### Actions

An action accompanies a syntactic rule and contains Ocaml code to be executed each time an instance of that rule is recognized. The task of most actions is to compute a semantic value for the grouping built by the rule from the semantic values associated with tokens or smaller groupings.


An action consists of Ocaml statements surrounded by braces. All rules have just one action at the end of the rule, following all the components.


The Ocaml code in an action can refer to the semantic values of the components matched by the rule with the construct $n, which stands for the value of the nth component. The value of the evaluation of the action is the value for the grouping being constructed.


Here is a typical example:

```
exp:    ...
        | exp PLUS exp { $1 +. $3 }
```

 This rule constructs an exp from two smaller exp groupings connected by a plus-sign token. In the action, $1 and $3 refer to the semantic values of the two component exp groupings, which are the first and third symbols on the right hand side of the rule. The sum is returned so that it becomes the semantic value of the addition-expression just recognized by the rule. If there were a useful semantic value associated with the PLUS token, it could be referred to as '$2.'
