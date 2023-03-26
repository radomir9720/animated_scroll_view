#!/usr/bin/env bash
flutter pub get &&
dart format --set-exit-if-changed lib test &&
flutter analyze lib test &&
flutter pub run dart_code_metrics:metrics check-unused-files lib &&
flutter pub run dart_code_metrics:metrics analyze lib &&
flutter pub run dart_code_metrics:metrics check-unused-code lib &&
flutter test --coverage --test-randomize-ordering-seed random