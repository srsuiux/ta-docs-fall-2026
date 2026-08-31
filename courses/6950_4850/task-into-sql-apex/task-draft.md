# Getting Started with Oracle APEX — Your First Table and Query

**Course:** _[Course number / name]_
**Instructor:** _[Name]_
**Estimated time:** 30–45 minutes

---

## Before You Begin

This is a warm-up, not a graded assignment. The goal is simple: by the end of this
document you will have created a table, put data into it, and pulled that data back
out with SQL — all inside Oracle APEX.

You do not need to understand database theory yet. Just follow the steps, run the
commands, and look at what comes back.

**What you will do:**

1. Find your way around the APEX SQL Workshop
2. Create a table with `CREATE TABLE`
3. Add sample rows with `INSERT`
4. Read the data back with `SELECT`
5. Change data with `UPDATE` and remove it with `DELETE`
6. Break a few things on purpose so the error messages are familiar later

---

## Step 1 — Open the SQL Workshop

Sign in to your APEX workspace and look at the top navigation bar. Click
**SQL Workshop**.

This is where all your database work happens. Everything else in APEX (App Builder,
etc.) is for building applications — ignore it for now.

![Screenshot: APEX home page with SQL Workshop highlighted](images/step-01-sql-workshop.png)

_Figure 1 — [description]_

---

## Step 2 — Know Your Three Tools

Inside SQL Workshop there are three things you will actually use. Open each one
briefly so you know what it looks like.

| Tool | What it is for | When you'll use it |
|------|----------------|--------------------|
| **SQL Commands** | Type and run **one** SQL statement at a time | Most of this document |
| **Object Browser** | Point-and-click view of your tables, columns, and data | Checking your work |
| **SQL Scripts** | Run **many** statements at once, saved as a file | Longer setup scripts |

For the rest of this walkthrough, use **SQL Commands** unless told otherwise.

![Screenshot: SQL Workshop menu showing the three tools](images/step-02-workshop-menu.png)

_Figure 2 — [description]_

> **Note:** SQL Commands runs one statement per click of **Run**. If you paste three
> statements separated by semicolons, it will fail. Run them one at a time, or move
> them to SQL Scripts.

---

## Step 3 — Create Your First Table

In **SQL Commands**, clear the editor and type the following. Type it rather than
pasting it — you will remember it better.

```sql
CREATE TABLE students (
    student_id     NUMBER          PRIMARY KEY,
    first_name     VARCHAR2(50)    NOT NULL,
    last_name      VARCHAR2(50)    NOT NULL,
    major          VARCHAR2(50),
    gpa            NUMBER(3,2),
    enrolled_date  DATE
);
```

Click **Run**. You should see a success message telling you the table was created.

![Screenshot: CREATE TABLE statement and success message](images/step-03-create-table.png)

_Figure 3 — [description]_

### What the data types mean

| Type | Holds | Example |
|------|-------|---------|
| `NUMBER` | Any number, whole or decimal | `1001`, `3.75` |
| `NUMBER(3,2)` | 3 digits total, 2 after the decimal point | `3.75` — good for a GPA |
| `VARCHAR2(50)` | Text, up to 50 characters | `'Sharma'` |
| `DATE` | A date (and time) | `2026-08-25` |

### What the extra keywords mean

- **`PRIMARY KEY`** — this column uniquely identifies each row. No duplicates, no blanks.
- **`NOT NULL`** — this column cannot be left empty.

Pick your `VARCHAR2` sizes with a little room to spare. `VARCHAR2(50)` only uses the
space it needs, so being generous costs you nothing.

---

## Step 4 — Confirm the Table Exists

Go to **SQL Workshop → Object Browser** and click **STUDENTS** in the left panel.

You should see your six columns listed with their data types. Click through the tabs
across the top (**Data**, **Constraints**, **Indexes**) to see what APEX generated for
you. The **Data** tab will be empty — that is expected, you haven't added anything yet.

![Screenshot: Object Browser showing the STUDENTS table columns](images/step-04-object-browser.png)

_Figure 4 — [description]_

---

## Step 5 — Insert Sample Data

Back in **SQL Commands**, run each of these one at a time.

```sql
INSERT INTO students VALUES (1001, 'Maya', 'Patel', 'Computer Science', 3.85, DATE '2025-08-25');
```

```sql
INSERT INTO students VALUES (1002, 'Jordan', 'Lee', 'Information Systems', 3.20, DATE '2025-08-25');
```

```sql
INSERT INTO students VALUES (1003, 'Sam', 'Okafor', 'Computer Science', 3.95, DATE '2024-01-15');
```

```sql
INSERT INTO students VALUES (1004, 'Riley', 'Chen', 'Data Analytics', 2.90, DATE '2025-01-13');
```

