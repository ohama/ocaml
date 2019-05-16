---
title: "Infix Notation Calculator"
description: "Infix Notation Calculator: calc"
weight: 20
---

We now modify rpcalc to handle infix operators instead of postfix. Infix notation involves the concept of operator precedence and the need for parentheses nested to arbitrary depth. Here is the Ocamlyacc code for calc.mly, an infix desk-top calculator.

```
/* file: calc.mly */
/* Infix notatoin calculator -- calc */
%{
  open Printf
%}

/* Ocamlyacc Declarations */
%token NEWLINE
%token LPAREN RPAREN
%token <float> NUM
%token PLUS MINUS MULTIPLY DIVIDE CARET

%left PLUS MINUS
%left MULTIPLY DIVIDE
%left NEG		/* negation -- unary minus */
%right CARET	/* exponentiation */

%start input
%type <unit> input

/* Grammar follows */
%%
input:	/* empty */	{ }
	| input line	{ }
;
line:	NEWLINE		{ }
	| exp NEWLINE	{ printf "\t%.10g\n" $1; flush stdout }
;
exp:	NUM			{ $1 }
	| exp PLUS exp		{ $1 +. $3 }
	| exp MINUS exp		{ $1 -. $3 }
	| exp MULTIPLY exp		{ $1 *. $3 }
	| exp DIVIDE exp		{ $1 /. $3 }
	| MINUS exp %prec NEG	{ -. $2 }
	| exp CARET exp		{ $1 ** $3 }
	| LPAREN exp RPAREN	{ $2 }
;

%%
```

There are two important new features shown in this code.


In the second section (Ocamlyacc declarations), %left says they are left-associative operators. The declarations %left and %right (right associativity) is used for the declaration of associativity.


Operator precedence is determined by the line ordering of the declarations; the higher the line number of the declaration (lower on the page or screen), the higher the precedence. Hence, exponentiation has the highest precedence, unary minus (NEG) is next, followed by MULTIPLY and DIVIDE, and so on. See Operator Precedence.


The other important new feature is the %prec in the grammar section for the unary minus operator. The %prec simply instructs Ocamlyacc that the rule | MINUS exp has the same precedence as NEG---in this case the next-to-highest. See Context-Dependent Precedence.


Here is a sample run of calc.mly:

```
$ calc
4 + 4.5 - (34/(8*3+-3))
	6.880952381
-56 + 2
	-54
3 ^ 2
	9
```
