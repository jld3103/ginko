#!/bin/bash

folders=("models")
for d in "${folders[@]}"; do
  cd "$d" || exit
  if [[ "$d" == "app" ]]; then
    flutter pub get 1>/dev/null
    flutter test || error=true
  else
    pub get 1>/dev/null
    pub run test || error=true
  fi

  cd ..

  # Fail the build if there was an error
  if [[ "$error" == true ]]; then
    exit 1
  fi

done
