# package.el multi-file package install

# These are the variables that are specific to the package
NAME=eshell-manual
VERSION=20141024
DOC="An manual for Eshell."

package_parts = $(shell cat build-parts.txt)
PACKAGE=$(NAME)-$(VERSION)
TARBALL=$(PACKAGE).tar 

all: tarball

# Really would like this to clean the elc files of the package_parts
clean-elc:
	rm -f *.elc

clean: clean-elc
	rm -rf dist
	rm -f eshell.info
	rm -f dir
	rm -f $(TARBALL)
	rm -rf $(PACKAGE) 
	rm -f $(NAME)-pkg.el

dist:
	mkdir dist
	cp eshell-manual.el dist

tarball: dist $(TARBALL)

$(TARBALL): $(PACKAGE) $(PACKAGE)/$(NAME)-pkg.el
	tar cf $@ $<

$(PACKAGE): $(package_parts)
	mkdir -p $@
	cp $(package_parts) $@

$(PACKAGE)/$(NAME)-pkg.el: $(PACKAGE)
	echo "(define-package \"$(NAME)\" \"$(VERSION)\" \"$(DOC)\")" > $@

dist/dir: dist/eshell.info
	install-info --dir=dist/dir dist/eshell.info

dist/eshell.info:
	makeinfo -o $@ eshell.texi

# End
