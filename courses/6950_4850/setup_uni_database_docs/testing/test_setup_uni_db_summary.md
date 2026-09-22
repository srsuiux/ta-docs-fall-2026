# Test Script — Results Summary

| Number | Elapsed | Statement | Feedback | Rows |
|---|---|---|---|---|
| 1 | 0.02 | SELECT * FROM Student | 11 rows selected. | 11 |
| 2 | 0.01 | SELECT StdFirstName, StdLastName, StdClass, StdGPA FROM Stu | 5 rows selected. | 5 |
| 3 | 0.01 | SELECT StdNo, StdLastName FROM Student WHERE StdGPA IS NUL | Statement processed. | 1 |
| 4 | 0.01 | SELECT DISTINCT StdMajor FROM Student ORDER BY StdMajor | 4 rows selected. | 4 |
| 5 | 0.01 | SELECT FacLastName, FacSalary, FacRank FROM Faculty WHERE | 4 rows selected. | 4 |
| 6 | 0.00 | SELECT COUNT(*) AS AllStudents, COUNT(StdGPA) AS WithGPA FR | Statement processed. | 1 |
| 7 | 0.00 | SELECT StdMajor, COUNT(*) AS NumStudents, ROUND(AVG(StdGPA), | 4 rows selected. | 4 |
| 8 | 0.01 | SELECT OffTerm, OffYear, COUNT(*) AS NumOfferings FROM Offe | 2 rows selected. | 2 |
| 9 | 0.01 | SELECT FacDept, COUNT(*) AS NumFaculty, AVG(FacSalary) AS Av | 2 rows selected. | 2 |
| 10 | 0.02 | SELECT o.OfferNo, o.CourseNo, c.CrsDesc, o.OffTerm, o.OffYea | 13 rows selected. | 13 |
| 11 | 0.02 | SELECT o.OfferNo, c.CrsDesc, f.FacFirstName, f.FacLastName | 12 rows selected. | 12 |
| 12 | 0.02 | SELECT s.StdNo, s.StdFirstName, s.StdLastNam | 29 rows selected. | 29 |
| 13 | 0.01 | SELECT f.FacLastName AS Faculty, s.FacLastName AS Supervisor | 4 rows selected. | 4 |
| 14 | 0.01 | SELECT f.FacLastName AS Faculty, s.FacLastName AS Supervisor | 7 rows selected. | 7 |
| 15 | 0.01 | SELECT c.CourseNo, c.CrsDesc FROM Course c LEFT JOIN | 3 rows selected. | 3 |
| 16 | 0.00 | SELECT s.StdNo, s.StdFirstName, s.StdLastName FROM Student | Statement processed. | 1 |
| 17 | 0.01 | SELECT s.StdLastName, c.CrsDesc, e.EnrGrade FROM Student s | 30 rows selected. | 30 |
| 18 | 0.01 | SELECT o.OfferNo, o.CourseNo, o.OffTerm, o.OffYear FROM Off | Statement processed. | 1 |
| 19 | 0.01 | SELECT StdLastName, StdGPA FROM Student WHERE StdGPA > (SE | 5 rows selected. | 5 |
| 20 | 0.01 | SELECT StdNo, StdLastName FROM Student WHERE StdNo IN (SEL | 9 rows selected. | 9 |
| 21 | 0.01 | SELECT FacNo, FacLastName FROM Faculty WHERE FacNo NOT IN | Statement processed. | 0 |
| 22 | 0.01 | SELECT FacNo, FacLastName FROM Faculty WHERE FacNo NOT IN | Statement processed. | 1 |
| 23 | 0.00 | SELECT f.FacNo, f.FacLastName FROM Faculty f WHERE NOT EXI | Statement processed. | 1 |
| 24 | 0.00 | SELECT f.FacLastName, f.FacDept FROM Faculty f WHERE EXIST | 6 rows selected. | 6 |
| 25 | 0.00 | SELECT s.StdLastName, (SELECT COUNT(*) FROM | 11 rows selected. | 11 |
| 26 | 0.01 | SELECT t.CrsDesc, t.NumEnrolled FROM (SELECT c.CrsDesc, COU | 2 rows selected. | 2 |
| 27 | 0.01 | SELECT s.StdLastName, COUNT(*) AS Classes | 10 rows selected. | 10 |
| 28 | 0.01 | SELECT s.StdLastName, s.StdGPA AS StoredGPA, | 5 rows selected. | 5 |
| 29 | 0.02 | SELECT c.CrsDesc, COUNT(*) AS NumEnrolled FROM Enrollment e | Statement processed. | 1 |
| 30 | 0.01 | SELECT s.StdNo, s.StdLastName FROM Student s WHERE NOT EXI | Statement processed. | 1 |