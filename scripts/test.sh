#!/bin/bash

cd tests
flutter test || error=true
cd ..

# Fail the build if there was an error
if [[ "$error" = true ]]; then
  exit -1
fi