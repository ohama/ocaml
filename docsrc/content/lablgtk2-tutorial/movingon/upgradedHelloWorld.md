---
title: "Upgraded hello world"
description: "A slightly improved helloworld with better examples of callbacks."
weight: 20
---

Let's take a look at a slightly improved helloworld with better examples of callbacks. This will also introduce us to our next topic, packing widgets.

![hello2.jpg](../files/hello2.jpg)

``` ocaml
(* file: hello2.ml *)

let clicked msg () =
  print_endline msg;
  flush stdout

let delete_event ev =
 GMain.Main.quit ();
 false

let main () =
  (* Create a new window and sets the border width and title of the window. *)
  let window = GWindow.window ~title:"Hello Buttons!" ~border_width:10 () in

  (* Here we just set a handler for delete_event that immediately
   * exits GTK. *)
  window#event#connect#delete ~callback:delete_event;

  (* We create a box to pack widgets into.  This is described in detail
   * in the "packing" section. The box is not really visible, it
   * is just used as a tool to arrange widgets.
   * And put the box into the main window. *)
  let box1 = GPack.hbox ~packing:window#add () in

  (* Creates a new button with the label "Button 1".
   * Instead of box1#add, we pack this button into the invisible
   * box, which has been packed into the window. *)
  let button = GButton.button ~label:"Button 1" ~packing:box1#pack () in
    
  (* Now when the button is clicked, we call the "clicked" function
   * with "button 1" as its argument *)
  button#connect#clicked ~callback:(clicked "button 1");

  (* Do these same steps again to create a second button *)
  let button = GButton.button ~label:"Button 2" ~packing:box1#pack () in

  (* Call the same callback function with a different argument,
   * passing "button 2" instead. *)
  button#connect#clicked ~callback:(clicked "button 2");

  (* Display the window. *)
  window#show ();

  (* Rest in GMain.Main.main and wait for the fun to begin! *)
  GMain.Main.main ()

let _ = main ()
```

Compile this program using the same linking arguments as our first example. You'll notice this time there is no easy way to exit the program, you have to use your window manager or command line to kill it. A good exercise for the reader would be to insert a third "Quit" button that will exit the program. You may also wish to play with the options to box#pack () while reading the next section. Try resizing the window, and observe the behavior.
