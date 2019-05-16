---
title: "Recursive Rules"
description: "A rule is called recursive when its result nonterminal appears also on its right hand side."
weight: 40
---

A rule is called recursive when its result nonterminal appears also on its right hand side.
Nearly all Ocamlyacc grammars need to use recursion, because that is the only way to define a sequence of any number of a particular thing. Consider this recursive definition of a comma-separated sequence of one or more expressions:

```
expseq1:  exp			{}
        | expseq1 COMMA exp		{}
        ;
```


Since the recursive use of expseq1 is the leftmost symbol in the right hand side, we call this left recursion. By contrast, here the same construct is defined using right recursion:


```
expseq1:  exp			{}
        | exp COMMA expseq1		{}
        ;
```

Any kind of sequence can be defined using either left recursion or right recursion, but you should always use left recursion, because it can parse a sequence of any number of elements with bounded stack space. Right recursion uses up space on the Ocamlyacc stack in proportion to the number of elements in the sequence, because all the elements must be shifted onto the stack before the rule can be applied even once. See The Ocamyacc Parser Algorithm, for further explanation of this.

Indirect or mutual recursion occurs when the result of the rule does not appear directly on its right hand side, but does appear in rules for other nonterminals which do appear on its right hand side.


For example:


```
expr:     primary			{}
        | primary PLUS primary	{}
        ;

primary:  constant			{}
        | LPAREN expr RPAREN	{}
        ;
```

defines two mutually-recursive nonterminals, since each refers to the other.
