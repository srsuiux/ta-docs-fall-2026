var express = require("express");
var http = require("http");
var path = require("path");

// Construct express obj
var app = express();

// Get path to book files
var bookPath = path.resolve(__dirname, 'Pages');
app.use(express.static(bookPath));

// Home page at "/" -- index page
app.get("/", function(request, response) {
    response.sendFile(path.join(__dirname, 'index.html'));
});

// Route to correct isbn/book from button user clicks on
app.get("/select/:book", function(request, response, next) {
    var bookfile = request.params.book + ".html";
    response.sendFile(bookfile, {root: bookPath}, function(err) {
        if (err) { // If no such file, begin error routing
            next(new Error("book isbn not found"));
        }
    });
});

// First error handling routine logs error 
app.use("/select", function(err, request, response, next) {
    console.log(err);
    next(err); // Create new error specific to problem
});

// Next error handling routine sends back error message (and halts) if file error
app.use("/select", function(err, request, response, next) {
    if (err.message.includes("book isbn not found")) {
        response.writeHead(200, {'Content-Type': 'text/html'});
        response.end('<html><body><h2>Error: Bad ISBN! Try again!</h2></body></html>');
    }
    else {
        next(err); // If this was not the error, route to the next handler
    }
});

// If reach here, request not handled by any previous gets, so send error page
app.use(function(request, response) {
    response.writeHead(404, {'Content-Type': 'text/html'});
    response.end('<html><body><h2>Sorry -- file not found!</h2></body></html>');
});

// If reach here, an unhandled error occured somewhere
app.use(function(err, request, response, next) {
    console.log(err);
    response.writeHead(500, {'Content-Type': 'text/html'});
    response.end('<html><body><h2>Server error!</h2></body></html>');
});

// Have the app listen at port 3000
http.createServer(app).listen(3000);