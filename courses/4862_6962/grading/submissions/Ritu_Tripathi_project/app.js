/*
 * Name:        Ritu Tripathi
 * Course:      CSCI 4862/6962 - Server-Side Development and Programming
 * Assignment:  Assignment 1 - Express Routing
 *
 * Description:
 * A simple Node/Express application that routes requests to static HTML
 * pages for three books by Liu Cixin.
 *
 *   GET /                  -> sends the book selection page (index.html)
 *   GET /select/:variable  -> sends the book page whose file name is the
 *                             ISBN given in the URL (e.g. /select/9780765382030
 *                             sends 9780765382030.html)
 *
 * Errors:
 *   - Requested page does not exist -> "File Not Found" (404)
 *   - Any other error               -> "Server Error"   (500)
 *
 * Run with:  npm install   then   node app.js
 */

// Load the Express framework and Node's built-in path module.
const express = require("express");
const path = require("path");

// Create the Express application and choose the port to listen on.
const app = express();
const PORT = 3000;

// Build the absolute path to the Pages directory with path.resolve so the
// code works on any operating system (Windows, macOS, Linux).
// __dirname is the directory that contains this app.js file.
const pagesPath = path.resolve(__dirname, "Pages");

// Serve static files from Pages. This is what lets the book pages load their
// cover images through <img src="/images/filename.jpg">, because the file
// Pages/images/filename.jpg is made available at the URL /images/filename.jpg.
app.use(express.static(pagesPath));

/*
 * Home page route.
 * When http://localhost:3000/ is requested, send back the product selection
 * page, index.html, from the Pages directory.
 */
app.get("/", function (request, response) {
    response.sendFile("index.html", { root: pagesPath }, function (error) {
        // If sending the file fails, report a server error.
        if (error) {
            response.status(500).send("Server Error");
        }
    });
});

/*
 * Book page route (a single method handles ALL books).
 * A request such as /select/9780765382030 puts "9780765382030" into
 * request.params.variable. We add ".html" to build the file name and send
 * that file from the Pages directory.
 */
app.get("/select/:variable", function (request, response) {
    // Build the file name from the ISBN in the URL, e.g. "9780765382030.html".
    const filename = request.params.variable + ".html";

    response.sendFile(filename, { root: pagesPath }, function (error) {
        if (error) {
            if (error.code === "ENOENT" || error.status === 404) {
                // The file does not exist (e.g. an ISBN that is not one of ours).
                response.status(404).send("File Not Found");
            } else {
                // Any other kind of error while sending the file.
                response.status(500).send("Server Error");
            }
        }
    });
});

/*
 * Catch-all handler for any other URL that no route above matched.
 * It must come after all other routes, so it only runs when nothing else did.
 */
app.use(function (request, response) {
    response.status(404).send("File Not Found");
});

/*
 * Error-handling middleware (four parameters tell Express this is an error
 * handler). It catches any unexpected error thrown elsewhere in the app.
 */
app.use(function (error, request, response, next) {
    response.status(500).send("Server Error");
});

// Start the server and print a message so we know it is running.
app.listen(PORT, function () {
    console.log("Server running at http://localhost:" + PORT);
});
