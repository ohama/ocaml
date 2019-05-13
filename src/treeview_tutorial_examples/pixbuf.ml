(* $Id: pixbuf.ml,v 1.1 2004/09/18 00:44:44 shoh Exp $ *)
(* file: pixbuf.ml *)

let cols = new GTree.column_list
let col_name = cols#add Gobject.Data.string
let col_year_born = cols#add Gobject.Data.uint
let col_pix: GdkPixbuf.pixbuf GTree.column = cols#add Gobject.Data.gobject

let create_and_fill_model () =
  let liststore = GTree.list_store cols in

  (* Append a row, and fill it with some data *)
  let append (name, year_born, pix) =
    let row = liststore#append () in
    liststore#set ~row ~column:col_name name;
    liststore#set ~row ~column:col_year_born year_born;
    liststore#set ~row ~column:col_pix pix
  in
  List.iter append [
    ("Abel", 1963, GdkPixbuf.from_file "ellipse.xpm");
    ("Park", 1971, GdkPixbuf.from_file "curve.xpm");
    ("Lee", 1930, GdkPixbuf.from_file "rect.xpm");
  ];

  liststore

  
let create_list_and_view ~packing () =
  let liststore = create_and_fill_model () in

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

  (* Column #3 *)
  let renderer = (GTree.cell_renderer_pixbuf [], [("pixbuf", col_pix)]) in
  let col = GTree.view_column ~title:"Pixbuf" ~renderer () in
  view#append_column col;

  view

let main () =
  let window = GWindow.window ~title:"Sortable" ~border_width:10 () in
  window#connect#destroy ~callback:GMain.Main.quit;
  create_list_and_view ~packing:window#add ();
  window#show ();
  GMain.Main.main ()

let _ = Printexc.print main ()
