---
title: "Reverse Polish Notation Calculator"
description: "Reverse Polish Notation Calculator: rpcalc"
weight: 10
---

The first example is that of a simple double-precision reverse polish notation calculator (a calculator using postfix operators). This example provides a good starting point, since operator precedence is not an issue. The second example will illustrate how operator precedence is handled.


The source code for this calculator is named rpcalc.mly. The .mly extension is a convention used for Ocamlyacc input files.

### Declarations for "rpcalc"

Here are the Ocaml and Ocamlyacc declarations for the reverse polish notation calculator. By default, comments are enclosed between /* and */ (as in C) except in Ocaml code.

```
/* file: rpcalc.mly */
/* Reverse polish notation calculator. */

%{
open Printf
%}

%token <float> NUM
%token PLUS MINUS MULTIPLY DIVIDE CARET UMINUS
%token NEWLINE

%start input
%type <unit> input

%% /* Grammar rules and actions follow */
```

The header section (see The Header Section) has a code of openning "Printf" module.

The second section, Ocamlyacc declarations, provides information to Ocamlyacc about the token types (see The Ocamlyacc Declarations Section). Each terminal must be declared here. The first terminal symbol is the token type for numeric constants which has a value of float The possible arithmetic operators are PLUS, MINUS, MULTIPLY, DIVIDE, CARET for exponetiation and UMINUS for unary minus. These operator terminals don't have any value with it. The last terminal is NEWLINE, a token type for the newline character.

You must give the names of the start symbols and their types, too. In this examples, there is one start symbol named input which has type of unit. For each start symbol, the parser function with the same name is generated.

### Grammar Rules for rpcalc

Here are the grammar rules for the reverse polish notation calculator.

```
input:    /* empty */		{ }
        | input line		{ }
;

line:     NEWLINE		{ }
        | exp NEWLINE		{ printf "\t%.10g\n" $1; flush stdout }
;

exp:      NUM			{ $1 }
        | exp exp PLUS		{ $1 +. $2 }
        | exp exp MINUS		{ $1 -. $2 }
        | exp exp MULTIPLY		{ $1 *. $2 }
        | exp exp DIVIDE		{ $1 /. $2 }
      	/* Exponentiation */
        | exp exp CARET		{ $1 ** $2 }
      	/* Unary minus    */
        | exp UMINUS		{ -. $1 }
;
%%
```

The groupings of the rpcalc "language" defined here are the expression (given the name exp), the line of input (line), and the complete input transcript (input). Each of these nonterminal symbols has several alternate rules, joined by the | punctuator which is read as ''or''. The following sections explain what these rules mean.


The semantics of the language is determined by the actions taken when a grouping is recognized. The actions are the Ocaml code that appears inside braces. See Actions.


You must specify these actions in Ocaml, but Ocamlyacc provides the means for passing semantic values between the rules. In each action, the semantic value for the grouping that the rule is going to construct should be given. The semantic values of the components of the rule are referred to as $1, $2, and so on.

#### Explanation of input

Consider the definition of input:

```
input:    /* empty */
        | input line
;
```

This definition reads as follows: ''A complete input is either an empty string, or a complete input followed by an input line''. Notice that ''complete input'' is defined in terms of itself. This definition is said to be left recursive since input appears always as the leftmost symbol in the sequence. See Recursive Rules.


The first alternative is empty because there are no symbols between the colon and the first |; this means that input can match an empty string of input (no tokens). We write the rules this way because it is legitimate to type Ctrl-d right after you start the calculator. It's conventional to put an empty alternative first and write the comment /* empty */ in it.


The second alternate rule (input line) handles all nontrivial input. It means, ''After reading any number of lines, read one more line if possible.'' The left recursion makes this rule into a loop. Since the first alternative matches empty input, the loop can be executed zero or more times.


The parser function input continues to process input until a grammatical error is seen or the lexical analyzer says there are no more input tokens; we will arrange for the latter to happen at end of file.

#### Explanation of line

Now consider the definition of line:

```
line:     NEWLINE      { }
        | exp NEWLINE  { printf "\t%.10g\n" $1; flush stdout }
;
```


The first alternative is a token which is a newline character; this means that rpcalc accepts a blank line (and ignores it, since there is no action). The second alternative is an expression followed by a newline. This is the alternative that makes rpcalc useful. The semantic value of the exp grouping is the value of $1 because the exp in question is the first symbol in the alternative. The action prints this value, which is the result of the computation the user asked for.


As you can see, the semantic value associated with the line is unit.

#### Explanation of expr

The exp grouping has several rules, one for each kind of expression. The first rule handles the simplest expressions: those that are just numbers. The second handles an addition-expression, which looks like two expressions followed by a plus-sign. The third handles subtraction, and so on.

```
exp:	  NUM		{ $1 }
	| exp exp PLUS	{ $1 +. $2 }
	| exp exp MINUS	{ $1 -. $2 }
	...
	;
```

We have used | to join all the rules for exp, but we could equally well have written them separately:

```
exp:	NUM		{ $1 };
exp:	exp exp PLUS	{ $1 +. $2 };
exp:	exp exp MINUS	{ $1 -. $2 };
	...
```

All of the rules have actions that compute the value of the expression in terms of the value of its parts. For example, in the rule for addition, $1 refers to the first component exp and $2 refers to the second one. The third component, PLUS, has no meaningful associated semantic value, but if it had one you could refer to it as $3. When the parser function recognizes a sum expression using this rule, the sum of the two subexpressions' values is produced as the value of the entire expression. See Actions.


The formatting shown here is the recommended convention, but Ocamlyacc does not require it. You can add or change whitespace as much as you wish. For example, this:

