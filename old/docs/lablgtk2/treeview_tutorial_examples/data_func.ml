(* $Id: data_func.ml,v 1.1 2004/09/18 00:44:44 shoh Exp $ *)
(* file: data_func.ml *)

open Gobject.Data

let cols = new GTree.column_list
let col_name = cols#add string
let col_age = cols#add float

let create_model data =
  let store = GTree.tree_store cols in
  let append (name, age) =
    let row = store#append () in
    store#set ~row ~column:col_name name;
    store#set ~row ~column:col_age age;
  in
  List.iter append data;
  store

let age_cell_data_func renderer (model:GTree.model) iter =
  let age = model#get ~row:iter ~column:col_age in
  renderer#set_properties [`TEXT (Printf.sprintf "%.1f" age)]
  
let create_view ~model ~packing () =
  let view = GTree.view ~model ~packing () in
  let col = GTree.view_column ~title:"Name"
      ~renderer:(GTree.cell_renderer_text [], ["text", col_name]) () in
  view#append_column col;

  let renderer_text = GTree.cell_renderer_text [] in
  let col = GTree.view_column ~title:"Age" ~renderer:(renderer_text, []) () in
  col#set_cell_data_func renderer_text (age_cell_data_func renderer_text);
  view#append_column col;
  view

let data = [("Kim YooSin", 51.0); ("King Sejong", 23.7);
  ("Kim Goo", 91.3); ("Jang Young Sil", 44.8)]

let main () =
  let model = create_model data in
  let window = GWindow.window ~title:"Treeview" ~border_width:10 () in
  window#connect#destroy ~callback:GMain.Main.quit;
  let view = create_view ~model ~packing:window#add () in
  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
