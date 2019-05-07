(* $Id: helloworld.ml,v 1.1 2004/09/18 00:52:26 shoh Exp shoh $ *)
(* file: helloworld.ml *)
(* Compile with:
	ocamlc -I +lablgtk2 -o helloworld lablgtk.cma gtkInit.cmo helloworld.ml
*)

open Gobject.Data

let cols = new GTree.column_list
let col_name = cols#add string	(* string column *)
let col_age = cols#add int	(* int column *)

let create_model () =
  let data = [("Heinz El-Mann", 51); ("Jane Doe", 23); ("Joe Bungop", 91)] in
  let store = GTree.list_store cols in
  let fill (name, age) =
    let iter = store#append () in
    store#set ~row:iter ~column:col_name name;
    store#set ~row:iter ~column:col_age age
  in
  List.iter fill data;
  store

let create_view ~model ~packing () =
  let view = GTree.view ~model ~packing () in

  (* Column #1: col_name is string column *)
  let col = GTree.view_column ~title:"Name"
      ~renderer:(GTree.cell_renderer_text [], ["text", col_name]) () in
  ignore (view#append_column col);

  (* Column #2: col_age is int column *)
  let col = GTree.view_column ~title:"Age"
      ~renderer:(GTree.cell_renderer_text [], ["text", col_age]) () in
  ignore (view#append_column col);

  view

let main () =
  let window = GWindow.window ~title:"GTree Demo" () in
  window#connect#destroy ~callback:GMain.Main.quit;
  let model = create_model () in
  create_view ~model ~packing:window#add ();
  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
