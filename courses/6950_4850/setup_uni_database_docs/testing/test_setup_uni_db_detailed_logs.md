# Test Script — Detailed Results

Script: `test_setup_uni_db`
Run by: US_B168_SQL_S30 · Parsing schema: US_B168_SQL_S30
Oracle APEX 24.2.17 · Tuesday, September 01, 2026

**Statements processed: 30 · Successful: 30 · With errors: 0 · Elapsed: 0.45 seconds**

A dash (`-`) in any result table means NULL.

---

## 1

```sql
SELECT * FROM Student
```

| STDNO | STDFIRSTNAME | STDLASTNAME | STDCITY | STDSTATE | STDZIP | STDMAJOR | STDCLASS | STDGPA |
|---|---|---|---|---|---|---|---|---|
| 123-45-6789 | HOMER | WELLS | SEATTLE | WA | 98121-1111 | IS | FR | 3 |
| 124-56-7890 | BOB | NORBERT | BOTHELL | WA | 98011-2121 | FIN | JR | 2.7 |
| 234-56-7890 | CANDY | KENDALL | TACOMA | WA | 99042-3321 | ACCT | JR | 3.5 |
| 345-67-8901 | WALLY | KENDALL | SEATTLE | WA | 98123-1141 | IS | SO | 2.8 |
| 456-78-9012 | JOE | ESTRADA | SEATTLE | WA | 98121-2333 | FIN | SR | 3.2 |
| 567-89-0123 | MARIAH | DODGE | SEATTLE | WA | 98114-0021 | IS | JR | 3.6 |
| 678-90-1234 | TESS | DODGE | REDMOND | WA | 98116-2344 | ACCT | SO | 3.3 |
| 789-01-2345 | ROBERTO | MORALES | SEATTLE | WA | 98121-2333 | FIN | SR | - |
| 890-12-3456 | LUKE | BRAZZI | SEATTLE | WA | 98116-0021 | IS | SR | 2.2 |
| 901-23-4567 | BONNIE | GRANGER | SEATTLE | WA | 98114-1332 | - | FR | 3.9 |
| 012-34-5678 | PHILLIP | LEE | SEATTLE | WA | 98111-9921 | IS | SO | 2.5 |

11 rows selected. 0.02 seconds

---

## 2

```sql
SELECT StdFirstName, StdLastName, StdClass, StdGPA
FROM Student
WHERE StdMajor = 'IS'
```

| STDFIRSTNAME | STDLASTNAME | STDCLASS | STDGPA |
|---|---|---|---|
| HOMER | WELLS | FR | 3 |
| WALLY | KENDALL | SO | 2.8 |
| MARIAH | DODGE | JR | 3.6 |
| LUKE | BRAZZI | SR | 2.2 |
| PHILLIP | LEE | SO | 2.5 |

5 rows selected. 0.01 seconds

---

## 3

```sql
SELECT StdNo, StdLastName
FROM Student
WHERE StdGPA IS NULL
```

| STDNO | STDLASTNAME |
|---|---|
| 789-01-2345 | MORALES |

Statement processed. 0.01 seconds

---

## 4

```sql
SELECT DISTINCT StdMajor
FROM Student
ORDER BY StdMajor
```

| STDMAJOR |
|---|
| ACCT |
| FIN |
| IS |
| - |

4 rows selected. 0.01 seconds

---

## 5

```sql
SELECT FacLastName, FacSalary, FacRank
FROM Faculty
WHERE FacSalary BETWEEN 40000 AND 80000
ORDER BY FacSalary DESC
```

| FACLASTNAME | FACSALARY | FACRANK |
|---|---|---|
| MILLS | 75000 | ASSC |
| FIBON | 70000 | ASSC |
| MACON | 65000 | PROF |
| COLAN | 40000 | ASST |

4 rows selected. 0.01 seconds

---

## 6

```sql
SELECT COUNT(*) AS AllStudents, COUNT(StdGPA) AS WithGPA
FROM Student
```

| ALLSTUDENTS | WITHGPA |
|---|---|
| 11 | 10 |

Statement processed. 0.00 seconds

---

## 7

```sql
SELECT StdMajor, COUNT(*) AS NumStudents, ROUND(AVG(StdGPA),2) AS AvgGPA
FROM Student
GROUP BY StdMajor
ORDER BY StdMajor
```

| STDMAJOR | NUMSTUDENTS | AVGGPA |
|---|---|---|
| ACCT | 2 | 3.4 |
| FIN | 3 | 2.95 |
| IS | 5 | 2.82 |
| - | 1 | 3.9 |

