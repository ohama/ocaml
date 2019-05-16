---
title: "Widget overview"
pre: "5. "
description: "The general steps to creating a widget in GTK are ..."
weight: 50
---

The general steps to creating a widget in GTK are:

1. Creation - one of various functions to create a new widget. The returned widget is an object and you can use it to get/set values or do something. These are all detailed in this section.

1. Set the attributes of the widget. This can be done on widget creation.

1. Pack the widget into a container using the appropriate call such as add or pack method. This can be done on widget creation.

1. Connect all signals and events we wish to use to the appropriate handlers.

1. If it is toplevel window, show() the widget. Except toplevel window, show is default.

show method lets GTK know that we are done setting the attributes of the widget, and it is ready to be displayed. You may also use hide metehod to make it disappear again. The order in which you show the widgets is not important, but I suggest showing the window last so the whole window pops up at once rather than seeing the individual widgets come up on the screen as they're formed. The children of a widget (a window is a widget too) will not be displayed until the window itself is shown using the show() method.

{{% children style="h3" description="true" %}}
