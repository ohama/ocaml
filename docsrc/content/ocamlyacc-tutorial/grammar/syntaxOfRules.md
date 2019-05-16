---
title: "Syntax of grammar rules"
description: "A Ocamlyacc grammar rule has the following general form:"
weight: 30
---

A Ocamlyacc grammar rule has the following general form:

```
result:
	  symbol ... symbol { semantic-action }
	| ...
	| symbol ... symbol { semantic-action }
	;
```

where result is the nonterminal symbol that this rule describes, and symbol are various terminal and nonterminal symbols that are put together by this rule (see Symbols).


For example,


```
exp:      exp PLUS exp		{}
        ;
```

says that two groupings of type exp, with a PLUS token in between, can be combined into a larger grouping of type exp.


Whitespace in rules is significant only to separate symbols. You can add extra whitespace as you wish.


At the end of the components there must be one action that determine the semantics of the rule. An action looks like this:


```
{Ocaml code}
```

See Actions for detail description.


Multiple rules for the same result can be written separately or can be joined with the vertical-bar character | as follows:


```
result:
	  rule1-symbol ... rule1-symbol { rule1-semantic-action }
	| rule2-symbol ... rule2-symbol { rule2-semantic-action }
	| ...
	;
```

They are still considered distinct rules even when joined in this way.


If components in a rule is empty, it means that result can match the empty string. For example, here is how to define a comma-separated sequence of zero or more exp groupings:


```
expseq:   /* empty */	{}
        | expseq1		{}
        ;

expseq1:  exp			{}
        | expseq1 COMMA exp		{}
        ;
```

It is customary to write a comment /* empty */ in each rule with no components.
