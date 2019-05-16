---
title: "Menu widgets"
pre: "12. "
weight: 120
description: "There are two ways to create menus: there's the easy way, and there's the hard way. Both have their uses, but you can usually use the Itemfactory (the easy way)."
---

There are two ways to create menus: there's the easy way, and there's the hard way. Both have their uses, but you can usually use the Itemfactory (the easy way).
The "hard" way is to create all the menus using the calls directly. The easy way is to use the gtk_item_factory calls. This is much simpler, but there are advantages and disadvantages to each approach.

The Itemfactory is much easier to use, and to add new menus to, although writing a few wrapper functions to create menus using the manual method could go a long way towards usability. With the Itemfactory, it is not possible to add images or the character '/' to the menus.

{{% children style="h3" description="true" %}}

