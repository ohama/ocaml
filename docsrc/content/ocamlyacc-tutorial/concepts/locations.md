---
title: "Locations"
description: "Locations in order to keep track of the textual position, or location, of each syntactic construct."
weight: 50
---

Many applications, like interpreters or compilers, have to produce verbose and useful error messages. To achieve this, one must be able to keep track of the textual position, or location, of each syntactic construct. Ocamlyacc provides a mechanism for handling these locations.

Each token has a semantic value. In a similar fashion, each token has an associated location, but the type of locations is the same for all tokens and groupings. Moreover, the output parser is equipped with a data structure for storing locations (see Locations, for more details).

Like semantic values, locations can be reached in actions using functions of the Parsing module.

