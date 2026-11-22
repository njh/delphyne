#!/usr/bin/env bash

# shellcheck source=delphyne
source "${BASH_SOURCE%/*}/../delphyne"

set +e
set +u

setUp() {
  CURL="${BASH_SOURCE%/*}/fake-curl"
  MYTHIC_BEASTS_API_KEY='key'
  MYTHIC_BEASTS_SECRET='secret'
  set_defaults
  FAKE_CURL_LOG="$(_mktemp)"
  export FAKE_CURL_LOG
}

tearDown() {
  rm -f "${FAKE_CURL_LOG}"
}

requested_url() {
  cat "${FAKE_CURL_LOG}"
}

testApiBasePathDefault() {
  assertEquals 'https://api.mythic-beasts.com/dns/v2' "$(api_base_path)"
}

testApiBasePathIPv4() {
  ip_version=4
  assertEquals 'https://ipv4.api.mythic-beasts.com/dns/v2' "$(api_base_path)"
}

testApiBasePathIPv6() {
  ip_version=6
  assertEquals 'https://ipv6.api.mythic-beasts.com/dns/v2' "$(api_base_path)"
}

testGetExcludesGeneratedRecords() {
  (command_get example.com) >/dev/null 2>&1
  assertEquals 'https://api.mythic-beasts.com/dns/v2/zones/example.com/records?exclude-generated' "$(requested_url)"
}

testGetAllIncludesGeneratedRecords() {
  all_records=1
  (command_get example.com) >/dev/null 2>&1
  assertEquals 'https://api.mythic-beasts.com/dns/v2/zones/example.com/records' "$(requested_url)"
}

testGetIPv6UsesIPv6Hostname() {
  ip_version=6
  (command_get example.com) >/dev/null 2>&1
  assertEquals 'https://ipv6.api.mythic-beasts.com/dns/v2/zones/example.com/records?exclude-generated' "$(requested_url)"
}

testDynamicDefaultsToIPv4Hostname() {
  (command_dynamic www.example.com) >/dev/null 2>&1
  assertEquals 'https://ipv4.api.mythic-beasts.com/dns/v2/dynamic/www.example.com' "$(requested_url)"
}

testDynamicIPv6UsesIPv6Hostname() {
  ip_version=6
  (command_dynamic www.example.com) >/dev/null 2>&1
  assertEquals 'https://ipv6.api.mythic-beasts.com/dns/v2/dynamic/www.example.com' "$(requested_url)"
}

testDynamicNoHostname() {
  result="$(command_dynamic 2>&1)"
  assertEquals 1 $?
  assertContains "${result}" 'No hostname given.'
}

testAddUrl() {
  (command_add example.com www a 93.184.216.34) >/dev/null 2>&1
  assertEquals 'https://api.mythic-beasts.com/dns/v2/zones/example.com/records/www/A' "$(requested_url)"
}

testSetApexUrl() {
  (command_set example.com @ MX 10 mx.example.com.) >/dev/null 2>&1
  assertEquals 'https://api.mythic-beasts.com/dns/v2/zones/example.com/records/@/MX' "$(requested_url)"
}

testAddTooFewArguments() {
  result="$(command_add example.com www A 2>&1)"
  assertEquals 1 $?
  assertContains "${result}" 'A zone, host, record type and data must be given.'
}

testSetTooFewArguments() {
  result="$(command_set 2>&1)"
  assertEquals 1 $?
  assertContains "${result}" 'A zone, host, record type and data must be given.'
}

testGetNoZone() {
  result="$(command_get 2>&1)"
  assertEquals 1 $?
  assertContains "${result}" 'No zone name given.'
}


# shellcheck disable=SC1091
source "$(command -v shunit2)"