```sql
INSERT INTO students VALUES (1005, 'Alex', 'Novak', 'Information Systems', 3.60, DATE '2024-08-26');
```

Each one should report **1 row(s) inserted**.

![Screenshot: INSERT statement with the 1 row inserted message](images/step-05-insert.png)

_Figure 5 — [description]_

### Two things to notice

**Text goes in single quotes.** `'Maya'` — not `"Maya"`, not `Maya`. Double quotes mean
something different in Oracle and will give you an error.

**Dates need a format.** `DATE '2025-08-25'` always works and always uses
`YYYY-MM-DD`. If you write `'25-AUG-2025'` it may work on one system and fail on
another, so stick with the `DATE` literal.

### Naming your columns explicitly

The inserts above rely on column order. That is fine for a quick test, but the safer
habit — and the one you should use in your assignments — names the columns:

```sql
INSERT INTO students (student_id, first_name, last_name, major, gpa, enrolled_date)
VALUES (1006, 'Priya', 'Raman', 'Computer Science', 3.40, DATE '2026-01-12');
```

This version still works if someone adds a column to the table later.

---

## Step 6 — Your First SELECT

This is the one you will write more than any other:

```sql
SELECT * FROM students;
```

The `*` means "every column." Run it, and APEX shows your rows in a results grid at
the bottom of the page.

![Screenshot: SELECT * results grid showing six rows](images/step-06-select-all.png)

_Figure 6 — [description]_

### Reading the results grid

- Column headers come from your table definition
- Each row of the grid is one row in the table
- Row order is **not guaranteed** unless you ask for it with `ORDER BY`
- The row count appears below the grid

Now ask for only the columns you want:

```sql
SELECT first_name, last_name, gpa FROM students;
```

Fewer columns, same rows. That is the difference between `SELECT *` and naming
columns.

---

## Step 7 — Narrow It Down

`WHERE` filters which rows come back. `ORDER BY` decides what order they come back in.
Run each of these and watch what changes.

**Students in one major:**

```sql
SELECT first_name, last_name, major
FROM students
WHERE major = 'Computer Science';
```

**Students above a GPA cutoff, best first:**

```sql
SELECT first_name, last_name, gpa
FROM students
WHERE gpa > 3.50
ORDER BY gpa DESC;
```

**Two conditions at once:**

```sql
SELECT first_name, last_name, major, gpa
FROM students
WHERE major = 'Computer Science'
  AND gpa >= 3.00;
```

**Partial text match** — `%` stands for "anything":

```sql
SELECT first_name, last_name, major
FROM students
WHERE major LIKE 'Info%';
```

**Count rows instead of listing them:**

```sql
SELECT COUNT(*) AS total_students FROM students;
```

**Group and summarize:**

```sql
SELECT major, COUNT(*) AS student_count, ROUND(AVG(gpa), 2) AS avg_gpa
FROM students
GROUP BY major
ORDER BY student_count DESC;
```

![Screenshot: GROUP BY query with its results](images/step-07-group-by.png)

_Figure 7 — [description]_

> **Case matters inside quotes.** `WHERE major = 'computer science'` returns nothing,
> because the stored value is `'Computer Science'`. The keywords (`SELECT`, `WHERE`)
> are not case sensitive, but your data is.

---

## Step 8 — Change Data with UPDATE

`UPDATE` modifies rows that already exist.

```sql
UPDATE students
SET gpa = 3.75
WHERE student_id = 1004;
```

Confirm it worked:

```sql
SELECT student_id, first_name, gpa FROM students WHERE student_id = 1004;
```

You can change more than one column at once:

```sql
UPDATE students
SET major = 'Data Science', gpa = 3.10
WHERE student_id = 1002;
```

![Screenshot: UPDATE statement and the row-updated confirmation](images/step-08-update.png)

_Figure 8 — [description]_

> ### The most expensive mistake in SQL
>
> ```sql
> UPDATE students SET gpa = 4.0;   -- no WHERE clause
> ```
>
> That updates **every row in the table**. There is no undo button once it commits.
> Get in the habit of writing the `WHERE` clause first, running it as a `SELECT` to see
> which rows it catches, and only then turning it into an `UPDATE`.

---

## Step 9 — Remove Data with DELETE

```sql
DELETE FROM students
WHERE student_id = 1006;
```

Check the result:

```sql
SELECT * FROM students;
```

The same warning applies. `DELETE FROM students;` with no `WHERE` empties the entire
table.

![Screenshot: DELETE statement and the resulting row count](images/step-09-delete.png)

_Figure 9 — [description]_

### DELETE vs DROP

| Statement | Effect |
|-----------|--------|
| `DELETE FROM students;` | Removes the rows. The table still exists, empty. |
| `DROP TABLE students;` | Removes the table itself — structure, rows, everything. |

