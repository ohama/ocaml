TARGET = rpcalc

rpcalc: lexer.cmo rpcalc.cmo main.cmo
	ocamlc -o $@ lexer.cmo rpcalc.cmo main.cmo

depend:
	ocamldep *.ml *.mli > .depend

lex.ml: parser.cmi

clean:
	rm -rf *.cmi *.cmo $(TARGET)
	rm -rf rpcalc.ml rpcalc.mli lexer.ml lexer.mli

.SUFFIXES: .ml .mli .mll .mly .cmo .cmi

.ml.cmo:
	ocamlc -c $<
.mli.cmi:
	ocamlc -c $<
.mll.ml:
	ocamllex $<
.mly.ml:
	ocamlyacc $<
.mly.mli:
	ocamlyacc $<

include .depend
