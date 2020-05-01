#!/usr/bin/env bash

# shellcheck source=delphyne
source "${BASH_SOURCE%/*}/../delphyne"

set +e
set +u

testCleanJsonSpaces() {
  input=$'{ "foo": 1,\n  "bar": 2  }'
  assertEquals '{"foo": 1, "bar": 2}' "$(echo "${input}" | clean_json)"
}

testJsonStringValue() {
  input='{"foo": "hello", "bar": "world"}'
  assertEquals 'hello' "$(echo "${input}" | get_json_string_value foo)"
  assertEquals 'world' "$(echo "${input}" | get_json_string_value bar)"
}

testJsonIntValue() {
  input='{"foo": 1, "bar": 2}'
  assertEquals '1' "$(echo "${input}" | get_json_int_value foo)"
  assertEquals '2' "$(echo "${input}" | get_json_int_value bar)"
}

testJsonArrayValue() {
  input='{"string": "str", "array": ["foo", "bar"]}'
  assertEquals '"foo", "bar"' "$(echo "${input}" | get_json_array_value array)"
}

testJsonDictValue() {
  input='{"string": "str", "dict": {"a": 1, "b": 2}}'
  assertEquals '"a": 1, "b": 2' "$(echo "${input}" | get_json_dict_value dict)"
}

testJsonArrayAsLinesSingle() {
  input='{"items": ["item1"]}'
  result="$(echo "${input}" | get_json_array_value items | get_json_array_as_lines)"
  assertEquals 'item1' "${result}"
}

testJsonArrayAsLinesMultiple() {
  input='{"items": ["item1","item2","item3"]}'
  result="$(echo "${input}" | get_json_array_value items | get_json_array_as_lines)"
  assertEquals $'item1\nitem2\nitem3' "$result"
}

testJsonArrayAsLinesMultipleWithSpaces() {
  input='{"items": [ "item1", "item2", "item3" ]}'
  result="$(echo "${input}" | get_json_array_value items | get_json_array_as_lines)"
  assertEquals $'item1\nitem2\nitem3' "$result"
}


# shellcheck disable=SC1091
source "$(command -v shunit2)"
