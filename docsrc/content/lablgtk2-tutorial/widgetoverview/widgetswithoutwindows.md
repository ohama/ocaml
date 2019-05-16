---
title: "Widget without windows"
description: "The following widgets do not have an associated window."
weight: 30
---

{{% notice note %}}
The names of widgets used in this section are C version, not ocaml version.
{{% /notice %}}

The following widgets do not have an associated window. If you want to capture events, you'll have to use the EventBox. See the section on the EventBox widget.

``` ocaml
GtkAlignment
GtkArrow
GtkBin
GtkBox
GtkButton
GtkCheckButton
GtkFixed
GtkImage
GtkLabel
GtkMenuItem
GtkNotebook
GtkPaned
GtkRadioButton
GtkRange
GtkScrolledWindow
GtkSeparator
GtkTable
GtkToolbar
GtkAspectFrame
GtkFrame
GtkVBox
GtkHBox
GtkVSeparator
GtkHSeparator
```

We'll further our exploration of GTK by examining each widget in turn, creating a few simple functions to display them. Another good source is the testgtk program that comes with LablGtk. It can be found in examples/testgtk.ml.
