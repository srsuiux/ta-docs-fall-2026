# Movie Ticket: the Four-Decision Framework Applied

Purpose: apply the four decisions to the movie ticket problem, using the two code versions in `code/movieTicket.cpp`.
Status: draft, Nov 9 2026. The definitions come from `thesis-repo/framework/overview.md` and are not yet agreed.

`code/movieTicket.cpp` is left as it is. This file only reads it.

## The problem

Inputs: `age` (int) and `is_student` (bool).

- Under 12: $5.
- 65 and older: $6.
- Students aged 12 to 64: $8.
- Other adults aged 12 to 64: $12.
- Age below 0 or above 120: print "Invalid age entered".

## The two code versions in the file

| | Version A (`ticketPriceSundar`) | Version B (`ticketPrice`, marked "terminology: implementation decisions") |
|---|---|---|
| Shape | One `if / else if` chain | Separate `if` blocks, each returning early |
| Order | Invalid, under 12, 65+, student, regular | Same order |
| Last step | `else if (isStudent)` then `else` | Re-checks `age >= 12 && age <= 64`, then nested student check. A comment explains why this must be true |
| Invalid age | Returns `-1`; `main` prints the message | Same |

Both versions use the same algorithm (decision 2). They differ only in how it is written down (decision 3). That is a useful example: the same plan, two sets of implementation choices.

Things found when reading the file (the file is not changed):

- Version B does not compile as written: `return 6` on line 29 has no semicolon.
- Version B has no return after the last `if`. The compiler warns "does not return a value in all control paths". Logically the path cannot be reached, but the compiler cannot see that.
- Version B's extra `age >= 12 && age <= 64` check repeats what the earlier ifs already guarantee. The comment in the file says so.
- `main` calls Version A, so Version B is never used.
- Lines 64 to 75 are notes, not C++, so the whole file does not compile until they are moved out.
- `cin >> isStudent` reads a bool, so only 0 or 1 is read cleanly. This matches the prompt "1 = yes, 0 = no".
- The programs could not be run here because the linker is broken in this environment. The results below are traced by hand from the code.

## Breakdown by decision

| Decision | What it looks like in this problem |
|---|---|
| 1 Understand the problem | Which price applies to whom. The student flag only matters for ages 12 to 64. Age 65 or older pays $6 whether or not the person is a student. An invalid age must print a message instead of a price |
| 2 Algorithm approach | Check validity first, then under 12, then 65 and over, then student vs regular. A wrong order means age -1 gets a $5 child ticket and age 150 gets a $6 senior ticket. Other valid orders exist, so any correct order is accepted |
| 3 Implementation decisions | `age` as int, `is_student` as bool, price as a whole number. How "invalid" is represented: the code returns `-1` and `main` prints the message. The boundaries at 11/12 and 64/65. Chain of `else if` (Version A) or separate early-return ifs (Version B). Whether to repeat the 12 to 64 check |
| 4 Dry run | Trace ages around each boundary by hand |
| Hidden tests (setting) | (11,1), (12,1), (12,0), (64,1), (65,0), (0,0), (120,0), (-1,0), (121,1) |

### Where decisions 1 and 3 meet

This is the problem that tests the split hardest.

- What must come out for an invalid age, a message, is decision 1.
- The `-1` that stands for it inside the function is decision 3.

### Dry run (decision 4), traced by hand on Version A

| Test (age, student) | Path through the code | Output |
|---|---|---|
| (11,1) | not invalid, under 12 | $5 |
| (12,1) | not under 12, not 65+, student | $8 |
| (12,0) | not under 12, not 65+, not student | $12 |
| (64,1) | not 65+, student | $8 |
| (65,0) | 65+ | $6 |
| (0,0) | not invalid, under 12 | $5 |
| (120,0) | not invalid, 65+ | $6 |
| (-1,0) | invalid | Invalid age entered |
| (121,1) | invalid | Invalid age entered |

Version B gives the same results on every row by the same reasoning, once the missing semicolon is fixed.

## Who owns what in a run

The study design is not picked yet (`thesis-repo/proposed_study.md`). This table shows only what a run would look like if the AI owned one decision, as in design option A. It is an illustration, not a decision.

| If the AI owns | The AI does | The student does | What would be a leak |
|---|---|---|---|
| 1 Understand the problem | Restates what is asked and explains it | Decisions 2, 3 and 4 | Saying the order of checks, or how to represent invalid |
| 2 Algorithm approach | Gives the steps in order and explains why validity comes first | Decisions 1, 3 and 4 | Saying how to hold the data or what the function returns |
| 3 Implementation decisions | Chooses the types, the `-1` return and the boundary tests, and explains them | Decisions 1, 2 and 4 | Saying what is being asked, or the order of the steps |
| 4 Dry run | Traces the plan on sample ages and explains each step | Decisions 1, 2 and 3 | Saying the plan or the code |

In every row the AI also writes the code. Under the leak rule, the AI may point back only to content from the decisions it owns (`thesis-repo/framework/ownership_and_leak_rules.md`).

## Open points for this problem

- Whether the starter template gives the function name, parameters and return type. That would fix part of decision 3 and part of decision 1 for every student.
- Whether Version B's repeated check counts as a different decision 3 or only as style. Both pass the same tests.
- Whether the student should be told that the invalid message is printed by `main` and not by the function.
