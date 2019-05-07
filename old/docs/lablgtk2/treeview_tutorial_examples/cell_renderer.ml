(* $Id: cell_renderer.ml,v 1.1 2004/09/18 00:44:44 shoh Exp $ *)
(* file: cell_renderer.ml *)

open Gobject.Data

let cols = new GTree.column_list
let col_first_name = cols#add string
let col_last_name = cols#add string

let create_and_fill_model () =
  let treestore = GTree.tree_store cols in

  (* Append a top level row and leave it empty *)
  let toplevel = treestore#append () in

  (* Append a second top level row, and fill it with some data *)
  let toplevel = treestore#append () in
  treestore#set ~row:toplevel ~column:col_first_name "Joe";
  treestore#set ~row:toplevel ~column:col_last_name "Average";

  (* Append a child to the second top level row, and fill in some data *)
  let child = treestore#append ~parent:toplevel () in
  treestore#set ~row:child ~column:col_first_name "Jane";
  treestore#set ~row:child ~column:col_last_name "Average";

  treestore

let create_view_and_model ~packing () =
  let view = GTree.view ~packing () in

  (* Column #1 *)
  (* create text cell renderer
     and `TEXT property of the cell renderer *)
  let renderer_text = GTree.cell_renderer_text [`TEXT "Boooo!"] in
  (* create tree view column and pack cell renderer into tree view column *)
  let col = GTree.view_column ~title:"First Name"
      ~renderer:(renderer_text, []) () in
  (* pack tree view column into tree view *)
  view#append_column col;

  (* Column #2 *)
  (* create text cell renderer
     and set `BACKGROUND property of the cell renderer *)
  let renderer_text = GTree.cell_renderer_text [
    `BACKGROUND "Orange";
    `BACKGROUND_SET true
  ] in
  (* create tree view column and pack cell renderer into tree view column *)
  let col = GTree.view_column ~title:"Last Name" ()
      ~renderer:(renderer_text, []) in
  (* pack tree view column into tree view *)
  view#append_column col;

  let model = create_and_fill_model () in
  view#set_model (Some (model#coerce));
  view#selection#set_mode `NONE;

  view

let main () =
  let window = GWindow.window ~title:"Name" ~border_width:10 () in
  window#connect#destroy ~callback:GMain.Main.quit;
  create_view_and_model ~packing:window#add ();
  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
