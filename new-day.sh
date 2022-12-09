#!/bin/bash
# Requires bash for pushd/popd

usage_and_exit() {
  echo "Usage:"
  echo "./new-day.sh DAYNUMBER"
  [ -n "$1" ] && {
    echo
    echo "$1"
  }
  exit
}

DAY=$1
[ -z "$DAY" ] && {
  usage_and_exit "Missing DAYNUMBER"
}

case $DAY in
'' | *[!0-9]*)
  usage_and_exit "DAYNUMBER is not a number, got ${DAY}"
  ;;
*) ;;
esac

pushd $(dirname "${0}") >/dev/null
. "${PWD}/secrets.sh"
[ ! -f "day-${DAY}.jakt" ] && {
  cp boiler-plate.jakt "day-${DAY}.jakt"
  mkdir -p inputs
  curl --silent "https://adventofcode.com/2022/day/${DAY}/input" -H "COOKIE: session=${SESSION_COOKIE}" >"inputs/day-${DAY}.input"
  mkdir -p outputs
  touch "outputs/day-${DAY}.output"
  vim "inputs/day-${DAY}.example"
}
vim "outputs/day-${DAY}.example"
git add "day-${DAY}.jakt" "inputs/day-${DAY}.*" "outputs/day-${DAY}.*"
#vim "day-${DAY}.jakt"
echo "You can now edit 'day-${DAY}.jakt'"
popd >/dev/null
