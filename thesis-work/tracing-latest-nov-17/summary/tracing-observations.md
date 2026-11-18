# Tracing findings: what the student decided and what the AI decided

Here a "decision" means a choice about how the solution is built. Line numbers are from the log files.

The problem text already fixes the prices, the age ranges, and the types `age:int` and `is_student:bool`. Those were not decided in the chat.

# T1: Baseline

What happened: the student sent the prompt. The AI replied with the full C++ code, a comment on every line, and an overall explanation. The student did nothing else.

| Who | What was decided | Where |
|---|---|---|
| Student | nothing | n/a |
| AI | the code, in the order: invalid age, child, senior, student, adult | lines 64-90 |
| AI | checking for an invalid age first (`age < 0 \|\| age > 120`) | line 64 |
| AI | an extra variable `ticket_price` | line 54 |
| AI | the input messages ("Enter your age") and the 1 or 0 for student | line 56 |

Observation: the student made no decisions. The AI made all of them.

# T6: Explain-before-Usage

What happened: the AI showed the full code first. It then asked 4 questions, one at a time. The student answered each in words, and the AI scored each answer 5/5.

| Who | What was decided | Where |
|---|---|---|
| AI | the whole code | lines 23-46 |
| AI | the 4 questions and which lines each covers (6-9, 10-11, 12-15, 16-19) | questions 1-4 |
| AI | the score and the feedback for each answer | lines 75, 104, 137, 186 |
| Student | explained that age picks the price group and student status matters only for 12-64 | line 70 |
| Student | explained that invalid ages like -5 or 200 would get a wrong price | line 100 |
| Student | explained that checking age first stops a student child or senior getting $8 | line 131 |
| Student | explained that the final else leaves only non-student adults 12-64 | line 179 |

Observation: the student saw the finished code first. The student's answers explain choices the AI had already made. The student chose no code.

# T7: Lead-and-Reveal

What happened: the AI kept the code hidden and asked 5 multiple-choice questions, one at a time. The student picked A to D. After a correct pick, the AI revealed the matching code lines. After a wrong pick, it said "Not quite", gave a hint, and let the student pick again. At the end it showed the full code.

| Question | Student's picks | Result | Where |
|---|---|---|---|
| Q1 Why validate age first | B | correct | line 168 |
| Q2 Why children before students | A, then C | wrong, then correct | lines 214, 240 |
| Q3 Why seniors before students | B | correct | line 278 |
| Q4 Who gets the $8 student price | A, then C | wrong, then correct | lines 317, 343 |
| Q5 Why the final else works | C | correct | line 383 |

| Who | What was decided |
|---|---|
| AI | the hidden code |
| AI | the 5 questions, the choices and the wrong answers |
| AI | which lines to reveal after each question (1-9, 10-12, 13-15, 16-18, 19-23) |
| AI | the order of the checks. For example Q2 asks "Why must children be checked before the student discount?" (line 197) |
| Student | which choice is the correct reason, 7 picks in total |

Observation: the student made choices before seeing the code, but only among answers the AI had written. The wrong first picks on Q2 (A: children who are students get $8) and Q4 (A: every student qualifies) both let student status override age.

## Side by side with table

| | T1 | T6 | T7 |
|---|---|---|---|
| Who wrote the code | AI | AI | AI (hidden at first) |
| Student turns after the prompt | 0 | 4 answers | 7 picks |
| What the student did | nothing | explained the code after seeing it | picked the correct reason before seeing the code |
| Right or wrong | n/a | 4 of 4 (5/5 each) | 5 of 5 in the end, 2 wrong on the first try |

## Basic observations from the tracing

1. In all three runs the AI wrote the code.
2. T1: the student had no part.
3. T6: the student took part after the code was shown, by explaining it.
4. T7: the student took part before the code was shown, by choosing among written options.
5. The three runs gave different code for the same problem. T1 uses a `ticket_price` variable. T6 and T7 do not.

## Limits of the tracings

- One run per technique, one session, and the model was not recorded.
- In T7, ChatGPT gave hints after wrong picks. 
- The correct answer was only ever at B or C. 
- The first reveal was 9 lines. The 3-retry limit was never reached.