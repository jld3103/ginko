#!/bin/bash
DATE=$(date +%F)
FILE="CHANGELOG.md"
echo "# CHANGELOG ON $DATE" >${FILE}

parent=$(/bin/ps -o ppid -p $PPID | tail -1)
if [[ -n "$parent" ]]; then
  amended=$(/bin/ps -o command -p "$parent" | grep -e '--amend')
  if [[ -n "$amended" ]]; then
    exit 0
  fi
fi

rm ${FILE}
PREVIOUS=""
while read -r line; do
  IFS=', ' read -r -a array <<<"$line"
  if [[ "${array[0]}" != "$PREVIOUS" ]]; then
    echo "" >>${FILE}
    echo "# ${array[0]}  " >>${FILE}
  fi
  PREVIOUS="${array[0]}"
  array=("${array[@]:1}")
  echo "$(printf " %s" "${array[@]}")  " >>${FILE}
done < <(git log --pretty=format:"%ad %an: %s" --date=short --no-merges)

git add ${FILE}
git commit --amend
git checkout "$(git branch | grep \  | cut -d ' ' -f2)" -- ${FILE}
echo "Populated Changelog in ${FILE}"
