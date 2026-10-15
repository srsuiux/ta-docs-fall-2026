# Assignment 1: Express Routing

Charles Lowerre — CSCI 4862/6962

## Run the application

1. Extract the ZIP completely. Do not run the application inside the ZIP.
2. Open a terminal in the `Assignment1` folder containing `app.js`.
3. Run `npm start`.
4. Open http://localhost:3000/ in a browser.
5. Press Ctrl+C in the terminal to stop the server.

Node.js 18 or newer is required. The ZIP includes `node_modules` with Express
and its dependencies already installed. If dependencies are removed or need
restoring, run `npm ci`, then `npm start`.

## Pages and routes

| URL | Page | Price |
| --- | --- | --- |
| `/` | Book selection | — |
| `/select/9780441172719` | Dune | $11.00 |
| `/select/9780441172696` | Dune Messiah | $8.50 |
| `/select/9780441104055` | Children of Dune | $10.00 |

All three book links use the assignment's exact form:
`http://localhost:3000/select/ISBN`. One route, `/select/:isbn`, reads
`request.params.isbn` and sends the corresponding static HTML page using
`response.sendFile(filename, { root: pagesDirectory })`. Node's built-in
`path.resolve()` creates absolute, OS-compatible directory paths.

All HTML files are in `Pages`. Covers are stored in `Pages/images` and use
`/images/filename` URLs. The shared stylesheet is also in `Pages`.
Only image files are exposed as a static directory. Book HTML uses the
selection route. Each book page displays its title, cover, price, and the
student's name at the bottom.

Unknown routes and missing files return HTTP 404 with `File Not Found`.
Other server errors return HTTP 500 with `Server Error`.

## ISBN and cover notes

The three page filenames, links, and displayed ISBNs preserve the proposal's
values exactly. The provided Children of Dune value `9780441104055` does not
have a valid ISBN-13 check digit; the publisher lists the mass-market edition
as `9780441104024`. Its publisher cover is used for the Children of Dune page.
If the proposal is corrected later, update the HTML filename, the index link,
the displayed ISBN, and the allowed ISBN in `app.js` together.

Cover images were downloaded from Penguin Random House's cover service:

- Dune: https://images.penguinrandomhouse.com/cover/9780441172719
- Dune Messiah: https://images.penguinrandomhouse.com/cover/9780441172696
- Children of Dune: https://images.penguinrandomhouse.com/cover/9780441104024

Cover artwork belongs to its respective rights holders and is included for
this educational book-selection project.

## Submission

Submit `Assignment1.zip` through the assignment's Blackboard link. It contains
the complete application folder, including the installed dependencies.
The assignment uses `Pages` throughout its instructions and once says `Files`
in the submission paragraph; this project follows the specified `Pages` name.
