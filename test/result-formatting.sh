#!/usr/bin/env bash

# shellcheck source=delphyne
source "${BASH_SOURCE%/*}/../delphyne"

set +e
set +u

testDisplayZones() {
  assertEquals $'example.com\nexample.org\nexample.net' "$(display_zones < zones.json)"
}


# shellcheck disable=SC1091
source "$(command -v shunit2)"
