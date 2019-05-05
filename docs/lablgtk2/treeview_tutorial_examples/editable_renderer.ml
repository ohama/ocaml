(* $Id: editable_renderer.ml,v 1.2 2004/09/18 00:52:26 shoh Exp shoh $ *)
(* file: editable_renderer.ml *)

open Gobject.Data
open GTree

let cols = new GTree.column_list
let col_name = cols#add string
let col_age = cols#add int

let create_model data =
  let store = GTree.tree_store cols in
  let append (name, age) =
    let row = store#append () in
    store#set ~row ~column:col_name name;
    store#set ~row ~column:col_age age;
  in
  List.iter append data;
  store

let cell_edited_callback index path string =
  if index = col_name.index
  then (
    Printf.printf "col_name edited\n"
  ) else (
    (* index = col_age.index *) 
    Printf.printf "col_age edited\n"
  );
  flush stdout

let create_view ~packing () =
  let view = GTree.view ~packing () in

  let renderer = GTree.cell_renderer_text [`EDITABLE true] in
  renderer#connect#edited ~callback:(cell_edited_callback col_name.index);
  let col = GTree.view_column ~title:"Name"
      ~renderer:(renderer, ["text", col_name]) () in
  view#append_column col;

  let renderer = GTree.cell_renderer_text [`EDITABLE true] in
  renderer#connect#edited ~callback:(cell_edited_callback col_age.index);
  let col = GTree.view_column ~title:"Age"
      ~renderer:(renderer, ["text", col_age]) () in
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
