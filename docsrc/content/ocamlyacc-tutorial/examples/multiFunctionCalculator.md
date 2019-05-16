---
title: "Multi-Function Calculator"
description: "Multi-Function Calculator: mfcalc"
weight: 50
---

Now that the basics of Ocamlyacc have been discussed, it is time to move on to a more advanced problem. The above calculators provided only five functions, +, -, *, / and ^. It would be nice to have a calculator that provides other mathematical functions such as sin, cos, etc.


In this example, we will show how to implement built-in functions whose syntax has this form:

```
function_name (argument)
```

At the same time, we will add memory to the calculator, by allowing you to create named variables, store values in them, and use them later. Here is a sample session with the multi-function calculator:


```
$ mfcalc
pi = 3.14159265
        3.1415927
sin(pi/2)
        1
alpha = beta1 = 2.3
        2.3
alpha
        2.3
log(alpha)
        0.83290912
exp(log(beta1))
        2.3
^D
$
```

Note that multiple assignment and nested function calls are permitted.

### Declarations for mfcalc

Here are the Ocaml and Ocamlyacc declarations for the multi-function calculator.

```
/* file: mfcalc.mly */
%{

open Printf
open Lexing

let var_table = Hashtbl.create 16

%}

/* Ocamlyacc Declarations */
%token NEWLINE
%token LPAREN RPAREN EQ
%token <float> NUM
%token PLUS MINUS MULTIPLY DIVIDE CARET
%token <string> VAR
%token <float->float> FNCT

%left PLUS MINUS
%left MULTIPLY DIVIDE
%left NEG	/* negation -- unary minus */
%right CARET	/* exponentiation */

%start input
%type <unit> input

/* Grammar follows */
%%
```

Since values can have various types, it is necessary to associate a type with each grammar symbol whose semantic value is used. These symbols are NUM, VAR, FNCT, and exp. The declarations of terminals are augmented with information about their data type (placed between angle brackets).


The data type of non-terminal, exp, is nomally declared implicitly by the action.


In header section, a hash table called var_table is created for storing variable's name and value. This will be used in the semantic action part. See The mfcalc Symbol Table.

### Grammar Rules for mfcalc

Here are the grammar rules for the multi-function calculator. Most of them are copied directly from calc; three rules, those which mention VAR or FNCT, are new.

```
input:	/* empty */	{ }
	| input line	{ }
;
line:	NEWLINE		{ }
	| exp NEWLINE	{ printf "\t%.10g\n" $1; flush stdout }
	| error NEWLINE	{ }
;
exp:	NUM			{ $1 }
	| VAR			{ try Hashtbl.find var_table $1
				  with Not_found ->
				    printf "no such variable '%s'\n" $1;
				    0.0
				}
	| VAR EQ exp		{ Hashtbl.replace var_table $1 $3;
				  $3
				}
	| FNCT LPAREN exp RPAREN	{ $1 $3 }
	| exp PLUS exp		{ $1 +. $3 }
	| exp MINUS exp		{ $1 -. $3 }
	| exp MULTIPLY exp	{ $1 *. $3 }
	| exp DIVIDE exp	{ $1 /. $3 }
	| MINUS exp %prec NEG	{ -. $2 }
	| exp CARET exp		{ $1 ** $3 }
	| LPAREN exp RPAREN	{ $2 }
;

%%
```

For the meaning of the semantic actions related with VAR, see The mfcalc Symbol Table.

### The mfcalc Symbol Table

The multi-function calculator requires a symbol table to keep track of the names and meanings of variables and functions. This doesn't affect the grammar rules (except for the actions) or the Ocamlyacc declarations, but it requires some additional Ocaml functions for support.


In this example, we use two symbol tables: one for variables and one for functions. The variable symbol table is defined and used in parser and the function symbol table is defined and used in lexer.


The variable symbol table itself is implemented using the hash table. It has a key of string type and a value of float type.


It is a simple job to modify this code to install predefined variables such as pi or e as well.


Two important functions allow look-up and installation of symbols in the symbol table. The function Hashtbl.replace is passed a name and the value of the variable to be installed. The function Hashtbl.find is passed the name of the symbol to look up. If found, the value of that symbol is returned; otherwise zero is returned.


The lexical analyzer function must now recognize variables, numeric values, and the arithmetic operators. Strings of alphanumeric characters with a leading non-digit are recognized as either variables or functions depending on what the symbol table says about them.


The string is used for look up in the function symbol table. If the name appears in the table, the corresponding function is returned to the parser function as the value of FNCT. If it is not, VAR with the string is returned.


No change is needed in the handling of numeric values and arithmetic operators in the lexical analyzer function.

```
(* file: lexer.mll *)

{
  open Mfcalc
  open Lexing

  let create_hashtable size init =
    let tbl = Hashtbl.create size in
    List.iter (fun (key, data) -> Hashtbl.add tbl key data) init;
    tbl

  let fun_table = create_hashtable 16 [
    ("sin", sin);
    ("cos", cos);
    ("tan", tan);
    ("asin", asin);
    ("acos", acos);
    ("atan", atan);
    ("log", log);
    ("exp", exp);
    ("sqrt", sqrt);
  ]
}

let digit = ['0'-'9']
let ident = ['a'-'z' 'A'-'Z']
let ident_num = ['a'-'z' 'A'-'Z' '0'-'9']
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
  | '('		{ LPAREN }
  | ')'		{ RPAREN }
  | '='		{ EQ }
  | ident ident_num* as word
  		{ try
		    let f = Hashtbl.find fun_table word in
		    FNCT f
		  with Not_found -> VAR word
  		}
  | _		{ token lexbuf }
  | eof		{ raise End_of_file }
```

A hash table named fun_table is used for storing a function name and a value, that is, a function definition. It is initialized in the header part of the lexer file.


This program is both powerful and flexible. You may easily add new functions.

