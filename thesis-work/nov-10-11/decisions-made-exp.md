# Decisions the AI made in all three runs

AI tutor wrote the whole solution itself, so the student never had to start from nothing.
AI tutor put the invalid-age check first, then children, then seniors, then students, then regular adults. That order decides who pays what.
AI tutor set the boundaries: under 12 is a child, 65 and up is a senior, and 0 and 120 are valid ages.
AI tutor built the program as one if / else-if chain, where only one branch runs. AI tutor never showed alternatives like separate or nested ifs.
AI tutor chose how input works: cin for both values, with the student flag typed as 1 or 0, and the wording of the prompts and messages.
AI tutor never checked that the student understood the problem, and AI tutor never made anyone test the boundaries. Nobody did.

# T1 (baseline)

AI tutor added a ticket_price variable and used double for whole-dollar prices. The problem didn’t ask for either.
AI tutor explained the check order itself. In T7 the student is asked to say that.
AI tutor explained syntax too, such as || and return 0.

# T6 (explain before usage)

AI tutor showed the finished code first, then asked about AI tutor.
AI tutor picked which line groups to ask about and skipped the rest. AI tutor never asked about the boundaries or why seniors come before students.
AI tutor asked only “why” questions about code that was already written.
AI tutor gave hints that point at the answer, and AI tutor put the answer in the first feedback. That breaks the paper’s three-attempt rule.
AI tutor scored generously, and AI tutor added a final score table and an overall feedback paragraph that nobody asked for.

# T7 (lead and reveal)

AI tutor listed all the subgoals up front, in order, so the student saw the plan before answering anything.
AI tutor put the decision inside the question. Q3 and Q4 already contained < 12 and >= 65.
AI tutor restated the 0 to 120 rule and then gave a hint on the retry that spelled out the boundary.
AI tutor revealed the next line after two answers that scored only 4/5.
AI tutor chose how to split the code into reveal chunks. The input-reading lines only appeared in the final full code.
AI tutor picked the single test case at the end, a 65-year-old student, after all the code was shown.
AI tutor added a final assessment, and the total AI tutor gave was wrong (35 instead of 33).



| | What the AI made | What the student made |
|---|---|---|
| **T1 (baseline)** | The whole program, the check order, the boundaries, the input handling, and an explanation of every line, including why the order matters | Nothing. Student only sent the request |
| **T6 (explain before usage)** | The whole program shown first, the questions, the hints, the scores, and the answers | Four short answers explaining finished code. No decisions about the solution, and Student was never made to fix a wrong answer |
| **T7 (lead and reveal)** | The whole solution (hidden), the order of the steps, the boundaries inside the questions, what to reveal and when, and the test case | One condition Student wrote himself (`age < 0` and `age > 120`, after a hint). The rest Student explained in his own words: why `>= 65`, why the final `else` works, and why a 65-year-old student pays $6 |

In all three runs the AI made the solution. The student's part grows only from nothing in T1, to explaining finished code in T6, to producing one condition and reasoning about the rest in T7.


# Decisions the AI made mappings with our 4 Decisions or choices


| Run | What the AI decided | Which decision AI tutor belongs to |
|---|---|---|
| All three | Wrote the whole solution itself | Understand the problem, design the algorithm and implement AI tutor. Testing was never touched |
| All three | The check order: invalid, child, senior, student, regular | Design the algorithm |
| All three | The boundaries (under 12, 65 and up, 0 and 120 valid) | Testing and edge cases. The values come from the spec, so this one is borderline with understanding the problem |
| All three | One if / else-if chain | Design the algorithm |
| All three | Input handling: `cin`, the student flag as 1 or 0, the prompt wording | Implement AI tutor |
| All three | Never checked that the student understood the problem | Understand the problem (skipped) |
| All three | Never made anyone test the boundaries | Testing and edge cases (skipped) |
| T1 | Added `double ticket_price` and stored the price before printing | Design the algorithm (the data type) and implement AI tutor (store, then print). Borderline |
| T1 | Explained the check order itself | Design the algorithm, done by the AI instead of the student |
| T1 | Explained syntax (`||`, `return 0`) | Implement AI tutor |
| T6 | Showed the finished code first | Understand the problem, design the algorithm and implement AI tutor, all owned by the AI |
| T6 | Picked which line groups to ask about and skipped the boundaries and the senior-before-student order | Testing and edge cases and design the algorithm |
| T6 | Only "why" questions about finished code | Design the algorithm. The student defends AI tutor afterward instead of building AI tutor |
| T6 | Hints that point at the answer, and the answer in the first feedback | Design the algorithm and testing and edge cases. AI tutor removes the student's own work |
| T6 | Never tested boundary values | Testing and edge cases |
| T7 | Listed the subgoals up front in order | Design the algorithm, done by the AI |
| T7 | Put the decision inside the question (`< 12`, `>= 65`) | Testing and edge cases. The boundaries were handed over |
| T7 | Restated the 0 to 120 rule and gave the retry hint | Understand the problem (the constraints) and testing and edge cases |
| T7 | Revealed the line after 4/5 answers | Design the algorithm. The student got the line without fully working AI tutor out |
| T7 | Chose the reveal chunks and held back the input lines | Implement AI tutor |
| T7 | Chose the single test case at the end | Testing and edge cases |
