// importing express
var express = require("express");

// importing path to work with file locations
var path = require("path");

// creating the express application
var app = express();

// setting the path to the Pages folder
var pagesPath = path.resolve(__dirname, "Pages");

// allowing the browser to access files inside the Pages folder
app.use(express.static(pagesPath));


// home route that displays the book selection page
app.get("/", function(request, response) {

    // sending the index page to the browser
    response.sendFile("index.html", {root: pagesPath}, function(error) {

        if (error) {
            if (error.status === 404) {
                response.status(404).send("File Not Found");
            }
            else {
                response.status(500).send("Server Error");
            }
        }
    });

});


// dynamic route for selecting a book using its ISBN
app.get("/select/:book", function(request, response) {

    // getting the ISBN from the URL
    var bookNumber = request.params.book;

    // creating the filename using the ISBN
    var fileName = bookNumber + ".html";

    // sending the matching book page
    response.sendFile(fileName, {root: pagesPath}, function(error) {

        if (error) {
            if (error.status === 404) {
                response.status(404).send("File Not Found");
            }
            else {
                response.status(500).send("Server Error");
            }
        }
    });

});


// handling requests for pages that do not exist
app.use(function(request, response) {
    response.status(404).send("File Not Found");
});


// starting the application on port 3000
app.listen(3000);