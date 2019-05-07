(* $Id: name_born.ml,v 1.1 2004/09/18 00:44:44 shoh Exp $ *)
(* file: name_born.ml *)

open Gobject.Data

let cols = new GTree.column_list
let col_first_name = cols#add string
let col_last_name = cols#add string
let col_year_born = cols#add uint

let create_and_fill_model data =
  let treestore = GTree.tree_store cols in
  let append (first_name, last_name, born) =
    let toplevel = treestore#append () in
    treestore#set ~row:toplevel ~column:col_first_name first_name;
    treestore#set ~row:toplevel ~column:col_last_name last_name;
    if born > 0
    then treestore#set ~row:toplevel ~column:col_year_born born
  in
  List.iter append [
    ("Maria", "Incognito", 0);
    ("Jane", "Average", 1962);
    ("Janinita", "Average", 1985)
  ];
  treestore

let age_cell_data_func renderer (model:GTree.model) iter =
  let year_now = 2004 in
  let year_born = model#get ~row:iter ~column:col_year_born in
  if year_born <= year_now && year_born > 0
  then (
    let age = year_now - year_born in
    renderer#set_properties [
      `TEXT (Printf.sprintf "%u years old" age);
      `FOREGROUND_SET false
    ]
  ) else (
    renderer#set_properties [
      `TEXT "age unknown";
      `FOREGROUND "Red";
      `FOREGROUND_SET true;
    ]
  )
  
let create_view_and_model ~packing () =
  let view = GTree.view ~packing () in

  (* Column #1 *)
  (* pack cell renderer into tree view column *)
  (* connect 'text' property of the cell renderer to
   * model column that contains the first name *)
  let col = GTree.view_column ~title:"First Name"
      ~renderer:(GTree.cell_renderer_text [], ["text", col_first_name]) () in
  (* pack tree view column into tree view *)
  view#append_column col;

  (* Column #2 *)
  (* create cell_renderer and set 'weight' property of it to
   * bold print (we want all last name in bold) *)
  let cell_renderer = GTree.cell_renderer_text [`WEIGHT `BOLD] in
  (* pack cell renderer into tree view column *)
  (* connect 'text' property of the cell renderer to
   * model column that contains the last name *)
  let col = GTree.view_column ~title:"Last Name"
      ~renderer:(cell_renderer, ["text", col_last_name]) () in
  (* pack tree view column into tree view *)
  view#append_column col;

  let renderer = GTree.cell_renderer_text [] in
  (* pack cell renderer into tree view column *)
  let col = GTree.view_column ~title:"Age"
      ~renderer:(renderer, []) () in
  (* connect a cell data function *)
  col#set_cell_data_func renderer (age_cell_data_func renderer);
  (* pack tree view column into tree view *)
  view#append_column col;

  let model = create_and_fill_model () in
  view#set_model (Some (model#coerce));

  view#selection#set_mode `NONE;
  view

let main () =
  let window = GWindow.window ~title:"Treeview" ~border_width:10 () in
  window#connect#destroy ~callback:GMain.Main.quit;
  let view = create_view_and_model ~packing:window#add () in
  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
