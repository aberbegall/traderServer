#!/bin/bash

# Fast fail the script on failures.
set -e

# Verify that the libraries are error and warning-free.
echo "Running dartanalyzer..."
libs=$(find lib -maxdepth 1 -type f -name '*.dart')
dartanalyzer $DARTANALYZER_FLAGS $libs test/all_tests.dart

# Run the tests.
echo "Running tests..."
pub run test:test

# Gather and send coverage data.
if [ "$REPO_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
  echo "Collecting coverage..."
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --token $REPO_TOKEN \
    --retry 2 \
    --exclude-test-files \
    test/all_tests.dart
fi