---
title: "Nested comments"
pre: "11.2 "
weight: 2
---

Some language such as Ocaml support nested comment. It can be implemented like this:

``` ocaml
{ }

rule token = parse
  | "(*"		{ print_endline "comments start"; comments 0 lexbuf }
  | [' ' '\t' '\n']	{ token lexbuf }
  | ['a'-'z']+ as word
  		{ Printf.printf "word: %s\n" word; token lexbuf }
  | _ as c	{ Printf.printf "char %c\n" c; token lexbuf }
  | eof		{ raise End_of_file }

and comments level = parse
  | "*)"	{ Printf.printf "comments (%d) end\n" level;
  		  if level = 0 then token lexbuf
		  else comments (level-1) lexbuf
		}
  | "(*"	{ Printf.printf "comments (%d) start\n" (level+1);
  		  comments (level+1) lexbuf
		}
  | _		{ comments level lexbuf }
  | eof		{ print_endline "comments are not closed";
  		  raise End_of_file
		}
```

When the scanner function meets _comments start_ token "(*" in evaluating token rule, it enters _comments_ rule with level of 0. token rule is invoked again when all comments are closed. Comments nesting level is increased whenever there is _comment start_ token "(*" in the input text.


If the scanner function meets _end of comments_ token "*)", it tests the comments nesting level. When the nesting level is not zero, it decrements the level by one and continues to scan comments. It returns to token rule when all the comments are closed i.e., the nesting level is zero.
