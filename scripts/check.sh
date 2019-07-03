#!/bin/bash

parent=$(/bin/ps -o ppid -p $PPID | tail -1)
if [[ -n "$parent" ]]; then
    amended=$(/bin/ps -o command -p ${parent} | grep -e '--amend')
    if [[ -n "$amended" ]]; then
        exit 0
    fi
fi

bash scripts/setup.sh
folders=("models" "server" "tests" "app")
for d in ${folders[@]} ; do
    cd ${d}

    if [[ -d "test" ]]
    then
        dartfmt -w --fix test
        output=$(dartanalyzer test)
    else
        dartfmt -w --fix lib
        output=$(dartanalyzer lib)
    fi

    status=$?
    echo "$output"
    if [[ "$status" != 0 ]] || echo "$output" | grep -q "(l|h)int"; then
	d=${d%/}
        echo "$d failed checks"
        exit 1
    fi
    cd ..
done

cd tests
flutter test
status=$?
if [[ "$status" != 0 ]]; then
    exit 1
fi
cd ..
