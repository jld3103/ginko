#!/bin/bash
folders=("models" "server" "app")
for d in ${folders[@]} ; do
    cd ${d}

    dartfmt -w --fix lib

    output=$(dartanalyzer lib)
    status=$?
    echo "$output"
    if [[ "$status" != 0 ]] || echo "$output" | grep -q "lint"; then
	d=${d%/}
        echo "$d failed checks"
        exit 1
    fi
    cd ..
done
