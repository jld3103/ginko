#!/bin/bash
cd app || cd ..
flutter clean
rm -rf go/build
flutter build web
cp web/* build/web
cd build/web || cd ../..
mkdir -p ../../../artifacts
tar -czvf ../../../artifacts/ginko_web.tar.gz . >/dev/null
cd ../../..
