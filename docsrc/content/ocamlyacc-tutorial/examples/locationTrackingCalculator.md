---
title: "Location Tracking Calculator"
description : "Location Tracking Calculator: ltcalc"
weight: 40
---

This example extends the infix notation calculator with location tracking. This feature will be used to improve the error messages. For the sake of clarity, this example is a simple integer calculator, since most of the work needed to use locations will be done in the lexical analyser.

3.4.1. Declarations for ltcalc

The Ocaml and Ocamlyacc declarations for the location tracking calculator are the same as the declarations for the infix notation calculator except open Lexing.


/* file: ltcalc.mly */
/* Location tracking calculator. */
%{
open Printf
open Lexing
%}

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

Note there are no declarations specific to locations. Defining a data type for storing locations is not needed: we will use the type provided by default (see Data Type of Locations), which is a four member structure with the following fields:


type Lexing.position = {
  pos_fname : string; 
  pos_lnum : int; 
  pos_bol : int; 
  pos_cnum : int; 
} 
3.4.2. Grammar Rules for ltcalc

Whether handling locations or not has no effect on the syntax of your language. Therefore, grammar rules for this example will be very close to those of the previous example: we will only modify them to benefit from the new information.


Here, we will use locations to report divisions by zero, and locate the wrong expressions or subexpressions.


input:	/* empty */	{ }
	| input line	{ }
;
line:	NEWLINE		{ }
	| exp NEWLINE	{ Printf.printf "\t%.10g\n" $1; flush stdout }
;
exp:	NUM			{ $1 }
	| exp PLUS exp		{ $1 +. $3 }
	| exp MINUS exp		{ $1 -. $3 }
	| exp MULTIPLY exp		{ $1 *. $3 }
	| exp DIVIDE exp		{ if $3 <> 0.0 then $1 /. $3
				  else (
				    let start_pos = Parsing.rhs_start_pos 3 in
				    let end_pos = Parsing.rhs_end_pos 3 in
				    printf "%d.%d-%d.%d: division by zero"
				      start_pos.pos_lnum (start_pos.pos_cnum - start_pos.pos_bol)
				      end_pos.pos_lnum (end_pos.pos_cnum - end_pos.pos_bol);
				    1.0
				  )
				}
	| MINUS exp %prec NEG	{ -. $2 }
	| exp CARET exp		{ $1 ** $3 }
	| LPAREN exp RPAREN	{ $2 }
;


This code shows how to reach locations inside of semantic actions. For rule components, use the following functions,


val Parsing.rhs_start_pos : int -> Lexing.position
val Parsing.rhs_end_pos : int -> Lexing.position

where the integer parameter says the position of the components on the right-hand side of the rule. It is 1 for the leftmost component.


For groupings, use the following functions.


val Parsing.symbol_start_pos : unit -> Lexing.position
val Parsing.symbol_end_pos : unit -> Lexing.position

We don't need to calculate the values of the position: the output parser does it automatically. symbol_start_pos is set to the beginning of the leftmost component, and symbol_end_pos to the end of the rightmost component.

3.4.3. The "ltcalc" Lexical Analyzer

Until now, we relied on Ocamlyacc's defaults to enable location tracking. The next step is to rewrite the lexical analyser, and make it able to feed the parser with the token locations, as it already does for semantic values.


To this end, we must take into account every single character of the input text, to avoid the computed locations of being fuzzy or wrong. lexbuf.lex_curr_p.pos_cnum is updated automatically for scanning a character by the lexer engine, so you have to update only lexbuf.lex_curr_p.pos_lnum and lexbuf.lex_curr_p.pos_bol.


(* file: lexer.mll *)
(* Lexical analyzer returns one of the tokens:
   the token NUM of a floating point number,
   operators (PLUS, MINUS, MULTIPLY, DIVIDE, CARET, UMINUS),
   or NEWLINE.  It skips all blanks and tabs, and unknown characters
   and raises End_of_file on EOF. *)

{
  open Ltcalc
  open Lexing
  let incr_lineno lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <- { pos with
      pos_lnum = pos.pos_lnum + 1;
      pos_bol = pos.pos_cnum;
    }
}
let digit = ['0'-'9']
rule token = parse
  | [' ' '\t']	{ token lexbuf }
  | '\n'		{ incr_lineno lexbuf; NEWLINE }
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
  | _		{ token lexbuf }
  | eof		{ raise End_of_file }

Basically, the lexical analyzer performs the same processing as before: it skips blanks and tabs, and reads numbers, operators or delimiters. In addition, it updates lexbuf.lex_curr_p containing the token's location.


Now, each time this function returns a token, the parser has its number as well as its semantic value, and its location in the text.


Remember that computing locations is not a matter of syntax. Every character must be associated to a location update, whether it is in valid input, in comments, in literal strings, and so on.
