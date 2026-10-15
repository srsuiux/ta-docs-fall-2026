# Assignment 1 (Express Routing): Grading Rubric

CSCI 4862 / 6962 Server-Side Development

The rubric is worth **100 points**. The final grade is the total **divided by 5**, so it is out of **20**. The script `grade-all.sh` grades exactly the rules below.

**Where each rule comes from**
- **Instructions**: written in the assignment instructions.
- **Lecture**: taught in Lessons 2 and 3 (the code shared with students).
- **Weight**: the point value is the grader's own choice. The instructions only name penalties for links (up to 10), routing (up to 10), and documentation (up to 5).

Only what the instructions ask for is graded. File names of the cover images can be anything, Morgan (logging) is not required, and any valid port is fine.

---

## How a project is graded

1. The student's folder is **copied** to a temporary place. The original is never touched.
2. The project folder is the folder that holds `app.js` (searched up to 4 levels deep). If `app.js` is nested 2 or more levels deep, or missing, the summary says so.
3. If `node_modules` is missing, the grader runs `npm install` on the copy. A missing `node_modules` takes no points; it is only noted.
4. The app is started with `node app.js`. It may use **any valid port**; the grader finds the port by itself.
5. The grader reads the code, opens the pages, and forces two errors (see section 3).
6. If the app does not start, every "runs the app" item scores 0 and the last lines of its output are shown at the end of the report.
7. If another program on the grading computer is using the app's port, the run stops with a clear message (or the report says "could not test"), so a busy port is never mistaken for a student's mistake.

The student's proposal (`proposals/<name>.json`) gives the three ISBNs, titles, prices, and the student's name that the pages are checked against.

---

## 1. Project Structure: 5 pts

| Item | Pts | Rule | Source |
|---|---|---|---|
| `Pages/` folder | 2 | A folder named exactly `Pages` (capital P) in the project folder | Instructions |
| `Pages/images/` with cover images | 2 | At least 3 image files (.jpg, .jpeg, .png, .gif, .webp). **File names can be anything.** 1 or 2 images give 1 pt | Instructions |
| express in `package.json` | 1 | `express` is listed in dependencies | Instructions ("complete and working directory") |

Expected layout:

```
project_name/
├── app.js
├── package.json
├── node_modules/
└── Pages/
    ├── index.html
    ├── <ISBN>.html   (3 book pages)
    └── images/
        └── (3 cover images, any names)
```

## 2. Naming Conventions: 5 pts

| Item | Pts | Rule | Source |
|---|---|---|---|
| Main file | 2 | The file is named `app.js` | Instructions |
| `index.html` | 1 | `Pages/index.html` exists | Instructions |
| Book pages | 2 | Each book page is named `<ISBN>.html`, matching the ISBNs in the proposal (2/3 of the points per matching page) | Instructions |

## 3. app.js: 65 pts

Items marked "No partial" are all-or-nothing. The code-reading items are checked from the source, so a 0 should be looked at by eye before it is final.

| Item | Pts | Rule | How it is checked | Source |
|---|---|---|---|---|
| Single route | 10 | One `app.get("/select/:variable", ...)` that uses `request.params`. Separate routes per book get 0. No partial | Reads the code | Instructions (up to 10 lost), Lecture 3.3 / 3.4 |
| `sendFile` with root | 8 | `response.sendFile(file, {root: ...})`. No partial | Reads the code | Instructions, Lecture 3.2 to 3.4 |
| `path.resolve` | 7 | `path.resolve(...)` builds the path. `path.join` does not count. No partial | Reads the code | Instructions, Lecture 3.2 to 3.4 |
| `/` returns index.html | 5 | `GET /` returns the same content as `Pages/index.html`. A different page that links to `/select/` gets 3 | Runs the app | Instructions |
| Images served at `/images/...` | 7 | Each image file in `Pages/images/` loads from `/images/<file>` (7 x files loaded / 3) | Runs the app | Instructions, Lecture 3.2 (`express.static`) |
| Nonexistent ISBN | 10 | `/select/0000000000000` returns a page containing "File Not Found". "Server Error" instead gets 0. No partial | Runs the app | Instructions, Lecture 3.4 |
| Unknown route | 6 | `/no-such-route/xyz` returns "File Not Found". Express's default "Cannot GET" gets 0. No partial | Runs the app | Instructions, Lecture 3.1 to 3.4 |
| Other errors | 7 | A forced error returns "Server Error". Two errors are tried: a badly encoded address (reaches error-handling middleware) and a file outside the root (reaches the `sendFile` callback). Either one returning "Server Error" gets full points. The text only in the code, but not returned, gets 3 | Runs the app (forces an error) | Instructions, Lecture 3.3 / 3.4 |
| Well documented | 5 | Share of lines with comments: 15% or more = 5, 7% or more = 3, any comments = 1, none = 0. **Also check by eye** | Reads the code | Instructions (up to 5 lost) |

