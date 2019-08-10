#!/bin/bash
cd translations || exit
pub get
dart lib/builder.dart
cd ..
