OCAMLLEX_XML = tutorial/ocamllex-tutorial.xml
OCAMLYACC_XML = tutorial/ocamlyacc-tutorial.xml
NEW_HOME = "https://ohama.github.io/NEW_HOME"

all: ocamllex ocamlyacc

ocamllex:
	db2html $(OCAMLLEX_XML) -o ocamllex-tutorial
	db2pdf $(OCAMLLEX_XML)

ocamlyacc:
	db2html $(OCAMLYACC_XML) -o ocamlyacc-tutorial
	db2pdf $(OCAMLYACC_XML)

test:
	sed -i -e "s@OCAMLLEX_HOME@$(NEW_HOME)@" test.xml
clean:
	rm -rf ocamllex-tutorial
	rm -f ocamllex-tutorial.pdf
	rm -rf ocamlyacc-tutorial
	rm -f ocamlyacc-tutorial.pdf
