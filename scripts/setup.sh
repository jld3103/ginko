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

pub global activate test_coverage

cd server/js || exit
yarn install
cd ../..
folders=("app" "models" "server" "translations")
for d in "${folders[@]}"; do
  cd "$d" || exit
  if [[ "$d" == "app" ]]; then
    flutter pub get
  else
    pub get
  fi
  cd ..
done
bash scripts/generate.sh

echo "#!/bin/bash
bash scripts/check.sh" >.git/hooks/pre-commit
chmod a+x .git/hooks/pre-commit

echo "#!/bin/bash
bash scripts/changelog.sh" >.git/hooks/post-commit
chmod a+x .git/hooks/post-commit
