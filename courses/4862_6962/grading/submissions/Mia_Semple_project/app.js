// Mia Semple
// Y00869288
// CSIS_4862

const express = require("express");
const path = require("path");
const app = express();

// Static Files (images)
app.use(express.static(path.resolve(__dirname, "Pages")));

// Home page

app.get("/", (req, res) => {

    const indexPath = path.resolve(__dirname, "Pages", "index.html");

    res.sendFile(indexPath, (err) => {

        if (err) {

            res.status(500).send("Server Error");

        }

    });

});

// Dynamic routing

app.get("/select/:variable", (req, res) => {

        const fileName = req.params.variable + ".html";
        const filePath = path.resolve(__dirname, "Pages", fileName);

        res.sendFile(filePath, (err) => {

            if (err) {

                if (err.code === "ENOENT") {

                    res.status(404).send("File Not Found");

                } else {

                    res.status(500).send("Server Error");

                }

            }

        });

});

app.listen(3000, () => {

    console.log("Server running on port 3000");

});