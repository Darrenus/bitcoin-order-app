#!/bin/bash

jshint --exclude="node_modules/" --reporter=unix . > JSHint-report
scan_status=$?

# Findings remain in the report; they should not prevent the artifact upload.
if [ "$scan_status" -ne 0 ]; then
  echo "JSHint completed with findings (exit code $scan_status)." >&2
fi

test -s JSHint-report
