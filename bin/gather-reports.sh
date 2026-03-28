#!/bin/bash
# gather-reports.sh - Copy recent drdad reports for Claude analysis
#
# Copies the last 7 days of JSON reports from all tracked repos
# into ./reports-snapshot/ for the scheduled Claude task to analyze.

set -e

REPORTS_BASE="/Users/d/Library/CloudStorage/ProtonDrive-delano@onetimesecret.com-folder/Individual/Reports/drdad"
SNAPSHOT_DIR="$(dirname "$0")/reports-snapshot"

# Create snapshot directory (no rm -rf - sandbox may block it)
mkdir -p "$SNAPSHOT_DIR"

# Copy last 7 days of reports from each repo (overwrites existing)
for repo_dir in "$REPORTS_BASE"/*/; do
  repo_name=$(basename "$repo_dir")
  mkdir -p "$SNAPSHOT_DIR/$repo_name"

  # Find JSON files from the last 7 days
  for i in $(seq 0 6); do
    day=$(date -v-${i}d +%Y-%m-%d)
    src="$repo_dir/${day}.json"
    if [ -f "$src" ]; then
      cp -f "$src" "$SNAPSHOT_DIR/$repo_name/"
    fi
  done
done

# Summary
echo "Reports gathered:"
total=$(find "$SNAPSHOT_DIR" -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
echo "  Total files: $total"
for repo in "$SNAPSHOT_DIR"/*/; do
  [ -d "$repo" ] || continue
  repo_name=$(basename "$repo")
  count=$(find "$repo" -name "*.json" 2>/dev/null | wc -l | tr -d ' ')
  [ "$count" -gt 0 ] && echo "  $repo_name: $count"
done

exit 0
