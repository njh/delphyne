SHELL_FILES=delphyne

test:
	shellcheck $(SHELL_FILES)

.PHONY: test
