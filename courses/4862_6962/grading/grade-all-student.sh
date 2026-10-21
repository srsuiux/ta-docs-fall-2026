#!/bin/bash
# grade-all.sh - Grade every student project in submissions/ and build one summary.
#
#   bash grade-all.sh                  # everyone
#   bash grade-all.sh --only <id>      # one student again, e.g.  --only charles_lowerre
#
# Folders (submissions/ and proposals/ go next to this file, or one level up from it):
#   submissions/   one unpacked project folder per student      e.g.  Charles_Lowerre_project/
#   proposals/     one proposal file per student, in .json      e.g.  Charles_Lowerre.json
#   results/       created by this script:
#                    summary.csv              one row per student (start here)
#                    reports/<id>_feedback.txt the feedback letter for the student
#                    reports/<id>_grade.txt   the score report for the grader (and _grade.json)
#                  feedback/            (next to results/) one detailed feedback page per student: <id>.html, plus index.html
#                    logs/<id>.log            that student's copy, npm and grader output
#                    logs/<id>/<n>-<category>.log   one log per rubric category
#                    logs/<id>_app.log        what the student's own app printed while tested
#                    run.log                  everything the run printed
#
# The student id is the folder (or .json) name in lowercase, without a trailing "_project",
# "_submission" or "_proposal", so  Charles_Lowerre_project  and  Charles_Lowerre.json  both
# become  charles_lowerre  and are matched to each other.
#
# Proposal .json format:
#   { "student": "Jane Doe",
#     "books": [ { "isbn": "...", "title": "...", "price": "..." }, ...exactly 3 books... ] }
#
# For each student: copy the folder to a temporary place (the original is never touched), run
# "npm install" there if express is missing, run the grader (built into this file), delete the copy.
#
# Needs: bash, node, npm, tar.  The terminal shows one line per student; everything else is in
# the logs.

set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -d "$HERE/submissions" ]; then ROOT="$HERE"; else ROOT="$(cd "$HERE/.." && pwd)"; fi
SUBMISSIONS="$ROOT/submissions"
PROPOSALS="$ROOT/proposals"
RESULTS="$ROOT/results"
REPORTS="$RESULTS/reports"
LOGS="$RESULTS/logs"
PROPOSAL_COPIES="$RESULTS/proposals"
CACHE="$RESULTS/.cache"
FEEDBACK="$ROOT/feedback"
LOG="$RESULTS/run.log"
META="$RESULTS/meta.tsv"

# ---------------------------------------------------------------
# Options
# ---------------------------------------------------------------
ONLY=""
while [ $# -gt 0 ]; do
    case "$1" in
        --only) ONLY="$(printf '%s' "${2:-}" | tr 'A-Z' 'a-z')"; shift 2 ;;
        -h|--help) sed -n '2,29p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
        *) echo "Unknown option: $1 (try --help)"; exit 1 ;;
    esac
done

# ---------------------------------------------------------------
# Checks before starting (these go to the terminal)
# ---------------------------------------------------------------
fail=0
for c in node npm tar; do
    command -v "$c" > /dev/null 2>&1 || { echo "Missing program: $c"; fail=1; }
done
[ -d "$SUBMISSIONS" ] || { echo "Folder not found: $SUBMISSIONS"; fail=1; }
[ -d "$PROPOSALS" ]   || { echo "Folder not found: $PROPOSALS"; fail=1; }
[ "$fail" -eq 0 ] || exit 1

# A full run starts clean, so no old report can be mistaken for a new one.
# (--only keeps the other students' results and replaces just this one.)
if [ -z "$ONLY" ]; then
    rm -rf "$REPORTS" "$LOGS" "$PROPOSAL_COPIES" "$META" "$RESULTS/summary.csv" "$RESULTS/feedback.md" "$FEEDBACK"
fi
mkdir -p "$REPORTS" "$LOGS" "$PROPOSAL_COPIES" "$CACHE"

# ---------------------------------------------------------------
# Logging: fd 3 is the terminal. Everything else goes to run.log.
# ---------------------------------------------------------------
[ -z "$ONLY" ] && : > "$LOG"
exec 3>&1
exec >> "$LOG" 2>&1

say() {                       # a short line for the terminal, also kept in the log
    local m
    m="$(printf "$@")"
    printf '%s\n' "$m" >&3
    printf '%s\n' "$m"
}

echo "=== grade-all started $(date) ==="

# Port 3000 is what most student apps use. If another program holds it, no app can be tested.
holder="$(lsof -nP -iTCP:3000 -sTCP:LISTEN 2> /dev/null | awk 'NR == 2 { print $1 " (PID " $2 ")" }')"
if [ -n "$holder" ]; then
    say 'Port 3000 is already in use by %s on this computer.' "$holder"
    say 'Student apps that use port 3000 cannot be tested while it is busy. Close it, then run again.'
    say 'To close it:  kill %s' "$(printf '%s' "$holder" | sed -E 's/.*PID ([0-9]+).*/\1/')"
    exit 1
fi

echo "root: $ROOT"

TMPBASE="$(mktemp -d "${TMPDIR:-/tmp}/grade-all.XXXXXX")"
trap 'rm -rf "$TMPBASE"' EXIT

# ---------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------

# Student id from a folder name or a file name without its extension
student_id() {
    printf '%s' "$1" | tr 'A-Z' 'a-z' \
        | sed -E 's/[_ -]*(project|submission|proposal)$//' \
        | tr -c 'a-z0-9' '_' | sed -E 's/_+/_/g; s/^_//; s/_$//'
}

