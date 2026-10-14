// Assignment 1: Express Routing (MASTER REFERENCE)
// Routes a book selection page to static book pages named ISBN.html.
// Works for any student's proposal: no ISBNs are hardcoded here.

var express = require("express");
var http = require("http");
var path = require("path");
var logger = require("morgan");

// Construct the actual express object we will use
var app = express();

// Log every request (placed first so ALL requests are logged, including images)
app.use(logger("short"));

// Get path to the Pages directory (regardless of OS) using path.resolve
var pagesPath = path.resolve(__dirname, 'Pages');

// Serve static files such as /images/ISBN.jpg from the Pages directory
app.use(express.static(pagesPath));

// Home page at "/" sends back the book selection page
app.get("/", function(request, response) {
    response.sendFile('index.html', {root: pagesPath});
});

// A single method handles all book requests of the form /select/ISBN.
// Get the ISBN using request.params and add .html to get the file name.
app.get("/select/:isbn", function(request, response, next) {
    var bookfile = request.params.isbn + ".html";
    response.sendFile(bookfile, {root: pagesPath}, function(err) {
        if (err) { // If no such file, begin error routing
            next(new Error("book file not found"));
        }
    });
});

// First error handling routine for book requests logs the error
app.use("/select", function(err, request, response, next) {
    console.log(err);
    next(err); // Pass the error on to the next handler
});

// Next error handling routine sends File Not Found if the book file does not exist
app.use("/select", function(err, request, response, next) {
    if (err.message.includes("book file not found")) {
        response.writeHead(404, {'Content-Type': 'text/html'});
        response.end('<html><body><h2>File Not Found</h2></body></html>');
    }
    else {
        next(err); // If this was not the error, route to the next handler
    }
});

// If reach here, request not handled by any previous gets, so send File Not Found
app.use(function(request, response) {
    response.writeHead(404, {'Content-Type': 'text/html'});
    response.end('<html><body><h2>File Not Found</h2></body></html>');
});

// If reach here, an unhandled error occurred somewhere, so send Server Error
app.use(function(err, request, response, next) {
    console.log(err);
    response.writeHead(500, {'Content-Type': 'text/html'});
    response.end('<html><body><h2>Server Error</h2></body></html>');
});

// Have the app listen at port 3000
http.createServer(app).listen(3000);
