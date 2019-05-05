TARGET = ltcalc

ltcalc: lexer.cmo ltcalc.cmo main.cmo
	ocamlc -o $@ lexer.cmo ltcalc.cmo main.cmo

depend:
	ocamldep *.ml *.mli > .depend

clean:
	rm -rf *.cmi *.cmo $(TARGET)
	rm -rf ltcalc.ml ltcalc.mli lexer.ml lexer.mli

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
