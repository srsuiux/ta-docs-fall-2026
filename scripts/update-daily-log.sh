#!/usr/bin/env bash
# Rebuilds the "Recent Updates" daily log inside readme.md from git history.
# Same-day commits are grouped under one date heading.
# Usage: scripts/update-daily-log.sh [--commit] [days=3]
#   --commit  also commit readme.md as "docs: daily log update" if it changed
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
COMMIT=0; DAYS=3
for a in "$@"; do case "$a" in --commit) COMMIT=1;; *) DAYS="$a";; esac; done

# Never listed publicly: student work/feedback, repo meta files
EXCLUDE='(^\.gitignore$|^scripts/|^readme\.md$|/submissoins/|/submissions/|/results/|/feedback/|\.json$)'
SKIP_MSG='^docs: daily log'

section() {
  echo "## Recent Updates"
  for d in $(git log --format='%ad' --date=short | uniq | head -n "$DAYS"); do
    range=(--since="$d 00:00" --until="$d 23:59:59" --invert-grep --grep="$SKIP_MSG")
    echo
    echo "### $d"
    echo
    echo "**Work done**"
    git log "${range[@]}" --format='- %s' --reverse
    echo
    echo "**Files updated**"
    git log "${range[@]}" --name-only --format= | sort -u | grep -v '^$' | grep -Ev "$EXCLUDE" \
      | while read -r f; do echo "- [\`$f\`](./${f// /%20})"; done
  done
}

START='<!-- RECENT-UPDATES:START -->'; END='<!-- RECENT-UPDATES:END -->'
base=$(awk -v s="$START" -v e="$END" '$0==s{skip=1} !skip{print} $0==e{skip=0}' readme.md)
printf '%s\n\n%s\n%s\n%s\n' "$base" "$START" "$(section)" "$END" > readme.md

if [ "$COMMIT" = 1 ] && ! git diff --quiet readme.md; then
  git add readme.md && git commit -q -m "docs: daily log update" && echo "committed readme"
fi
