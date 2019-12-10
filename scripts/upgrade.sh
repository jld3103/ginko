#!/bin/bash
folders=("app" "backend" "models" "parsers" "translations")
for d in "${folders[@]}"; do
  cd "$d" || exit

  if [[ "$d" == "app" ]]; then
    flutter pub upgrade
    hover bumpversion
  else
    pub upgrade
  fi
  cd ..
done
