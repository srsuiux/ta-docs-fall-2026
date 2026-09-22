# University Database — What the Data Means

This explains every code and abbreviation used in `university_seed_data.sql`. The database
stores short codes to save space, which is normal practice, but the codes only make sense
if you know what they stand for. Read this before writing queries against the data.

---

## The five tables in one sentence each

**Course** is the catalog — a course exists here whether or not anyone ever teaches it.

**Faculty** is the instructor list, including who reports to whom.

**Student** is the student roster, one row per student.

**Offering** is a specific run of a course in a specific term — the same course taught in
Fall 2025 and again in Spring 2026 is two separate offerings with two different offer numbers.

**Enrollment** connects a student to an offering and records the grade they earned.

The distinction between **Course** and **Offering** is the one that confuses people most.
`IS320` is a course. `IS320 taught Mondays and Wednesdays at 10:30 in Fall 2025 by Professor
Fibon` is an offering. Students enroll in offerings, not courses.

---

## Identification numbers

**StdNo** and **FacNo** are eleven-character student and faculty numbers, formatted like
`123-45-6789`. They look like Social Security numbers because older university systems used
SSNs as identifiers. Real universities stopped doing this because of identity theft and now
issue their own numbers — YSU's Y-number is exactly that kind of replacement. The format is
kept here to match the textbook.

**OfferNo** is a plain integer identifying one offering, such as `1111` or `5678`. The numbers
carry no meaning; they are just unique labels.

**CourseNo** is the catalog code, such as `IS320`. The letters are the department and the digits
are the level — a `3xx` course is junior level, `4xx` is senior level, `2xx` is sophomore level.

---

## StdMajor — the student's declared major

| Code | Meaning |
|------|---------|
| `IS` | Information Systems |
| `FIN` | Finance |
| `ACCT` | Accounting |
| *(NULL)* | Undeclared — the student has not chosen a major yet |

Bonnie Granger has a NULL major. She is a freshman and has not declared. This is a real
business situation, not missing data: NULL here means "no major exists," not "we forgot to
type it in."

---

## StdClass — the student's year

| Code | Meaning |
|------|---------|
| `FR` | Freshman (first year) |
| `SO` | Sophomore (second year) |
| `JR` | Junior (third year) |
| `SR` | Senior (fourth year) |

---

## StdGPA — grade point average

A number from 0.00 to 4.00 on the standard American scale, where 4.00 is an A average and
2.00 is a C average. This is the student's *overall* GPA as stored on their record.

Roberto Morales has a NULL GPA. He is a transfer student whose GPA has not been calculated
yet. Again, NULL means the value does not exist, which is different from a GPA of 0.00 —
a 0.00 would mean he failed everything.

---

## FacRank — the instructor's academic rank

| Code | Meaning |
|------|---------|
| `INST` | Instructor — teaches, usually not on a tenure track |
| `ASST` | Assistant Professor — tenure track, most junior professor rank |
| `ASSC` | Associate Professor — tenured, mid rank |
| `PROF` | Full Professor — most senior rank |

Ranks go INST → ASST → ASSC → PROF as a career progresses, and salary generally follows.
Amy Tang has a NULL rank because she is newly hired and not yet classified.

---

## FacDept — the instructor's department

| Code | Meaning |
|------|---------|
| `MS` | Management Science — teaches the IS courses |
| `FIN` | Finance |
| `ACCT` | Accounting |

Note that department codes and major codes overlap but are not the same field. `FIN` in
`Student.StdMajor` means a student majoring in finance; `FIN` in `Faculty.FacDept` means an
instructor employed by the finance department.

---

## FacSupervisor — who the instructor reports to

This holds the **FacNo of another faculty member**, which is why the Faculty table has a
foreign key pointing at itself. A NULL means this person has no supervisor — they are at
the top of the chain.

The supervision structure in this data:

- Victoria Emmanuel (PROF) supervises Leonard Fibon
- Leonard Fibon (ASSC) supervises John Miller
- Nicki Macon (PROF) supervises Cristopher Colan and Julia Mills
- Emmanuel, Macon and Tang report to nobody

---

## OffTerm and OffYear — when the offering runs

| Code | Meaning |
|------|---------|
| `FALL` | Fall term, roughly August to December |
| `WINTER` | Winter term, January to March |
| `SPRING` | Spring term, March to June |
| `SUMMER` | Summer term, June to August |

`OffYear` is the four-digit calendar year. The two columns together identify a term, so
`FALL` + `2025` is a different term from `FALL` + `2026`. Neither column alone is enough.

---

## OffDays — which days the class meets

| Code | Meaning |
|------|---------|
| `MW` | Mondays and Wednesdays |
| `TTH` | Tuesdays and Thursdays |

These are the two standard American university meeting patterns. A class meets twice a week
on one pattern or the other.

---

## OffLocation — the room

Values look like `BLM302`. `BLM` is the building abbreviation and the three digits are the
room number, so `BLM302` is room 302 in the BLM building. The first digit is the floor.

Offering 2222 has a NULL location because the room has not been assigned yet.

---

## OffTime — the class start time

Stored as an Oracle `DATE`, which in Oracle carries both a date and a time. The date portion
is set to a fixed placeholder because only the time matters — the class meets at 10:30 every
Monday and Wednesday, not on one particular calendar day. Read only the time portion.

Offering 9999 has a NULL time because it is a future offering that has not been scheduled.

---

## EnrGrade — the grade earned in one class

A number from 0.00 to 4.00 on the same scale as GPA:

| Grade | Letter |
|-------|--------|
| 4.0 | A |
| 3.7 | A− |
| 3.3 | B+ |
| 3.0 | B |
| 2.7 | B− |
| 2.0 | C |

A NULL grade means the class is **in progress** — the student is enrolled but no grade has
been assigned yet. This is not the same as a failing grade. When you write queries, remember
that `AVG(EnrGrade)` silently ignores these rows, so a student's average is computed only
over the classes that actually have grades.

---

## Deliberate gaps in the data

The following are intentional, not mistakes. They exist so you can see the difference between
query techniques that look equivalent but are not.

| What | Which rows | Why it is there |
|------|-----------|-----------------|
| Courses never offered | ACC201, FIN480, IS490 | An INNER JOIN to Offering drops them; a LEFT JOIN keeps them |
| Student with no enrollments | Phillip Lee | Same effect from the Student side |
| Offering with nobody enrolled | 9999 | A class that exists but has no students |
| Instructor teaching nothing | Amy Tang | Newly hired, no assignments yet |
| Offering with no instructor | 2222 | Instructor not yet assigned — the textbook explicitly says this happens |
| Grades not yet given | 4 enrollments, including all of offering 5679 | Term still in progress |
| NULL major, GPA, units, room, time | Granger, Morales, IS490, 2222, 9999 | One NULL in every table so you meet NULL handling everywhere |

The NULL instructor in offering 2222 matters more than it looks. It makes
`WHERE FacNo NOT IN (SELECT FacNo FROM Offering)` return **zero rows** instead of the one row
you would expect, because a NOT IN comparison against a set containing NULL is never true.
Most sample databases have no NULLs, so students never encounter this until it breaks
something real.

---

## A note on the data itself

These rows follow the naming conventions of Mannino's University database but the specific
students, faculty and grades were written for this assignment. They are not the rows printed
in the textbook, so your query output will not match the book's printed results.