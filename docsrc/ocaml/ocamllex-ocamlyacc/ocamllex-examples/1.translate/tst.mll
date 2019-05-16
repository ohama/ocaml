{ }

rule translate = parse
  | "current_directory"	{ print_string (Sys.getcwd ()) }
  | _ as c		{ print_char c }
  | eof			{ exit 0 }

{
  let main () =
    let lexbuf = Lexing.from_channel stdin in
    while true do
      translate lexbuf
    done

  let _ = Printexc.print main ()
}
