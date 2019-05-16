(* $Id: popup.ml,v 1.1 2004/09/18 00:44:44 shoh Exp $ *)
(* file: popup.ml *)

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

let on_doSomething treeview () =
  Printf.printf "Do something!\n";
  flush stdout

let view_popup_menu treeview ev =
  let menu = GMenu.menu () in
  let menuitem = GMenu.menu_item ~label:"Do something" ~packing:menu#append () in
  menuitem#connect#activate ~callback:(on_doSomething treeview);
  menu#popup ~button:(GdkEvent.Button.button ev) ~time:(GdkEvent.Button.time ev)

let on_button_pressed treeview ev =
  if GdkEvent.Button.button ev = 3 then (
    Printf.printf "Single right click on the tree view.\n";

    (* optional: select row if no row is selected or only
     *  one other row is selected (will only do something
     *  if you set a tree selection mode as described later
     *  in the tutorial) *)

    if true then begin
      let selection = treeview#selection in

      (* Note: gtk_tree_selection_count_selected_rows() does not
       *   exist in gtk+-2.0, only in gtk+ >= v2.2 ! *)
      if selection#count_selected_rows <= 1 then (
    	let x = int_of_float (GdkEvent.Button.x ev) in
    	let y = int_of_float (GdkEvent.Button.y ev) in
        let Some (path, _, _, _) = treeview#get_path_at_pos ~x ~y in
    	selection#unselect_all ();
    	selection#select_path path
      )
    end; (* end of optional bit *)

    view_popup_menu treeview ev;
    true (* we handled this *)
  ) else
    false (* we did not handle this *)
  
let create_view ~packing () =
  let view = GTree.view ~packing () in
  let col = GTree.view_column ~title:"Name"
      ~renderer:(GTree.cell_renderer_text [], ["text", col_name]) () in
  view#append_column col;
  let col = GTree.view_column ~title:"Age"
      ~renderer:(GTree.cell_renderer_text [], ["text", col_age]) () in
  view#append_column col;
  view#event#connect#button_press ~callback:(on_button_pressed view);
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
