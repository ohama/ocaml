all:
	cd docsrc; hugo
	rm -rf docs
	cp -a docsrc/docs .
	touch ./docs/.nojekyll
