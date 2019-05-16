---
title: "Structure of widgets"
description: "Structure of widgets"
weight: 40
---

The following modules provide classes to wrap the raw Gtk+ function calls. Here are the widget classes contained in each module:

- GPango: Pango font handling
- Gdk: pixmaps, etc...
- GObj: gtkobj, widget, style
- GData: data, adjustment, tooltips
- GContainer: container, item_container
- GWindow: window, dialog, color_selection_dialog, file_selection, plug
- GPack: box, button_box, table, fixed, layout, packer, paned, notebook
- GBin: scrolled_window, event_box, handle_box, frame, aspect_frame, viewport, socket
- GButton: button, toggle_button, check_button, radio_button, toolbar
- GMenu: menu_item, tearoff_item, check_menu_item, radio_menu_item, menu_shell, menu, option_menu, menu_bar, factory
- GMisc: separator, statusbar, calendar, drawing_area, misc, arrow, image, pixmap, label, tips_query, color_selection, font_selection
- GTree: tree_item, tree, view (also tree/list_store, model)
- GList: list_item, liste, clist
- GEdit: editable, entry, spin_button, combo
- GRange: progress, progress_bar, range, scale, scrollbar
- GText: view (also buffer, iter, mark, tag, tagtable)

Practically, each widget class is composed of:

- coerce method, returning the object coerced to the type widget.
- as_widget method, returning the raw Gtk widget used for packing, etc...
- destroy method, sending the destroy signal to the object.
- get_oid method, the equivalent of Oo.id for Gtk objects.
- connect sub-object, allowing one to widget specific signals (this is what prevents width subtyping in subclasses.)
- misc sub-object, giving access to miscellanous functionality of the basic gtkwidget class, and a misc#connect sub-object.
- event sub-object, for Xevent related functions (only if the widget has an Xwindow), and an event#connect sub-object.
- drag sub-object, containing drag and drop functions, and a drag#connect sub-object.
- widget specific methods.

Here is a diagram of the structure (- for methods, + for sub-objects)

``` ocaml
        - coerce : widget
        - as_widget : Gtk.widget obj
        - destroy : unit -> unit
        - get_oid : int
        - ...
        + connect : mywidget_signals
        |   - after
        |   - signal_name : callback:(... -> ...) -> GtkSignal.id
        + misc : misc_ops
        |   - show, hide, disconnect, ...
        |   + connect : misc_signals
        + drag : drag_ops
        |   - ...
        |   + connect : drag_signals
        + event : event_ops
        |   - add, ...
        |   + connect : event_signals
```
