#!/usr/bin/env bash

# shellcheck source=delphyne
source "${BASH_SOURCE%/*}/../delphyne"

set +e
set +u

testParseZoneFilenameSimpleDotZone() {
  assertEquals 'example.com' "$(parse_zone_filename 'example.com.zone')"
}

testParseZoneFilenameSimpleDbDot() {
  assertEquals 'example.com' "$(parse_zone_filename 'db.example.com')"
}

testParseZoneFilenameTooShort() {
  assertContains "$(parse_zone_filename 'example.zone' 2>&1)" 'Filename does not contain a valid zone name'
}

testParseZoneFilenameInvalidCharacters() {
  assertContains "$(parse_zone_filename 'example_.com.zone' 2>&1)" 'Filename does not contain a valid zone name'
}

testParseZoneFilenameRelative() {
  assertEquals 'example.com' "$(parse_zone_filename '../example.com.zone')"
}

testParseZoneFilenameFullPath() {
  assertEquals 'example.com' "$(parse_zone_filename '/home/user/dns/example.com.zone')"
}


# shellcheck disable=SC1091
source "$(command -v shunit2)"