```
exp:	NUM { $1 } | exp exp PLUS { $1 +. $2 } | ...
```

means the same thing as this:

```
exp:      NUM		{ $1 }
        | exp exp PLUS	{ $1 + $2 }
        | ...
```

The latter, however, is much more readable.

### The rpcalc Lexical Analyzer

The lexical analyzer's job is low-level parsing: converting characters or sequences of characters into tokens. The Ocamlyacc parser gets its tokens by calling the lexical analyzer. See The Lexical Analyzer Function.


Only a simple lexical analyzer is needed for the RPN calculator. This lexical analyzer reads in numbers as float and returns them as NUM tokens. It recognizes '+', '-', '*', '/', '^', 'n' as operators and returns the corresponding token: ADD, MINUS, MULTIPLY, DIVIDE, CARET and UMINUS. When it meets '\n', the returning token is NEWLINE. Spaces and unknown characers are skipped.


The return value of the lexical analyzer function is a value of the concrete token type. The same text used in Ocamlyacc rules to stand for this token type is also a Ocaml expression for the value for the type. Token type is defined by Ocamlyacc as a constructor of the concrete token type. In this example, therefore, NUM, PLUS, ... become values for the lexer function to use.


The semantic value of the token (if it has one) is returned with it. In this example, only NUM has a semantic value.


Here is the code for the lexical analyzer:

```
(* file: lexer.mll *)
(* Lexical analyzer returns one of the tokens:
   the token NUM of a floating point number,
   operators (PLUS, MINUS, MULTIPLY, DIVIDE, CARET, UMINUS),
   or NEWLINE.  It skips all blanks and tabs, unknown characters
   and raises End_of_file on EOF. *)
{
  open Rtcalc (* Assumes the parser file is "rtcalc.mly". *)
}
let digit = ['0'-'9']
rule token = parse
  | [' ' '\t']	{ token lexbuf }
  | '\n'	{ NEWLINE }
  | digit+
  | "." digit+
  | digit+ "." digit* as num
		{ NUM (float_of_string num) }
  | '+'		{ PLUS }
  | '-'		{ MINUS }
  | '*'		{ MULTIPLY }
  | '/'		{ DIVIDE }
  | '^'		{ CARET }
  | 'n'		{ UMINUS }
  | _		{ token lexbuf }
  | eof		{ raise End_of_file }
```

### The Controlling Function

In keeping with the spirit of this example, the controlling function is kept to the bare minimum. To start the process of parsings, the only requirement is that it call parser function Parser.input with two argumenst: lexical analyzer function Lexer.token and lexbuf of Lexing.lexbuf type.

```
(* file: main.ml *)
(* Assumes the parser file is "rtcalc.mly" and the lexer file is "lexer.mll". *)
let main () =
  try
    let lexbuf = Lexing.from_channel stdin in
    while true do
      Rtcalc.input Lexer.token lexbuf
    done
  with End_of_file -> exit 0
      
let _ = Printexc.print main ()
```

### The Error Reporting Routine

When ther parser function detects a syntax error, it calls a function named parse_error with the string "syntax error" as argument. The default parse_error function does nothing and returns, thus initiating error recovery (see Error Recovery). The user can define a customized parse_error function in the header section of the grammar file such as:

```
let parse_error s = (* Called by the parser function on error *)
  print_endline s;
  flush stdout
```

After parse_error returns, the Ocamlyacc parser may recover from the error and continue parsing if the grammar contains a suitable error rule (see Error Recovery). Otherwise, the parser aborts by raising the Parsing.Parse_error exception. We have not written any error rules in this example, so any invalid input will cause the calculator program to raise exception. This is not clean behavior for a real calculator, but it is adequate for the first example.

### Running Ocamlyacc to Make the Parser

Before running Ocamlyacc to produce a parser, we need to decide how to arrange all the source code in source files. For our example, we make three files: rpcalc.mly for Ocamlyacc grammar file, lexer.mll for Ocamllex input file, main.ml which contains main function which calls our parser function.


You can use the following command to convert the parser grammar file into a parser file:

```
ocamlyacc file_name.mly
```

In this example the file was called rpcalc.mly (for ''Reverse Polish CALCulator''). Ocamlyacc produces a file named file_name.ml. The file output by Ocamlyacc contains the source code for parser function input. The additional functions in the input file (parse_error) are copied verbatim to the output.

### Compiling the Parser File

Here is how to compile and run the parser file and lexer file:

```
# List files in current directory.
$ ls
.depend  Makefile  lexer.mll  main.ml  rpcalc.mly

# Compile the Ocamlyacc parser.
$ make
ocamlyacc rpcalc.mly
ocamlc -c rpcalc.mli
ocamllex lexer.mll
15 states, 304 transitions, table size 1306 bytes
ocamlc -c lexer.ml
ocamlc -c rpcalc.ml
ocamlc -c main.ml
ocamlc -o rpcalc lexer.cmo rpcalc.cmo main.cmo
rm rpcalc.mli lexer.ml rpcalc.ml

# List files again.
$ ls
./   .depend   lexer.cmo  main.cmi   main.ml   rpcalc.cmi  rpcalc.mly
../  Makefile  lexer.cmi  lexer.mll  main.cmo  rpcalc*	   rpcalc.cmo
```

The file rpcalc now contains the executable code. Here is an example session using rpcalc.

```
$ rpcalc
4 9 +
	13
3 7 + 3 4 5 *+-
	-13
3 7 + 3 4 5 * + - n	Note the unary minus, n
	13
5 6 / 4 n +
	-3.166666667
3 4 ^			Exponentiation
	81
^D			End-of-file indicator
$
```
