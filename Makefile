SHELL_FILES=delphyne test/*.sh

test:
	test/*.sh
	shellcheck --shell=bash $(SHELL_FILES)

.PHONY: test
