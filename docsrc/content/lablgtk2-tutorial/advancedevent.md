---
title: "Advanced event and signal handling"
pre: "16. "
weight: 160
description: "Advanced event and signal handling"
---

### Signal Functions

#### Connecting and Disconnecting Signal Handlers

``` ocaml
let handler_id = [widget]#connect#[signal name] ~callback:... in

let handler_id = [widget]#event#connect#[event signal name] ~callback:... in

let handler_id = [widget]#event#connect#after#[event signal name] ~callback:... in

[widget]#misc#disconnect [handler_id];
```

#### Blocking and Unblocking Signal Handlers

``` ocaml
[widget]#misc#handler_block [handler_id];
[widget]#misc#handler_unblock [handler_id];
```

### Signal Emission and Propagation

Signal emission is the process whereby GTK runs all handlers for a specific object and signal.

First, note that the return value from a signal emission is the return value of the last handler executed. Since event signals are all of type GTK_RUN_LAST, this will be the default (GTK supplied) handler, unless you connect with event#connect#after.

The way an event (say "button_press event") is handled, is:

- Start with the widget where the event occured.

- Emit the generic "event" signal. If that signal handler returns a value of TRUE, stop all processing.

- Otherwise, emit a specific, "button_press event" signal. If that returns TRUE, stop all processing.

- Otherwise, go to the widget's parent, and repeat the above two steps.

- Continue until some signal handler returns TRUE, or until the top-level widget is reached.

Some consequences of the above are:

- Your handler's return value will have no effect if there is a default handler, unless you connect with #event#connect#after.

- To prevent the default handler from being run, you need to connect with #event#connect and use GtkSignal.emit_stop_by_name - the return value only affects whether the signal is propagated, not the current emission.
