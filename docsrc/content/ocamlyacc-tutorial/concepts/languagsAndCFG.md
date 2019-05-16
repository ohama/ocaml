---
title: "Languages and context-free grammars"
description: "In order for Ocamlyacc to parse a language, it must be described by a context-free grammar."
weight: 10
---

In order for Ocamlyacc to parse a language, it must be described by a
`context-free grammar`.  This means that you specify one or more
_syntactic groupings_ and give rules for constructing them from their
parts.  For example, in the C language, one kind of grouping is called an
'expression'.  One rule for making an expression might be, "An expression
can be made of a minus sign and another expression".  Another would be,
"An expression can be an integer".  As you can see, rules are often
recursive, but there must be at least one rule which leads out of the
recursion.

The most common formal system for presenting such rules for humans to read
is `Backus-Naur Form` or `BNF`, which was developed in order to
specify the language Algol 60.  Any grammar expressed in BNF is a
context-free grammar.  The input to Ocamlyacc is essentially machine-readable
BNF.

Not all context-free languages can be handled by Ocamlyacc, only those
that are LALR(1).  In brief, this means that it must be possible to
tell how to parse any portion of an input string with just a single
token of look-ahead.  Strictly speaking, that is a description of an
LR(1) grammar, and LALR(1) involves additional restrictions that are
hard to explain simply; but it is rare in actual practice to find an
LR(1) grammar that fails to be LALR(1).
See <link linkend="sec-mysterious-reduce-reduce-conflicts">Mysterious
Reduce/Reduce Conflicts</link>,
for more information on this.

In the formal grammatical rules for a language, each kind of syntactic unit
or grouping is named by a _symbol_.  Those which are built by grouping
smaller constructs according to grammatical rules are called
_nonterminal symbols_; those which can't be subdivided are called
_terminal symbols_ or _token types_.  We call a piece of input
corresponding to a single terminal symbol a "token", and a piece
corresponding to a single nonterminal symbol a _grouping_.

We can use the C language as an example of what symbols, terminal and
nonterminal, mean.  The tokens of C are identifiers, constants (numeric and
string), and the various keywords, arithmetic operators and punctuation
marks.  So the terminal symbols of a grammar for C include 'identifier',
'number', 'string', plus one symbol for each keyword, operator or
punctuation mark: 'if', 'return', 'const', 'static', 'int', 'char',
'plus-sign', 'open-brace', 'close-brace', 'comma' and many more.  (These
tokens can be subdivided into characters, but that is a matter of
lexicography, not grammar.)

Here is a simple C function subdivided into tokens:

'''C
int             /* keyword 'int' */
square (int x)  /* identifier, open-paren, identifier, identifier, close-paren */
{               /* open-brace */
  return x * x; /* keyword 'return', identifier, asterisk, identifier, semicolon */
}               /* close-brace */
'''

The syntactic groupings of C include the expression, the statement, the
declaration, and the function definition.  These are represented in the
grammar of C by nonterminal symbols 'expression', 'statement',
'declaration' and 'function definition'.  The full grammar uses dozens of
additional language constructs, each with its own nonterminal symbol, in
order to express the meanings of these four.  The example above is a
function definition; it contains one declaration, and one statement.  In
the statement, each "x" is an expression and so is "x * x".

Each nonterminal symbol must have grammatical rules showing how it is made
out of simpler constructs.  For example, one kind of C statement is the
"return" statement; this would be described with a grammar rule which
reads informally as follows:

    A 'statement' can be made of a 'return' keyword, an 'expression' and a 'semicolon'.

There would be many other rules for 'statement', one for each kind of
statement in C.

One nonterminal symbol must be distinguished as the special one which
defines a complete utterance in the language.  It is called the _start
symbol_.
In a compiler, this means a complete input program.  In the C
language, the nonterminal symbol 'sequence of definitions and declarations'
plays this role.

For example, "1 + 2" is a valid C expression---a valid part of a C
program---but it is not valid as an _entire_ C program.  In the
context-free grammar of C, this follows from the fact that 'expression' is
not the start symbol.

The Ocamlyacc parser reads a sequence of tokens as its input, and groups the
tokens using the grammar rules.  If the input is valid, the end result is
that the entire token sequence reduces to a single grouping whose symbol is
the grammar's start symbol.  If we use a grammar for C, the entire input
must be a 'sequence of definitions and declarations'.  If not, the parser
reports a syntax error.

