---
title: "Nonterminal Symbols"
description: "The Ocamlyacc declarations section of a Ocamlyacc grammar defines the symbols used in formulating the grammar and the data types of semantic values.  All token type must be declared. Nonterminal symbols must be declared if you need to specify which data type to use for the semantic value."
weight: 70
---

The Ocamlyacc declarations section of a Ocamlyacc grammar defines the symbols used in formulating the grammar and the data types of semantic values. See Symbols.

All token type must be declared. Nonterminal symbols must be declared if you need to specify which data type to use for the semantic value (see Data Types of Semantic Values).

The first rule in the file also specifies the start symbol, by default. If you want some other symbol to be the start symbol, you must declare it explicitly (see Languages and Context-Free Grammars).

### Token Type Names

The basic way to declare a token type name (terminal symbol) is as follows:

```
%token name ... name
%token <type> name ... name
```

Ocamlyacc will convert this into a token type in the parser, so that the lexer function can use the name name to stand for this token type's code.

In the event that the token has a value, you must augment the %token declaration to include the data type alternative delimited by angle-brackets (see Data Types of Semantic Values).

For example:

```
%token <float> NUM	/* define toke NUM and its type */
```

The type part is an arbitrary Caml type expression,

### Operator Precedence

Use the %left, %right or %nonassoc declaration to specify token's precedence and associativity, all at once. These are called precedence declarations. See Operator Precedence, for general information on operator precedence.

The syntax of a precedence declaration is

```
%left symbols ...symbols
%right symbols ...symbols
%nonassoc symbols ...symbols
```

They specify the associativity and relative precedence for all the symbols:

The associativity of an operator op determines how repeated uses of the operator nest: whether x op y op z is parsed by grouping x with y first or by grouping y with z first. %left specifies left-associativity (grouping x with y first) and %right specifies right-associativity (grouping y with z first). %nonassoc specifies no associativity, which means that x op y op z is considered a syntax error.

The precedence of an operator determines how it nests with other operators. All the tokens declared in a single precedence declaration have equal precedence and nest together according to their associativity. When two tokens declared in different precedence declarations associate, the one declared later has the higher precedence and is grouped first.

### Nonterminal Symbols

You can declare the value type of each nonterminal symbol for which values are used. This is done with a %type declaration, like this:

```
%type <type> nonterminal ... nonterminal
```

Here nonterminal is the name of a nonterminal symbol, and type is the name of the type that you want. You can give any number of start nonterminal symbols in the same %type declaration, if they have the same value type. Use spaces to separate the symbol names.

This is necessary for start symbols. For the type part, see Token Type Names.

### The Start-Symbol

You have to declare the start symbols using %start declaration as follows:

```
%start symbol ... symbol
```

Each start symbol has a parsing function with the same name in the output file so you can use it as an entry point for the grammar. As noted eariler, type should be assinged to each start symbol using %type directive (see Nonterminal Symbols).

### Ocamlyacc Declaration Summary

Here is a summary of the declarations used to define a grammar:

- `%token`: Declare a terminal symbol (token type name) with no precedence or associativity specified (see Token Type Names).
- `%right`: Declare a terminal symbol (token type name) that is right-associative (see Operator Precedence).
- `%left`: Declare a terminal symbol (token type name) that is left-associative (see Operator Precedence).
- `%nonassoc`: Declare a terminal symbol (token type name) that is nonassociative (using it in a way that would be associative is a syntax error) (see Operator Precedence).
- `%type`: Declare the type of semantic values for a nonterminal symbol (see Nonterminal Symbols).
- `%start`: Specify the grammar's start symbol (see The Start-Symbol).
