#!/bin/bash
# Setup script for Assignment 1: Express Routing (master reference)
# Creates the full project, downloads book covers, and installs dependencies.

set -e

echo "Creating Pages/images directory..."
mkdir -p Pages/images

# ---------------------------------------------------------------
# package.json and dependencies
# ---------------------------------------------------------------
echo "Initializing npm and installing express and morgan..."
npm init -y > /dev/null
npm install express morgan

# ---------------------------------------------------------------
# app.js
# ---------------------------------------------------------------
echo "Writing app.js..."
cat > app.js << 'EOF'
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
EOF

# ---------------------------------------------------------------
# Pages/index.html
# ---------------------------------------------------------------
echo "Writing Pages/index.html..."
cat > Pages/index.html << 'EOF'
<html>
<body>
    <h2>Books by Sebastian Raschka</h2>
    <p>Select a book:</p>
    <ul>
        <li><a href="http://localhost:3000/select/9781633437166">Build a Large Language Model (From Scratch)</a></li>
        <li><a href="http://localhost:3000/select/9781633434677">Build a Reasoning Model (From Scratch)</a></li>
        <li><a href="http://localhost:3000/select/9781801819312">Machine Learning with PyTorch and Scikit-Learn</a></li>
    </ul>
</body>
</html>
EOF

# ---------------------------------------------------------------
# Book pages
# ---------------------------------------------------------------
echo "Writing book pages..."
cat > Pages/9781633437166.html << 'EOF'
<html>
<body>
    <h2>Build a Large Language Model (From Scratch)</h2>
    <img src="/images/9781633437166.jpg">
    <p>Price: $49.24</p>
    <p>Sundar Raj Sharma</p>
</body>
</html>
EOF

cat > Pages/9781633434677.html << 'EOF'
<html>
<body>
    <h2>Build a Reasoning Model (From Scratch)</h2>
    <img src="/images/9781633434677.jpg">
    <p>Price: $47.82</p>
    <p>Sundar Raj Sharma</p>
</body>
</html>
EOF

cat > Pages/9781801819312.html << 'EOF'
<html>
<body>
    <h2>Machine Learning with PyTorch and Scikit-Learn</h2>
    <img src="/images/9781801819312.jpg">
    <p>Price: $34.23</p>
    <p>Sundar Raj Sharma</p>
</body>
</html>
EOF

# ---------------------------------------------------------------
# Book cover images (downloaded and renamed to ISBN.jpg)
# ---------------------------------------------------------------
echo "Downloading book covers..."
UA="Mozilla/5.0"

download() {
    if curl -fsSL -A "$UA" -o "Pages/images/$2.jpg" "$1"; then
        echo "  Saved Pages/images/$2.jpg"
    else
        echo "  WARNING: could not download $1"
        echo "  Save it manually as Pages/images/$2.jpg"
    fi
}

set +e
download "https://m.media-amazon.com/images/I/41yqngwddyL.jpg" "9781633437166"
download "https://m.media-amazon.com/images/I/71Ahb2iunzL.jpg" "9781633434677"
download "https://m.media-amazon.com/images/I/51vUhSqDEmL.jpg" "9781801819312"
set -e

echo ""
echo "Done. To run the app:"
echo "  cd $PROJECT"
echo "  node app.js"
echo "Then open http://localhost:3000/"