4 rows selected. 0.00 seconds

---

## 8

```sql
SELECT OffTerm, OffYear, COUNT(*) AS NumOfferings
FROM Offering
GROUP BY OffTerm, OffYear
HAVING COUNT(*) >= 3
ORDER BY OffYear, OffTerm
```

| OFFTERM | OFFYEAR | NUMOFFERINGS |
|---|---|---|
| FALL | 2025 | 3 |
| WINTER | 2026 | 4 |

2 rows selected. 0.01 seconds

---

## 9

```sql
SELECT FacDept, COUNT(*) AS NumFaculty, AVG(FacSalary) AS AvgSalary
FROM Faculty
WHERE FacRank IS NOT NULL
GROUP BY FacDept
HAVING COUNT(*) > 1
```

| FACDEPT | NUMFACULTY | AVGSALARY |
|---|---|---|
| MS | 4 | 76666.6666666666666666666666666666666667 |
| FIN | 2 | 70000 |

2 rows selected. 0.01 seconds

---

## 10

```sql
SELECT o.OfferNo, o.CourseNo, c.CrsDesc, o.OffTerm, o.OffYear
FROM Offering o
     INNER JOIN Course c ON o.CourseNo = c.CourseNo
ORDER BY o.OfferNo
```

| OFFERNO | COURSENO | CRSDESC | OFFTERM | OFFYEAR |
|---|---|---|---|---|
| 1111 | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | FALL | 2025 |
| 1234 | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | FALL | 2025 |
| 2222 | IS460 | SYSTEMS ANALYSIS | SUMMER | 2025 |
| 3333 | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | SPRING | 2026 |
| 4321 | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | FALL | 2025 |
| 4444 | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | WINTER | 2026 |
| 5555 | FIN300 | FUNDAMENTALS OF BUSINESS FINANCE | WINTER | 2026 |
| 5678 | IS480 | FUNDAMENTALS OF DATABASE MANAGEMENT | WINTER | 2026 |
| 5679 | IS480 | FUNDAMENTALS OF DATABASE MANAGEMENT | SPRING | 2026 |
| 6666 | FIN450 | PRINCIPLES OF INVESTMENTS | WINTER | 2026 |
| 7777 | FIN450 | PRINCIPLES OF INVESTMENTS | SUMMER | 2026 |
| 8888 | IS460 | SYSTEMS ANALYSIS | SUMMER | 2026 |
| 9999 | IS460 | SYSTEMS ANALYSIS | FALL | 2026 |

13 rows selected. 0.02 seconds

---

## 11

```sql
SELECT o.OfferNo, c.CrsDesc, f.FacFirstName, f.FacLastName
FROM Offering o
     INNER JOIN Course c ON o.CourseNo = c.CourseNo
     INNER JOIN Faculty f ON o.FacNo = f.FacNo
ORDER BY o.OfferNo
```

| OFFERNO | CRSDESC | FACFIRSTNAME | FACLASTNAME |
|---|---|---|---|
| 1111 | FUNDAMENTALS OF BUSINESS PROGRAMMING | LEONARD | FIBON |
| 1234 | FUNDAMENTALS OF BUSINESS PROGRAMMING | LEONARD | FIBON |
| 3333 | FUNDAMENTALS OF BUSINESS PROGRAMMING | LEONARD | FIBON |
| 4321 | FUNDAMENTALS OF BUSINESS PROGRAMMING | LEONARD | FIBON |
| 4444 | FUNDAMENTALS OF BUSINESS PROGRAMMING | VICTORIA | EMMANUEL |
| 5555 | FUNDAMENTALS OF BUSINESS FINANCE | JULIA | MILLS |
| 5678 | FUNDAMENTALS OF DATABASE MANAGEMENT | JOHN | MILLER |
| 5679 | FUNDAMENTALS OF DATABASE MANAGEMENT | CRISTOPHER | COLAN |
| 6666 | PRINCIPLES OF INVESTMENTS | JOHN | MILLER |
| 7777 | PRINCIPLES OF INVESTMENTS | NICKI | MACON |
| 8888 | SYSTEMS ANALYSIS | NICKI | MACON |
| 9999 | SYSTEMS ANALYSIS | JULIA | MILLS |

12 rows selected. 0.02 seconds

---

## 12

