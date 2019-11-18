#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Missing new version"
  exit 1
fi
cd app || cd ..
currentVersion=$(grep 'version:' pubspec.yaml | cut -d' ' -f2)
if [ "$currentVersion" == "$1" ]; then
  echo "The new version can't be the same version as the current version"
  exit 1
fi
echo "Current version: $currentVersion"
echo "New version: $1"
find . -name "pubspec.yaml" -print0 | xargs -0 sed -i "s/$currentVersion/$1/g"
find ./go/packaging -type f -print0 | xargs -0 sed -i "s/$currentVersion/$1/g"
mv go/packaging/linux-rpm/rpmbuild/BUILDROOT/ginko-"$currentVersion"-"$currentVersion".x86_64 go/packaging/linux-rpm/rpmbuild/BUILDROOT/ginko-"$1"-"$1".x86_64
rm -rf go/build
cd ..
