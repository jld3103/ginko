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

if ! [[ -x "$(command -v lcov)" ]]; then
  echo 'Error: lcov is not installed.' >&2
  exit 1
fi

if ! [[ -x "$(command -v hover)" ]]; then
  echo 'Error: hover is not installed.' >&2
  exit 1
fi

if ! [[ -x "$(command -v go)" ]]; then
  echo 'Error: go is not installed.' >&2
  exit 1
fi

if ! [[ -x "$(command -v docker)" ]]; then
  echo 'Error: docker is not installed.' >&2
  exit 1
fi

pub global activate test_coverage

cd parsers/js || exit
yarn install
cd ../..
folders=("app" "models" "backend" "parsers")
for d in "${folders[@]}"; do
  cd "$d" || exit
  if [[ "$d" == "app" ]]; then
    flutter pub get
  else
    pub get
  fi
  cd ..
done
bash scripts/icons.sh

echo "#!/bin/bash
bash scripts/changelog.sh" >.git/hooks/post-commit
chmod a+x .git/hooks/post-commit
