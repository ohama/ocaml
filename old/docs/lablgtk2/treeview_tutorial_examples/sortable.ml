(* $Id: sortable.ml,v 1.1 2004/09/18 00:44:44 shoh Exp $ *)
(* file: sortable.ml *)

open GTree

let cols = new GTree.column_list
let col_name = cols#add Gobject.Data.string
let col_year_born = cols#add Gobject.Data.uint

let create_and_fill_model () =
  let liststore = GTree.list_store cols in

  (* Append a row, and fill it with some data *)
  let append (name, year_born) =
    let row = liststore#append () in
    liststore#set ~row ~column:col_name name;
    liststore#set ~row ~column:col_year_born year_born
  in
  List.iter append [
    ("Abel", 1963);
    ("Park", 1971);
    ("Lee", 1930);
  ];

  liststore

let compare a b =
  if a < b then -1
  else if a > b then 1
  else 0

let sort_by_name (model:#GTree.model) row1 row2 =
  let name1 = model#get ~row:row1 ~column:col_name in
  let name2 = model#get ~row:row2 ~column:col_name in
  compare name1 name2

let sort_by_year_born (model:#GTree.model) row1 row2 =
  let year1 = model#get ~row:row1 ~column:col_year_born in
  let year2 = model#get ~row:row2 ~column:col_year_born in
  compare year1 year2
  
let create_list_and_view ~packing () =
  let liststore = create_and_fill_model () in

  liststore#set_sort_func col_name.index sort_by_name;
  liststore#set_sort_func col_year_born.index sort_by_year_born;

  (* set initial sort order *)
  liststore#set_sort_column_id col_name.index `ASCENDING;

  let view = GTree.view ~model:liststore ~packing () in

  let renderer_text = GTree.cell_renderer_text [] in
  (* create tree view column and pack cell renderer into tree view column *)
  let col = GTree.view_column ~title:"Name"
      ~renderer:(renderer_text, [("text", col_name)]) () in
  (* pack tree view column into tree view *)
  view#append_column col;

  (* Column #2 *)
  let renderer_text = GTree.cell_renderer_text [] in
  (* create tree view column and pack cell renderer into tree view column *)
  let col = GTree.view_column ~title:"Year Born"
      ~renderer:(renderer_text, [("text", col_year_born)]) () in
  (* pack tree view column into tree view *)
  view#append_column col;

  view

let main () =
  let window = GWindow.window ~title:"Sortable" ~border_width:10 () in
  window#connect#destroy ~callback:GMain.Main.quit;
  create_list_and_view ~packing:window#add ();
  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
