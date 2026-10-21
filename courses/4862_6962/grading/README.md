# Assignment 1 (Express Routing): Grader Instructions

CSCI 4862 / 6962 Server-Side Development

`grade-all-student.sh` grades every student project in `submissions/` using the rules in `rubric.md` and builds one summary. The rubric is worth 17 points, which is the final grade. It also builds a `feedback/` folder with one detailed page per student (`feedback/<student>.html`) that has a button to copy the feedback as plain text.

## Requirements

- bash, Node.js, npm, tar
- Port 3000 free on the grading computer. If another program holds it, the script stops with a message telling you how to close it.

## Folder layout

```
assignment-01/
├── grade-all-student.sh
├── rubric.md
├── submissions/     one unpacked folder per student, e.g. Jane_Doe_project/
└── proposals/       one .json per student, e.g. Jane_Doe.json
```

Students and proposals are matched by name. The id is the folder (or `.json`) name in lowercase without a trailing `_project`, `_submission` or `_proposal`, so `Jane_Doe_project` and `Jane_Doe.json` both become `jane_doe`. If a student has several folders, the last one is graded. Zip files in `submissions/` are skipped, so unzip them first.

## Proposal file

Exactly 3 books. The ISBNs, titles and prices are what the pages are checked against.

```json
{
  "student": "Jane Doe",
  "books": [
    { "isbn": "9780836218220", "title": "Book Title", "price": "$12.99" },
    { "isbn": "...", "title": "...", "price": "..." },
    { "isbn": "...", "title": "...", "price": "..." }
  ]
}
```

The pages tested are the ISBNs in the student's own index links (hyphens ignored), matched to the proposal. Without a usable proposal, or when a linked ISBN is not in it, title and price become a rough check (some heading, or a `$` amount, is present).

## Running

```
bash grade-all-student.sh                   # everyone
bash grade-all-student.sh --only jane_doe   # one student again
```

The terminal shows one line per student. Everything else goes to the logs.

## How a project is graded

1. The student's folder is copied to a temporary place. The original is never touched.
2. The project folder is the shallowest folder holding `package.json` with an entry file (else any `package.json`, else the folder holding `app.js`), searched up to 4 levels deep. If it is nested 2 or more levels deep, or missing, the summary says so.
3. If `node_modules/express` is missing, the grader runs `npm install` on the copy. If that fails, it uses a shared fallback copy of express. A missing `node_modules` takes no points; it is only noted.
4. The entry file is found from `package.json`: `main`, else the file in `scripts.start` / `dev` / `serve`, else `app.js`, `index.js`, `server.js`.
5. The app is started with `node <entry>`. Any valid port is fine; the grader finds the port itself and waits up to 10 seconds for an answer.
6. The grader reads the entry file's code, opens the pages, and forces two errors (a badly encoded address and a file outside the root).
7. If the app does not start, every item that needs the running app scores 0, and the last lines of its output are shown at the end of the report.
8. If another program is using the app's port, the report says "could not test", so a busy port is never mistaken for a student's mistake.

Layout and file names (`app.js`, `Pages/`, `express` listed) are not scored; they appear in the "Project structure" part of the feedback page. Only the behavior the assignment asks for is scored. Any wording that says "not found" is accepted for missing pages, letter case of paths does not matter, and logging with morgan is not required.

## Results

Next to `results/`, the script also writes `feedback/index.html` (all students) and `feedback/<student>.html` (details and a Copy button).

```
results/
├── summary.csv                      one row per student: grade (out of 17), category scores, items to review, flags
├── reports/<student>_grade.txt      the score report for the grader (and _grade.json)
├── logs/<student>.log               copy, npm and grader output
├── logs/<student>/<n>-<category>.log   one log per rubric category (requests, answers, points)
├── logs/<student>_app.log           what the student's own app printed while tested
└── run.log                          everything the run printed
```

A full run starts clean. `--only` keeps the other students' results and replaces just that one.

## Flags in the summary (no points taken)

- Project nested 2 or more folders deep, or no `package.json` / `app.js` found
- `node_modules` not included (installed by the grader, or fallback express used)
- Missing or unusable proposal
- Several folders for one student
- App did not start, or could not be tested
- Proposal with no matching submission
- Index links to ISBNs that are not in the proposal

## What the script does not check (look by eye)

- Any lost point in Proper Routing of Books: the code checks read only the entry file, so routes in another file score 0.
- The quality of the comments (only the share of comment lines is counted).
- Whether the student's name is at the bottom of the page (only that it appears on the page).
- Extra requirements such as logging with morgan.
- Status codes (404 / 500). Only the messages are scored; a wrong status code is mentioned in the feedback page.

Anything the rubric cannot capture (for example, a project submitted inside the wrong folder) is handled by hand, outside the script.
