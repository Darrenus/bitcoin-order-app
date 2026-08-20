#!/bin/bash

set -u

project_root="$(cd -- "$(dirname -- "$0")/.." && pwd)"
target_url="https://darrenus.github.io/bitcoin-order-app/"
report_file="zap_baseline_report.html"

docker pull zaproxy/zap-stable
chmod a+rwx "$project_root"
docker run --rm \
  --volume "$project_root:/zap/wrk/:rw" \
  zaproxy/zap-stable \
  zap-baseline.py -t "$target_url" -l PASS -r "$report_file"
scan_status=$?

if [ ! -s "$project_root/$report_file" ]; then
  echo "ZAP did not create $report_file." >&2
  exit 1
fi

# ZAP returns 1 or 2 when the completed scan reports alerts. Preserve those
# results in the report without treating them as a workflow execution error.
case "$scan_status" in
  0|1|2) exit 0 ;;
  *) exit "$scan_status" ;;
esac
