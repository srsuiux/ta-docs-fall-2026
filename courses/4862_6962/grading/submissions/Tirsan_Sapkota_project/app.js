var express = require("express");
var path = require("path");
var morgan = require("morgan");
var http = require("http");

// Construct the actual express object that we will use.
var app = express();

// Use external middleware logger to display information about requests
app.use(morgan("short"));

// Get a path to the Pages/images folder (regardless of OS) and serve it statically
var imagesPath = path.resolve(__dirname, "Pages", "images");
app.use("/images", express.static(imagesPath));

// Home page at "/": send back the product selection page
app.get("/", function (request, response) {
  var filePath = path.resolve(__dirname, "Pages", "index.html");

  response.sendFile(filePath, function (error) {
    if (error) {
      response.writeHead(500, { "Content-Type": "text/html" });
      response.end("Server Error");
    }
  });
});

// Single route handles all book pages: /select/:isbn
// request.params.isbn holds whatever the client put after /select/
app.get("/select/:isbn", function (request, response) {
  var isbn = request.params.isbn;
  var filePath = path.resolve(__dirname, "Pages", isbn + ".html");

  response.sendFile(filePath, function (error) {
    if (error) {
      // sendFile sets error.status to 404 when the file doesn't exist
      if (error.status === 404) {
        response.writeHead(404, { "Content-Type": "text/html" });
        response.end("File Not Found");
      } else {
        response.writeHead(500, { "Content-Type": "text/html" });
        response.end("Server Error");
      }
    }
  });
});

// Why not!
// Hello page at "/hello"
app.get("/hello", function (request, response) {
  response.writeHead(200, { "Content-Type": "text/html" });
  response.end("<html><body><h2> Hello World! </h2></body></html>");
});

// If reach here, request not handled by any previous gets, so send error page
app.use(function (request, response) {
  response.writeHead(404, { "Content-Type": "text/html" });
  response.end("File Not Found");
});

// Have the app listen at port 3000
http.createServer(app).listen(3000);
console.log("http:/localhost:3000")