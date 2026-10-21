/*
 * Assignment 1 - Book Routing with Node and Express
 * Name: Pradeep Poudel
 *
 * This is my app.js file. It runs a small Express server on port 3000.
 * When you go to the home page it shows my book selection page (index.html),
 * and when you click a book it uses the ISBN in the URL to find and send
 * the right book page. All my html pages are in the Pages folder.
 *
 * To run it: node app.js, then go to http://localhost:3000/
 */

// I need express for the server and path to build the file path
const express = require("express");
const path = require("path");

const app = express();
const PORT = 3000;

// I used path.resolve here so the path to my Pages folder works on
// any computer (Windows uses \ and Mac/Linux use /)
const PAGES_DIR = path.resolve(__dirname, "Pages");

// This lets the browser load my book cover images. When a page asks for
// /images/placeholder.jpg it gets the file from Pages/images
app.use(express.static(PAGES_DIR));

// I made this function so I don't repeat the same sendFile code twice.
// It sends the file and if something goes wrong it sends back an error.
function sendPage(response, filename) {
  response.sendFile(filename, { root: PAGES_DIR }, function (err) {
    if (err) {
      // printing this helped me check which file it was looking for
      console.log("Tried to open:", path.join(PAGES_DIR, filename));

      // if the file does not exist, send File Not Found
      if (err.code === "ENOENT" || err.status === 404) {
        response.status(404).send("File Not Found");
      }
      // anything else is a server error
      else {
        console.log(err);
        response.status(500).send("Server Error");
      }
    }
  });
}

// Home page - send back the book selection page
app.get("/", function (request, response) {
  sendPage(response, "index.html");
});

// This one route handles all three books. The :isbn part of the URL
// gets saved in request.params.isbn, so I just add .html to it to get
// the file name (for example 9780441013593 -> 9780441013593.html)
app.get("/select/:isbn", function (request, response) {
  let isbn = request.params.isbn;
  sendPage(response, isbn + ".html");
});

// If the URL doesn't match any of my routes, send File Not Found
app.use(function (request, response) {
  response.status(404).send("File Not Found");
});

// If any other error happens, send Server Error
app.use(function (err, request, response, next) {
  console.log(err);
  response.status(500).send("Server Error");
});

// Start the server
app.listen(PORT, function () {
  console.log("Server running at http://localhost:" + PORT + "/");
});
