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
#                    reports/<id>_grade.txt   the report to send as feedback (and _grade.json)
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
    rm -rf "$REPORTS" "$LOGS" "$PROPOSAL_COPIES" "$META" "$RESULTS/summary.csv"
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
        node "$TMPBASE/grader.js" "$root" ${pj:+"$pj"} --out "$REPORTS" --name "$id" --log "$LOGS/${id}_app.log" --catlogs "$LOGS/$id"
    ) >> "$slog" 2>&1
    rc=$?
    [ "$rc" -ne 0 ] && notes="${notes:+$notes; }grader failed (exit $rc, see logs/$id.log)"

    write_meta "$id" "$name" "$nm" "$pstatus" "$notes"

    grade="not graded"
    if [ -f "$REPORTS/${id}_grade.json" ]; then
        grade="$(node -p "require('$REPORTS/${id}_grade.json').grade20" 2>> "$slog")/20"
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
const CATS = ["Routing & File Handling", "Error Handling", "Pages Served", "HTML Content", "Startup & Documentation"];
const out = [["student", "grade_out_of_20", "total_out_of_100", ...CATS.map(c => c + " (pts)"), "manual_points_pending", "zero_items", "flags", "proposal", "folder"].join(",")];
let graded = 0, look = 0;
for (const r of rows) {
    const flags = [];
    if (r.notes) flags.push(r.notes);
    if (r.modules && r.modules !== "included") flags.push("node_modules: " + r.modules);
    let g = null, grade = "", total = "", manual = "", zeros = "", cats = CATS.map(() => "");
    const jp = path.join(dir, "reports", r.id + "_grade.json");
    if (fs.existsSync(jp)) { try { g = JSON.parse(fs.readFileSync(jp, "utf8")); } catch (e) { flags.push("report could not be read"); } }
    if (g) {
        graded++; grade = g.grade20; total = g.total; manual = g.manualPoints || "";
        cats = CATS.map(c => g.categories && g.categories[c] ? `${g.categories[c].score}/${g.categories[c].max}` : "");
        zeros = g.items.filter(i => !i.manual && i.score === 0).map(i => i.item).join("; ");
        if (!g.started) flags.push(g.startNote ? "NOT TESTED: " + g.startNote : "app did not start");
        flags.push(...(g.flags || []));
    } else if (r.folder) flags.push("NOT GRADED");
    if (zeros || flags.length) look++;
    out.push([r.id, grade, total, ...cats, manual, zeros, flags.join("; "), r.proposal, r.folder].map(cell).join(","));
}
fs.writeFileSync(path.join(dir, "summary.csv"), "﻿" + out.join("\n") + "\n");
console.log(`Summary saved to ${path.join(dir, "summary.csv")}`);
console.log(`${graded} graded, ${rows.length - graded} not graded, ${look} with items to look at`);
SUMMARY_EOF

# ---------------------------------------------------------------
# The grader (the rubric: routing, errors, pages served, HTML, startup + docs). Started once per student.
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
let proposalArg, dirArg, outDir = ".", nameArg, logArg, catLogDir;
for (let i = 0; i < args.length; i++) {
    if (args[i] === "--out") outDir = args[++i];
    else if (args[i] === "--name") nameArg = args[++i];
    else if (args[i] === "--log") logArg = args[++i];
    else if (args[i] === "--catlogs") catLogDir = args[++i];
    else if (args[i].endsWith(".json")) proposalArg = args[i];
    else dirArg = args[i];
}
const projectDir = path.resolve(dirArg || ".");
if (!fs.existsSync(projectDir)) {
    console.error(`Folder not found: ${projectDir}`);
    process.exit(1);
}
const projectName = nameArg || path.basename(projectDir);
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

