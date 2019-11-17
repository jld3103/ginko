#!/bin/bash

rm -rf app/lib/generated_plugin_registrant.dart

folders=("models" "backend" "app" "translations")
for d in "${folders[@]}"; do
  cd "$d" || exit

  dartfmt -w --fix lib test
  output=$(dartanalyzer lib test)

  status=$?
  echo "$output"
  if [[ "$status" != 0 ]] || echo "$output" | grep -q "lint" || echo "$output" | grep -q "hint"; then
    d=${d%/}
    echo "$d failed checks"
    exit 1
  fi
  cd ..
done
