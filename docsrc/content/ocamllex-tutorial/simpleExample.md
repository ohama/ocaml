---
title: "Some simple examples"
weight: 2
pre: "2. "
description: "First some simple examples to get the flavor of how one uses ocamllex. The following ocamllex input specifies a scanner which whenever it encounters the string \"current_directory\" will replace it with the current directory: ..."
---

First some simple examples to get the flavor of how one uses _ocamllex_.
The following _ocamllex_ input specifies a scanner which whenever it
encounters the string "current_directory" will replace it with the current 
directory:

``` ocaml
{ }
rule translate = parse
  | "current_directory"	{ print_string (Sys.getcwd ()); translate lexbuf }
  | _ as c		{ print_char c; translate lexbuf }
  | eof			{ exit 0 }
```

In the first rule, "current_directory" is the <emphasis>pattern</emphasis>
and the expression between braces is the <emphasis>action</emphasis>.
By this rule, when the scanner matches the string "current_directory",
it executes the corresponding action which prints the current directory name
and call the scanner again.
Recursive calling itself is necessary to do the other job.

Any text not matched by a <emphasis>ocamllex</emphasis> scanner
generates exception _Failure "lexing: empty token"_,
so you have to supply the last two rules.
The second rule copies any character to its output
which is not matched by the first rule, and it calls itself again.
By the third rule, the program exits when it meets
_end of file_.
So the net effect of this scanner is to copy its input file
to its output with each occurrence of "current_directory" expanded.
The "{ }" in the first line delimits the _header_ section from the rest.

Here's another simple example:

``` ocaml
{
  let num_lines = ref 0
  let num_chars = ref 0
}

rule count = parse
  | '\n'        { incr num_lines; incr num_chars; count lexbuf }
  | _           { incr num_chars; count lexbuf }
  | eof         { () }

{
  let main () =
    let lexbuf = Lexing.from_channel stdin in
    count lexbuf;
    Printf.printf "# of lines = %d, # of chars = %d\n" !num_lines !num_chars

  let _ = Printexc.print main ()
}
```

   This scanner counts the number of characters and the number of lines
in its input (it produces no output other than the final report on the
counts).
The first _header_ section declares two globals,
"num_lines" and "num_chars", which are accessible both inside scanner function
_count_ and in the _trailer_ section
which is the last part enclosed by braces.
There are three rules,
one which matches a newline ("\n") and increments both the line count
and the character count, and one which matches any character other than
a newline (indicated by the "\_"  regular expression).
At the end of file, the scanner function _count_ returns
_unit_.

A somewhat more complicated example:

``` ocaml
(* scanner for a toy language *)

{
  open Printf
}

let digit = ['0'-'9']
let id = ['a'-'z'] ['a'-'z' '0'-'9']*

rule toy_lang = parse
  | digit+ as inum
  	{ printf "integer: %s (%d)\n" inum (int_of_string inum);
	  toy_lang lexbuf
	}
  | digit+ '.' digit* as fnum
  	{ printf "float: %s (%f)\n" fnum (float_of_string fnum);
	  toy_lang lexbuf
	}
  | "if"
  | "then"
  | "begin"
  | "end"
  | "let"
  | "in"
  | "function" as word
  	{ printf "keyword: %s\n" word;
	  toy_lang lexbuf
	}
  | id as text
  	{ printf "identifier: %s\n" text;
	  toy_lang lexbuf
	}
  | '+'
  | '-'
  | '*'
  | '/' as op
  	{ printf "operator: %c\n" op;
	  toy_lang lexbuf
	}
  | '{' [^ '\n']* '}'	{ toy_lang lexbuf }	(* eat up one-line comments *)
  | [' ' '\t' '\n']	{ toy_lang lexbuf }	(* eat up whitespace *)
  | _ as c
  	{ printf "Unrecognized character: %c\n" c;
	  toy_lang lexbuf
	}
  | eof		{ }

{
  let main () =
    let cin =
      if Array.length Sys.argv > 1
      then open_in Sys.argv.(1)
      else stdin
    in
    let lexbuf = Lexing.from_channel cin in
    toy_lang lexbuf

  let _ = Printexc.print main ()
}
```

   This is the beginnings of a simple scanner for a language.
It identifies different types of <emphasis>tokens</emphasis>
and reports on what it has seen.

   The details of this example will be explained in the following
sections.


