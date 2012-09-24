# package.el multi-file package install

# These are the variables that are specific to the package
NAME=eshell-manual
VERSION=$(shell git show | head -n1 | cut -d' ' -f2 | head -c8)
DOC="An updated manual for Eshell."

# Everything beyond here should be generic
package_parts = $(shell cat build-parts.txt)
PACKAGE=$(NAME)-$(VERSION)
TARBALL=$(PACKAGE).tar 

all: tarball

# Really would like this to clean the elc files of the package_parts
clean-elc:
	rm -f *.elc

clean: clean-elc
	rm -f eshell.info
	rm -f dir
	rm -f $(TARBALL)
	rm -rf $(PACKAGE) 
	rm -f $(NAME)-pkg.el

tarball: $(TARBALL)

$(TARBALL): $(PACKAGE) $(PACKAGE)/$(NAME)-pkg.el
	tar cf $@ $<

$(PACKAGE): $(package_parts)
	mkdir $@
	cp $(package_parts) $@

$(PACKAGE)/$(NAME)-pkg.el: $(PACKAGE)
	echo "(define-package \"$(NAME)\" \"$(VERSION)\" \"$(DOC)\")" > $@

dir: eshell.info
	install-info --dir=dir eshell.info

eshell.info:
	makeinfo -o $@ eshell.texi

# End
