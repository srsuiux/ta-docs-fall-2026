/**
 * Assignment 1: Express Routing
 * Author: Pratiksha Bam
 * Serves three static Emily Henry book pages using one parameterized route.
 */
const express = require('express');
const path = require('path');
const app = express();
const pagesDirectory = path.resolve(__dirname, 'Pages');
const bookISBNs = ['9780593440872', '9780593441190', '9780593441213'];

// Serve cover images at /images/... without exposing HTML pages as static files.
app.use('/images', express.static(path.resolve(pagesDirectory, 'images')));

// Send the selection page when the home URL is requested.
app.get('/', (request, response, next) => {
  response.sendFile('index.html', { root: pagesDirectory }, (error) => {
    if (error) next(error);
  });
});

// One shared route selects the ISBN-named HTML file for any of our books.
app.get('/select/:isbn', (request, response, next) => {
  const isbn = request.params.isbn;
  // Only allow our three ISBNs, preventing paths outside the book directory.
  if (!bookISBNs.includes(isbn)) {
    return response.status(404).type('text').send('File Not Found');
  }
  response.sendFile(`${isbn}.html`, { root: pagesDirectory }, (error) => {
    if (error) next(error);
  });
});

// Any URL that was not handled above is a nonexistent page.
app.use((request, response) => {
  response.status(404).type('text').send('404 Page not found');
});

// sendFile errors arrive here. Missing files are 404; other failures are 500.
app.use((error, request, response, next) => {
  if (response.headersSent) return next(error);
  if (error.code === 'ENOENT' || error.status === 404) {
    return response.status(404).type('text').send('File Not Found');
  }
  console.error('Request failed:', error.message);
  response.status(500).type('text').send('Server Error');
});

// Exporting the app allows tests to start an isolated server.
if (require.main === module) {
  app.listen(3000, () => {
    console.log('Book selection: http://localhost:3000/');
  });
}
module.exports = app;
