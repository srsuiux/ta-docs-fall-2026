// Import required modules
const express = require("express");
const path = require("path");

// Create the Express application
const app = express();
const PORT = 3000;

// Set the path to the Pages directory
const pagesPath = path.resolve(__dirname, "Pages");

// Serve images from the Pages/images directory
app.use("/images", express.static(path.resolve(pagesPath, "images")));

// Handle the home page
app.get("/", (req, res) => {
    res.sendFile("index.html", { root: pagesPath }, (err) => {
        if (err) {
            console.error(err);
            res.status(500).send("Server Error");
        }
    });
});

// Handle requests for product pages
app.get("/select/:variable", (req, res) => {
    const filename = `${req.params.variable}.html`;

    res.sendFile(filename, { root: pagesPath }, (err) => {
        if (err) {
            if (err.statusCode === 404) {
                res.status(404).send("File Not Found");
            } else {
                console.error(err);
                res.status(500).send("Server Error");
            }
        }
    });
});

// fix added after v1.1
// If no route above matched, the page does not exist, so send File Not Found
app.use((req, res) => {
    res.status(404).send("File Not Found");
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
