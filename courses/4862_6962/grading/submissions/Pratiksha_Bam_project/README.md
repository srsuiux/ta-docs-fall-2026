# Assignment 1 Express Routing

Author: Pratiksha Bam  
Course: CSCI 4862 Server-Side Development and Programming

## Run

1. Extract the entire ZIP file.
2. Open a terminal in the extracted `Assignment1` directory (the directory containing `app.js`).
3. Run `npm start` or `node app.js`.
4. Open http://localhost:3000/ in a web browser.
5. Press Ctrl+C in the terminal to stop the server.

Node.js must be installed. Installed Express middleware is included in `node_modules`. If dependencies need to be restored, run `npm ci`.
Do not open the HTML files directly: the root-relative image paths and selection links work through the running Express app.

## Proposal books

| Title | ISBN-13 | Proposal price |
| --- | --- | --- |
| Book Lovers | 9780593440872 | $17.00 |
| Happy Place | 9780593441190 | $19.00 |
| Funny Story | 9780593441213 | $19.00 |

All three books are by Emily Henry. ISBN hyphens are omitted from filenames and URLs; the digits match the proposal.
The prices are taken from the proposal, rather than current retailer prices.

## Structure and routing

- `app.js`: documented Node/Express application.
- `Pages/index.html`: selection page with absolute localhost `/select/ISBN` links.
- `Pages/ISBN.html`: three static book pages, each with title, image, price, and student name.
- `Pages/images/ISBN.jpg`: local cover image files served at `/images/ISBN.jpg`.
- `package.json`, `package-lock.json`, `node_modules`: Express dependency and installed middleware.
- `test/routing.test.js`: automated HTTP checks; run `npm test`.

A single `app.get('/select/:isbn', ...)` route uses `request.params.isbn` to select the page.
`path.resolve` creates portable absolute directories, and `response.sendFile` sends the HTML files using its `root` option.
Nonexistent pages respond with status 404 and `File Not Found`. Other file errors respond with status 500 and `Server Error`.
Only the image directory is exposed as static content, so books are selected through the app route.
The assignment's final reference to a “Files” subdirectory appears to be a typo: this project uses `Pages` and `Pages/images` as specified throughout the instructions and demonstrated in the video.

## Cover sources

Publisher cover images, saved locally for this educational assignment:
- https://images.penguinrandomhouse.com/cover/9780593440872
- https://images.penguinrandomhouse.com/cover/9780593441190
- https://images.penguinrandomhouse.com/cover/9780593441213

Book cover artwork belongs to its respective rights holders.

## Submit

Upload `Assignment1.zip` to the assignment link in Blackboard. The ZIP includes the complete application directory and installed dependencies.
