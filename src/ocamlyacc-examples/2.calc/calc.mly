/* file: calc.mly */
/* Infix notatoin calculator -- calc */
/*
%{
open Printf
%}
*/

/* Ocamlyacc Declarations */
%token NEWLINE
%token LPAREN RPAREN
%token <float> NUM
%token PLUS MINUS MULTIPLY DIVIDE CARET

%left PLUS MINUS
%left MULTIPLY DIVIDE
%left NEG	/* negation -- unary minus */
%right CARET	/* exponentiation */

%start input
%type <unit> input

/* Grammar follows */
%%
input:	/* empty */	{ }
	| input line	{ }
;
line:	NEWLINE		{ }
	| exp NEWLINE	{ Printf.printf "\t%.10g\n" $1; flush stdout }
;
exp:	NUM			{ $1 }
	| exp PLUS exp		{ $1 +. $3 }
	| exp MINUS exp		{ $1 -. $3 }
	| exp MULTIPLY exp	{ $1 *. $3 }
	| exp DIVIDE exp	{ $1 /. $3 }
	| MINUS exp %prec NEG	{ -. $2 }
	| exp CARET exp		{ $1 ** $3 }
	| LPAREN exp RPAREN	{ $2 }
;

%%