```sql
SELECT s.StdNo,
       s.StdFirstName,
       s.StdLastName,
       c.CourseNo,
       c.CrsDesc,
       o.OffTerm,
       o.OffYear,
       e.EnrGrade
FROM Student s
     INNER JOIN Enrollment e ON s.StdNo    = e.StdNo
     INNER JOIN Offering   o ON e.OfferNo  = o.OfferNo
     INNER JOIN Course     c ON o.CourseNo = c.CourseNo
ORDER BY s.StdLastName, s.StdFirstName, c.CourseNo
```

| STDNO | STDFIRSTNAME | STDLASTNAME | COURSENO | CRSDESC | OFFTERM | OFFYEAR | ENRGRADE |
|---|---|---|---|---|---|---|---|
| 890-12-3456 | LUKE | BRAZZI | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | FALL | 2025 | 2 |
| 890-12-3456 | LUKE | BRAZZI | IS460 | SYSTEMS ANALYSIS | SUMMER | 2026 | 2.8 |
| 890-12-3456 | LUKE | BRAZZI | IS480 | FUNDAMENTALS OF DATABASE MANAGEMENT | WINTER | 2026 | 2.5 |
| 567-89-0123 | MARIAH | DODGE | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | FALL | 2025 | 3 |
| 567-89-0123 | MARIAH | DODGE | IS460 | SYSTEMS ANALYSIS | SUMMER | 2025 | 3.3 |
| 567-89-0123 | MARIAH | DODGE | IS480 | FUNDAMENTALS OF DATABASE MANAGEMENT | WINTER | 2026 | 3.8 |
| 678-90-1234 | TESS | DODGE | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | SPRING | 2026 | 3.6 |
| 678-90-1234 | TESS | DODGE | IS460 | SYSTEMS ANALYSIS | SUMMER | 2026 | 3.4 |
| 678-90-1234 | TESS | DODGE | IS480 | FUNDAMENTALS OF DATABASE MANAGEMENT | SPRING | 2026 | - |
| 456-78-9012 | JOE | ESTRADA | FIN300 | FUNDAMENTALS OF BUSINESS FINANCE | WINTER | 2026 | 3.4 |
| 456-78-9012 | JOE | ESTRADA | FIN450 | PRINCIPLES OF INVESTMENTS | SUMMER | 2026 | - |
| 456-78-9012 | JOE | ESTRADA | FIN450 | PRINCIPLES OF INVESTMENTS | WINTER | 2026 | 3.9 |
| 901-23-4567 | BONNIE | GRANGER | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | WINTER | 2026 | 4 |
| 901-23-4567 | BONNIE | GRANGER | IS480 | FUNDAMENTALS OF DATABASE MANAGEMENT | WINTER | 2026 | 4 |
| 234-56-7890 | CANDY | KENDALL | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | FALL | 2025 | 3.8 |
| 234-56-7890 | CANDY | KENDALL | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | SPRING | 2026 | 3.1 |
| 234-56-7890 | CANDY | KENDALL | IS480 | FUNDAMENTALS OF DATABASE MANAGEMENT | SPRING | 2026 | - |
| 345-67-8901 | WALLY | KENDALL | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | FALL | 2025 | 3.5 |
| 345-67-8901 | WALLY | KENDALL | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | WINTER | 2026 | 3.1 |
| 789-01-2345 | ROBERTO | MORALES | FIN300 | FUNDAMENTALS OF BUSINESS FINANCE | WINTER | 2026 | - |
| 789-01-2345 | ROBERTO | MORALES | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | FALL | 2025 | 3.5 |
| 124-56-7890 | BOB | NORBERT | FIN300 | FUNDAMENTALS OF BUSINESS FINANCE | WINTER | 2026 | 3.2 |
| 124-56-7890 | BOB | NORBERT | FIN450 | PRINCIPLES OF INVESTMENTS | WINTER | 2026 | 3.5 |
| 124-56-7890 | BOB | NORBERT | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | FALL | 2025 | 3.2 |
| 124-56-7890 | BOB | NORBERT | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | FALL | 2025 | 3.7 |
| 123-45-6789 | HOMER | WELLS | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | SPRING | 2026 | 3.3 |
| 123-45-6789 | HOMER | WELLS | IS320 | FUNDAMENTALS OF BUSINESS PROGRAMMING | FALL | 2025 | 3.2 |
| 123-45-6789 | HOMER | WELLS | IS460 | SYSTEMS ANALYSIS | SUMMER | 2025 | 3.5 |
| 123-45-6789 | HOMER | WELLS | IS480 | FUNDAMENTALS OF DATABASE MANAGEMENT | WINTER | 2026 | 3.7 |

