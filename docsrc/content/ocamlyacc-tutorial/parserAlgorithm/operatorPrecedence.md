---
title: "Operator Precedence"
description: "the Ocamlyacc declarations for operator precedence allow you to specify when to shift and when to reduce."
weight: 20
---


Another situation where shift/reduce conflicts appear is in arithmetic expressions.
Here shifting is not always the preferred resolution;
the Ocamlyacc declarations for operator precedence allow you to specify when to shift and when to reduce.

### When Precedence is Needed

Consider the following ambiguous grammar fragment (ambiguous because the input 1 - 2 * 3 can be parsed in two different ways):

```
expr:     expr MINUS expr
        | expr MULTIPLY expr
        | expr LT expr
        | LPAREN expr RPAREN
        ...
        ;
```

Suppose the parser has seen the tokens 1, - and 2; should it reduce them via the rule for the subtraction operator? It depends on the next token. Of course, if the next token is ), we must reduce; shifting is invalid because no single rule can reduce the token sequence - 2 ) or anything starting with that. But if the next token is * or **, we have a choice: either shifting or reduction would allow the parse to complete, but with different results.


To decide which one Ocamlyacc should do, we must consider the results. If the next operator token op is shifted, then it must be reduced first in order to permit another opportunity to reduce the difference. The result is (in effect) 1 - (2 op 3). On the other hand, if the subtraction is reduced before shifting op, the result is (1 - 2) op 3. Clearly, then, the choice of shift or reduce should depend on the relative precedence of the operators - and op: * should be shifted first, but not **.


What about input such as 1 - 2 - 5; should this be (1 - 2) - 5 or should it be 1 - (2 - 5)? For most operators we prefer the former, which is called left association. The latter alternative, right association, is desirable for assignment operators. The choice of left or right association is a matter of whether the parser chooses to shift or reduce when the stack contains 1 - 2 and the look-ahead token is -: shifting makes right-associativity.

### Specifying Operator Precedence

Ocamlyacc allows you to specify these choices with the operator precedence declarations %left and %right. Each such declaration contains a list of tokens, which are operators whose precedence and associativity is being declared. The %left declaration makes all those operators left-associative and the %right declaration makes them right-associative. A third alternative is %nonassoc, which declares that it is a syntax error to find the same operator twice ''in a row''.


The relative precedence of different operators is controlled by the order in which they are declared. The first %left or %right declaration in the file declares the operators whose precedence is lowest, the next such declaration declares the operators whose precedence is a little higher, and so on.

### Precedence Examples

In our example, we would want the following declarations:

```
%left LT
%left MINUS
%left MULTIPLY
```

In a more complete example, which supports other operators as well, we would declare them in groups of equal precedence. For example, '+' is declared with '-':


```
%left LT GT EQ NE LE GE
%left PLUS MINUS
%left MULTIPLY DIVIDE
```

(Here NE and so on stand for the operators for "not equal" and so on. We assume that these tokens are more than one character long and therefore are represented by names, not character literals.)

### How Precedence Works

The first effect of the precedence declarations is to assign precedence levels to the terminal symbols declared. The second effect is to assign precedence levels to certain rules: each rule gets its precedence from the last terminal symbol mentioned in the components. (You can also specify explicitly the precedence of a rule. See Context-Dependent Precedence.)


Finally, the resolution of conflicts works by comparing the precedence of the rule being considered with that of the look-ahead token. If the token's precedence is higher, the choice is to shift. If the rule's precedence is higher, the choice is to reduce. If they have equal precedence, the choice is made based on the associativity of that precedence level. The verbose output file made by -v (see Invoking Ocamlyacc) says how each conflict was resolved.


Not all rules and not all tokens have precedence. If either the rule or the look-ahead token has no precedence, then the default is to shift.
