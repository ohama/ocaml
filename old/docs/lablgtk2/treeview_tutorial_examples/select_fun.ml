(* $Id: select_fun.ml,v 1.1 2004/09/18 00:44:44 shoh Exp $ *)
(* file: select_fun.ml *)

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

let view_selection_func (model:#GTree.model) path currently_selected =
  let row = model#get_iter path in
  let name = model#get ~row ~column:col_name in
  if not currently_selected
  then Printf.printf "%s is going to be selected.\n" name
  else Printf.printf "%s is going to be unselected.\n" name;
  flush stdout;
  true (* allow selection state to change *)

let create_view ~model ~packing () =
  let view = GTree.view ~model ~packing () in
  let col = GTree.view_column ~title:"Name"
      ~renderer:(GTree.cell_renderer_text [], ["text", col_name]) () in
  view#append_column col;
  let col = GTree.view_column ~title:"Age"
      ~renderer:(GTree.cell_renderer_text [], ["text", col_age]) () in
  view#append_column col;
  view#selection#set_select_function (view_selection_func model);
  view

let data = [("Kim YooSin", 51); ("King Sejong", 23);
  ("Kim Goo", 91); ("Jang Young Sil", 44)]

let main () =
  let model = create_model data in
  let window = GWindow.window ~title:"Treeview" ~border_width:10 () in
  window#connect#destroy ~callback:GMain.Main.quit;
  let view = create_view ~model ~packing:window#add () in
  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