# Checks a proposal .json. Prints the problem and returns 1 if it cannot be used.
check_proposal() {
    node -e '
        let d;
        try { d = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")); }
        catch (e) { console.log("not valid JSON (" + e.message + ")"); process.exit(1); }
        if (!d || !Array.isArray(d.books)) { console.log("no \"books\" list"); process.exit(1); }
        if (d.books.length !== 3) { console.log("has " + d.books.length + " books, needs exactly 3"); process.exit(1); }
        const bad = d.books.findIndex(b => !b || !String(b.isbn || "").replace(/[^0-9Xx]/g, ""));
        if (bad >= 0) { console.log("book " + (bad + 1) + " has no isbn"); process.exit(1); }
    ' "$1"
}

# One shared copy of express, used only when a student's project has none
ensure_fallback() {
    if [ ! -d "$CACHE/node_modules/express" ]; then
        echo "--- installing the fallback copy of express ---"
        npm install express --prefix "$CACHE" --ignore-scripts --no-audit --no-fund --loglevel=error
    fi
    [ -d "$CACHE/node_modules/express" ]
}

# One line in meta.tsv per student (replaces an older line for the same student)
write_meta() {   # id folder modules proposal notes
    if [ -f "$META" ]; then
        awk -F'\t' -v id="$1" '$1 != id' "$META" > "$META.tmp" && mv "$META.tmp" "$META"
    fi
    printf '%s\t%s\t%s\t%s\t%s\n' "$1" "$2" "$3" "$4" "$5" >> "$META"
}

# ---------------------------------------------------------------
# Grade one student
# ---------------------------------------------------------------
grade_one() {
    local id="$1" folder="$2" copies="$3" position="$4" count="$5"
    local name work src app root rel depth nm="" notes="" pj="" pfile pstatus pmsg rc fallback=0 grade
    local slog="$LOGS/$id.log"

    name="$(basename "$folder")"
    work="$(mktemp -d "$TMPBASE/$id.XXXXXX")"
    src="$work/src"
    mkdir -p "$src"
    printf '=== %s  (%s)  %s ===\n' "$id" "$name" "$(date)" > "$slog"
    echo "--- $id: $name ---"
    [ "$copies" -gt 1 ] && notes="$copies folders for this student, graded the last one"

    # 1. Copy the project (the original stays untouched)
    ( cd "$folder" && tar -cf - . ) 2>> "$slog" | tar -xf - -C "$src" 2>> "$slog"
    rm -rf "$src/__MACOSX"

    # 2. Find the project folder: the shallowest package.json folder that has an entry file
    #    (main, a file in scripts.start/dev, or app.js/index.js/server.js); else the first
    #    package.json; else the folder holding app.js
    app=""
    first=""
    while IFS= read -r pj_file; do
        [ -z "$first" ] && first="$pj_file"
        if node -e '
            const fs = require("fs"), path = require("path");
            const dir = path.dirname(process.argv[1]);
            let p = {}; try { p = JSON.parse(fs.readFileSync(process.argv[1], "utf8")); } catch (e) {}
            const s = p.scripts || {}, c = [p.main];
            const m = (s.start || s.dev || s.serve || "").match(/(?:node|nodemon)\s+(?:-\S+\s+)*([^\s&|;]+\.[cm]?js)/);
            if (m) c.push(m[1]);
            c.push("app.js", "index.js", "server.js");
            process.exit(c.some(f => f && fs.existsSync(path.join(dir, f)) && fs.statSync(path.join(dir, f)).isFile()) ? 0 : 1);
        ' "$pj_file" 2>> "$slog"; then app="$pj_file"; break; fi
    done < <(find "$src" -maxdepth 4 -name package.json -not -path '*/node_modules/*' 2>> "$slog" \
             | awk '{ n = gsub("/", "/"); print n " " $0 }' | sort -n | cut -d' ' -f2-)
    [ -z "$app" ] && app="$first"
    [ -z "$app" ] && app="$(find "$src" -maxdepth 4 -name app.js -not -path '*/node_modules/*' 2>> "$slog" \
           | awk '{ n = gsub("/", "/"); print n " " $0 }' | sort -n | head -1 | cut -d' ' -f2-)"
    if [ -n "$app" ]; then
        root="$(dirname "$app")"
    else
        root="$src"
        notes="${notes:+$notes; }no package.json or app.js found in the submission"
    fi
    rel="${root#$src}"
    depth="$(printf '%s' "$rel" | tr -cd '/' | wc -c | tr -d ' ')"
    [ "$depth" -ge 2 ] && notes="${notes:+$notes; }project is nested $depth folders deep"
    echo "project folder: ${rel:-/}" >> "$slog"

    # 3. Make sure express is available: theirs, else npm install, else the shared copy
    if [ -d "$root/node_modules/express" ]; then
        nm="included"
    else
        if [ -f "$root/package.json" ]; then
            echo "--- npm install ---" >> "$slog"
            ( cd "$root" && npm install --ignore-scripts --no-audit --no-fund --loglevel=error ) >> "$slog" 2>&1
        else
            echo "no package.json, skipping npm install" >> "$slog"
        fi
        if [ -d "$root/node_modules/express" ]; then
            nm="installed by grader (not in submission)"
        elif ensure_fallback >> "$slog" 2>&1; then
            fallback=1
            nm="express missing, graded with a fallback copy"
        else
            nm="express missing and could not be installed"
        fi
    fi

    # 4. Proposal: proposals/<same id>.json
    pstatus="no proposal .json for this student"
    pfile="$(awk -F'\t' -v id="$id" '$1 == id { print $2; exit }' "$TMPBASE/props.tsv")"
    if [ -n "$pfile" ]; then
        if pmsg="$(check_proposal "$PROPOSALS/$pfile")"; then
            cp "$PROPOSALS/$pfile" "$PROPOSAL_COPIES/$id.json"
            pj="$PROPOSAL_COPIES/$id.json"
            pstatus="$pfile"
        else
            pstatus="$pfile not usable: $pmsg"
        fi
    fi
    echo "proposal: $pstatus" >> "$slog"
    [ -z "$pj" ] && notes="${notes:+$notes; }$pstatus"

    # 5. Grade it. Remove old results first so a failed run can never show an old grade.
    rm -f "$REPORTS/${id}_grade.txt" "$REPORTS/${id}_grade.json" "$LOGS/${id}_app.log"
    echo "--- grader ---" >> "$slog"
    (
        [ "$fallback" -eq 1 ] && export NODE_PATH="$CACHE/node_modules"
        node "$TMPBASE/grader.js" "$root" ${pj:+"$pj"} --out "$REPORTS" --name "$id" --log "$LOGS/${id}_app.log" --catlogs "$LOGS/$id" --top "$src"
    ) >> "$slog" 2>&1
    rc=$?
    [ "$rc" -ne 0 ] && notes="${notes:+$notes; }grader failed (exit $rc, see logs/$id.log)"

    write_meta "$id" "$name" "$nm" "$pstatus" "$notes"

    grade="not graded"
    if [ -f "$REPORTS/${id}_grade.json" ]; then
        grade="$(node -p "const g = require('$REPORTS/${id}_grade.json'); g.grade + '/17  (' + g.total + ' points)'" 2>> "$slog")"
    fi
    say '[%s/%s] %-24s %s' "$position" "$count" "$id" "$grade"

    rm -rf "$work"
}

# ---------------------------------------------------------------
# The summary (results/summary.csv), built from meta.tsv and the reports
# ---------------------------------------------------------------
cat > "$TMPBASE/summary.js" << 'SUMMARY_EOF'
const fs = require("fs"), path = require("path");
const dir = process.argv[2];      // node summary.js <results folder>
// Text starting with = + - @ gets a leading apostrophe so a spreadsheet never runs it as a formula
const cell = v => {
    let s = String(v === undefined || v === null ? "" : v);
    if (/^[=+\-@]/.test(s) && !/^-?\d+(\.\d+)?$/.test(s)) s = "'" + s;
    return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
};
const rows = fs.readFileSync(path.join(dir, "meta.tsv"), "utf8").split("\n").filter(Boolean)
    .map(l => { const [id, folder, modules, proposal, notes] = l.split("\t"); return { id, folder, modules, proposal, notes: notes || "" }; })
    .sort((a, b) => a.id.localeCompare(b.id));
const CATS = ["Proper Routing of Books", "Error Handling", "Documentation", "HTML Content"];
const out = [["student", "grade_out_of_17", "points", ...CATS.map(c => c + " (pts)"), "items_to_review", "flags", "proposal", "folder"].join(",")];
let graded = 0, look = 0;
for (const r of rows) {
    const flags = [];
    if (r.notes) flags.push(r.notes);
    if (r.modules && r.modules !== "included") flags.push("node_modules: " + r.modules);
    let g = null, grade = "", points = "", zeros = "", cats = CATS.map(() => "");
    const jp = path.join(dir, "reports", r.id + "_grade.json");
    if (fs.existsSync(jp)) { try { g = JSON.parse(fs.readFileSync(jp, "utf8")); } catch (e) { flags.push("report could not be read"); } }
    if (g) {
        graded++; grade = g.grade; points = g.total;
        cats = CATS.map(c => g.categories && g.categories[c] ? `${g.categories[c].score}/${g.categories[c].max}` : "");
        zeros = g.items.filter(i => i.score < i.max).map(i => i.item).join("; ");
        if (!g.started) flags.push(g.startNote ? "NOT TESTED: " + g.startNote : "app did not start");
        flags.push(...(g.flags || []));
    } else if (r.folder) flags.push("NOT GRADED");
    if (zeros || flags.length) look++;
    out.push([r.id, grade, points, ...cats, zeros, flags.join("; "), r.proposal, r.folder].map(cell).join(","));
}
fs.writeFileSync(path.join(dir, "summary.csv"), "﻿" + out.join("\n") + "\n");
console.log(`Summary saved to ${path.join(dir, "summary.csv")}`);
console.log(`${graded} graded, ${rows.length - graded} not graded, ${look} with items to look at`);

SUMMARY_EOF

# ---------------------------------------------------------------
# The grader (the 17-point rubric: routing 8, error handling 7, documentation 1, HTML content 1).
# Started once per student. Writes a grade report and a feedback letter for the student.
# ---------------------------------------------------------------
cat > "$TMPBASE/grader.js" << 'GRADER_EOF'
const fs = require("fs");
const path = require("path");
const http = require("http");
const { spawn, execFile } = require("child_process");

// The port is found after the student's app starts (any valid port is fine)
let PORT = 0;
// The entry file named in package.json (any .js file); set in main()
let ENTRY = "app.js";

// Read the arguments: an optional folder and an optional proposal.json
const args = process.argv.slice(2);
let proposalArg, dirArg, outDir = ".", nameArg, logArg, catLogDir, topArg;
for (let i = 0; i < args.length; i++) {
    if (args[i] === "--out") outDir = args[++i];
    else if (args[i] === "--name") nameArg = args[++i];
    else if (args[i] === "--log") logArg = args[++i];
    else if (args[i] === "--catlogs") catLogDir = args[++i];
    else if (args[i] === "--top") topArg = args[++i];
    else if (args[i].endsWith(".json")) proposalArg = args[i];
    else dirArg = args[i];
}
const projectDir = path.resolve(dirArg || ".");
if (!fs.existsSync(projectDir)) {
    console.error(`Folder not found: ${projectDir}`);
    process.exit(1);
}
const projectName = nameArg || path.basename(projectDir);
// The top of what the student handed in (the project folder may be a subfolder of it)
const topDir = path.resolve(topArg || projectDir);
let proposal = null;
if (proposalArg) {
    try { proposal = JSON.parse(fs.readFileSync(proposalArg, "utf8")); }
    catch (e) { console.error(`Could not read ${proposalArg}: ${e.message}`); process.exit(1); }
    if (!proposal.books || proposal.books.length !== 3) {
        console.error("proposal.json must list exactly 3 books."); process.exit(1);
    }
}

// ---------------------------------------------------------------
// Small helper functions
// ---------------------------------------------------------------

// Save the score for one rubric item.
//   fb = { code, ok, fix, example }  is what the student's feedback letter says about the item:
//   code = their own line of code, ok = praise when the item is full marks,
//   fix = what to change when it is not, example = a short code sample to learn from.
const results = [];
function record(section, item, max, score, note, fb) {
    score = Math.max(0, Math.min(max, Math.round(score * 100) / 100));
    results.push({ section, item, max, score, note: note || "", fb: fb || {} });
}

// Extra lines for a category log (what was requested, what came back)
const details = {};
function detail(section, text) { (details[section] = details[section] || []).push(text); }

const full = p => path.join(projectDir, p);
const exists = p => fs.existsSync(full(p));
const read = p => fs.readFileSync(full(p), "utf8");
const sleep = ms => new Promise(r => setTimeout(r, ms));

// Turn HTML into plain lowercase text (scripts and styles removed)
const textOf = html => html
    .replace(/<(script|style)[\s\S]*?<\/\1>/gi, " ")
    .replace(/<[^>]*>/g, " ").replace(/\s+/g, " ").toLowerCase();

// Make text lowercase with single spaces, for easy comparing
const norm = s => String(s).replace(/\s+/g, " ").trim().toLowerCase();
// Same, but "&" = "and", curly quotes = straight quotes, and spaces around hyphens do not matter
// (so "Crime & Punishment" matches "Crime and Punishment"). Page text is decoded first.
const normT = s => norm(String(s).replace(/&amp;/g, "&").replace(/&(rsquo|lsquo|apos|#39|#8217);/g, "'").replace(/&quot;/g, '"'))
    .replace(/[\u2018\u2019`]/g, "'").replace(/[\u201C\u201D]/g, '"').replace(/\s*&\s*/g, " and ").replace(/\s*[-\u2010-\u2014]\s*/g, "-").replace(/\s+/g, " ");

// Ask the student's server for a page. Gives up after 3 seconds.
function get(urlPath, port) {
    port = port || PORT;
    return new Promise(resolve => {
        if (!port) return resolve({ status: 0, type: "", body: "", error: "no port" });
        const req = http.get({ host: "localhost", port, path: urlPath, timeout: 3000 }, res => {
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

// Run a system command and return its output ("" if it fails or is missing)
function run(cmd, cmdArgs) {
    return new Promise(res => execFile(cmd, cmdArgs, { timeout: 3000 }, (e, out) => res(out ? String(out) : "")));
}

// Find the TCP ports a process is listening on (works on Mac, Linux, Windows)
async function listeningPorts(pid) {
    const ports = new Set();
    let out = await run("lsof", ["-nP", "-a", "-p", String(pid), "-iTCP", "-sTCP:LISTEN"]);
    for (const m of out.matchAll(/:(\d+)\s+\(LISTEN\)/g)) ports.add(+m[1]);
    if (ports.size) return [...ports];
    out = await run("ss", ["-ltnpH"]);
    for (const line of out.split("\n")) {
        if (!line.includes(`pid=${pid},`)) continue;
        const col = line.trim().split(/\s+/)[3] || "";
        const p = +col.split(":").pop();
        if (p) ports.add(p);
    }
    if (ports.size) return [...ports];
    out = await run("netstat", ["-ano"]);
    for (const line of out.split("\n")) {
        const c = line.trim().split(/\s+/);
        if (/LISTEN/i.test(line) && c[c.length - 1] === String(pid)) {
            const p = +(c[1] || "").split(":").pop();
            if (p) ports.add(p);
        }
    }
    return [...ports];
}

// Backup plan if the tools above are missing: ports written in the student's code
function portsFromCode(src) {
    const found = new Set();
    for (const m of src.matchAll(/\.listen\s*\(\s*(\d{2,5})/g)) found.add(+m[1]);
    for (const m of src.matchAll(/\bport\s*=\s*(?:process\.env\.PORT\s*\|\|\s*)?(\d{2,5})/gi)) found.add(+m[1]);
    found.add(3000);
    return [...found];
}

// Start the student's app with "node app.js", find its port, and wait until it answers
function startServer(src) {
    return new Promise(resolve => {
        let log = "";
        let exited = false;
        const child = spawn("node", [ENTRY], { cwd: projectDir });
        child.stdout.on("data", d => log += d);
        child.stderr.on("data", d => log += d);
        child.on("exit", () => exited = true);
        child.on("error", e => { log += e.message; exited = true; });
        (async () => {
            const start = Date.now();
            while (Date.now() - start < 10000) {
                if (exited) {
                    // The app quit. If a port named in its code answers now, another program on this
                    // computer is using that port (newer Express still prints "running" in that case).
                    const busy = [];
                    for (const p of portsFromCode(src)) if ((await get("/", p)).status > 0) busy.push(p);
                    return resolve({ child, ok: false, busy, log: () => log });
                }
                let candidates = await listeningPorts(child.pid);
                if (!candidates.length && Date.now() - start > 2500) candidates = portsFromCode(src);
                for (const p of candidates) {
                    const r = await get("/", p);
                    if (r.status > 0) { PORT = p; return resolve({ child, ok: true, log: () => log }); }
                }
                await sleep(300);
            }
            resolve({ child, ok: false, log: () => log });
        })();
    });
}

function stopServer(server) {
    if (!server) return;
    try { server.child.kill(); } catch (e) {}
    setTimeout(() => { try { server.child.kill("SIGKILL"); } catch (e) {} }, 1000).unref();
}

// Code samples shown in the feedback letter
const EX_ROUTE =
`app.get("/select/:variable", (request, response) => {
    const file = request.params.variable + ".html";
    response.sendFile(file, { root: path.resolve(__dirname, "Pages") });
});`;
const EX_BAD =
`response.sendFile(file, { root: path.resolve(__dirname, "Pages") }, err => {
    if (!err) return;
    if (err.code === "ENOENT") response.status(404).send("File Not Found");   // no such book
    else response.status(500).send("Server Error");                           // some other problem
});`;
const EX_UNK =
`// put this AFTER all your routes: it catches every address that matched nothing
app.use((request, response) => response.status(404).send("Page Not Found"));`;
const EX_ERR =
`// put this last, after the "Page Not Found" handler. The four parameters are what make it an error handler
app.use((err, request, response, next) => response.status(500).send("Server Error"));`;

// ---------------------------------------------------------------
// Grading
// ---------------------------------------------------------------
async function main() {
    console.log(`\nGrading project: ${projectName}\n`);
    let server = null;
    const tips = [];            // extra advice for the feedback letter (no points involved)
    const structure = [];       // project layout findings: { level: "ok" | "warn", title, text }
    const flags = [];           // things for the grader to look at (no points involved)
    let entry = "", entrySource = "", pkgNote = "", pkg = null, src = "", code = "";
    let running = false, down = "", busyNote = "";
    try {

    // Section names (the report and the per-category logs follow SECTION_ORDER)
    const R = "Proper Routing of Books";   // 8
    const E = "Error Handling";            // 7
    const D = "Documentation";             // 1
    const H = "HTML Content";              // 1

    // ===== ENTRY FILE: any .js file, found from package.json =====
    if (exists("package.json")) {
        try { pkg = JSON.parse(read("package.json")); }
        catch (e) { pkgNote = "package.json could not be read"; }
    } else pkgNote = "package.json not found";

    // 1) "main"  2) the file named in scripts.start / dev / serve  3) app.js, index.js, server.js
    const isFile = p => { try { return fs.statSync(full(p)).isFile(); } catch (e) { return false; } };
    let cand = "";
    if (pkg && typeof pkg.main === "string" && pkg.main) { cand = pkg.main; entrySource = 'package.json "main"'; }
    else if (pkg && pkg.scripts) {
        const cmd = pkg.scripts.start || pkg.scripts.dev || pkg.scripts.serve || "";
        const m = cmd.match(/(?:node|nodemon|ts-node)\s+(?:-\S+\s+)*([^\s&|;]+\.[cm]?js)/);
        if (m) { cand = m[1]; entrySource = "package.json scripts"; }
    }
    if (cand && isFile(cand)) entry = cand;
    else {
        if (cand) detail(D, `package.json points to ${cand}, which does not exist`);
        for (const f of ["app.js", "index.js", "server.js"]) if (isFile(f)) { entry = f; entrySource = "default file name"; break; }
    }
    detail(D, entry ? `entry file: ${entry} (${entrySource})` : "no entry file found");
    ENTRY = entry || "app.js";

    src = entry ? read(entry) : "";
    // Remove comments so they do not count as code (new lines are kept so line numbers still match)
    code = src.replace(/\/\*[\s\S]*?\*\//g, m => m.replace(/[^\n]/g, " ")).replace(/(^|[^:])\/\/.*$/gm, "$1");
    const srcLines = src.split("\n");
    // "app.js line 12:  <that line>" for the first place a pattern matches in the code
    const show = re => {
        const m = re.exec(code);
        if (!m) return "";
        const n = code.slice(0, m.index).split("\n").length;
        return `${entry} line ${n}:  ${(srcLines[n - 1] || "").trim().slice(0, 110)}`;
    };

    // ===== Project structure (no points): where things are, and what that means for running the app =====
    const S = (level, title, text) => structure.push({ level, title, text });
    const relTop = p => (path.relative(topDir, p) || ".").split(path.sep).join("/");
    const found = { pkgs: [], modules: [], html: [] };
    (function scan(dir, depth) {
        let list = [];
        try { list = fs.readdirSync(dir, { withFileTypes: true }); } catch (e) { return; }
        for (const f of list) {
            if (f.name.startsWith(".") || f.name === "__MACOSX") continue;
            const p = path.join(dir, f.name);
            if (f.isDirectory()) { if (f.name === "node_modules") found.modules.push(p); else if (depth < 5) scan(p, depth + 1); }
            else if (f.name === "package.json") found.pkgs.push(p);
            else if (/\.html?$/i.test(f.name)) found.html.push(p);
        }
    })(topDir, 0);
    const insidePages = path.basename(projectDir).toLowerCase() === "pages";
    const nestedDepth = relTop(projectDir) === "." ? 0 : relTop(projectDir).split("/").length;
    if (entry) {
        if (insidePages) {
            S("warn", "Your app is inside the Pages folder",
              `${entry}, package.json and node_modules are all sitting inside ${relTop(projectDir)}/. That folder is only supposed to hold the html pages and the images folder. Move ${entry} and package.json up to the main project folder, next to Pages, and run npm install there. Then you start it with node ${entry} from the project folder and it serves the files in ./Pages.`);
        } else if (nestedDepth >= 1) {
            S("warn", "Your project is inside an extra folder",
              `${entry} is in ${relTop(projectDir)}/ instead of at the top of what you turned in. Zip the project folder itself so package.json and ${entry} are right at the top.`);
        } else S("ok", "Server files are at the top of the project", `${entry} and package.json are in the project folder, as expected.`);
    }
    if (found.pkgs.length > 1)
        S("warn", `You have ${found.pkgs.length} package.json files`,
          `I found them in: ${found.pkgs.map(relTop).join(", ")}. You only need one, at the top. This usually happens when npm init or npm install gets run in the wrong folder, and then it's not clear which one is the real project.`);
    if (found.modules.length > 1)
        S("warn", `You have ${found.modules.length} node_modules folders`,
          `I found them in: ${found.modules.map(relTop).join(", ")}. Install once, in the folder that has package.json. Right now the same packages are stored twice.`);
    const topPkgFile = found.pkgs.find(p => path.dirname(p) === topDir);
    if (topPkgFile && path.dirname(topPkgFile) !== projectDir) {
        let tp = {}; try { tp = JSON.parse(fs.readFileSync(topPkgFile, "utf8")); } catch (e) {}
        if (!tp.main && !(tp.scripts && tp.scripts.start))
            S("warn", "The package.json at the top doesn't say how to start the app",
              `It has no "main" and no "start" script, so node ${entry || "app.js"} or npm start from the top folder fails with "Cannot find module". I had to dig into ${relTop(projectDir)}/ to find your app.`);
    } else if (pkg && !pkg.main && !(pkg.scripts && pkg.scripts.start)) {
        S("warn", "package.json has no start script", `Add "start": "node ${entry || "app.js"}" under "scripts" so npm start works.`);
    }
    if (entry && path.basename(entry) !== "app.js")
        S("warn", `Your main file is ${entry}, not app.js`, `The assignment asks for app.js. Rename it and update "main" / "scripts.start" in package.json.`);
    if (pkg) {
        const deps = Object.assign({}, pkg.dependencies, pkg.devDependencies);
        if (!deps.express) S("warn", "express isn't in package.json", 'Run npm install express in the project folder so it gets saved under "dependencies".');
    } else S("warn", pkgNote || "No package.json", 'Run npm init -y to make a package.json so the project can be installed with npm install and started with npm start.');
    const dirNamed = (base, name) => { try { return fs.readdirSync(base).find(f => f.toLowerCase() === name && fs.statSync(path.join(base, f)).isDirectory()) || ""; } catch (e) { return ""; } };
    const pagesAbs = insidePages ? projectDir : dirNamed(projectDir, "pages") ? path.join(projectDir, dirNamed(projectDir, "pages")) : dirNamed(topDir, "pages") ? path.join(topDir, dirNamed(topDir, "pages")) : "";
    if (!pagesAbs) S("warn", "No Pages folder", "The assignment wants the book pages and index.html in a folder called Pages inside the app.");
    else {
        const imgs = dirNamed(pagesAbs, "images");
        if (!imgs) S("warn", "No images folder inside Pages", `I found ${relTop(pagesAbs)}/ but no images folder in it. The covers should be in Pages/images and used as <img src="/images/filename">.`);
        else S("ok", "Pages and Pages/images folders exist", `Found ${relTop(pagesAbs)}/ and its images folder.`);
        const idx = fs.readdirSync(pagesAbs).find(f => /^index\.html?$/i.test(f));
        if (idx && idx !== "index.html") S("warn", `The index page is called ${idx}`, `Rename it to index.html, all lowercase. On Linux and most web hosts file names are case-sensitive, so ${idx} and index.html are different files.`);
    }
    // A hard-coded list of ISBNs in the code
    if ((code.match(/["'`]\d{9}[\dXx]["'`]\s*,/g) || []).length >= 2)
        tips.push("Your code keeps its own list of valid ISBNs. You don't need that. Just ask sendFile for the file and, if it isn't there, the callback gives you err.code === \"ENOENT\" and you can send \"File Not Found\". Then adding a book is only adding a file.");

    // ===== Documentation (1 point): share of lines with comments =====
    const lines = src.split("\n").filter(l => l.trim());
    const commentLines = lines.filter(l => /(^|[^:])\/\/|\/\*|^\s*\*/.test(l)).length;
    const ratio = lines.length ? commentLines / lines.length : 0;

    // ===== ROUTING: reads the code =====
    const dynRoutes = (code.match(/\.get\s*\(\s*["'`]\/select\/:\w+/g) || []).length;
    const litRoutes = (code.match(/\.get\s*\(\s*["'`]\/select\/[^:"'`]/g) || []).length;
    const usesParams = /\.params\s*(\.\w+|\[)/.test(code) || /=\s*\w+\.params\b/.test(code);
    detail(R, `dynamic /select/:x routes: ${dynRoutes}, literal /select/... routes: ${litRoutes}, uses params: ${usesParams}`);

    // One route for all 3 books (3 points)
    {
        const line = show(/\.get\s*\(\s*["'`]\/select\//);
        let sc = 0, note = "", fb = { code: line, example: EX_ROUTE };
        if (litRoutes >= 2) {
            sc = 1; note = `${litRoutes} separate /select routes (one per book)`;
            fb.fix = `You have a separate route for each book (${litRoutes} routes starting with /select/). That works for three books, but the idea of this assignment is that ONE route handles every book: put a variable in the path and read it with request.params.variable, so a fourth book would need no new code.`;
        } else if (dynRoutes >= 1 && usesParams) {
            sc = 3;
            fb.ok = "One route with a path variable handles every book and reads it from request.params. This is exactly the pattern the assignment is after.";
        } else if (dynRoutes >= 1) {
            sc = 1.5; note = "dynamic route found but request.params not used";
            fb.fix = "You declared a route with a path variable, but I did not see request.params used to read it. The value of :variable is available as request.params.variable. Use it to build the file name.";
        } else {
            note = "no /select/:variable route found" + (entry ? " in " + entry : "");
            fb.fix = (entry ? `I did not find an app.get("/select/:variable", ...) route in ${entry}. ` : "I could not find an entry file to read. ") +
                "If your routes are in another file, tell me and I will look there. Otherwise, one route with a path variable should serve every book.";
        }
        fb.test = `I scanned ${entry || "the code"} for app.get routes: ${dynRoutes} with a path variable (/select/:x), ${litRoutes} separate per-book routes; request.params used: ${usesParams ? "yes" : "no"}.`; fb.why = "One route for every book is the core idea of the assignment: adding a book then means adding a file, not writing more code.";
        record(R, "One route handles all 3 books (request.params)", 3, sc, note, fb);
    }

    // sendFile with a root (1 point)
    {
        const sendRoot = /\.sendFile\s*\([\s\S]{0,250}?root\s*:/.test(code);
        const sendAny = /\.sendFile\s*\(/.test(code);
        const line = show(sendRoot ? /\.sendFile\s*\([^)]*root\s*:/ : /\.sendFile\s*\(/);
        let note = "", fb = { code: line, example: 'response.sendFile(file, { root: path.resolve(__dirname, "Pages") });' };
        if (sendRoot) fb.ok = "response.sendFile with a {root: ...} option, which also stops a request from reaching files outside your Pages folder.";
        else if (sendAny) { note = "sendFile used without root"; fb.fix = "sendFile is used, but without the {root: ...} option. Passing the folder as root (instead of building a full path yourself) is the safer and more portable way, and it blocks requests such as ../ from escaping the folder."; }
        else { note = /readFile/.test(code) ? "uses fs.readFile instead of sendFile" : "sendFile not found"; fb.fix = "I did not find response.sendFile. It is the simplest way to send an HTML file, and it sets the right headers for you. Give it the file name and {root: <your Pages folder>}."; }
        fb.test = "I looked for response.sendFile(file, {root: ...}) in the code."; fb.why = "root keeps requests inside your Pages folder (so a URL like ../app cannot read other files) and avoids building the path by hand.";
        record(R, "sendFile with {root: ...}", 0.5, sendRoot ? 0.5 : sendAny ? 0.25 : 0, note, fb);
    }

    // path.resolve (1 point)
    {
        const resolveUsed = /path\.resolve\s*\(/.test(code);
        const joinUsed = /path\.join\s*\(/.test(code);
        const line = show(resolveUsed ? /path\.resolve\s*\(/ : /path\.join\s*\(/);
        let note = "", fb = { code: line, example: 'path.resolve(__dirname, "Pages")' };
        if (resolveUsed) fb.ok = "path.resolve builds the folder path, so it works on any operating system.";
        else if (joinUsed) { note = "uses path.join instead of path.resolve"; fb.fix = "You used path.join. It also avoids hard-coding slashes, which is great. The assignment specifically asks for path.resolve, which turns the pieces into one absolute path."; }
        else { note = "path.resolve not found"; fb.fix = "I did not see path.resolve. Use it to build the path to your Pages folder instead of typing the path as a string; it works on every operating system."; }
        fb.test = "I looked for path.resolve(...) in the code."; fb.why = "path.resolve gives one absolute path that works on Windows, Mac and Linux alike.";
        record(R, "path.resolve builds the path", 0.5, resolveUsed ? 0.5 : joinUsed ? 0.25 : 0, note, fb);
    }

    // ===== Run the app with the entry file =====
    if (entry) server = await startServer(src);
    running = !!(server && server.ok);
    busyNote = server && server.busy && server.busy.length
        ? `port ${server.busy.join(", ")} is already in use by another program on this computer. ` +
          `Close it (find it with: lsof -nP -iTCP:${server.busy[0]} -sTCP:LISTEN), then grade again.`
        : "";
    down = running ? "" : busyNote ? `could not test: ${busyNote}` : "server did not start (see logs/<student>_app.log)";
    if (running) { console.log(`App is running on port ${PORT}\n`); detail(D, `app answered on port ${PORT}`); }
    else detail(D, down || "no entry file to start");
    // Used when an item needs the running app and it was not running
    const notRun = { fix: busyNote
        ? "I could not test this because my computer's port was busy, so this is not a mistake of yours. I will re-run it."
        : "I could not check this because the app did not start when I ran it (see the note at the top of this letter)." };

    // Request the home page, then every book page
    const home = running ? await get("/") : { status: 0, body: "" };
    if (running) detail(R, `GET / -> ${home.status || home.error}`);

    // Index HTML: what the app serves at "/". If the app is down, fall back to any index.html in the project.
    function findFile(dir, name, depth) {
        if (depth > 3) return "";
        let list = [];
        try { list = fs.readdirSync(dir, { withFileTypes: true }); } catch (e) { return ""; }
        for (const f of list) if (f.isFile() && f.name.toLowerCase() === name) return path.join(dir, f.name);
        for (const f of list) {
            if (!f.isDirectory() || f.name === "node_modules" || f.name.startsWith(".")) continue;
            const hit = findFile(path.join(dir, f.name), name, depth + 1);
            if (hit) return hit;
        }
        return "";
    }
    let indexHtml = "", indexFrom = "";
    if (running && home.status === 200) { indexHtml = home.body; indexFrom = "served at /"; }
    else {
        const f = findFile(projectDir, "index.html", 0);
        if (f) { indexHtml = fs.readFileSync(f, "utf8"); indexFrom = "file " + path.relative(projectDir, f) + " (app not tested)"; }
    }
    const hrefs = [...indexHtml.matchAll(/href\s*=\s*["']([^"']+)["']/gi)].map(m => m[1]);
    const directLinks = hrefs.filter(h => /\.html?$/i.test(h));
    const selectLinks = hrefs.filter(h => /\/select\/[\w-]+\/?$/.test(h));

    // The three ISBNs: from the proposal, else from the index links
    // The student's own index links come first (that is what their app really serves, hyphens and all);
    // any proposal ISBN not covered by a link is added so a missing book still counts against the page total.
    const bare = s => String(s).replace(/-/g, "");
    const linkIsbns = [...new Set(selectLinks.map(h => h.match(/\/select\/([\w-]+)\/?$/)[1]))].slice(0, 3);
    let bookIsbns = linkIsbns.slice();
    if (proposal) {
        for (const b of proposal.books)
            if (bookIsbns.length < 3 && !linkIsbns.some(u => bare(u) === bare(b.isbn))) bookIsbns.push(bare(b.isbn));
        const strays = linkIsbns.filter(u => !proposal.books.some(b => bare(b.isbn) === bare(u)));
        if (strays.length) {
            flags.push(`index links ISBN(s) not in the proposal: ${strays.join(", ")}`);
            tips.push(`Your index links to ${strays.join(", ")}, which ${strays.length > 1 ? "aren't" : "isn't"} in your proposal. The pages should be for the three books you proposed. Because of that I could only check that each page has some title and some price, not the right ones.`);
        }
    }
    const book = isbn => proposal ? proposal.books.find(b => bare(b.isbn) === bare(isbn)) : null;

    const pages = {};
    if (running) for (const isbn of bookIsbns) {
        pages[isbn] = await get(`/select/${isbn}`);
        detail(R, `GET /select/${isbn} -> ${pages[isbn].status || pages[isbn].error}`);
    }
    const goodPage = isbn => { const r = pages[isbn]; return !!r && r.status === 200 && !/not\s*found/i.test(r.body) && r.body.trim().length > 0; };

    // "/" serves the index, and its links go through the app (1 point)
    {
        const good = Math.min(selectLinks.length, 3);
        const bad = Math.min(directLinks.length, 3);
        let served = 0, note = down;
        if (running) {
            if (home.status === 200 && /\/select\//.test(home.body)) { served = 0.5; note = ""; }
            else if (home.status === 200) note = "GET / returned a page without /select/ links";
            else note = `GET / returned ${home.status || home.error}`;
        }
        const linkPart = 0.5 * Math.max(0, good - bad) / 3;
        let linkNote = `${selectLinks.length} /select/ links (index ${indexFrom || "not found"})`;
        if (directLinks.length) linkNote += `, direct links to .html files: ${directLinks.join(", ")}`;
        const sc = served + linkPart;
        const fb = {};
        if (sc >= 0.995) fb.ok = "GET / returns your index page, and its three links go through your app (/select/ISBN) instead of pointing at the .html files.";
        else if (!running) fb.fix = notRun.fix;
        else {
            const parts = [];
            if (!served) parts.push(home.status === 200 ? "GET / returned a page, but I did not find /select/ links in it." : `GET / answered with ${home.status || home.error} instead of your index page. Add app.get("/", ...) that sends index.html the same way as the book pages.`);
            if (directLinks.length) parts.push(`Your index links straight to the .html file(s): ${directLinks.slice(0, 3).join(", ")}. Links should look like http://localhost:3000/select/<ISBN> so the click goes through your app's route.`);
            else if (selectLinks.length < 3) parts.push(`I found ${selectLinks.length} of the 3 expected /select/<ISBN> links in the index page.`);
            fb.fix = parts.join(" ");
        }
        fb.test = running ? `GET / returned ${home.status || home.error}. Index page (${indexFrom || "not found"}) has ${selectLinks.length} links of the form /select/ISBN and ${directLinks.length} direct links to .html files.` : "The app was not running, so I read the index.html file instead."; fb.why = "Links that go through /select/ prove a click reaches your route; a direct .html link skips the app entirely.";
        record(R, "'/' serves the index; links use /select/ISBN", 1, sc, [note, linkNote].filter(Boolean).join("; "), fb);
    }

    // The 3 book pages come back through the route (2 points)
    {
        const okPages = bookIsbns.filter(goodPage).length;
        const missing = bookIsbns.filter(i => running && !goodPage(i));
        const fb = {};
        if (!running) fb.fix = notRun.fix;
        else if (okPages === 3) fb.ok = "All three books load at /select/<ISBN>.";
        else fb.fix = `${okPages} of 3 books loaded. Not working: ${missing.map(i => `/select/${i} (${pages[i].status || pages[i].error})`).join(", ")}. Check that the file is named exactly <ISBN>.html and lives in the folder you pass as root.`;
        fb.test = running ? bookIsbns.map(i => `GET /select/${i} returned ${pages[i] ? (pages[i].status || pages[i].error) : "nothing"}`).join("; ") + "." : "The app was not running."; fb.why = "Each of your three proposal books must be reachable through the route.";
        record(R, "The 3 book pages are served at /select/ISBN", 3, 3 * okPages / 3, running ? `${okPages}/3 book pages returned` : down, fb);
    }

    // ===== ERROR HANDLING: runs the app =====
    const snip = r => `${r.status || r.error}: ${r.body.slice(0, 80).replace(/\s+/g, " ")}`;
    const errLine = show(/not\s*found|server\s*error|\.status\s*\(\s*(404|500)/i);
    let badRes = null, unkRes = null, errRes1 = null, errRes2 = null;

    // A book that does not exist (3 points)
    {
        let sc = 0, note = down;
        const fb = { code: show(/file\s*not\s*found|not\s*found/i) || errLine, example: EX_BAD };
        if (running) {
            badRes = await get("/select/0000000000000");
            detail(E, `GET /select/0000000000000 -> ${snip(badRes)}`);
            if (/not\s*found/i.test(badRes.body)) {
                sc = 3; note = "";
                fb.ok = 'A request for a book that does not exist answers "File Not Found".';
                if (badRes.status !== 404) tips.push(`For a missing book you send "File Not Found" with status ${badRes.status}. Add .status(404) too: response.status(404).send("File Not Found").`);
            } else if (/server\s*error/i.test(badRes.body)) {
                sc = 1; note = "returns Server Error instead of a 'not found' message";
                fb.fix = 'A missing book currently gives "Server Error". A missing file is not a server fault. It is an expected "not found" case, so it should get its own "File Not Found" answer. With sendFile, check err.code === "ENOENT" inside the callback.';
            } else {
                note = `no 'not found' message (${snip(badRes)})`;
                fb.fix = `/select/0000000000000 answered "${badRes.body.slice(0, 60).replace(/\s+/g, " ")}" (status ${badRes.status || badRes.error}). Handle the missing-file case in the sendFile callback and send "File Not Found".`;
            }
        } else fb.fix = notRun.fix;
        fb.test = badRes ? `GET /select/0000000000000 returned ${snip(badRes)}` : "The app was not running."; fb.why = "A missing book is an expected case, not a crash, so it needs its own clear answer.";
        record(E, "A book that does not exist returns 'File Not Found'", 3, sc, note, fb);
    }

    // A page that does not exist (2 points)
    {
        let sc = 0, note = down;
        const fb = { code: show(/\.use\s*\(\s*(\(|function)[^)]*\)\s*(=>|\{)/), example: EX_UNK };
        if (running) {
            unkRes = await get("/no-such-route/xyz");
            detail(E, `GET /no-such-route/xyz -> ${snip(unkRes)}`);
            if (/not\s*found/i.test(unkRes.body) && !/cannot\s+get/i.test(unkRes.body)) {
                sc = 2; note = "";
                fb.ok = 'An unknown address gets its own "not found" answer, separate from the missing-book case.';
                if (unkRes.status !== 404) tips.push(`Your page-not-found message comes back with status ${unkRes.status}. Add .status(404) so browsers know it wasn't found.`);
            } else if (/cannot\s+get/i.test(unkRes.body)) {
                note = "Express default 'Cannot GET' page, no catch-all handler";
                fb.fix = 'An address that matches no route shows Express\'s built-in "Cannot GET /..." page. Add a catch-all app.use(...) after all your routes that sends your own "Page Not Found" message, kept separate from the missing-book handler.';
            } else {
                note = `no 'not found' message (${snip(unkRes)})`;
                fb.fix = `An unknown address answered "${unkRes.body.slice(0, 60).replace(/\s+/g, " ")}". Add a catch-all handler after your routes that sends a "not found" message.`;
            }
        } else fb.fix = notRun.fix;
        fb.test = unkRes ? `GET /no-such-route/xyz returned ${snip(unkRes)}` : "The app was not running."; fb.why = "An address that matches no route should get your own message, handled separately from a missing book.";
        record(E, "An unknown page returns a 'not found' response (separate handler)", 2, sc, note, fb);
    }

    // Any other error (2 points). The grader forces a real error with a badly encoded address
    // (reaches the error-handling middleware) and a file outside the root (reaches the sendFile callback).
    {
        const errText = /server\s*error/i.test(code);
        let sc = 0, note = down;
        const fb = { code: show(/server\s*error/i), example: EX_ERR };
        if (running) {
            errRes1 = await get("/select/%E0%A4%A");
            errRes2 = await get("/select/..%2Fapp");
            detail(E, `GET /select/%E0%A4%A -> ${snip(errRes1)}`);
            detail(E, `GET /select/..%2Fapp -> ${snip(errRes2)}`);
            const hit = /server\s*error/i.test(errRes1.body) ? errRes1 : /server\s*error/i.test(errRes2.body) ? errRes2 : null;
            if (hit) {
                sc = 2; note = "";
                fb.ok = 'Other errors return "Server Error".';
                if (hit.status !== 500) tips.push(`Your "Server Error" comes back with status ${hit.status}. Add .status(500) so it's marked as a server problem.`);
            } else if (errText) {
                sc = 1; note = "'Server Error' is in the code but was not returned when an error was forced";
                fb.fix = `I can see "Server Error" in your code, but when I forced an error it did not come back (I got: ${snip(errRes1)}). Express only reaches an error handler written with FOUR parameters, app.use((err, request, response, next) => ...), and that handler must come after your routes. Also check that errors from sendFile are passed to it or answered in its callback.`;
            } else {
                note = "no 'Server Error' response found";
                fb.fix = 'I did not find a "Server Error" response. Add an error-handling middleware (four parameters: err, request, response, next) after your routes, and send "Server Error" from it.';
            }
        } else if (errText) { sc = 1; note = "'Server Error' is in the code, but the app did not start so it could not be tested"; fb.fix = notRun.fix; }
        else fb.fix = notRun.fix;
        fb.test = errRes1 ? `I forced two errors. GET /select/%E0%A4%A returned ${snip(errRes1)}; GET /select/..%2Fapp returned ${snip(errRes2)}` : "The app was not running."; fb.why = "Anything unexpected must still end in a clean \"Server Error\" instead of a stack trace or a hanging request.";
        record(E, "Any other error returns 'Server Error'", 2, sc, note, fb);
    }

    // ===== DOCUMENTATION (1 point) =====
    {
        const pct = Math.round(ratio * 100);
        const sc = ratio >= 0.10 ? 1 : ratio > 0 ? 0.5 : 0;
        const fb = {};
        if (sc === 1) fb.ok = `About ${pct}% of the lines in ${entry} are comments, which makes the file easy to follow.`;
        else fb.fix = (ratio > 0 ? `${entry} has some comments (${pct}% of its lines). ` : `${entry || "Your main file"} has no comments. `) +
            "Add a short comment above each route and each error handler saying what it does and why, and a header comment at the top with the file's purpose. Explaining the why (for example, why one route serves every book) is worth more than restating the code.";
        fb.test = `${commentLines} of ${lines.length} non-empty lines in ${entry || "the main file"} contain comments (${pct}%). Full marks need 10% or more.`; fb.why = "Comments explain why the code is written the way it is, which helps you and anyone who reads it later.";
        record(D, "Comments in the main file", 1, sc, `${pct}% comment lines`, fb);
    }

    // ===== HTML CONTENT (1 point): 0.25 each, scaled by pages / 3 =====
    {
        // The student's name: from the proposal, else from the folder name
        const display = (proposal && proposal.student) ||
            projectName.replace(/_/g, " ").replace(/\b\w/g, c => c.toUpperCase());
        const toks = norm(display).split(" ").filter(t => t.length > 1);
        const nameOk = text => text.includes(norm(display)) || (toks.length >= 2 && new RegExp("\\b" + toks[toks.length - 1] + "\\b").test(text) && new RegExp("\\b" + toks[0].slice(0, Math.min(5, toks[0].length)), "i").test(text));
        let titles = 0, covers = 0, prices = 0, names = 0;
        const lack = { title: [], img: [], price: [], name: [] };
        for (const isbn of bookIsbns) {
            if (!goodPage(isbn)) continue;
            const r = pages[isbn];
            const text = textOf(r.body);
            const b = book(isbn);
            if (b && b.title ? normT(text).includes(normT(b.title)) : /<(h[1-6]|title)[^>]*>\s*[^<\s]/i.test(r.body)) titles++; else lack.title.push(isbn);
            if (/<img[^>]*src\s*=\s*["']\/images\/[^"'?#]+["']/i.test(r.body)) covers++; else lack.img.push(isbn);
            if (b && b.price ? text.includes(String(b.price).replace("$", "")) : /\$\s?\d/.test(text)) prices++; else lack.price.push(isbn);
            if (nameOk(text)) names++; else lack.name.push(isbn);
        }
        const auto = proposal ? "" : " (no proposal given: rough check, verify by eye)";
        const pageDown = running ? "" : ` ${down}`;
        const pts = 0.25;
        // fb for one HTML item: what was checked, why it matters, and what to do when a page lacks it
        const mk = (label, n, list, okMsg, fixMsg, what, why) => ({
            test: running ? `${what} ${n} of 3 book pages have it${list.length ? " (missing on " + list.join(", ") + ")" : ""}.` : "The app was not running.",
            why,
            ok: n === 3 ? okMsg : undefined,
            fix: n === 3 ? undefined : running ? `${label} was missing on ${3 - n} of the 3 pages (${list.join(", ") || "none loaded"}). ${fixMsg}` : notRun.fix });
        record(H, 'Cover <img src="/images/..."> on each book page', pts, pts * covers / 3, `${covers}/3${pageDown}`,
            mk("An <img src=\"/images/filename\"> tag", covers, lack.img, "Every page has an <img src=\"/images/...\"> cover tag.",
               'Reference the cover as <img src="/images/yourfile.jpg">. The /images/ part works because the app serves the Pages/images folder (e.g. with express.static), even though it will not show when you open the .html file directly.',
               'I looked for <img src="/images/..."> in the HTML of each book page:', "The cover is part of the book page the assignment asks for, and the /images/ path is how the app serves it."));
        record(H, "Price on each book page", pts, pts * prices / 3, `${prices}/3${auto}${pageDown}`,
            mk("The price from your proposal", prices, lack.price, "Every book page shows the price from your proposal.", "Add the price exactly as it appears in your proposal.",
               "I compared the page text with the price in your proposal:", "The price is one of the three things each book page must show."));
        record(H, "Title on each book page", pts, pts * titles / 3, `${titles}/3${auto}${pageDown}`,
            mk("The book title from your proposal", titles, lack.title, "Every book page shows the title from your proposal.", "Put the exact title from your proposal in a heading on the page.",
               "I compared the page text with the title in your proposal:", "The title is how a reader knows which book the page is about."));
        record(H, "Student name on each book page", pts, pts * names / 3, `${names}/3${pageDown}`,
            mk("Your name", names, lack.name, "Your name appears on every book page.", "The assignment asks for your name at the bottom of each page, for example in a <footer>.",
               "I looked for your name in the text of each book page:", "The assignment asks for your name on the bottom of every page."));
    }

    } finally {
        // Always stop the student's app
        stopServer(server);
    }

    // ===== TOTALS =====
    const SECTION_ORDER = ["Proper Routing of Books", "Error Handling", "Documentation", "HTML Content"];
    const r2 = x => Math.round(x * 100) / 100;
    let total = 0, outOf = 0;
    const categories = {};
    for (const sec of SECTION_ORDER) {
        const rows = results.filter(r => r.section === sec);
        const sScore = rows.reduce((a, r) => a + r.score, 0);
        const sMax = rows.reduce((a, r) => a + r.max, 0);
        total += sScore; outOf += sMax;
        categories[sec] = { score: r2(sScore), max: r2(sMax) };
    }

    // ===== GRADE REPORT (for the grader) =====
    let report = `Grade report: ${projectName}\n${"=".repeat(60)}\n`;
    for (const sec of SECTION_ORDER) {
        report += `\n${sec}: ${categories[sec].score} / ${categories[sec].max}\n`;
        for (const r of results.filter(x => x.section === sec)) {
            report += `  [${String(r.score).padStart(5)} / ${String(r.max).padEnd(4)}] ${r.item}`;
            report += r.note ? `  -- ${r.note}\n` : "\n";
        }
    }
    report += `\n${"=".repeat(60)}\nPOINTS: ${r2(total)} / ${r2(outOf)}   GRADE (rounded up): ${total >= outOf - 0.001 ? r2(outOf) : Math.min(outOf, Math.ceil(total - 0.001))} / ${r2(outOf)}\n`;
    if (server && !server.ok) {
        const tail = server.log().trim().split("\n").slice(-3).map(l => l.slice(0, 200)).join("\n");
        report += busyNote
            ? `\nTHE APP COULD NOT BE TESTED: ${busyNote}\nThe lost points above are not the student's fault.\n`
            : `\nThe app did not start. Last lines of its output:\n${tail || "(empty)"}\n`;
    }

    console.log(report);
    fs.mkdirSync(outDir, { recursive: true });
    const out = path.join(outDir, `${projectName}_grade.txt`);
    fs.writeFileSync(out, report);
    fs.writeFileSync(path.join(outDir, `${projectName}_grade.json`), JSON.stringify({
        student: projectName, total: r2(total), outOf: r2(outOf), categories,
        grade: total >= outOf - 0.001 ? r2(outOf) : Math.min(outOf, Math.ceil(total - 0.001)), studentName: (proposal && proposal.student) || "", entry, structure, tips,
        serverTail: (server && !server.ok) ? server.log().trim().split("\n").slice(-6).map(l => l.slice(0, 200)).join("\n") : "",
        started: !!(server && server.ok), startNote: (server && server.ok) ? "" : busyNote, flags, items: results
    }, null, 2));
    // What the student's own app printed (kept for finding problems; last 200 KB only)
    if (logArg && server) {
        fs.mkdirSync(path.dirname(path.resolve(logArg)), { recursive: true });
        fs.writeFileSync(logArg, server.log().slice(-200000));
    }
    // One log per category: what was checked, what the app answered, and the points
    if (catLogDir) {
        fs.rmSync(catLogDir, { recursive: true, force: true });
        fs.mkdirSync(catLogDir, { recursive: true });
        SECTION_ORDER.forEach((sec, i) => {
            const rows = results.filter(r => r.section === sec);
            if (!rows.length) return;
            let t = `${projectName}: ${sec}  ${categories[sec].score} / ${categories[sec].max}\n${"-".repeat(60)}\n`;
            for (const line of details[sec] || []) t += `  ${line}\n`;
            t += "\n";
            for (const r of rows) t += `[${String(r.score).padStart(5)} / ${String(r.max).padEnd(4)}] ${r.item}${r.note ? "  -- " + r.note : ""}\n`;
            fs.writeFileSync(path.join(catLogDir, `${i + 1}-${sec.toLowerCase().replace(/[^a-z]+/g, "-").replace(/^-|-$/g, "")}.log`), t);
        });
    }
    console.log(`Report saved to ${out}`);
    process.exit(0);
}

main().catch(e => { console.error("Grader crashed:", e); process.exit(1); });
GRADER_EOF

# ---------------------------------------------------------------
# The feedback pages (feedback/<student>.html + feedback/index.html), built from the grade reports.
# Each page explains every result in detail and has a button that copies the feedback as plain text.
# ---------------------------------------------------------------
cat > "$TMPBASE/feedback.js" << 'FEEDBACK_EOF'
const fs = require("fs"), path = require("path");
const [resultsDir, outDir] = process.argv.slice(2);
const esc = s => String(s === undefined || s === null ? "" : s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
const titleCase = id => id.split("_").map(w => w ? w[0].toUpperCase() + w.slice(1) : "").join(" ");

const files = fs.readdirSync(path.join(resultsDir, "reports")).filter(f => f.endsWith("_grade.json")).sort();
fs.mkdirSync(outDir, { recursive: true });

// What went wrong with one item, said the way a person would say it. null = nothing to say.
function say(i, g) {
    const n = i.note || "", fx = i.fb.fix || "", test = i.fb.test || "";
    const missing = (test.match(/missing on ([^)]*)/) || [])[1];
    const entry = g.entry || "app.js";
    if (!g.started && i.score === 0 && !/^(One route|sendFile|path\.resolve|Comments)/.test(i.item))
        return "I couldn't check this one because your app didn't start when I ran it.";
    switch (i.item) {
        case "One route handles all 3 books (request.params)":
            if (/separate/.test(n)) return `You wrote a separate route for each book. It works, but the point of the assignment is one route, app.get("/select/:variable", ...), that reads request.params.variable and sends that file. Then a new book is just a new file.`;
            if (/params not used/.test(n)) return `You have a /select/:something route, but I didn't see request.params being used to pick the file.`;
            return `I couldn't find a /select/:variable route in ${entry}. If your routes are in another file, let me know and I'll look there.`;
        case "sendFile with {root: ...}":
            return /without root/.test(n)
                ? `You use sendFile, but not with the {root: ...} option. The assignment wants the Pages folder passed as root, like sendFile(file, {root: ...}). It also keeps people from asking for files outside that folder.`
                : `I didn't see response.sendFile in ${entry}. Use sendFile(file, {root: ...}) to send the html pages.`;
        case "path.resolve builds the path":
            return /path\.join/.test(n)
                ? `You used path.join for the paths. The assignment asked for path.resolve, so swap them, e.g. path.resolve(__dirname, "Pages").`
                : `I didn't see path.resolve anywhere. Use it to build the path to your Pages folder.`;
        case "'/' serves the index; links use /select/ISBN": {
            const bits = [];
            if (/GET \/ returned (?!a page)/.test(n) || /GET \/ returned a page without/.test(n)) bits.push(/without/.test(n) ? `GET / gives a page, but I didn't find any /select/ links in it.` : `GET / didn't give me your index page. Add an app.get("/", ...) that sends index.html.`);
            const direct = (n.match(/direct links to \.html files: ([^;]*)/) || [])[1];
            if (direct) bits.push(`Your index links straight to the html files (${direct}). They need to look like http://localhost:3000/select/<ISBN> so the click goes through your route.`);
            const links = (n.match(/^(\d+) \/select\/ links/) || [])[1];
            if (!direct && links !== undefined && +links < 3) bits.push(`I only found ${links} of the 3 /select/<ISBN> links in the index page.`);
            return bits.join(" ") || fx;
        }
        case "The 3 book pages are served at /select/ISBN": {
            const bad = (fx.match(/Not working: (.+?)\. Check/) || [])[1];
            return `Not all three books loaded${bad ? ": " + bad : ""}. Check that each file is named exactly <ISBN>.html and sits in the folder you use as root.`;
        }
        case "A book that does not exist returns 'File Not Found'":
            return /Server Error/.test(n)
                ? `A made-up ISBN gives "Server Error" in your app. A missing book isn't really a server error, so send "File Not Found" there. In the sendFile callback, err.code === "ENOENT" tells you the file wasn't there.`
                : `A made-up ISBN didn't give me "File Not Found". Handle the missing-file case in the sendFile callback and send that message.`;
        case "An unknown page returns a 'not found' response (separate handler)":
            return /Cannot GET/.test(n)
                ? `A wrong URL still shows Express's own "Cannot GET ..." page. Add an app.use(...) after all your routes that sends "Page Not Found". Keep it separate from the missing-book message.`
                : `A wrong URL didn't get a "not found" message from your app. Add an app.use(...) after your routes that sends one.`;
        case "Any other error returns 'Server Error'":
            return /in the code/.test(n)
                ? `I can see "Server Error" in your code, but when I forced an error it never came back. An Express error handler needs four parameters, app.use((err, req, res, next) => ...), and has to come after your routes.`
                : `I didn't find a "Server Error" response anywhere. Add an error handler at the bottom, app.use((err, req, res, next) => ...), that sends "Server Error".`;
        case "Comments in the main file": {
            const pct = (n.match(/(\d+)%/) || [])[1];
            return `${entry} doesn't have many comments (${pct || 0}% of the lines). A short comment above each route and handler saying what it does would be enough.`;
        }
        case 'Cover <img src="/images/..."> on each book page':
            return `The cover image tag is missing on ${3 - parseInt(n) === 3 ? "all" : 3 - parseInt(n) + " of"} the book pages${missing ? " (" + missing + ")" : ""}. It should be <img src="/images/yourfile.jpg">.`;
        case "Price on each book page":
            return `The price from your proposal isn't on ${3 - parseInt(n) === 3 ? "any of the" : 3 - parseInt(n) + " of the"} book pages${missing ? " (" + missing + ")" : ""}.`;
        case "Title on each book page":
            return `The title from your proposal isn't on ${3 - parseInt(n) === 3 ? "any of the" : 3 - parseInt(n) + " of the"} book pages${missing ? " (" + missing + ")" : ""}. I look for it exactly as it is written in the proposal.`;
        case "Student name on each book page":
            return `Your name isn't on ${3 - parseInt(n) === 3 ? "any of the" : 3 - parseInt(n) + " of the"} book pages${missing ? " (" + missing + ")" : ""}. The assignment wants it at the bottom of every page.`;
    }
    return fx;
}

// What worked, in a few words
const GOOD = {
    "One route handles all 3 books (request.params)": "one route that handles every book",
    "sendFile with {root: ...}": "sendFile with root",
    "path.resolve builds the path": "path.resolve",
    "'/' serves the index; links use /select/ISBN": "the index page and its /select links",
    "The 3 book pages are served at /select/ISBN": "all three book pages load",
    "A book that does not exist returns 'File Not Found'": "File Not Found for a missing book",
    "An unknown page returns a 'not found' response (separate handler)": "a separate not-found page for wrong URLs",
    "Any other error returns 'Server Error'": "the Server Error handler",
    "Comments in the main file": "the comments",
    'Cover <img src="/images/..."> on each book page': "the cover images",
    "Price on each book page": "the prices",
    "Title on each book page": "the titles",
    "Student name on each book page": "your name on the pages"
};
const EXAMPLE = {
    "One route handles all 3 books (request.params)": `app.get("/select/:variable", (request, response) => {\n    const file = request.params.variable + ".html";\n    response.sendFile(file, { root: path.resolve(__dirname, "Pages") });\n});`,
    "sendFile with {root: ...}": `response.sendFile(file, { root: path.resolve(__dirname, "Pages") });`,
    "path.resolve builds the path": `path.resolve(__dirname, "Pages")`,
    "A book that does not exist returns 'File Not Found'": `response.sendFile(file, { root: ... }, err => {\n    if (err) response.status(404).send("File Not Found");\n});`,
    "An unknown page returns a 'not found' response (separate handler)": `// after all your routes\napp.use((request, response) => response.status(404).send("Page Not Found"));`,
    "Any other error returns 'Server Error'": `// last thing in the file\napp.use((err, request, response, next) => response.status(500).send("Server Error"));`
};
const join = a => a.length <= 1 ? a.join("") : a.slice(0, -1).join(", ") + " and " + a[a.length - 1];

// Everything one student's feedback says, as data
function build(g, name) {
    const first = name.split(" ")[0];
    const notes = [];
    if (!g.started) notes.push(g.startNote
        ? { title: "Couldn't test the app", text: "I couldn't run your app because something else on my computer was using the port, so this isn't your fault. I'll re-run it." }
        : { title: "Your app didn't start", text: `I ran node ${g.entry || "app.js"} and it didn't start, so I couldn't check the pages or the error messages (those points are lost for now).${g.serverTail ? " This is the last thing it printed:" : ""}`, code: g.serverTail });
    for (const s of (g.structure || [])) if (s.level === "warn") notes.push({ title: s.title, text: s.text });
    const good = g.items.filter(i => i.score >= i.max - 0.001).map(i => GOOD[i.item]).filter(Boolean);
    const fix = g.items.filter(i => i.score < i.max - 0.001).map(i => ({ item: i.item, score: i.score, max: i.max, text: say(i, g), example: EXAMPLE[i.item], code: i.fb.code }));
    return { first, notes, good, fix, tips: g.tips || [] };
}

function plain(g, name) {
    const b = build(g, name), L = [];
    L.push(`Hi ${b.first},`, "");
    L.push(`Your grade for Assignment 1 is ${g.grade} / ${g.outOf}.`);
    L.push(`(Routing ${g.categories["Proper Routing of Books"].score}/8, error handling ${g.categories["Error Handling"].score}/7, comments ${g.categories["Documentation"].score}/1, page content ${g.categories["HTML Content"].score}/1. I round up to the next whole point.)`, "");
    if (b.good.length) L.push(`What worked: ${join(b.good)}.`, "");
    if (b.fix.length) {
        L.push("What to fix:");
        b.fix.forEach((f, n) => {
            L.push(`${n + 1}. ${f.text}`);
            if (f.code) L.push(`   (your code, ${f.code})`);
            if (f.example) L.push(...f.example.split("\n").map(l => "       " + l));
        });
        L.push("");
    }
    if (b.notes.length) {
        L.push("About your project folder:");
        b.notes.forEach(s => { L.push(`- ${s.title}. ${s.text}`); if (s.code) L.push(...s.code.split("\n").map(l => "     " + l)); });
        L.push("");
    }
    if (b.tips.length) { L.push("A few extra things:"); b.tips.forEach(t => L.push("- " + t)); L.push(""); }
    L.push("If any of this is unclear, send me your code and we'll go through it.");
    return L.join("\n");
}

const CSS = `
:root{--bg:#f7f7f5;--card:#fff;--ink:#222;--mute:#666;--line:#e3e3df;--accent:#2a5bd7;--code:#f0f0ec;--warn:#b26a00}
@media (prefers-color-scheme:dark){:root{--bg:#161616;--card:#1f1f1f;--ink:#e8e8e6;--mute:#9a9a96;--line:#303030;--accent:#8fb0ff;--code:#141414;--warn:#f0b060}}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--ink);font:16px/1.6 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif}
main{max-width:760px;margin:0 auto;padding:24px 16px 64px}h1{font-size:1.5rem;margin:0 0 4px}h2{font-size:1.05rem;margin:28px 0 8px}
.sub{color:var(--mute);margin:0 0 14px}.top{display:flex;justify-content:space-between;align-items:center;gap:12px;flex-wrap:wrap;background:var(--card);border:1px solid var(--line);border-radius:10px;padding:14px 18px}
.grade{font-size:2rem;font-weight:700}.grade small{font-size:1rem;color:var(--mute);font-weight:400}
button{font:inherit;background:var(--accent);color:#fff;border:0;border-radius:8px;padding:8px 16px;cursor:pointer}
.card{background:var(--card);border:1px solid var(--line);border-radius:10px;padding:12px 16px;margin:8px 0}.card.warn{border-left:4px solid var(--warn)}
.card p{margin:4px 0}pre{background:var(--code);border-radius:6px;padding:8px 10px;overflow-x:auto;font:13px/1.45 ui-monospace,Menlo,monospace;margin:6px 0 0}
table{width:100%;border-collapse:collapse;background:var(--card);border:1px solid var(--line);border-radius:10px;font-size:.92rem}td,th{padding:7px 12px;text-align:left;border-bottom:1px solid var(--line);vertical-align:top}th{color:var(--mute);font-weight:500}
a{color:var(--accent)}textarea{position:absolute;left:-9999px}details{margin-top:28px}summary{cursor:pointer;color:var(--mute)}
`;

function page(g, name) {
    const b = build(g, name), text = plain(g, name);
    let h = `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>${esc(name)} Feedback</title><style>${CSS}</style></head><body><main>`;
    h += `<p class="sub"><a href="index.html">All students</a></p><h1>${esc(name)}</h1><p class="sub">Assignment 1: Express Routing</p>`;
    h += `<div class="top"><div class="grade">${g.grade} <small>/ ${g.outOf} &nbsp;(${g.total} before rounding up)</small></div><button id="copyAll">Copy feedback</button></div>`;
    if (b.good.length) h += `<h2>What worked</h2><p>${esc(join(b.good))}.</p>`;
    if (b.fix.length) {
        h += `<h2>What to fix</h2>`;
        b.fix.forEach(f => {
            h += `<div class="card"><p>${esc(f.text)}</p>`;
            if (f.code) h += `<p class="sub" style="margin:2px 0 0">Your code, ${esc(f.code)}</p>`;
            if (f.example) h += `<pre>${esc(f.example)}</pre>`;
            h += `<p class="sub" style="margin:4px 0 0">${esc(f.item)}: ${f.score} / ${f.max}</p></div>`;
        });
    }
    if (b.notes.length) {
        h += `<h2>About your project folder</h2>`;
        b.notes.forEach(s => h += `<div class="card warn"><p><b>${esc(s.title)}.</b> ${esc(s.text)}</p>${s.code ? `<pre>${esc(s.code)}</pre>` : ""}</div>`);
    }
    if (b.tips.length) { h += `<h2>A few extra things</h2>`; b.tips.forEach(t => h += `<div class="card"><p>${esc(t)}</p></div>`); }
    h += `<details><summary>How I checked each item</summary><table><tr><th>Item</th><th>Points</th><th>What I did</th></tr>`;
    for (const i of g.items) h += `<tr><td>${esc(i.item)}</td><td>${i.score} / ${i.max}</td><td>${esc(i.fb.test || i.note || "")}</td></tr>`;
    h += `</table></details><textarea id="plain">${esc(text)}</textarea></main><script>
document.getElementById("copyAll").onclick=function(e){var b=e.target,t=document.getElementById("plain").value;
function done(){var o=b.textContent;b.textContent="Copied";setTimeout(function(){b.textContent=o},1400)}
function fb(){var a=document.getElementById("plain");a.style.position="fixed";a.style.left="0";a.select();try{document.execCommand("copy");done()}catch(x){}a.style.left="-9999px"}
if(navigator.clipboard&&window.isSecureContext)navigator.clipboard.writeText(t).then(done,fb);else fb()};
</script></body></html>`;
    return h;
}

const index = [];
for (const f of files) {
    let g; try { g = JSON.parse(fs.readFileSync(path.join(resultsDir, "reports", f), "utf8")); } catch (e) { continue; }
    const id = f.replace(/_grade\.json$/, "");
    const name = g.studentName || titleCase(id);
    fs.writeFileSync(path.join(outDir, id + ".html"), page(g, name));
    index.push({ id, name, grade: g.grade, total: g.total, outOf: g.outOf, started: g.started });
}
let ih = `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Assignment 1 Feedback</title><style>${CSS}</style></head><body><main><h1>Assignment 1 Feedback</h1><p class="sub">Click a name to see the feedback and copy it.</p><table><tr><th>Student</th><th>Grade</th><th>Points</th></tr>`;
for (const s of index.sort((a, b) => a.name.localeCompare(b.name)))
    ih += `<tr><td><a href="${esc(s.id)}.html">${esc(s.name)}</a>${s.started ? "" : " (app did not run)"}</td><td>${s.grade} / ${s.outOf}</td><td>${s.total}</td></tr>`;
ih += `</table></main></body></html>`;
fs.writeFileSync(path.join(outDir, "index.html"), ih);
console.log(`Feedback pages saved to ${outDir} (${index.length} students)`);
FEEDBACK_EOF

# ---------------------------------------------------------------
# Main
# ---------------------------------------------------------------

# Proposals: id <tab> file name
: > "$TMPBASE/props.tsv"
for f in "$PROPOSALS"/*; do
    [ -f "$f" ] || continue
    b="$(basename "$f")"
    case "$(printf '%s' "$b" | tr 'A-Z' 'a-z')" in
        *.json) printf '%s\t%s\n' "$(student_id "${b%.*}")" "$b" >> "$TMPBASE/props.tsv" ;;
        *) say 'Ignored in proposals/ (only .json is read): %s' "$b" ;;
    esac
done

# Submissions: id <tab> folder <tab> how many folders had this id
: > "$TMPBASE/list.tsv"
for f in "$SUBMISSIONS"/*; do
    [ -e "$f" ] || continue
    b="$(basename "$f")"
    if [ -d "$f" ]; then
        printf '%s\t%s\n' "$(student_id "$b")" "$f" >> "$TMPBASE/list.tsv"
    else
        say 'Skipped in submissions/ (not a folder, unzip it first): %s' "$b"
    fi
done
awk -F'\t' '{ last[$1] = $2; n[$1]++ } END { for (k in last) print k "\t" last[k] "\t" n[k] }' \
    "$TMPBASE/list.tsv" | sort > "$TMPBASE/students.tsv"

if [ -n "$ONLY" ]; then
    awk -F'\t' -v id="$ONLY" '$1 == id' "$TMPBASE/students.tsv" > "$TMPBASE/one.tsv"
    mv "$TMPBASE/one.tsv" "$TMPBASE/students.tsv"
fi

count="$(wc -l < "$TMPBASE/students.tsv" | tr -d ' ')"
if [ "$count" -eq 0 ]; then
    say 'No project folders found in %s%s' "$SUBMISSIONS" "${ONLY:+ for '$ONLY'}"
    exit 1
fi

say 'Grading %s student(s)...' "$count"
say ''
position=0
while IFS="$(printf '\t')" read -r id folder copies; do
    position=$((position + 1))
    grade_one "$id" "$folder" "$copies" "$position" "$count"
done < "$TMPBASE/students.tsv"

# Proposals that have no project folder (only when grading everyone)
if [ -z "$ONLY" ]; then
    say ''
    while IFS="$(printf '\t')" read -r pid pname; do
        awk -F'\t' -v id="$pid" '$1 == id { found = 1 } END { exit !found }' "$TMPBASE/students.tsv" && continue
        write_meta "$pid" "" "" "$pname" "proposal found but no submission"
        say 'No submission for: %s' "$pid"
    done < "$TMPBASE/props.tsv"
fi

say ''
say '%s' "$(node "$TMPBASE/summary.js" "$RESULTS" 2>&1)"
say '%s' "$(node "$TMPBASE/feedback.js" "$RESULTS" "$FEEDBACK" 2>&1)"
say 'Logs: results/run.log and results/logs/<student>.log'