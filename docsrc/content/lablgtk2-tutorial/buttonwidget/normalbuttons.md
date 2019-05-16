---
title: "Normal buttons"
description: "For many constructor or method arguments, default values are provided."
weight: 10
---

We've almost seen all there is to see of the button widget. It's pretty simple. There is however more than one way to create a button. You can use the GButton.button function with ~label or ~mnemonic option to create a button with a label, use ~stock option to create a button containing the image and text from a stock item or use it without these options to create a blank button. It's then up to you to pack a label or pixmap into this new button. To do this, create a new box which is packed into button using #add method, and then pack your objects into this box using the usual #pack method.

Here's an example of using GButton.button to create a button with a image and a label in it. I've broken up the code to create a box from the rest so you can use it in your programs. There are further examples of using images later in the tutorial.

![normalbutton](../normalbutton.jpg)

``` ocaml
(* file: button.ml *)

open GMain

(* Create a new hbox with an image and a label packed into it
 * and pack the box *)
let xpm_label_box ~file ~text ~packing () =
  if not (Sys.file_exists file) then failwith (file ^ " does not exist");

  (* Create box for image and label and pack *)
  let box = GPack.hbox ~border_width:2 ~packing () in

  (* Now on to the image stuff and pack into box *)
  let pixmap = GDraw.pixmap_from_xpm ~file () in
  GMisc.pixmap pixmap ~packing:(box#pack ~padding:3) ();

  (* Create a label for the button and pack into box *)
  GMisc.label ~text ~packing:(box#pack ~padding:3) ()

let main () =
  (* Create a new window; set title and border_width *)
  let window = GWindow.window ~title:"Pixmap'd Buttons!" ~border_width:10 () in

  (* It's a good idea to do this for all windows. *)
  window#connect#destroy ~callback:Main.quit;
  window#event#connect#delete ~callback:(fun _ -> Main.quit (); true);

  (* Create a new button and pack *)
  let button = GButton.button ~packing:window#add () in

  (* Connect the "clicked" signal of the button to callback *)
  button#connect#clicked ~callback:
    (fun () -> print_endline "Hello again - cool button was pressed");

  (* Create box with xpm and label and pack into button *)
  xpm_label_box ~file:"info.xpm" ~text:"cool button" ~packing:button#add ();

  (* Show the window and wait for the fun to begin! *)
  window#show ();
  Main.main ()

let _ = main ()
```

The xpm_label_box() function could be used to pack images and labels into any widget that can be a container.

The Button widget has the following signals; see GButton.button_signals:

- pressed - emitted when pointer button is pressed within Button widget
- released - emitted when pointer button is released within Button widget
- clicked - emitted when pointer button is pressed and then released within Button widget
- enter - emitted when pointer enters Button widget
- leave - emitted when pointer leaves Button widget
