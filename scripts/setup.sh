#!/bin/bash
if ! [[ -x "$(command -v flutter)" ]]; then
  echo 'Error: flutter is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v dart)" ]]; then
  echo 'Error: dart is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v pub)" ]]; then
  echo 'Error: pub is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v dartfmt)" ]]; then
  echo 'Error: dartfmt is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v dartanalyzer)" ]]; then
  echo 'Error: dartanalyzer is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v node)" ]]; then
  echo 'Error: node is not installed.' >&2
  exit 1
fi
if ! [[ -x "$(command -v yarn)" ]]; then
  echo 'Error: yarn is not installed.' >&2
  exit 1
fi

cd server/js
yarn install
cd ../..
folders=("models" "server" "app" "tests")
for d in ${folders[@]} ; do
    cd ${d}
    flutter packages get
    cd ..
done
packages=("flutter_platform" "flutter_platform_storage")
for d in ${packages[@]} ; do
    cd packages/${d}
    flutter packages get
    cd ../..
done
bash scripts/generate.sh
