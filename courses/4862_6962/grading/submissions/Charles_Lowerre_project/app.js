/**
 * Charles Lowerre
 * CSCI 4862/6962 - Assignment 1: Express Routing
 * Start with npm start, then visit http://localhost:3000/.
 */
'use strict';

const express = require('express');
const path = require('path');
const app = express();
const port = 3000;

// Resolve paths relative to this file so the app works on different OSes
// and does not depend on the directory from which Node was started.
const pagesDirectory = path.resolve(__dirname, 'Pages');
const imagesDirectory = path.resolve(pagesDirectory, 'images');
const bookISBNs = new Set([
  '9780441172719',
  '9780441172696',
  '9780441104055'
]);

// Serve only images as static files; book HTML must use the select route.
app.use('/images', express.static(imagesDirectory));
app.get('/styles.css', (request, response, next) => {
  response.sendFile('styles.css', { root: pagesDirectory }, (error) => {
    if (error) next(error);
  });
});

// Send the static selection page when the home page is requested.
app.get('/', (request, response, next) => {
  response.sendFile('index.html', { root: pagesDirectory }, (error) => {
    if (error) next(error);
  });
});

// A single dynamic route handles all three books. Only known ISBNs are
// accepted, which also prevents user input from selecting unrelated files.
app.get('/select/:isbn', (request, response, next) => {
  const isbn = request.params.isbn;
  if (!bookISBNs.has(isbn)) {
    return response.status(404).type('text/plain').send('File Not Found');
  }

  response.sendFile(`${isbn}.html`, { root: pagesDirectory }, (error) => {
    if (error) next(error);
  });
});

// Any URL that did not match an existing route is a missing page.
app.use((request, response) => {
  response.status(404).type('text/plain').send('File Not Found');
});

// sendFile and static-file errors are forwarded here. Express recognizes
// error middleware by its four parameters, including the next parameter.
app.use((error, request, response, next) => {
  if (response.headersSent) return next(error);

  if (error.code === 'ENOENT' || error.status === 404) {
    return response.status(404).type('text/plain').send('File Not Found');
  }

  console.error(error.message);
  response.status(500).type('text/plain').send('Server Error');
});

app.listen(port, () => {
  console.log(`Bookstore running at http://localhost:${port}/`);
});
