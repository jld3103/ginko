#!/bin/bash

mkdir -p coverage
rm -rf coverage/*

folders=("models")
for d in "${folders[@]}"; do
  cd "$d" || exit

  if [[ "$d" == "app" ]]; then
    flutter pub get 1>/dev/null
    flutter test --coverage 1>/dev/null || error=true
  else
    pub get 1>/dev/null
    test_coverage 1>/dev/null || error=true
    rm coverage_badge.svg
  fi

  # Fail the build if there was an error
  if [[ "$error" == true ]]; then
    exit 1
  fi

  escapedPath="$(echo "$d" | sed 's/\//\\\//g')"
  sed "s/^SF:lib/SF:$escapedPath\/lib/g" coverage/lcov.info >>../coverage/lcov.info
  rm coverage -r

  cd ..
done

if ! [[ "$TRAVIS" ]]; then
  genhtml coverage/lcov.info -o coverage --no-function-coverage -s -q -p "$(pwd)"
fi
