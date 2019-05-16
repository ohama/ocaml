---
title: "Creating Widgets"
pre: "6. "
weight: 60
description: "You create a widget by ..."
---

You create a widget by

``` ocaml
  [Module].[widget name] options ... ()
```

Many optional arguments are admitted. The last two of them, packing: and show:, allow you respectively to call a function on your newly created widget, and to decide wether to show it immediately or not. By default all widgets except toplevel windows (GWindow module) are shown immediately.

{{% children style="h3" description="true" %}}
