(* $Id: age.ml,v 1.1 2004/09/18 00:44:44 shoh Exp $ *)
(* file: age.ml *)

let cols = new GTree.column_list
let col_name = cols#add Gobject.Data.string
let col_age = cols#add Gobject.Data.int

let create_model data =
  let store = GTree.tree_store cols in
  let append (name, age) =
    let row = store#append () in
    store#set ~row ~column:col_name name;
    store#set ~row ~column:col_age age;
  in
  List.iter append data;
  store

let create_view ~packing () =
  let view = GTree.view ~packing () in
  let col = GTree.view_column ~title:"Name"
      ~renderer:(GTree.cell_renderer_text [], ["text", col_name]) () in
  view#append_column col;
  let col = GTree.view_column ~title:"Age"
      ~renderer:(GTree.cell_renderer_text [], ["text", col_age]) () in
  view#append_column col;
  view

let data = [("Kim YooSin", 51); ("King Sejong", 23);
  ("Kim Goo", 91); ("Jang Young Sil", 44)]

let main () =
  let model = create_model data in
  let window = GWindow.window ~title:"Treeview" ~border_width:10 () in
  window#connect#destroy ~callback:GMain.Main.quit;
  let view = create_view ~packing:window#add () in
  view#set_model (Some (model#coerce));
  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
