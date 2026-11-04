# TA docs repo — working rules

## Daily log (readme.md)
`readme.md` has a "Recent Updates" section between the `RECENT-UPDATES` markers. It is generated, never hand-edit it.

- After finishing any commit of real work, run `scripts/update-daily-log.sh --commit`.
- Same-day work is grouped under one date heading automatically; "docs: daily log" commits are excluded from the log.
- Keep commit messages descriptive (they become the "Work done" lines), e.g. `ta-work: add quiz 2 for 6950`.

## Privacy
- Never list or link student submissions, grades, or feedback in the readme (the script already filters `submissions/`, `results/`, `feedback/`, `*.json`).
- `cappv1/` is gitignored and must stay untracked.

## Git
- Don't force-push or rewrite history without the user asking.
- Don't push unless asked.
