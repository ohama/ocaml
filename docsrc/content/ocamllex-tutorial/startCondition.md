---
title: "Start conditions"
pre: "8. "
weight: 8
description: "ocamllex provides a mechanism for conditionally activating rules. When you want do activate the other rule, just call the other entrypoint function."
---

ocamllex provides a mechanism for conditionally activating rules. When you want do activate the other rule, just call the other entrypoint function.
For example, the following has two rules, one for finding tokens and one for skipping comments.

``` ocaml
{}
rule token = parse
  | [' ' '\t' '\n']+
  	(* skip spaces *)
  	{ token lexbuf }
  | "(*"
	(* activate "comment" rule *)
  	{ comment lexbuf }
  ...
and comment = parse
  | "*)"
  	(* go to the "token" rule *)
  	{ token lexbuf }
  | _
	(* skip comments *)
  	{ comment lexbuf }
  ...
```

When the generated scanner meets comment start token "(*" at the token rule, it activates the other rule comment. When it meets the end of comment token "*)" at the comment rule. it returns to the scanning token rule.
