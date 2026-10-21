# Assignment 1 (Express Routing): Grading Rubric

CSCI 4862 / 6962 Server-Side Development

The rubric is worth **100 points**. The final grade is the total **divided by 5**, so it is out of **20**. The script `grade-all.sh` grades exactly the rules below.

**Where each rule comes from**
- **Instructions**: written in the assignment instructions.
- **Lecture**: taught in Lessons 2 and 3 (the code shared with students).
- **Weight**: the point value is the grader's own choice. The instructions only name penalties for links (up to 10), routing (up to 10), and documentation (up to 5).

Only the behavior the instructions ask for is graded. Any wording that says "not found" is accepted for missing pages. Letter case of paths and file names does not matter. Layout and file names can be anything, Morgan (logging) is not required, and any valid port is fine.

---

## How a project is graded

1. The student's folder is **copied** to a temporary place. The original is never touched.
2. The project folder is the folder that holds `package.json` (else `app.js`), searched up to 4 levels deep. If it is nested 2 or more levels deep, or missing, the summary says so.
3. If `node_modules/express` is missing, the grader runs `npm install` on the copy, and if that fails it uses a shared fallback copy of express. A missing `node_modules` takes no points; it is only noted.
4. The app is started with its entry file (`node <entry>`). It may use **any valid port**; the grader finds the port by itself.
5. The grader reads the code, opens the pages, and forces two errors (see Error Handling).
6. If the app does not start, every item that needs the running app scores 0 and the last lines of its output are shown at the end of the report.
7. If another program on the grading computer is using the app's port, the run stops with a clear message (or the report says "could not test"), so a busy port is never mistaken for a student's mistake.

The student's proposal (`proposals/<name>.json`) gives the three ISBNs, titles, prices, and the student's name that the pages are checked against.

---

## Grading categories (100 pts, one log per category)

Project layout and file names are **not graded**. The grader tests the running app over HTTP, so folders and file names can be anything. The entry file can be any `.js` file; it is found from `package.json`.

| # | Category | Pts |
|---|---|---|
| 1 | Routing & File Handling | 25 |
| 2 | Error Handling | 25 |
| 3 | Pages Served | 20 |
| 4 | HTML Content | 20 |
| 5 | Startup & Documentation | 10 |

### 1. Routing & File Handling: 25 pts (reads the code)

All-or-nothing items. A 0 should be looked at by eye before it is final (routes may be in another file).

| Item | Pts | Rule |
|---|---|---|
| Single route | 10 | Exactly one `app.get("/select/:variable", ...)` that uses `request.params`. Two or more literal `/select/...` routes (one per book) get 0. A dynamic route that never uses `params` gets 0 |
| `sendFile` with root | 8 | `response.sendFile(file, {root: ...})` |
| `path.resolve` | 7 | `path.resolve(...)` builds the path. `path.join` does not count |

### 2. Error Handling: 25 pts (runs the app)

| Item | Pts | Rule |
|---|---|---|
| Nonexistent ISBN | 10 | `/select/0000000000000` returns "File Not Found". "Server Error" instead gets 0 |
| Unknown route | 8 | `/no-such-route/xyz` returns a response containing "not found" in any wording ("Page Not Found", ...). Express's default "Cannot GET" gets 0 |
| Other errors | 7 | A forced error returns "Server Error". Two errors are tried (a badly encoded address and a file outside the root); either one is enough. The text only in the code, but not returned, gets 3 |

### 3. Pages Served: 20 pts (runs the app)

| Item | Pts | Rule |
|---|---|---|
| `/` | 5 | `GET /` returns status 200 with a page that contains `/select/` links (the index page) |
| Book pages | 10 | `/select/<ISBN>` returns a good page for each of the 3 proposal ISBNs (10 x pages / 3). A good page is status 200, not empty, and does not say "not found" |
| Cover images | 5 | The first `<img src="/images/...">` of each good book page loads with status 200 and an `image/*` content type (5 x images / 3) |

### 4. HTML Content: 20 pts

| Item | Pts | Rule |
|---|---|---|
| Index links | 10 | Three links in the index whose `href` ends in `/select/ISBN` (absolute or relative, any port). Score is 10 x max(0, good - bad) / 3, with good and bad each capped at 3. Each direct link to a `.html` file cancels one good link |
| Title | 3 | The proposal title is on each book page (1 pt per page) |
| Cover image tag | 4 | Each book page has `<img src="/images/filename">` (4 x pages / 3) |
| Price | 3 | The proposal price is on each book page (1 pt per page) |

Without a usable proposal file, title and price become a rough check (some heading or a `$` amount is present) and the ISBNs are taken from the index links.

### 5. Startup & Documentation: 10 pts

| Item | Pts | Rule |
|---|---|---|
| Starts | 3 | The app starts with the entry file from `package.json` (`main`, else the file in `scripts.start` / `dev` / `serve`, else `app.js`, `index.js`, `server.js`) and answers on some port within 10 seconds |
| express listed | 2 | `express` is in `dependencies` or `devDependencies` |
| Well documented | 5 | Share of lines with comments in the entry file: 15% or more = 5, 7% or more = 3, any = 1, none = 0. **Also check by eye** |

**No longer graded:** project structure, file and folder names, `app.js` name, `Pages/` and `images/` layout, student name at the bottom of pages.

---

## Flags for feedback (no points taken)

- **Nested or missing app.js / package.json**, **node_modules not included**, a missing or unusable proposal, and several folders for one student. These show in the summary so the grader can see how the project was packaged.

There are no automatic point adjustments. Anything the rubric cannot capture (for example, a project submitted inside the wrong folder) is handled by hand outside the script.

## What the script does not check (grader looks by eye)

- The quality of the comments (only the share of comment lines is counted).
- Extra requirements such as logging with morgan.
- Status codes (404 / 500). Only the messages "not found" and "Server Error" are checked.
- Whether routes live in a file other than the entry file (the code checks read only the entry file).

---

## What is needed to run the grader

- Node.js and npm installed.
- Folder layout:

```
assignment-01/
├── grade-all.sh
├── submissions/     one unpacked folder per student, e.g. Jane_Doe_project/
└── proposals/       one .json per student, e.g. Jane_Doe.json
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
├── logs/<student>.log            what the grader did for that student
└── logs/<student>/<n>-<category>.log   one log per category (requests, answers, points)
```