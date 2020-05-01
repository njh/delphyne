TEST_FILES=*.sh

test: $(TEST_FILES)
	@$(foreach f,$^,./$(f) &&) echo "All tests passed."

.PHONY: test
