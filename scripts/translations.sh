#!/bin/bash
cd translations || exit
flutter pub get
dart lib/builder.dart
cd ..
