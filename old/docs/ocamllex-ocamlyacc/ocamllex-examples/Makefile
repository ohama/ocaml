TAR_FILE = ocamllex_example.tar.gz
INSTALL_DIR = $(HOME)/www/ocaml/ocamllex_ocamlyacc

tar:
	cd ..; \
	tar cvf - ocamllex_example | gzip -c > $(TAR_FILE)

install: ../$(TAR_FILE)
	cp ../$(TAR_FILE) $(INSTALL_DIR)
