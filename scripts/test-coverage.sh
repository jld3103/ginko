#!/bin/bash

mkdir -p coverage
rm -rf coverage/*

folders=("models" "server" "app")
for d in ${folders[@]} ; do
    cd ${d}

    flutter test --coverage ../tests/test/${d} || error=true

    escapedPath="$(echo ${d} | sed 's/\//\\\//g')"
    sed "s/^SF:lib/SF:$escapedPath\/lib/g" coverage/lcov.info >> ../coverage/lcov.info
    rm coverage -r

    # Fail the build if there was an error
    if [[ "$error" = true ]]; then
      exit -1
    fi
    cd ..
done

if ! [[ "$TRAVIS" ]]; then
  genhtml coverage/lcov.info -o coverage --no-function-coverage -s -q -p `pwd`
fi