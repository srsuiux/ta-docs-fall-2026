#!/usr/bin/env python3
# proposal_to_json.py - Turn a student's proposal (PDF or text) into proposal.json
#
# How to use:
#   pip install -r requirements.txt
#   python proposal_to_json.py proposal.pdf
#   python proposal_to_json.py proposal.pdf my_output.json
#   python proposal_to_json.py proposal.pdf --debug     (also shows the raw text)
#
# Always read the printed result before grading. Proposals are written
# in different ways, so the script can miss or mix up details.

import json
import re
import sys
from pathlib import Path


def read_text(file_path):
    """Get all the text from a PDF or a text file."""
    if file_path.suffix.lower() == ".pdf":
        from pypdf import PdfReader
        reader = PdfReader(str(file_path))
        return "\n".join(page.extract_text() or "" for page in reader.pages)
    return file_path.read_text(encoding="utf-8", errors="ignore")


def flatten(text):
    """Join all text into one line with single spaces."""
    return re.sub(r"\s+", " ", text)


def find_student(text):
    """Find the student's name: the words after 'Student:' up to the next label."""
    flat = flatten(text)
    match = re.search(
        r"(?:Student(?:\s*Name)?|Name)\s*:\s*(.+?)\s*(?=Date\s*:|Author|Book\s*\d|Title\s*:|ISBN|Price\s*:|$)",
        flat, re.I)
    return match.group(1).strip() if match else ""


def find_isbns(text):
    """Find 13-digit ISBNs (with or without hyphens), in order, without repeats."""
    isbns = []
    for raw in re.findall(r"97[89][\d\-\s]{10,16}", text):
        digits = re.sub(r"\D", "", raw)[:13]
        if len(digits) == 13 and digits not in isbns:
            isbns.append(digits)
    return isbns


def find_prices(text):
    """Find prices like $49.24, in order."""
    return re.findall(r"\$\s?(\d+(?:\.\d{2})?)", text)


def find_titles(text):
    """Find each title: the words after 'Title:' up to the next label."""
    flat = flatten(text)
    titles = re.findall(
        r"Title\s*:\s*(.+?)\s*(?=Price\s*:|ISBN|Cover|Author|Book\s*\d|Title\s*:|—|$)",
        flat, re.I)
    if not titles:
        titles = re.findall(
            r"Book\s*\d+\s*[:\-–]\s*(.+?)\s*(?=Title\s*:|Price\s*:|ISBN|$)",
            flat, re.I)
    return [t.strip() for t in titles]


def main():
    # Separate the options from the file names
    debug = "--debug" in sys.argv
    files = [a for a in sys.argv[1:] if a != "--debug"]

    if not files:
        print("Usage: python proposal_to_json.py <proposal.pdf or .txt> [output.json] [--debug]")
        sys.exit(1)

    in_path = Path(files[0])
    out_path = Path(files[1]) if len(files) > 1 else Path("proposal.json")
    if not in_path.exists():
        print(f"File not found: {in_path}")
        sys.exit(1)

    text = read_text(in_path)

    # Show the raw text if asked, to see how the PDF was read
    if debug:
        print("----- RAW TEXT FROM FILE -----\n" + text + "\n------------------------------\n")

    student = find_student(text)
    isbns = find_isbns(text)
    titles = find_titles(text)
    prices = find_prices(text)

    # Match books by order: first ISBN with first title and first price, and so on
    books = []
    for i in range(3):
        books.append({
            "isbn": isbns[i] if i < len(isbns) else "",
            "title": titles[i] if i < len(titles) else "",
            "price": prices[i] if i < len(prices) else "",
        })

    data = {"student": student, "books": books}
    out_path.write_text(json.dumps(data, indent=2), encoding="utf-8")

    # Show the result and point out anything missing or suspicious
    print(json.dumps(data, indent=2))
    print(f"\nSaved to {out_path}")

    problems = []
    if not student:
        problems.append("student name not found")
    elif len(student.split()) < 2:
        problems.append(f"student name '{student}' is only one word, may be cut off")
    for i, b in enumerate(books, 1):
        for field in ("isbn", "title", "price"):
            if not b[field]:
                problems.append(f"book {i}: {field} not found")
        if b["title"] and len(b["title"].split()) < 2:
            problems.append(f"book {i}: title '{b['title']}' is only one word, may be cut off")
    if len(isbns) > 3:
        problems.append(f"found {len(isbns)} ISBNs, used the first 3")

    if problems:
        print("\nPlease check and fill in by hand:")
        for p in problems:
            print(f"  - {p}")
    else:
        print("\nAll fields found. Still check them against the proposal.")


if __name__ == "__main__":
    main()