#!/bin/bash
cd app || cd ..
flutter clean
rm -rf go/build
flutter build web
cp web/sw.js build/web
tar -czvf ../artifacts/ginko_web.tar.gz build/web >/dev/null
cd ..