---

## Step 10 — Experiment

Now change things and see what happens. Nothing here is graded, and you can always
start over with Step 12.

**Add a column:**

```sql
ALTER TABLE students ADD (email VARCHAR2(100));
```

**Fill it in for one student:**

```sql
UPDATE students
SET email = 'mpatel@student.ysu.edu'
WHERE student_id = 1001;
```

**Find the rows that are still missing an email** — note that it is `IS NULL`, not
`= NULL`:

```sql
SELECT student_id, first_name, email
FROM students
WHERE email IS NULL;
```

**Rename a column:**

```sql
ALTER TABLE students RENAME COLUMN major TO program;
```

(If you do this, remember every later query needs `program` instead of `major`. Rename
it back with the same statement reversed if that gets confusing.)

**Drop the column you added:**

```sql
ALTER TABLE students DROP COLUMN email;
```

### Try these on your own

Write the SQL yourself, then run it:

1. List every student whose last name starts with the letter `P`
2. Show only the students who enrolled in 2025
3. Find the highest GPA in the table (hint: `MAX`)
4. Add yourself as a new row, then delete yourself again
5. Sort all students by last name, A to Z

---

## Step 11 — The Four Commands at a Glance

| Command | Question it answers | Basic shape |
|---------|--------------------|--------------|
| `SELECT` | What data is in there? | `SELECT cols FROM table WHERE condition;` |
| `INSERT` | How do I add new data? | `INSERT INTO table (cols) VALUES (vals);` |
| `UPDATE` | How do I change existing data? | `UPDATE table SET col = val WHERE condition;` |
| `DELETE` | How do I remove data? | `DELETE FROM table WHERE condition;` |

`SELECT` reads. The other three write. Only the writers need a `WHERE` clause to stay
out of trouble.

---

## Step 12 — Starting Over (Optional)

If your table has gotten messy and you want a clean slate:

```sql
DROP TABLE students;
```

Then go back to Step 3 and rebuild it. Doing the whole sequence a second time without
looking is the best possible practice.

---

## Common Errors and What They Mean

You will hit these. They are normal — Oracle error messages are blunt but specific.

| Error | What it usually means | Fix |
|-------|----------------------|-----|
| `ORA-00942: table or view does not exist` | Table name typo, or the table was never created | Check spelling; run `SELECT table_name FROM user_tables;` |
| `ORA-00904: invalid identifier` | Column name typo, or a column that isn't in the table | Compare against the Object Browser column list |
| `ORA-00001: unique constraint violated` | You inserted a `student_id` that already exists | Use a different ID |
| `ORA-01400: cannot insert NULL` | You left a `NOT NULL` column empty | Provide a value for that column |
| `ORA-12899: value too large for column` | Your text is longer than the `VARCHAR2` size | Shorten the value or `ALTER TABLE` to widen the column |
| `ORA-01722: invalid number` | You put quotes around a number, or text into a `NUMBER` column | Remove the quotes; check which column got which value |
| `ORA-01858: a non-numeric character was found` | Date format doesn't match what Oracle expects | Use `DATE '2025-08-25'` |
| `ORA-00933: SQL command not properly ended` | Two statements pasted into SQL Commands at once, or a stray word after the statement | Run one statement at a time |
| `ORA-00936: missing expression` | Something is missing — often a comma, a value, or the column list | Re-read the statement slowly from the start |
| `ORA-00955: name is already used` | You ran `CREATE TABLE` twice | `DROP TABLE students;` first, or use a different name |
| *No error, but zero rows returned* | Your `WHERE` condition matched nothing — often a case or spelling mismatch | Run `SELECT * FROM students;` and compare the actual values |

### Habits that prevent most of them

- Text in **single** quotes, numbers with no quotes
- One statement at a time in SQL Commands
- Write the `WHERE` clause before the `UPDATE` or `DELETE`
- After every write, run a `SELECT` to confirm what actually changed
- Read the error from the **top** — the first message is the real one

---

## Checklist

Before your first assignment, you should be able to say yes to all of these:

- [ ] I can find SQL Commands and Object Browser in APEX
- [ ] I created the `STUDENTS` table and saw it in the Object Browser
- [ ] I inserted rows and saw the confirmation message
- [ ] I ran `SELECT *` and read the results grid
- [ ] I filtered rows with `WHERE` and sorted them with `ORDER BY`
- [ ] I updated a row and confirmed the change with a `SELECT`
- [ ] I deleted a row and confirmed it was gone
- [ ] I added and removed a column with `ALTER TABLE`
- [ ] I caused at least one error on purpose and understood the message

If any box is unchecked, redo that step before moving on. Everything in this course
builds on these five statements.

---

_Questions? Bring them to office hours or post them in the course discussion board._