29 rows selected. 0.02 seconds

---

## 13

```sql
SELECT f.FacLastName AS Faculty, s.FacLastName AS Supervisor
FROM Faculty f
     INNER JOIN Faculty s ON f.FacSupervisor = s.FacNo
ORDER BY s.FacLastName
```

| FACULTY | SUPERVISOR |
|---|---|
| FIBON | EMMANUEL |
| MILLER | FIBON |
| COLAN | MACON |
| MILLS | MACON |

4 rows selected. 0.01 seconds

---

## 14

```sql
SELECT f.FacLastName AS Faculty, s.FacLastName AS Supervisor
FROM Faculty f
     LEFT JOIN Faculty s ON f.FacSupervisor = s.FacNo
ORDER BY f.FacLastName
```

| FACULTY | SUPERVISOR |
|---|---|
| COLAN | MACON |
| EMMANUEL | - |
| FIBON | EMMANUEL |
| MACON | - |
| MILLER | FIBON |
| MILLS | MACON |
| TANG | - |

7 rows selected. 0.01 seconds

---

## 15

```sql
SELECT c.CourseNo, c.CrsDesc
FROM Course c
     LEFT JOIN Offering o ON c.CourseNo = o.CourseNo
WHERE o.OfferNo IS NULL
```

| COURSENO | CRSDESC |
|---|---|
| ACC201 | PRINCIPLES OF ACCOUNTING I |
| FIN480 | CORPORATE FINANCE |
| IS490 | INFORMATION SYSTEMS CAPSTONE |

3 rows selected. 0.01 seconds

---

## 16

```sql
SELECT s.StdNo, s.StdFirstName, s.StdLastName
FROM Student s
     LEFT JOIN Enrollment e ON s.StdNo = e.StdNo
WHERE e.StdNo IS NULL
```

| STDNO | STDFIRSTNAME | STDLASTNAME |
|---|---|---|
| 012-34-5678 | PHILLIP | LEE |

Statement processed. 0.00 seconds

---

## 17

```sql
SELECT s.StdLastName, c.CrsDesc, e.EnrGrade
FROM Student s
     LEFT JOIN Enrollment e ON s.StdNo   = e.StdNo
     LEFT JOIN Offering   o ON e.OfferNo = o.OfferNo
     LEFT JOIN Course     c ON o.CourseNo = c.CourseNo
ORDER BY s.StdLastName
```

| STDLASTNAME | CRSDESC | ENRGRADE |
|---|---|---|
| BRAZZI | FUNDAMENTALS OF DATABASE MANAGEMENT | 2.5 |
| BRAZZI | SYSTEMS ANALYSIS | 2.8 |
| BRAZZI | FUNDAMENTALS OF BUSINESS PROGRAMMING | 2 |
| DODGE | SYSTEMS ANALYSIS | 3.4 |
| DODGE | SYSTEMS ANALYSIS | 3.3 |
| DODGE | FUNDAMENTALS OF BUSINESS PROGRAMMING | 3.6 |
| DODGE | FUNDAMENTALS OF DATABASE MANAGEMENT | 3.8 |
| DODGE | FUNDAMENTALS OF DATABASE MANAGEMENT | - |
| DODGE | FUNDAMENTALS OF BUSINESS PROGRAMMING | 3 |
| ESTRADA | PRINCIPLES OF INVESTMENTS | - |
| ESTRADA | PRINCIPLES OF INVESTMENTS | 3.9 |
| ESTRADA | FUNDAMENTALS OF BUSINESS FINANCE | 3.4 |
| GRANGER | FUNDAMENTALS OF BUSINESS PROGRAMMING | 4 |
| GRANGER | FUNDAMENTALS OF DATABASE MANAGEMENT | 4 |
| KENDALL | FUNDAMENTALS OF BUSINESS PROGRAMMING | 3.1 |
| KENDALL | FUNDAMENTALS OF BUSINESS PROGRAMMING | 3.1 |
| KENDALL | FUNDAMENTALS OF BUSINESS PROGRAMMING | 3.8 |
| KENDALL | FUNDAMENTALS OF DATABASE MANAGEMENT | - |
| KENDALL | FUNDAMENTALS OF BUSINESS PROGRAMMING | 3.5 |
| LEE | - | - |
| MORALES | FUNDAMENTALS OF BUSINESS PROGRAMMING | 3.5 |
| MORALES | FUNDAMENTALS OF BUSINESS FINANCE | - |
| NORBERT | FUNDAMENTALS OF BUSINESS FINANCE | 3.2 |
| NORBERT | FUNDAMENTALS OF BUSINESS PROGRAMMING | 3.2 |
| NORBERT | PRINCIPLES OF INVESTMENTS | 3.5 |
| NORBERT | FUNDAMENTALS OF BUSINESS PROGRAMMING | 3.7 |
| WELLS | FUNDAMENTALS OF BUSINESS PROGRAMMING | 3.2 |
| WELLS | FUNDAMENTALS OF BUSINESS PROGRAMMING | 3.3 |
| WELLS | SYSTEMS ANALYSIS | 3.5 |
| WELLS | FUNDAMENTALS OF DATABASE MANAGEMENT | 3.7 |

