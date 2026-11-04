# Experiment Problems: L1, L2 and L3 on Practice Problems

Oct 27, 2026 · Sundar Raj

This document goes with the proposal (`proposal-updated-27.md`). It shows what the three ownership levels look like on real problems.

## The levels (from the proposal)

A decision is a choice for one of three categories needed to solve a programming problem: algorithmic approach, modeling of inputs, testing. The AI always writes the code.

| Condition | Student owns | AI owns |
|---|---|---|
| L1 | Algorithmic approach | Modeling of inputs, testing, writing the code |
| L2 | Algorithmic approach, modeling of inputs | Testing, writing the code |
| L3 | Algorithmic approach, modeling of inputs, testing | Writing the code |

For beginners, the approach is judged only on whether it solves the problem, not on time or space efficiency. Any correct approach is accepted, and the AI builds on the student's approach even if a more efficient one exists [2].

---

## Problem 1: Palindrome checker

| Level | The student decides | The AI does |
|---|---|---|
| L1 | Compare from both ends and stop at the first mismatch | Handles the inputs (the string, two index variables left and right, ignore case), picks the test cases, writes the code |
| L2 | The approach, plus: ignore case and spaces, use two index variables, left and right | Picks the test cases, writes the code |
| L3 | The approach, the inputs, plus the tests: "abba", "", "a", "Racecar" | Writes the code |

---

## Problem 2: Positive, Negative, Zero, Odd, Even

Input: `number: int`. The program says whether the number is positive, negative or zero, and whether it is odd or even.

| Level | The student decides | The AI does |
|---|---|---|
| L1 | Check zero first, then positive or negative. Use the remainder after dividing by 2 for odd or even. Zero counts as even | Handles the input (one int, and how odd is checked for negative numbers), picks the test cases, writes the code |
| L2 | The approach, plus: the input is one int, and odd is checked as "remainder is not 0" so negative numbers like -3 also work | Picks the test cases, writes the code |
| L3 | The approach, the inputs, plus the tests: 0, 1, -1, 2, -2, -3 | Writes the code |

---

## Problem 3: Movie ticket discount calculator

Inputs: `age: int` and `is_student: bool`.

- Under 12: $5
- 65 and older: $6
- Students aged 12 to 64: $8
- Other adults aged 12 to 64: $12
- Age below 0 or above 120: print "Invalid age entered"

| Level | The student decides | The AI does |
|---|---|---|
| L1 | Check for an invalid age first, then under 12, then 65 and older, then student or regular for everyone left | Handles the inputs (age and is_student, and that is_student only matters for ages 12 to 64), picks the test cases, writes the code |
| L2 | The approach, plus: age is an int, is_student is a bool, and is_student is only used after the age checks | Picks the test cases, writes the code |
| L3 | The approach, the inputs, plus the tests: ages -1, 0, 11, 12, 64, 65, 120, 121, and a student and a non-student at 12 and 64 | Writes the code |

Age 65 or older pays $6 whether or not the person is a student, so the order of the checks matters here.

---

## References

[2] Loksa, D., Ko, A. J., Jernigan, W., Oleson, A., Mendez, C. J., & Burnett, M. M. (2016). Programming, Problem Solving, and Self-Awareness: Effects of Explicit Guidance. CHI 2016, 1449-1461. (Numbering follows the proposal.)