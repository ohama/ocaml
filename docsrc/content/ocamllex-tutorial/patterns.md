---
title: "Patterns"
weight: 4
pre: "4. "
description: "The patterns in the input are written using regular expressions in the style of lex, with a more Caml-like syntax."
---

The patterns in the input are written using regular expressions
in the style of lex, with a more Caml-like syntax.
These are:

- `'c'`: match _the character_ 'c'. The character constant is the same syntax as Objective Caml character.
- `_`: (underscore) match _any character_.
- `eof`: match an _end-of-file_ .
- `"foo"`: _the literal string_ "foo". The syntax is the same syntax as Objective Caml string constants.
- `['x' 'y' 'z']`: _character set_; in this case, the pattern matches either an 'x', a 'y', or a 'z' .
- `['a' 'b' 'j'-'o' 'Z']`: _character set with a range_ in it; ranges of characters 'c1' - 'c2' (all characters between c1 and c2, inclusive);
  in this case, the pattern matches an 'a', a 'b', any letter from 'j' through 'o', or a 'Z'.
- `[^ 'A'-'Z']`:
  _a negated character set_, i.e., any character but those in the class. In this case, any character EXCEPT an uppercase letter. 
- `[^ 'A'-'Z' '\n']`: _any character EXCEPT_ an uppercase letter or a newline 
- `r*`: _zero or more r's_, where r is any regular expression 
- `r+`: _one or more r's_, where r is any regular expression 
- `r?`: _zero or one r's_, where r is any regular expression (that is, "an optional r") 
- `ident`: the expansion of the "ident"
  defined by an earlier `let ident =  regexp` definition.
- `(r)`: match an r; parentheses are used to override precedence (see below) 
- `rs`: the regular expression r followed by the regular expression s; called "concatenation" 
- `r|s`: _either an r or an s_ 
- `r#s`: match the difference of the two specified character sets.
- `r as ident`: bind the string matched by _r_ to identifier _ident_

The regular expressions listed above are grouped according to precedence, from highest precedence at the top to lowest at the bottom;
'*' and '+' have highest precedence, followed by '?', 'concatenation', '|', and then _'as'_.
For example,


``` ocaml
"foo" | "bar"*
```

is the same as

``` ocaml
("foo")|("bar"*)
```

since the '*' operator has higher precedence than
than alternation ('|').  This pattern therefore
matches _either_ the string "foo" _or_
zero-or-more of the string "bar".


To match zero-or-more "foo"'s-or-"bar"'s:


``` ocaml
("foo"|"bar")*
```


A negated character set such as the example "[^ 'A'-'Z']" above
_will match a newline_
unless "\n" (or an equivalent escape sequence) is
one of the characters explicitly present in the negated character
set (e.g., "[^ 'A'-'Z' '\n']").  This is unlike how many other regular
expression tools treat negated character set, but
unfortunately the inconsistency is historically entrenched.
Matching newlines means that a pattern like [^"]* can match the
entire input unless there's another quote in the input.

