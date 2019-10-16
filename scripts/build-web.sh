#!/bin/bash
cd app || cd ..
flutter clean
flutter build web
cp web/sw.js build/web
cd ..
