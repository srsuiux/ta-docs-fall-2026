# Assignment 1 (Express Routing): Grading Rubric

CSCI 4862 / 6962 Server-Side Development

Total: **17 points**. This is the final grade; there is no conversion. A score with a fraction is rounded up to the next whole point (14.42 becomes 15), and 17 is the maximum.

> **Source: Angello revised (project out of 17 points)**
>
> - Proper Routing of Books | 8: one method handles routing for all 3 books
> - Error Handling | 7: the method for handling a book not found is separate from a web page not found
> - Documentation | 1
> - HTML Content | 1: `<image src=/localdir>`, price, etc

The four categories and their totals are exactly the ones above. Rows marked † are the split inside a category, which the source does not give. Most items give partial credit, and every student also gets a detailed feedback page in `feedback/<student>.html` explaining each result and how to improve it.

| # | Category | Pts |
|---|---|---|
| 1 | Proper Routing of Books | 8 |
| 2 | Error Handling | 7 |
| 3 | Documentation | 1 |
| 4 | HTML Content | 1 |

---

## 1. Proper Routing of Books (8 pts)

One method handles routing for all 3 books.

| Item | Pts | Rule |
|---|---|---|
| One route for all 3 books | 3 | One `app.get("/select/:variable", ...)` that reads `request.params` = 3. Route without `request.params` = 1.5. Separate route per book = 1 |
| All 3 book pages served † | 3 | `/select/<ISBN>` returns a page for each of the 3 books (3 × pages ÷ 3) |
| Index page and links † | 1 | `GET /` returns the index page (0.5). Its links are `/select/ISBN` (0.5 × good links ÷ 3; each direct `.html` link cancels one good link) |
| `sendFile` with root † | 0.5 | `response.sendFile(file, {root: ...})` = 0.5. Without `root` = 0.25 |
| `path.resolve` † | 0.5 | `path.resolve(...)` = 0.5. `path.join` = 0.25 |

## 2. Error Handling (7 pts)

The handling of a book that is not found is separate from the handling of a web page that is not found.

| Item | Pts | Rule |
|---|---|---|
| Book not found † | 3 | `/select/0000000000000` returns "File Not Found" = 3. "Server Error" instead = 1 |
| Page not found † | 2 | `/no-such-route/xyz` returns a "not found" response from its own handler = 2. Express's default "Cannot GET" = 0 |
| Other errors † | 2 | A forced error returns "Server Error" = 2. Text only in the code but not returned = 1 |

## 3. Documentation (1 pt)

| Item | Pts | Rule |
|---|---|---|
| Comments in the entry file † | 1 | 10% or more of the lines are comments = 1; some comments = 0.5; none = 0 |

## 4. HTML Content (1 pt)

Each book page has a cover image tag, the price and the other basics. Each item is 0.25, scaled by pages ÷ 3.

| Item | Pts | Rule |
|---|---|---|
| Cover image tag | 0.25 | `<img src="/images/filename">` on each book page |
| Price | 0.25 | The proposal price is on each book page |
| Title † | 0.25 | The proposal title is on each book page |
| Student name † | 0.25 | The student's name is on each book page |

---

## Not scored

- Main file is called `app.js`
- `express` is in `dependencies`; `node_modules` included
- `Pages/` and `Pages/images/` folder layout
- 404 / 500 status codes
- Index links pointing at ISBNs that are not in the proposal

## How the checks work

- The app is started from the entry file in `package.json`. If it does not start, items that need it score 0 and the feedback page says why.
- Book pages are tested with the ISBNs in the student's own index links (hyphens ignored) and matched to the proposal. Titles and prices are checked against the proposal when the ISBN matches, and roughly otherwise.
- Routes are read from the entry file only. If a route is in another file, check by hand.
