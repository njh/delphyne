INSTALL ?= install
DESTDIR ?= /usr/local

PACKAGE = delphyne
VERSION = $(shell ./delphyne version | grep 'Delphyne version' | awk '{print $$NF}')
SHELL_FILES = delphyne test/*.sh

test:
	$(MAKE) -C test test
	shellcheck --shell=bash $(SHELL_FILES)

install:
	$(INSTALL) -d -m 755 $(DESTDIR)/bin
	$(INSTALL) -m 755 delphyne $(DESTDIR)/bin

dist:
	distdir='$(PACKAGE)-$(VERSION)'; mkdir "$$distdir" || exit 1; \
	for file in $(git ls-files); do \
	  dirname="$$distdir/$$(dirname "$$file")"; \
	  [ -d "$$dirname" ] || mkdir "$$dirname" || exit 1; \
	  cp -pR "$$file" "$$distdir/$$file" || exit 1; \
	done; \
	tar -zcf $$distdir.tar.gz $$distdir; \
	rm -fr $$distdir

.PHONY: test install dist
