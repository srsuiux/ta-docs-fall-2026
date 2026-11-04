#!/usr/bin/env bash
# Regenerates the "Recent Updates" section of readme.md from git history.
# Usage: scripts/update-readme.sh [number_of_days_with_commits=5]
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
DAYS="${1:-5}"
# Paths never listed publicly (student work/feedback, ignored/meta files)
EXCLUDE='(^\.gitignore$|^scripts/|^readme\.md$|/submissoins/|/submissions/|/results/|/feedback/|\.json$)'

section() {
  echo "## Recent Updates"
  for d in $(git log --format='%ad' --date=short | uniq | head -n "$DAYS"); do
    echo
    echo "### $d"
    git log --since="$d 00:00" --until="$d 23:59:59" --format='%s' | sed 's/^/- **Commit:** /' | head -n 5
    git log --since="$d 00:00" --until="$d 23:59:59" --name-only --format= \
      | sort -u | grep -v '^$' | grep -Ev "$EXCLUDE" \
      | while read -r f; do echo "  - [\`$f\`](./${f// /%20})"; done
  done
}

START='<!-- RECENT-UPDATES:START -->'; END='<!-- RECENT-UPDATES:END -->'
base=$(awk -v s="$START" -v e="$END" '$0==s{skip=1} !skip{print} $0==e{skip=0}' readme.md)
printf '%s\n\n%s\n%s\n%s\n' "$base" "$START" "$(section)" "$END" > readme.md
