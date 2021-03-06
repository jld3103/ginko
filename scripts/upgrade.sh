#!/bin/bash
folders=("app" "backend" "models" "parsers")
for d in "${folders[@]}"; do
  cd "$d" || exit

  if [[ "$d" == "app" ]]; then
    flutter pub upgrade
    hover bumpversion
    cd go || exit
    go get -u ./...
    cd ..
  else
    pub upgrade
  fi
  cd ..
done