// Save the score for one rubric item. manual = true means "grader checks by eye":
// it is left out of the automatic total and listed separately.
const results = [];
function record(section, item, max, score, note, manual) {
    if (manual) { results.push({ section, item, max, score: null, note: note || "", manual: true }); return; }
    score = Math.max(0, Math.min(max, Math.round(score * 10) / 10));
    results.push({ section, item, max, score, note: note || "", manual: false });
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

// ---------------------------------------------------------------
// Grading
// ---------------------------------------------------------------
async function main() {
    console.log(`\nGrading project: ${projectName}\n`);
    let server = null;
    try {

    // Section names (the report and the per-category logs follow SECTION_ORDER)
    const R = "Routing & File Handling";   // 25
    const E = "Error Handling";            // 25
    const P = "Pages Served";              // 20
    const H = "HTML Content";              // 20
    const D = "Startup & Documentation";   // 10

    // ===== ENTRY FILE: any .js file, found from package.json =====
    let pkg = null, pkgNote = "";
    if (exists("package.json")) {
        try { pkg = JSON.parse(read("package.json")); }
        catch (e) { pkgNote = "package.json could not be read"; }
    } else pkgNote = "package.json not found";

    // 1) "main"  2) the file named in scripts.start / dev / serve  3) app.js, index.js, server.js
    const isFile = p => { try { return fs.statSync(full(p)).isFile(); } catch (e) { return false; } };
    let cand = "", entry = "", entrySource = "";
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

    const src = entry ? read(entry) : "";
    // Remove comments so they do not count as code
    const code = src.replace(/\/\*[\s\S]*?\*\//g, "").replace(/(^|[^:])\/\/.*$/gm, "$1");

    // ===== ROUTING & FILE HANDLING (25 points): reads the code =====
    const dynRoutes = (code.match(/\.get\s*\(\s*["'`]\/select\/:\w+/g) || []).length;
    const litRoutes = (code.match(/\.get\s*\(\s*["'`]\/select\/[^:"'`]/g) || []).length;
    const usesParams = /\.params\s*(\.\w+|\[)/.test(code) || /=\s*\w+\.params\b/.test(code);
    let routeScore = 0, routeNote = "";
    if (litRoutes >= 2) routeNote = `${litRoutes} separate /select routes (one per book)`;
    else if (dynRoutes === 1 && usesParams) routeScore = 10;
    else if (dynRoutes >= 1) routeNote = "dynamic route found but request.params not used";
    else routeNote = "no /select/:variable route found" + (entry ? " in " + entry + " (check by eye if routes are in another file)" : "");
    detail(R, `dynamic /select/:x routes: ${dynRoutes}, literal /select/... routes: ${litRoutes}, uses params: ${usesParams}`);
    record(R, "Single /select/:variable route with request.params", 10, routeScore, routeNote);

    const sendRoot = /\.sendFile\s*\([\s\S]{0,200}?root\s*:/.test(code);
    const sendAny = /\.sendFile\s*\(/.test(code);
    record(R, "sendFile with {root: ...}", 8, sendRoot ? 8 : 0,
        sendRoot ? "" : sendAny ? "sendFile used without root (check by eye)" :
        /readFile/.test(code) ? "uses fs.readFile instead of sendFile" : "sendFile not found");

    const resolveUsed = /path\.resolve\s*\(/.test(code);
    record(R, "path.resolve for the path", 7, resolveUsed ? 7 : 0,
        resolveUsed ? "" : /path\.join\s*\(/.test(code) ? "uses path.join instead of path.resolve" : "path.resolve not found");

    // ===== STARTUP: run the app with the entry file =====
    if (entry) server = await startServer(src);
    const running = server && server.ok;
    var busyNote = server && server.busy && server.busy.length
        ? `port ${server.busy.join(", ")} is already in use by another program on this computer. ` +
          `Close it (find it with: lsof -nP -iTCP:${server.busy[0]} -sTCP:LISTEN), then grade again.`
        : "";
    const down = running ? "" : busyNote ? `could not test: ${busyNote}` : "server did not start (see logs/<student>_app.log)";
    if (running) { console.log(`App is running on port ${PORT}\n`); detail(D, `app answered on port ${PORT}`); }
    else detail(D, down || "no entry file to start");

    // Request the home page, then every book page
    const home = running ? await get("/") : { status: 0, body: "" };
    if (running) detail(P, `GET / -> ${home.status || home.error}`);

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
    let bookIsbns;
    if (proposal) bookIsbns = proposal.books.map(b => String(b.isbn).replace(/-/g, ""));
    else bookIsbns = [...new Set(selectLinks.map(h => h.match(/\/select\/([\w-]+)\/?$/)[1]))].slice(0, 3);
    const book = isbn => proposal ? proposal.books.find(b => String(b.isbn).replace(/-/g, "") === isbn) : null;

    const pages = {};
    if (running) for (const isbn of bookIsbns) {
        pages[isbn] = await get(`/select/${isbn}`);
        detail(P, `GET /select/${isbn} -> ${pages[isbn].status || pages[isbn].error}`);
    }
    const goodPage = isbn => { const r = pages[isbn]; return !!r && r.status === 200 && !/not\s*found/i.test(r.body) && r.body.trim().length > 0; };

    // ===== PAGES SERVED (20 points): runs the app =====
    let homeScore = 0, homeNote = down;
    if (running) {
        if (home.status === 200 && /\/select\//.test(home.body)) { homeScore = 5; homeNote = ""; }
        else if (home.status === 200) homeNote = "GET / returned a page without /select/ links";
        else homeNote = `GET / returned ${home.status || home.error}`;
    }
    record(P, "/ returns the index page", 5, homeScore, homeNote);

    const okPages = bookIsbns.filter(goodPage).length;
    record(P, "/select/ISBN returns each book page", 10, 10 * okPages / 3,
        running ? `${okPages}/3 book pages returned` : down);

    // Cover images: take the <img src="/images/..."> of each book page and ask the server for it
    let served = 0;
    if (running) for (const isbn of bookIsbns) {
        if (!goodPage(isbn)) continue;
        const m = pages[isbn].body.match(/<img[^>]*src\s*=\s*["'](\/images\/[^"'?#]+)["']/i);
        if (!m) { detail(P, `/select/${isbn}: no <img src="/images/..."> found`); continue; }
        const r = await get(m[1]);
        detail(P, `GET ${m[1]} -> ${r.status || r.error} ${r.type}`);
        if (r.status === 200 && r.type.startsWith("image")) served++;
    }
    record(P, "Cover images served at /images/...", 5, 5 * served / 3,
        running ? `${served}/3 cover images loaded` : down);

    // ===== ERROR HANDLING (25 points): runs the app =====
    let badScore = 0, badNote = down;
    if (running) {
        const r = await get("/select/0000000000000");
        detail(E, `GET /select/0000000000000 -> ${r.status || r.error}: ${r.body.slice(0, 80).replace(/\s+/g, " ")}`);
        if (/not\s*found/i.test(r.body)) { badScore = 10; badNote = ""; }
        else if (/server\s*error/i.test(r.body)) badNote = "returns Server Error instead of a 'not found' message";
        else badNote = `no 'not found' message (status ${r.status || r.error})`;
    }
    record(E, "Nonexistent ISBN returns a not-found message", 10, badScore, badNote);

    let unkScore = 0, unkNote = down;
    if (running) {
        const r = await get("/no-such-route/xyz");
        detail(E, `GET /no-such-route/xyz -> ${r.status || r.error}: ${r.body.slice(0, 80).replace(/\s+/g, " ")}`);
        if (/not\s*found/i.test(r.body)) { unkScore = 8; unkNote = ""; }
        else if (/cannot\s+get/i.test(r.body)) unkNote = "Express default 'Cannot GET' page, no catch-all handler";
        else unkNote = `no 'not found' message (status ${r.status || r.error})`;
    }
    record(E, "Unknown route returns a not-found message", 8, unkScore, unkNote);

    // Other errors: the grader forces a real error with a badly encoded address (reaches the
    // error-handling middleware) and a file outside the root (reaches the sendFile callback).
    // Either one returning "Server Error" gets full credit.
    const errText = /server\s*error/i.test(code);
    let errScore = 0, errNote = down;
    if (running) {
        const r1 = await get("/select/%E0%A4%A");
        const r2 = await get("/select/..%2Fapp");
        detail(E, `GET /select/%E0%A4%A -> ${r1.status || r1.error}: ${r1.body.slice(0, 60).replace(/\s+/g, " ")}`);
        detail(E, `GET /select/..%2Fapp -> ${r2.status || r2.error}: ${r2.body.slice(0, 60).replace(/\s+/g, " ")}`);
        if (/server\s*error/i.test(r1.body) || /server\s*error/i.test(r2.body)) { errScore = 7; errNote = ""; }
        else if (errText) { errScore = 3; errNote = "'Server Error' is in the code but was not returned when an error was forced (handler may be broken, check by eye)"; }
        else errNote = "no 'Server Error' response found";
    } else if (errText) { errScore = 3; errNote = "'Server Error' is in the code, but the app did not start so it could not be tested"; }
    record(E, "Other errors return Server Error", 7, errScore, errNote);

    // ===== HTML CONTENT (20 points) =====
    // Each direct link to an .html file cancels out one good link (loss is at most 10)
    const good = Math.min(selectLinks.length, 3);
    const bad = Math.min(directLinks.length, 3);
    let linkNote = `${selectLinks.length} /select/ links (index ${indexFrom || "not found"})`;
    if (directLinks.length) linkNote += `, direct links to .html files: ${directLinks.join(", ")}`;
    record(H, "Index links use /select/ISBN", 10, 10 * Math.max(0, good - bad) / 3, linkNote);

    let titles = 0, covers = 0, prices = 0;
    for (const isbn of bookIsbns) {
        if (!goodPage(isbn)) continue;
        const r = pages[isbn];
        const text = textOf(r.body);
        const b = book(isbn);
        if (b && b.title ? text.includes(norm(b.title)) : /<(h[1-6]|title)[^>]*>\s*[^<\s]/i.test(r.body)) titles++;
        if (/<img[^>]*src\s*=\s*["']\/images\/[^"'?#]+["']/i.test(r.body)) covers++;
        if (b && b.price ? text.includes(String(b.price).replace("$", "")) : /\$\s?\d/.test(text)) prices++;
    }
    const auto = proposal ? "" : " (no proposal given: rough check, verify by eye)";
    const pageDown = running ? "" : ` ${down}`;
    record(H, "Title on each book page", 3, titles, `${titles}/3${auto}${pageDown}`);
    record(H, "Cover <img src=\"/images/...\"> on each book page", 4, 4 * covers / 3, `${covers}/3${pageDown}`);
    record(H, "Price on each book page", 3, prices, `${prices}/3${auto}${pageDown}`);

    // ===== STARTUP & DOCUMENTATION (10 points) =====
    record(D, "App starts from the package.json entry file", 3, running ? 3 : 0,
        running ? `${entry} (${entrySource})` : entry ? down : "no entry file found (package.json: " + (pkgNote || "no main or start script") + ")");

    let expressOk = false, expressNote = pkgNote;
    if (pkg) {
        const deps = Object.assign({}, pkg.dependencies, pkg.devDependencies);
        expressOk = !!deps.express;
        if (!expressOk) expressNote = "express not listed in package.json";
    }
    record(D, "express listed in package.json", 2, expressOk ? 2 : 0, expressNote);

    // Documentation: share of lines with comments (check by eye too)
    const lines = src.split("\n").filter(l => l.trim());
    const commentLines = lines.filter(l => /(^|[^:])\/\/|\/\*|^\s*\*/.test(l)).length;
    const ratio = lines.length ? commentLines / lines.length : 0;
    record(D, "Well documented", 5, ratio >= 0.15 ? 5 : ratio >= 0.07 ? 3 : ratio > 0 ? 1 : 0,
        `${Math.round(ratio * 100)}% comment lines (check by eye)`);

    } finally {
        // Always stop the student's app
        stopServer(server);
    }

    // ===== PRINT AND SAVE THE REPORT =====
    let report = `Grade report: ${projectName}\n${"=".repeat(60)}\n`;
    let total = 0, autoMax = 0, manualMax = 0;
    const SECTION_ORDER = ["Routing & File Handling", "Error Handling", "Pages Served", "HTML Content", "Startup & Documentation"];
    const categories = {};
    for (const sec of SECTION_ORDER.filter(s => results.some(r => r.section === s))) {
        const rows = results.filter(r => r.section === sec);
        const sScore = rows.filter(r => !r.manual).reduce((a, r) => a + r.score, 0);
        const sMax = rows.reduce((a, r) => a + r.max, 0);
        total += sScore;
        autoMax += rows.filter(r => !r.manual).reduce((a, r) => a + r.max, 0);
        manualMax += rows.filter(r => r.manual).reduce((a, r) => a + r.max, 0);
        categories[sec] = { score: Math.round(sScore * 10) / 10, max: sMax };
        report += `\n${sec}: ${Math.round(sScore * 10) / 10} / ${sMax}\n`;
        for (const r of rows) {
            const sc = r.manual ? "manual" : String(r.score);
            report += `  [${sc.padStart(6)} / ${String(r.max).padEnd(2)}] ${r.item}`;
            report += r.note ? `  -- ${r.note}\n` : "\n";
        }
    }
    report += `\n${"=".repeat(60)}\nTOTAL: ${Math.round(total * 10) / 10} / ${autoMax + manualMax}`;
    if (manualMax) report += `  (${autoMax} points graded automatically, ${manualMax} points left for manual check)`;
    report += "\n";
    // Final grade: the rubric is worth 100 points, the assignment is worth 20 (divide by 5)
    const r1 = x => Math.round(x * 10) / 10;
    report += `GRADE OUT OF 20: ${r1(total / 5)} / 20`;
    if (manualMax) report += `  (plus up to ${r1(manualMax / 5)} from the manual check)`;
    report += "\n";

    // Flags for feedback (no points taken)
    const flags = [];
    if (flags.length) report += `\nFlags for feedback (no points taken):\n` + flags.map(f => `  - ${f}`).join("\n") + "\n";

    // Only if the app could not start: show the end of its output so the 0s can be explained
    if (server && !server.ok) {
        const tail = server.log().trim().split("\n").slice(-3).map(l => l.slice(0, 200)).join("\n");
        report += busyNote
            ? `\nTHE APP COULD NOT BE TESTED: ${busyNote}\nThe zeros above are not the student's fault.\n`
            : `\nThe app did not start. Last lines of its output:\n${tail || "(empty)"}\n`;
    }

    console.log(report);
    fs.mkdirSync(outDir, { recursive: true });
    const out = path.join(outDir, `${projectName}_grade.txt`);
    fs.writeFileSync(out, report);
    fs.writeFileSync(path.join(outDir, `${projectName}_grade.json`), JSON.stringify({
        student: projectName, total: r1(total), outOf100: autoMax + manualMax, grade20: r1(total / 5),
        manualPoints: manualMax, categories, started: !!(server && server.ok), startNote: (server && server.ok) ? "" : busyNote, flags, items: results
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
            for (const r of rows) t += `[${String(r.score).padStart(5)} / ${String(r.max).padEnd(2)}] ${r.item}${r.note ? "  -- " + r.note : ""}\n`;
            fs.writeFileSync(path.join(catLogDir, `${i + 1}-${sec.toLowerCase().replace(/[^a-z]+/g, "-").replace(/^-|-$/g, "")}.log`), t);
        });
    }
    console.log(`Report saved to ${out}`);
    process.exit(0);
}

main().catch(e => { console.error("Grader crashed:", e); process.exit(1); });
GRADER_EOF

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
say 'Logs: results/run.log and results/logs/<student>.log'