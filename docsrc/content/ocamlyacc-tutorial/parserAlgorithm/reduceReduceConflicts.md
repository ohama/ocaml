---
title: "Reduce/Reduce Conflicts"
description: "A reduce/reduce conflict occurs if there are two or more rules that apply to the same sequence of input."
weight: 60
---


A reduce/reduce conflict occurs if there are two or more rules that apply to the same sequence of input.
This usually indicates a serious error in the grammar.


For example, here is an erroneous attempt to define a sequence of zero or more word groupings.

```
sequence: /* empty */	{ printf "empty sequence\n" }
        | maybeword	{}
        | sequence word	{ printf "added word %s\n" $2 }
        ;

maybeword: /* empty */	{ printf "empty maybeword\n" }
        | word		{ printf "single word %s\n" $1 }
        ;
```

The error is an ambiguity: there is more than one way to parse a single word into a sequence. It could be reduced to a maybeword and then into a sequence via the second rule. Alternatively, nothing-at-all could be reduced into a sequence via the first rule, and this could be combined with the word using the third rule for sequence.


There is also more than one way to reduce nothing-at-all into a sequence. This can be done directly via the first rule, or indirectly via maybeword and then the second rule.


You might think that this is a distinction without a difference, because it does not change whether any particular input is valid or not. But it does affect which actions are run. One parsing order runs the second rule's action; the other runs the first rule's action and the third rule's action. In this example, the output of the program changes.


Ocamlyacc resolves a reduce/reduce conflict by choosing to use the rule that appears first in the grammar, but it is very risky to rely on this. Every reduce/reduce conflict must be studied and usually eliminated. Here is the proper way to define sequence:


```
sequence: /* empty */	{ printf "empty sequence\n" }
        | sequence word 	{ printf "added word %s\n" $2 }
        ;
```

Here is another common error that yields a reduce/reduce conflict:


```
sequence: /* empty */
        | sequence words
        | sequence redirects
        ;

words:    /* empty */
        | words word
        ;

redirects:/* empty */
        | redirects redirect
        ;
```

The intention here is to define a sequence which can contain either word or redirect groupings. The individual definitions of sequence, words and redirects are error-free, but the three together make a subtle ambiguity: even an empty input can be parsed in infinitely many ways!


Consider: nothing-at-all could be a words. Or it could be two words in a row, or three, or any number. It could equally well be a redirects, or two, or any number. Or it could be a words followed by three redirects and another words. And so on.


Here are two ways to correct these rules. First, to make it a single level of sequence:


```
sequence: /* empty */
        | sequence word
        | sequence redirect
        ;
```

Second, to prevent either a words or a redirects from being empty:


```
sequence: /* empty */
        | sequence words
        | sequence redirects
        ;

words:    word
        | words word
        ;

redirects:redirect
        | redirects redirect
        ;
```
