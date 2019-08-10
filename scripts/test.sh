#!/bin/bash

folders=("app" "models" "server")
for d in "${folders[@]}"; do
  cd "$d" || exit
  if [[ "$d" == "app" ]]; then
    flutter test || error=true
  else
    pub run test || error=true
  fi

  cd ..

  # Fail the build if there was an error
  if [[ "$error" == true ]]; then
    exit 1
  fi

done
