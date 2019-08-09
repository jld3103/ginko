#!/bin/bash

cd tests || exit
ARGS=()
for ARG in "$@"; do
  ARGS+=("test/${ARG}")
done

flutter test "${ARGS[@]}" || error=true
cd ..

# Fail the build if there was an error
if [[ "$error" == true ]]; then
  exit 1
fi
