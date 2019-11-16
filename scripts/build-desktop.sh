#!/bin/bash
cd app || cd ..
flutter clean
rm -rf go/build
formats=("linux-appimage" "linux-deb" "linux-snap" "linux-rpm" "windows-msi" "darwin-pkg" "darwin-dmg")
for format in "${formats[@]}"; do
  hover build "$format" "$@"
  status=$?
  if [[ "$status" != 0 ]]; then
    exit 1
  fi
done
cd ..
