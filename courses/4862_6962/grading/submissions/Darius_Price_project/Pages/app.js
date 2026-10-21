const express = require("express");
const path = require("path");

const app = express();
const PORT = 3000;

// Allow images to load
app.use("/images", express.static(path.join(__dirname, "images")));

// Home page
app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "Index.html"));
});

// Dynamic ISBN route
app.get("/select/:isbn", (req, res) => {
    const isbn = req.params.isbn;

    const validISBNs = [
        "014044792X",
        "0140449132",
        "1685781152"
    ];

    if (validISBNs.includes(isbn)) {
        res.sendFile(path.join(__dirname, isbn + ".html"));
    } else {
        res.status(404).send(`
            <h1>404 - Book Not Found</h1>
            <p>The ISBN ${isbn} does not exist.</p>
        `);
    }
});

// nonexistent pages
app.use((req, res) => {
    res.status(404).send(`
        <h1>404 - Page Not Found</h1>
        <p>The page you requested does not exist.</p>
    `);
});

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});