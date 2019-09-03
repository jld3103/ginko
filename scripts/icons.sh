#!/bin/bash
cd app || exit
# Copy white SVG to green SVG
cp images/logo_white.svg images/logo_green.svg
sed -i -- 's/ffffff/5bc638/g' images/logo_green.svg
# Create PNGs from SVGs
convert -resize 1024x1024 -background none images/logo_white.svg images/logo_white.png
convert -resize 1024x1024 -background none images/logo_green.svg images/logo_green.png
# Create app icons
flutter pub get
flutter pub run flutter_launcher_icons:main -f icons_white.yaml
flutter pub run flutter_launcher_icons:main -f icons_green.yaml
cp images/logo_white.png android/app/src/main/res/drawable/
mkdir go/assets -p
cp images/logo_green.png go/assets/icon.png
cd ..