## 4. HTML Content: 25 pts

| Item | Pts | Rule | How it is checked | Source |
|---|---|---|---|---|
| Index links | 10 | Three links in `index.html` of the form `http://localhost:<port>/select/ISBN`. Any port is accepted. Each direct link to a `.html` file cancels one good link | Reads `index.html` | Instructions (up to 10 lost) |
| Title | 3 | The book title from the proposal is on each book page (1 pt per page) | Opens each page through `/select/ISBN` | Instructions |
| Cover image | 5 | Each page has `<img src="/images/filename">` and that file exists in `Pages/images/` (5 x pages / 3) | Opens each page | Instructions |
| Price | 3 | The book price from the proposal is on each book page (1 pt per page) | Opens each page | Instructions |
| Student name | 4 | The student's name is in the bottom part (last 40%) of each page (4 x pages / 3) | Opens each page | Instructions |

Without a usable proposal file, the title and price checks become a rough check (some heading or a `$` amount is present) and the **name check is left for a manual check**. It is then left out of the automatic total, so the student is graded out of 96 with up to 0.8 points (4 / 5) still to add by hand.

---

## Flags for feedback (no points taken)

- **README file** in the project (`README.md`, `README.txt`). It is not part of the assignment, so the report lists it so feedback can mention it. A README alone does not prove anything about how the code was written.
- **Nested or missing app.js** and **node_modules not included**. These show in the summary so the grader can see how the project was packaged.

## Remarks and point adjustments

Anything the rubric cannot capture (for example, a project submitted inside the wrong folder) is handled by hand, not by changing the rules. The grader puts a short text file, `remarks/<student>.txt`, in the report:

- An optional first line `points: +3.5` (or `points: -2`) changes the total out of 100.
- The rest of the file is the remark text. It is added to the student's report and shown in the summary.
- The report shows the new total. The summary marks the student as adjusted, so every change can be reviewed.

## What the script does not check (grader looks by eye)

- That the name is really visible at the very bottom of the page.
- The quality of the comments (only the share of comment lines is counted).
- Extra requirements such as logging with morgan.
- Status codes (404 / 500). Only the messages "File Not Found" and "Server Error" are checked.
- Capital letters in `app.js` and `index.html`. `Pages` must be spelled exactly, but on a Mac the other two names are not case-checked.
- Whether a project follows a different layout than the instructions that still works. Those cases are decided by hand and recorded as a remark.

---

## What is needed to run the grader

- Node.js and npm installed.
- Folder layout:

```
assignment-01/
├── grade-all.sh
├── submissions/     one unpacked folder per student, e.g. Jane_Doe_project/
├── proposals/       one .json per student, e.g. Jane_Doe.json
└── remarks/         optional, one .txt per student
```

- Proposal file format (exactly 3 books):

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

- A student and a proposal are matched by name: `Jane_Doe_project` and `Jane_Doe.json` both become `jane_doe`.

Run: `bash grade-all.sh` (everyone) or `bash grade-all.sh --only jane_doe` (one student again).

## Results

```
results/
├── summary.csv                one row per student: grade, items that scored 0, flags
├── reports/<student>_grade.txt   the report to use for feedback
└── logs/<student>.log            what the grader did for that student
```