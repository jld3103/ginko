#!/bin/bash
cd app || cd ..
flutter clean
rm -rf go/build
formats=("linux-appimage" "linux-deb" "linux-snap" "windows-msi" "darwin-pkg")
for format in "${formats[@]}"; do
  hover build "$format" -t lib/main.dart
  status=$?
  if [[ "$status" != 0 ]]; then
    exit 1
  fi
done
cd ..
