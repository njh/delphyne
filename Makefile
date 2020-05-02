INSTALL ?= install
DESTDIR ?= /usr/local

SHELL_FILES = delphyne test/*.sh

test:
	$(MAKE) -C test test
	shellcheck --shell=bash $(SHELL_FILES)

install:
	$(INSTALL) -d -m 755 $(DESTDIR)/bin
	$(INSTALL) -m 755 delphyne $(DESTDIR)/bin

.PHONY: test install