30 rows selected. 0.01 seconds

---

## 18

```sql
SELECT o.OfferNo, o.CourseNo, o.OffTerm, o.OffYear
FROM Offering o
     LEFT JOIN Enrollment e ON o.OfferNo = e.OfferNo
WHERE e.OfferNo IS NULL
```

| OFFERNO | COURSENO | OFFTERM | OFFYEAR |
|---|---|---|---|
| 9999 | IS460 | FALL | 2026 |

Statement processed. 0.01 seconds

---

## 19

```sql
SELECT StdLastName, StdGPA
FROM Student
WHERE StdGPA > (SELECT AVG(StdGPA) FROM Student)
ORDER BY StdGPA DESC
```

| STDLASTNAME | STDGPA |
|---|---|
| GRANGER | 3.9 |
| DODGE | 3.6 |
| KENDALL | 3.5 |
| DODGE | 3.3 |
| ESTRADA | 3.2 |

5 rows selected. 0.01 seconds

---

## 20

```sql
SELECT StdNo, StdLastName
FROM Student
WHERE StdNo IN (SELECT StdNo
                FROM Enrollment
                WHERE EnrGrade >= 3.5)
```

| STDNO | STDLASTNAME |
|---|---|
| 123-45-6789 | WELLS |
| 124-56-7890 | NORBERT |
| 234-56-7890 | KENDALL |
| 345-67-8901 | KENDALL |
| 456-78-9012 | ESTRADA |
| 567-89-0123 | DODGE |
| 678-90-1234 | DODGE |
| 789-01-2345 | MORALES |
| 901-23-4567 | GRANGER |

9 rows selected. 0.01 seconds

---

## 21

```sql
SELECT FacNo, FacLastName
FROM Faculty
WHERE FacNo NOT IN (SELECT FacNo FROM Offering)
```

no data found

Statement processed. 0.01 seconds

---

## 22

```sql
SELECT FacNo, FacLastName
FROM Faculty
WHERE FacNo NOT IN (SELECT FacNo FROM Offering WHERE FacNo IS NOT NULL)
```

| FACNO | FACLASTNAME |
|---|---|
| 111-22-3333 | TANG |

Statement processed. 0.01 seconds

---

## 23

```sql
SELECT f.FacNo, f.FacLastName
FROM Faculty f
WHERE NOT EXISTS (SELECT 1
                  FROM Offering o
                  WHERE o.FacNo = f.FacNo)
```

| FACNO | FACLASTNAME |
|---|---|
| 111-22-3333 | TANG |

Statement processed. 0.00 seconds

---

## 24

```sql
SELECT f.FacLastName, f.FacDept
FROM Faculty f
WHERE EXISTS (SELECT 1
              FROM Offering o
              WHERE o.FacNo = f.FacNo
                AND o.OffYear = 2026)
```

| FACLASTNAME | FACDEPT |
|---|---|
| FIBON | MS |
| EMMANUEL | MS |
| MACON | FIN |
| MILLS | FIN |
| COLAN | MS |
| MILLER | MS |

6 rows selected. 0.00 seconds

---

## 25

```sql
SELECT s.StdLastName,
       (SELECT COUNT(*)
        FROM Enrollment e
        WHERE e.StdNo = s.StdNo) AS ClassesTaken
FROM Student s
ORDER BY ClassesTaken DESC, s.StdLastName
```

| STDLASTNAME | CLASSESTAKEN |
|---|---|
| NORBERT | 4 |
| WELLS | 4 |
| BRAZZI | 3 |
| DODGE | 3 |
| DODGE | 3 |
| ESTRADA | 3 |
| KENDALL | 3 |
| GRANGER | 2 |
| KENDALL | 2 |
| MORALES | 2 |
| LEE | 0 |

