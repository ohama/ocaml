---
title: "Stepping throught hello world"
description : "Now that we know the theory behind this, let's clarify by walking through the example helloworld program."
weight: 50
---

Now that we know the theory behind this, let's clarify by walking through the example helloworld program.

Here is the callback function that will be called when the button is "clicked". We ignore both the widget and the data in this example, but it is not hard to do things with them. The next example will use the data argument to tell us which button was pressed.

``` ocaml
let hello () =
  print_endline "Hello World";
  flush stdout
```

The next callback is a bit special. The "delete_event" occurs when the window manager sends this event to the application. We have a choice here as to what to do about these events. We can ignore them, make some sort of response, or simply quit the application.

The value you return in this callback lets GTK know what action to take. By returning true, we let it know that we don't want to have the "destroy" signal emitted, keeping our application running. By returning false, we ask that "destroy" be emitted, which in turn will call our "destroy" signal handler.

``` ocaml
let delete_event ev =
  print_endline "Delete event occurred";
  flush stdout;
  true
```

Here is another callback function which causes the program to quit by calling GMain.Main.quit (). This function tells GTK that it is to exit from GMain.Main.main when control is returned to it.

``` ocaml
let destroy () = GMain.Main.quit ()
```
In "C" language, you have to use "main" for starting function name, but in "Ocaml", you don't have to. You may use any name for a fuction, and we'll tell the system the name of the starting point. In this example, we'll use "main" for the name of ther starting function.

``` ocaml
let main () =
```
Create a new window using GWindow.window. This is fairly straightforward. Memory is allocated for the GtkWidget *window structure so it now points to a valid structure. It sets up a new window, but it is not displayed until we call window#show () near the end of our program.

``` ocaml
  let window = GWindow.window ~border_width:10 () in
```
This ~border_width option is used to set an attribute of a container object. This just sets the window so it has a blank area along the inside of it 10 pixels wide where no widgets will go. There are other similar functions which we will look at in the section on Setting Widget Attributes

Here are two examples of connecting a signal handler to an object, in this case, the window. Here, the "delete_event" and "destroy" signals are caught. The first is emitted when we use the window manager to kill the window, or when we use the window#destroy () call passing in the window widget as the object to destroy. The second is emitted when, in the "delete_event" handler, we return false. The G_OBJECT and G_CALLBACK are macros that perform type casting and checking for us, as well as aid the readability of the code.

``` ocaml
  window#event#connect#delete ~callback:delete_event;
  window#connect#destroy ~callback:destroy;
```
This call creates a new button. It allocates space for a new GtkWidget structure in memory, initializes it, and makes the button pointer point to it. It will have the label "Hello World" on it when displayed.

``` ocaml
  let button = GButton.button ~label:"Hello World" ~packing:window#add () in
```
There is a ~packing option, which will be explained in depth later on in Packing Widgets. But it is fairly easy to understand. It simply tells GTK that the button is to be placed in the window where it will be displayed. Note that a GTK container can only contain one widget. There are other widgets, that are described later, which are designed to layout multiple widgets in various ways.

Here, we take this button, and make it do something useful. We attach a signal handler to it so when it emits the "clicked" signal, our hello() function is called. Obviously, the "clicked" signal is emitted when we click the button with our mouse pointer.

``` ocaml
  button#connect#clicked ~callback:hello;
```
We are also going to use this button to exit our program. This will illustrate how the "destroy" signal may come from either the window manager, or our program. When the button is "clicked", same as above, it calls the first hello() callback function, and then this one in the order they are set up. You may have as many callback functions as you need, and all will be executed in the order you connected them.

``` ocaml
  button#connect#clicked ~callback:window#destroy;
```
Now we have everything set up the way we want it to be. With all the signal handlers in place, and the button placed in the window where it should be, we ask GTK to "show" the widgets on the screen. All widgets are "shown" by default except window widget. The window widget is shown last so the whole window will pop up at once rather than seeing the window pop up, and then the button form inside of it. Although with such a simple example, you'd never notice.

``` ocaml
  window#show ();
  GMain.Main.main ()
```
And of course, we call GMain.Main.main () which waits for events to come from the X server/Window and will call on the widgets to emit signals when these events come.

``` ocaml
  GMain.Main.main ()
```
And for the final thing, we should tell the system how to do this application. On executing the following line, the function named "main" will be called.

``` ocaml
let _ = main ()
```
or, if you want to see error message which is raised on evaluating main () functon:

``` ocaml
let _ = Printexc.print main ()
```
Now, when we click the mouse button on a GTK button, the widget emits a "clicked" signal. In order for us to use this information, our program sets up a signal handler to catch that signal, which dispatches the function of our choice. In our example, when the button we created is "clicked", the hello() function is called , and then the next handler for this signal is called. This calls the window#destroy () function, destroying the window widget. This causes the window to emit the "destroy" signal, which is caught, and calls our destroy() callback function, which simply exits GTK.

Another course of events is to use the window manager to kill the window, which will cause the "delete_event" to be emitted. This will call our "delete_event" handler. If we return true here, the window will be left as is and nothing will happen. Returning false will cause GTK to emit the "destroy" signal which of course calls the "destroy" callback, exiting GTK.


