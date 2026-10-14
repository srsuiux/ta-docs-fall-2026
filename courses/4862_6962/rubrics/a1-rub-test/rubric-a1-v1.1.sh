#!/bin/bash
# rubric-a1.sh - Grader for Assignment 1: Express Routing
#
# How to use:
#   Put this file and the student's proposal.json in the student's project folder.
#   Then run:  bash rubric-a1.sh proposal.json
#   (Without proposal.json, the title, price, and name checks are rough or manual.)
#
# Needs Node.js. The student's app is started on port 3000 during grading.

if ! command -v node > /dev/null 2>&1; then
    echo "Node.js is not installed or not on PATH."
    exit 1
fi

# Write the grader to a temporary file, run it, then delete it
GRADER=$(mktemp "${TMPDIR:-/tmp}/grade_XXXXXX.js")
trap 'rm -f "$GRADER"' EXIT

cat > "$GRADER" << 'GRADER_EOF'
const fs = require("fs");
const path = require("path");
const http = require("http");
const { spawn } = require("child_process");

const PORT = 3000;

// Read the arguments: an optional folder and an optional proposal.json
const args = process.argv.slice(2);
const proposalArg = args.find(a => a.endsWith(".json"));
const dirArg = args.find(a => !a.endsWith(".json"));
const projectDir = path.resolve(dirArg || ".");
if (!fs.existsSync(projectDir)) {
    console.error(`Folder not found: ${projectDir}`);
    process.exit(1);
}
const projectName = path.basename(projectDir);
const proposal = proposalArg ? JSON.parse(fs.readFileSync(proposalArg, "utf8")) : null;

// ---------------------------------------------------------------
// Small helper functions
// ---------------------------------------------------------------

// Save the score for one rubric item
const results = [];
function record(section, item, max, score, note) {
    score = Math.max(0, Math.min(max, Math.round(score * 10) / 10));
    results.push({ section, item, max, score, note: note || "" });
}

const full = p => path.join(projectDir, p);
const exists = p => fs.existsSync(full(p));
const read = p => fs.readFileSync(full(p), "utf8");
const sleep = ms => new Promise(r => setTimeout(r, ms));

// Turn HTML into plain lowercase text
const textOf = html => html.replace(/<[^>]*>/g, " ").replace(/\s+/g, " ").toLowerCase();

// Make text lowercase with single spaces, for easy comparing
const norm = s => String(s).replace(/\s+/g, " ").trim().toLowerCase();

// Ask the student's server for a page. Gives up after 3 seconds.
function get(urlPath) {
    return new Promise(resolve => {
        const req = http.get({ host: "localhost", port: PORT, path: urlPath, timeout: 3000 }, res => {
            const chunks = [];
            res.on("data", c => chunks.push(c));
            res.on("end", () => resolve({
                status: res.statusCode,
                type: res.headers["content-type"] || "",
                body: Buffer.concat(chunks).toString("utf8")
            }));
        });
        req.on("timeout", () => { req.destroy(); resolve({ status: 0, type: "", body: "", error: "timeout" }); });
        req.on("error", e => resolve({ status: 0, type: "", body: "", error: e.code || e.message }));
    });
}

// Start the student's app with "node app.js" and wait until it answers
function startServer() {
    return new Promise(resolve => {
        let log = "";
        let exited = false;
        const child = spawn("node", ["app.js"], { cwd: projectDir });
        child.stdout.on("data", d => log += d);
        child.stderr.on("data", d => log += d);
        child.on("exit", () => exited = true);
        (async () => {
            const start = Date.now();
            while (Date.now() - start < 8000) {
                if (exited) return resolve({ child, ok: false, log: () => log });
                const r = await get("/");
                if (r.status > 0) return resolve({ child, ok: true, log: () => log });
                await sleep(300);
            }
            resolve({ child, ok: false, log: () => log });
        })();
    });
}

