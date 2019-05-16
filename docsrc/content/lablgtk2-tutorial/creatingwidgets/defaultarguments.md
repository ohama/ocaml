---
title: "Default arguments"
description: "For many constructor or method arguments, default values are provided."
weight: 10
---

For many constructor or method arguments, default values are provided.
Generally, this default value is defined by GTK, and you must refer to GTK's documentation.

For ML defined defaults, usually default values are either false, 0, None or `NONE, according to the expected type.

Important exceptions are ~show, which default to true in all widgets except those in GWindow, and ~fill, which defaults to true or `BOTH.
