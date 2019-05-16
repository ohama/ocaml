---
title: "How the input is matched"
pre: "5. "
weight: 5
description: "When the generated scanner is run, it analyzes its input looking for strings which match any of its patterns.  If it finds more than one match, it takes the one matching the most text (the \"longest match\" principle).  If it finds two or more matches of the same length, the rule listed first in the ocamllex input file is chosen (the \"first match\" principle)."
---

When the generated scanner is run, it analyzes its input looking for strings which match any of its patterns.  If it finds more than one match, it takes the one matching the most text (the "longest match" principle).  If it finds two or more matches of the same length, the rule listed first in the _ocamllex_ input file is chosen (the "first match" principle).

   Once the match is determined, the text corresponding to the match
(called the _token_) is made available in
the form of a string.
The _action_
corresponding to the matched pattern is then executed (a more detailed
description of actions follows), and then the remaining input is
scanned for another match.

If no match is found, the scanner raises 
the _Failure "lexing: empty token"_ exception.

Now, let's see the examples which shows how the patterns are applied.

``` ocaml
rule token = parse
  | "ding"	{ print_endline "Ding" }		(* "ding" pattern *)
  | ['a'-'z']+ as word				(* "word" pattern *)
  		{ print_endline ("Word: " ^ word) }
  ...
```

When "ding" is given as an input, the _ding_ and
_word_ pattern can be matched. _ding_
pattern is selected because it comes before _word_ pattern.
So if you code like this:

``` ocaml
rule token = parse
  | ['a'-'z']+ as word				(* "word" pattern *)
  		{ print_endline ("Word: " ^ word) }
  | "ding"	{ print_endline "Ding" }		(* "ding" pattern *)
  | ...
```

_ding_ pattern will be useless.

In the following example, there are three patterns: _ding_, _dong_ and _dingdong_.

``` ocaml
rule token = parse
  | "ding"	{ print_endline "Ding" }		(* "ding" pattern *)
  | "dong"	{ print_endline "Dong" }		(* "dong" pattern *)
  | "dingdong"	{ print_endline "Ding-Dong" }	(* "dingdong" pattern *)
  ...
```

When "dingdong" is given as an input, there are two choices:
_ding_ + _dong_ pattern or
_dingdong_ pattern.
But by the "longest match" principle,
_dingdong_ pattern will be selected.

Though the "shortest match" principle is not used so frequently, 
_ocamllex_ supports it.
If you want to select the shortest prefix of the input,
use _shortest_ keyword
instead of the _parse_ keyword.
The "first match" principle holds still with the "shortest match" principle.

