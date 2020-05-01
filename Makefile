SHELL_FILES=delphyne test/*.sh

test:
	make -C test test
	shellcheck --shell=bash $(SHELL_FILES)

.PHONY: test
