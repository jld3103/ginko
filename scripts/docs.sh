#!/bin/bash

mkdir -p doc
rm -rf doc/*

folders=("models" "server" "app" "translations")
for d in ${folders[@]} ; do
    mkdir -p doc/$d
    cd $d
    dartdoc --exclude 'dart:async,dart:collection,dart:convert,dart:core,dart:developer,dart:io,dart:isolate,dart:math,dart:typed_data,dart:ui'
    cp -r doc/api/* ../doc/$d/
    rm -r doc
    cd ..
    exit 0
done