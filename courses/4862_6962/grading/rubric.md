# Assignment 1 (Express Routing): Grading Rubric

CSCI 4862 / 6962 Server-Side Development

Total: **100 points**. Final grade = total ÷ 5, out of **20**.

| # | Category | Pts |
|---|---|---|
| 1 | Routing & File Handling | 25 |
| 2 | Error Handling | 25 |
| 3 | Pages Served | 20 |
| 4 | HTML Content | 20 |
| 5 | Startup & Documentation | 10 |

---

## 1. Routing & File Handling (25 pts)

| Item | Pts | Rule |
|---|---|---|
| Single route | 10 | Exactly one `app.get("/select/:variable", ...)` that uses `request.params`. Separate routes per book get 0 |
| `sendFile` with root | 8 | `response.sendFile(file, {root: ...})` |
| `path.resolve` | 7 | `path.resolve(...)` builds the path. `path.join` does not count |

## 2. Error Handling (25 pts)

| Item | Pts | Rule |
|---|---|---|
| Nonexistent ISBN | 10 | `/select/0000000000000` returns "File Not Found". "Server Error" instead gets 0 |
| Unknown route | 8 | `/no-such-route/xyz` returns a response containing "not found" in any wording. Express's default "Cannot GET" gets 0 |
| Other errors | 7 | A forced error returns "Server Error". Text only in the code, but not returned, gets 3 |

## 3. Pages Served (20 pts)

| Item | Pts | Rule |
|---|---|---|
| `/` | 5 | `GET /` returns the index page with `/select/` links |
| Book pages | 10 | `/select/<ISBN>` returns a page for each of the 3 proposal ISBNs (10 × pages ÷ 3) |
| Cover images | 5 | The `<img src="/images/...">` of each book page loads as an image (5 × images ÷ 3) |

## 4. HTML Content (20 pts)

| Item | Pts | Rule |
|---|---|---|
| Index links | 10 | Three index links of the form `/select/ISBN`. Each direct link to a `.html` file cancels one good link |
| Title | 3 | The proposal title is on each book page (1 pt per page) |
| Cover image tag | 4 | Each book page has `<img src="/images/filename">` (4 × pages ÷ 3) |
| Price | 3 | The proposal price is on each book page (1 pt per page) |

## 5. Startup & Documentation (10 pts)

| Item | Pts | Rule |
|---|---|---|
| Starts | 3 | The app starts with the entry file from `package.json` |
| express listed | 2 | `express` is in `dependencies` |
| Well documented | 5 | Comments in the entry file: 15% or more of lines = 5, 7% or more = 3, any = 1, none = 0 |