// ---------------------------------------------------------------
// Grading
// ---------------------------------------------------------------
async function main() {
    console.log(`\nGrading project: ${projectName}\n`);

    // Stop if something else is already using port 3000
    if ((await get("/")).status > 0) {
        console.error("Port 3000 is already in use. Stop the other server and try again.");
        process.exit(1);
    }

    // ===== PROJECT STRUCTURE (5 points) =====
    const S = "Project Structure";

    // Is there a Pages folder?
    const hasPages = exists("Pages") && fs.statSync(full("Pages")).isDirectory();
    record(S, "Pages/ folder exists", 2, hasPages ? 2 : 0, hasPages ? "" : "Pages/ not found");

    // Is there a Pages/images folder with the cover images?
    const images = exists("Pages/images")
        ? fs.readdirSync(full("Pages/images")).filter(f => /\.(jpe?g|png|gif|webp)$/i.test(f))
        : [];
    record(S, "Pages/images/ holds cover images", 2,
        images.length >= 3 ? 2 : images.length > 0 ? 1 : 0, `${images.length} image(s) found`);

    // Is express listed in package.json? (node_modules is not looked at.
    // If it is missing, the app will fail to start and the log will show it.)
    let pkgOk = false, pkgNote = "";
    if (exists("package.json")) {
        try {
            const pkg = JSON.parse(read("package.json"));
            const deps = Object.assign({}, pkg.dependencies, pkg.devDependencies);
            pkgOk = !!deps.express;
            if (!pkgOk) pkgNote = "express not listed in package.json";
        } catch (e) { pkgNote = "package.json could not be read"; }
    } else pkgNote = "package.json not found";
    record(S, "Dependencies listed in package.json", 1, pkgOk ? 1 : 0, pkgNote);

    // ===== NAMING CONVENTIONS (5 points) =====
    const N = "Naming Conventions";

    // Is the main file called app.js?
    const hasApp = exists("app.js");
    const otherJs = fs.readdirSync(projectDir).filter(f => f.endsWith(".js"));
    record(N, "Main file named app.js", 2, hasApp ? 2 : 0,
        hasApp ? "" : `app.js not found (found: ${otherJs.join(", ") || "none"})`);

    // Is index.html inside Pages?
    const hasIndex = exists("Pages/index.html");
    record(N, "index.html in Pages/", 1, hasIndex ? 1 : 0, hasIndex ? "" : "Pages/index.html not found");

    // Are the book pages named ISBN.html?
    const pageFiles = hasPages
        ? fs.readdirSync(full("Pages")).filter(f => f.endsWith(".html") && f !== "index.html")
        : [];
    const isbnPages = pageFiles.map(f => f.slice(0, -5)).filter(n => /^(\d{9}[\dXx]|\d{13})$/.test(n));
    let bookIsbns, matched;
    if (proposal) {
        bookIsbns = proposal.books.map(b => String(b.isbn).replace(/-/g, ""));
        matched = bookIsbns.filter(i => isbnPages.includes(i)).length;
    } else {
        bookIsbns = isbnPages.slice(0, 3);
        matched = bookIsbns.length;
    }
    record(N, "Book pages named ISBN.html", 2, 2 * matched / 3,
        `${matched}/3 matched (pages found: ${pageFiles.join(", ") || "none"})`);

    // ===== APP.JS: CHECKS BY READING THE CODE =====
    const A = "app.js";
    const src = hasApp ? read("app.js") : "";

    // Remove comments so they do not count as code
    const code = src.replace(/\/\*[\s\S]*?\*\//g, "").replace(/(^|[^:])\/\/.*$/gm, "$1");

    // One /select/:variable route that uses request.params (no partial credit)
    const dynRoutes = (code.match(/\.get\s*\(\s*["'`]\/select\/:\w+/g) || []).length;
    const litRoutes = (code.match(/\.get\s*\(\s*["'`]\/select\/[^:"'`]/g) || []).length;
    const usesParams = /\.params\s*(\.\w+|\[)/.test(code);
    let routeScore = 0, routeNote = "";
    if (litRoutes >= 2) routeNote = `${litRoutes} separate /select routes (one per book)`;
    else if (dynRoutes === 1 && usesParams) routeScore = 10;
    else if (dynRoutes >= 1) routeNote = "dynamic route found but request.params not used";
    else routeNote = "no /select/:variable route found";
    record(A, "Single /select/:variable route with request.params", 10, routeScore, routeNote);

    // sendFile with {root: ...} (no partial credit)
    const sendRoot = /\.sendFile\s*\([\s\S]{0,200}?root\s*:/.test(code);
    const sendAny = /\.sendFile\s*\(/.test(code);
    record(A, "sendFile with {root: ...}", 8, sendRoot ? 8 : 0,
        sendRoot ? "" : sendAny ? "sendFile used without root" :
        /readFile/.test(code) ? "uses fs.readFile instead of sendFile" : "sendFile not found");

    // path.resolve (no partial credit)
    const resolveUsed = /path\.resolve\s*\(/.test(code);
    record(A, "path.resolve for the path", 7, resolveUsed ? 7 : 0,
        resolveUsed ? "" : /path\.join\s*\(/.test(code) ? "uses path.join instead of path.resolve" : "path.resolve not found");

    // ===== APP.JS: CHECKS BY RUNNING THE APP =====
    let server = null;
    if (hasApp) server = await startServer();
    const running = server && server.ok;
    const down = running ? "" : "server did not start (see log below)";

    // Does "/" send back index.html?
    let homeScore = 0, homeNote = down;
    if (running) {
        const r = await get("/");
        const indexSrc = hasIndex ? read("Pages/index.html") : "";
        if (r.status === 200 && hasIndex && norm(r.body) === norm(indexSrc)) { homeScore = 5; homeNote = ""; }
        else if (r.status === 200 && /\/select\//.test(r.body)) { homeScore = 3; homeNote = "returns a selection page, but not the same as Pages/index.html"; }
        else homeNote = `GET / returned ${r.status || r.error}`;
    }
    record(A, "/ returns index.html", 5, homeScore, homeNote);

    // Open each book page through /select/ISBN
    const pages = {};
    if (running) for (const isbn of bookIsbns) pages[isbn] = await get(`/select/${isbn}`);

    // Do the cover images load from /images/...?
    let imgOk = 0;
    const imgSrcOk = {};
    if (running) {
        for (const isbn of bookIsbns) {
            const m = (pages[isbn].body || "").match(/<img[^>]*src\s*=\s*["']([^"']+)["']/i);
            if (!m) continue;
            const url = new URL(m[1], `http://localhost:${PORT}/select/${isbn}`);
            if (url.host !== `localhost:${PORT}`) continue; // image is on another website, not local
            const r = await get(url.pathname);
            const ok = r.status === 200 && r.type.startsWith("image");
            if (ok) imgOk++;
            imgSrcOk[isbn] = ok && m[1].startsWith("/images/");
        }
    }
    record(A, "Images served at /images/...", 7, 7 * imgOk / 3, running ? `${imgOk}/3 images loaded` : down);

    // A wrong ISBN must say "File Not Found" (no partial credit)
    let badScore = 0, badNote = down;
    if (running) {
        const r = await get("/select/0000000000000");
        if (/file\s*not\s*found/i.test(r.body)) { badScore = 10; badNote = ""; }
        else if (/server\s*error/i.test(r.body)) badNote = "returns Server Error instead of File Not Found";
        else badNote = `no 'File Not Found' message (status ${r.status || r.error})`;
    }
    record(A, "Nonexistent ISBN returns File Not Found", 10, badScore, badNote);

    // An unknown route must say "File Not Found" (no partial credit)
    let unkScore = 0, unkNote = down;
    if (running) {
        const r = await get("/no-such-route/xyz");
        if (/file\s*not\s*found/i.test(r.body)) { unkScore = 6; unkNote = ""; }
        else if (/cannot\s+get/i.test(r.body)) unkNote = "Express default 'Cannot GET' page, no catch-all handler";
        else unkNote = `no 'File Not Found' message (status ${r.status || r.error})`;
    }
    record(A, "Unknown route returns File Not Found", 6, unkScore, unkNote);

    // Other errors must send "Server Error".
    // Any way of doing it gets full credit. next(err) or a 4-argument
    // error handler is good practice but adds no extra points.
    const errText = /server\s*error/i.test(code);
    const errHandler = /\(\s*\w+\s*,\s*\w+\s*,\s*\w+\s*,\s*\w+\s*\)/.test(code);
    record(A, "Other errors return Server Error", 7, errText ? 7 : 0,
        !errText ? "no 'Server Error' response found"
        : errHandler ? "Server Error sent (uses a 4-argument error handler, good practice, no extra points)"
        : "Server Error sent (inside route code)");

    // Documentation: share of lines with comments (check by eye too)
    const lines = src.split("\n").filter(l => l.trim());
    const commentLines = lines.filter(l => /(^|[^:])\/\/|\/\*|^\s*\*/.test(l)).length;
    const ratio = lines.length ? commentLines / lines.length : 0;
    record(A, "Well documented", 5, ratio >= 0.15 ? 5 : ratio >= 0.07 ? 3 : ratio > 0 ? 1 : 0,
        `${Math.round(ratio * 100)}% comment lines (check by eye)`);

    // ===== HTML CONTENT (25 points) =====
    const H = "HTML Content";

    // Links in index.html must go through /select/ISBN, not straight to the .html files
    const indexSrc = hasIndex ? read("Pages/index.html") : "";
    const hrefs = [...indexSrc.matchAll(/href\s*=\s*["']([^"']+)["']/gi)].map(m => m[1]);
    const directLinks = hrefs.filter(h => /\.html?$/i.test(h));
    const selectLinks = hrefs.filter(h => /\/select\/[\w-]+\/?$/.test(h));
    const fullForm = selectLinks.filter(h => h.startsWith(`http://localhost:${PORT}/select/`)).length;
    let linkScore = 0, linkNote = "";
    if (directLinks.length) linkNote = `direct links to .html files: ${directLinks.join(", ")}`;
    else {
        linkScore = 10 * Math.min(selectLinks.length, 3) / 3;
        linkNote = `${selectLinks.length} /select/ links`;
        if (fullForm < selectLinks.length) linkNote += " (some are not the full http://localhost:3000/select/ form)";
    }
    record(H, "Index links use /select/ISBN", 10, linkScore, linkNote);

    // Check the title, image, price, and name on each book page
    let titles = 0, covers = 0, prices = 0, names = 0;
    const book = isbn => proposal ? proposal.books.find(b => String(b.isbn).replace(/-/g, "") === isbn) : null;
    for (const isbn of bookIsbns) {
        const r = pages[isbn];
        if (!r || r.status !== 200) continue;
        const text = textOf(r.body);
        const b = book(isbn);
        if (b ? text.includes(norm(b.title)) : /<(h[1-6]|title)[^>]*>\s*[^<\s]/i.test(r.body)) titles++;
        if (imgSrcOk[isbn]) covers++;
        if (b ? text.includes(String(b.price).replace("$", "")) : /\$\s?\d/.test(text)) prices++;
        if (proposal && proposal.student && text.includes(norm(proposal.student))) names++;
    }
    const auto = proposal ? "" : " (no proposal given: rough check, verify by eye)";
    record(H, "Title on each book page", 3, titles, `${titles}/3${auto}`);
    record(H, "Cover image via /images/... displays", 5, 5 * covers / 3, `${covers}/3`);
    record(H, "Price on each book page", 3, prices, `${prices}/3${auto}`);
    record(H, "Student name at bottom of each page", 4, 4 * names / 3,
        proposal ? `${names}/3 (check by eye that it is at the bottom)` : "MANUAL CHECK: no proposal given");

    // Stop the student's app
    if (server) server.child.kill();

    // ===== PRINT AND SAVE THE REPORT =====
    let report = `Grade report: ${projectName}\n${"=".repeat(60)}\n`;
    let total = 0, max = 0;
    for (const sec of [...new Set(results.map(r => r.section))]) {
        const rows = results.filter(r => r.section === sec);
        const sScore = rows.reduce((a, r) => a + r.score, 0);
        const sMax = rows.reduce((a, r) => a + r.max, 0);
        total += sScore; max += sMax;
        report += `\n${sec}: ${Math.round(sScore * 10) / 10} / ${sMax}\n`;
        for (const r of rows) {
            report += `  [${String(r.score).padStart(4)} / ${String(r.max).padEnd(2)}] ${r.item}`;
            report += r.note ? `  -- ${r.note}\n` : "\n";
        }
    }
    report += `\n${"=".repeat(60)}\nTOTAL: ${Math.round(total * 10) / 10} / ${max}\n`;
    if (server) {
        const tail = server.log().trim().split("\n").slice(-15).join("\n");
        report += `\nServer log (last lines):\n${tail || "(empty)"}\n`;
    }

    console.log(report);
    const out = `${projectName}_grade.txt`;
    fs.writeFileSync(out, report);
    console.log(`Report saved to ${out}`);
}

main();
GRADER_EOF

node "$GRADER" "$@"