11 rows selected. 0.00 seconds

---

## 26

```sql
SELECT t.CrsDesc, t.NumEnrolled
FROM (SELECT c.CrsDesc, COUNT(*) AS NumEnrolled
      FROM Enrollment e
           INNER JOIN Offering o ON e.OfferNo  = o.OfferNo
           INNER JOIN Course   c ON o.CourseNo = c.CourseNo
      GROUP BY c.CrsDesc) t
WHERE t.NumEnrolled >= 5
ORDER BY t.NumEnrolled DESC
```

| CRSDESC | NUMENROLLED |
|---|---|
| FUNDAMENTALS OF BUSINESS PROGRAMMING | 13 |
| FUNDAMENTALS OF DATABASE MANAGEMENT | 6 |

2 rows selected. 0.01 seconds

---

## 27

```sql
SELECT s.StdLastName,
       COUNT(*)            AS ClassesTaken,
       COUNT(e.EnrGrade)   AS ClassesGraded,
       ROUND(AVG(e.EnrGrade),2) AS ComputedGPA
FROM Student s
     INNER JOIN Enrollment e ON s.StdNo = e.StdNo
GROUP BY s.StdNo, s.StdLastName
ORDER BY ComputedGPA DESC
```

| STDLASTNAME | CLASSESTAKEN | CLASSESGRADED | COMPUTEDGPA |
|---|---|---|---|
| GRANGER | 2 | 2 | 4 |
| ESTRADA | 3 | 2 | 3.65 |
| DODGE | 3 | 2 | 3.5 |
| MORALES | 2 | 1 | 3.5 |
| KENDALL | 3 | 2 | 3.45 |
| WELLS | 4 | 4 | 3.43 |
| NORBERT | 4 | 4 | 3.4 |
| DODGE | 3 | 3 | 3.37 |
| KENDALL | 2 | 2 | 3.3 |
| BRAZZI | 3 | 3 | 2.43 |

10 rows selected. 0.01 seconds

---

## 28

```sql
SELECT s.StdLastName,
       s.StdGPA AS StoredGPA,
       ROUND(AVG(e.EnrGrade),2) AS ComputedGPA
FROM Student s
     INNER JOIN Enrollment e ON s.StdNo = e.StdNo
GROUP BY s.StdNo, s.StdLastName, s.StdGPA
HAVING s.StdGPA IS NULL
    OR ABS(s.StdGPA - AVG(e.EnrGrade)) > 0.3
ORDER BY s.StdLastName
```

| STDLASTNAME | STOREDGPA | COMPUTEDGPA |
|---|---|---|
| ESTRADA | 3.2 | 3.65 |
| KENDALL | 2.8 | 3.3 |
| MORALES | - | 3.5 |
| NORBERT | 2.7 | 3.4 |
| WELLS | 3 | 3.43 |

5 rows selected. 0.01 seconds

---

## 29

```sql
SELECT c.CrsDesc, COUNT(*) AS NumEnrolled
FROM Enrollment e
     INNER JOIN Offering o ON e.OfferNo  = o.OfferNo
     INNER JOIN Course   c ON o.CourseNo = c.CourseNo
GROUP BY c.CrsDesc
HAVING COUNT(*) = (SELECT MAX(Total)
                   FROM (SELECT COUNT(*) AS Total
                         FROM Enrollment e2
                              INNER JOIN Offering o2 ON e2.OfferNo  = o2.OfferNo
                              INNER JOIN Course   c2 ON o2.CourseNo = c2.CourseNo
                         GROUP BY c2.CrsDesc))
```

| CRSDESC | NUMENROLLED |
|---|---|
| FUNDAMENTALS OF BUSINESS PROGRAMMING | 13 |

Statement processed. 0.02 seconds

---

## 30

```sql
SELECT s.StdNo, s.StdLastName
FROM Student s
WHERE NOT EXISTS
      (SELECT 1
       FROM Offering o
       WHERE o.CourseNo = 'FIN450'
         AND NOT EXISTS
             (SELECT 1
              FROM Enrollment e
              WHERE e.OfferNo = o.OfferNo
                AND e.StdNo   = s.StdNo))
  AND EXISTS (SELECT 1 FROM Enrollment e3 WHERE e3.StdNo = s.StdNo)
```

| STDNO | STDLASTNAME |
|---|---|
| 456-78-9012 | ESTRADA |

Statement processed. 0.01 seconds