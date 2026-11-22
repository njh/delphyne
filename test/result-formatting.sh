#!/usr/bin/env bash

# shellcheck source=delphyne
source "${BASH_SOURCE%/*}/../delphyne"

set +e
set +u

testDisplayZones() {
  assertEquals $'example.com\nexample.org\nexample.net' "$(display_zones < zones.json)"
}

testDisplayError() {
  assertEquals '=> Access denied' "$(display_error json-headers.txt error.json 2>&1)"
}

testDisplayMultipleErrors() {
  expected=$'=> Unsupported record type \'xx\' (line 18)\n'
  expected+=$'=> Unsupported record type \'zz\' (line 19)'
  assertEquals "${expected}" "$(display_error json-headers.txt errors.json 2>&1)"
}

testDisplayErrorNotJson() {
  result="$(display_error html-headers.txt error.json 2>&1)"
  assertContains "${result}" '=> An error occurred while making request'
  assertContains "${result}" 'Content-Type: text/html'
  assertContains "${result}" '"error": "Access denied"'
}

testDisplayMessage() {
  result="$(display_message "$(<success.json)" 2>&1)"
  assertEquals '=> 8 records added' "${result}"
}


# shellcheck disable=SC1091
source "$(command -v shunit2)"
