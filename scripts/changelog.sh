#!/bin/bash
DATE=$(date +%F)
FILE="CHANGELOG.md"
echo "# CHANGELOG ON" ${DATE} > ${FILE}

parent=$(/bin/ps -o ppid -p $PPID | tail -1)
if [[ -n "$parent" ]]; then
    amended=$(/bin/ps -o command -p ${parent} | grep -e '--amend')
    if [[ -n "$amended" ]]; then
        exit 0
    fi
fi


res=$(git status --porcelain | grep ${FILE} | wc -l)
if [[ "$res" -gt 0 ]]; then
  git log --no-merges --format="%cd" --date=short --no-merges --all | sort -u -r | while read DATE ; do
    if [[ ${NEXT} != "" ]]
    then
      echo >> ${FILE}
      echo "###" ${NEXT} >> ${FILE}
    fi
    GIT_PAGER=cat git log --no-merges --format="    - %an: %s" --since=${DATE} --until=${NEXT}  --all >> ${FILE}
    NEXT=${DATE}
  done

  git add ${FILE}
  git commit --amend
fi