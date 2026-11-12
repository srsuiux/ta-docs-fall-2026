what is been done. 

# Lock the three traces

All three runs were done in ChatGPT. Each has a share link that anyone can open for revision. The link is also at the top of its own file, after the title and description.

**Files in `nov-10/`:**

- `work-done.md`: this log
- `problem.txt`: the Movie Ticket Discount Calculator problem
- `prompt-structure-extract-codebase.md`: prompt structure extracted from the authors' codebase
- `experiment-replicate/`
  - `baseline-t1.md`: T1 trace
  - `explain-before-usage-t6.md`: T6 trace
  - `lead-reveal-t7.md`: T7 trace
  - `cet-df.md`
- `code-engagement-techniques/`: clone of the authors' repo (source for the prompts)

**Saved transcripts:**

| Trace | Technique | Share link | Model | Date |
| ----- | --------- | ---------- | ----- | ---- |
| T1 | Baseline | https://chatgpt.com/share/6af506b3-a82c-83e9-ac3b-f815d4c86f66 | ChatGPT web, free model auto-assigned (exact name not recorded) | Nov 11, 2026, 3:30 to 11:30 (research session) |
| T6 | Explain-before-Usage | https://chatgpt.com/c/6af509cf-4e3c-83e9-b525-28d0c6d673a3 | ChatGPT web, free model auto-assigned (exact name not recorded) | Nov 11, 2026, 3:30 to 11:30 (research session) |
| T7 | Lead-and-Reveal | https://chatgpt.com/share/6af52d70-81fc-83e9-91c8-3efc586e0d0f | ChatGPT web, free model auto-assigned (exact name not recorded) | Nov 11, 2026, 3:30 to 11:30 (research session) |

Note: the T6 link is a `/c/` link, not a `/share/` link. It may only open for me, so create a share link for it.


# Fix the amendment

revise your amendment to the cmu/Toronto prompt: If a student is learning if/conditional statements, they don't know loops and how to write conditions.

The paper says nothing about learners who know if/conditionals but not loops, or about students who can’t write conditions.

let's check the participants from the paper. 

Who the paper’s participants were

CMU paper, recruited novice programmers from intermediate-level CS programming courses

Study 1 (n=82): an undergraduate data structures course, all from the same class to keep prior knowledge consistent.

Study 2 (n=42): another data structures class, pre-screened as confident in Python.

These students already know both conditionals and loops, and the tasks were stacks, 
queues and deques. 

A student who knows only conditionals is outside the population the paper tested. 
That is a good reason to call the amendment ours and to list it as a limit.

What the paper does support, in general terms

Novices have to learn conceptual, syntactic and strategic knowledge at the same time. Writing from scratch often leads to frustration over syntax (L168-180).
Parsons problems emphasize logical reasoning over syntax.
T5 was inspired by pseudocode used to support algorithmic thinking before complex syntax
T7 itself asks “what needs to be done at each step of the algorithm”.
This backs the idea of “focus on logic, not syntax” as motivation. It gives no rule for the prompt.

Conclusion: 

The paper and the repo both say nothing about the if-only learner, so the amendment is our additition in the prompt level when i was designing the 
prompt for the study. 


Amendment: Not used in the T1, T6 and T7 runs. The prompts come only from the authors’ 
repo (packages/server/routes/) and Kazemitabaar et al., with file and line pointers in
prompt-structure-extract-codebase.model

Earlier amendment: The first experiment’s line (“the student knows basic syntax, don’t quiz it”) 
was my own wording. I checked the paper and the repo, and neither says it. I would only add it 
back as a labeled, T7-only add-on, using the revised wording that removes the loops/conditions
contradiction.


Changes to the authors’ prompts: Python swapped to C++, our movie ticket problem inserted, 
and T7 set to short-answer instead of  multiple choice.


# Answer the paper questions.


### Do they say when T7 underperforms?

Not directly. The paper has no passage listing scenarios where T7 does worse. The evidence that comes closest:

Scores: In Study 2, T7 had the lowest mean of the three (55.0, against 57.6 for Baseline and 64.3 for Trace-and-Predict). The differences were not significant (§6.3). In Study 1, T7 had the highest mean, but not significantly (§4.3).
Time: T7 took 1.82 times longer than Baseline (857 s against 471 s, §6.4 and §6.7).
Accuracy on its questions: Learners got 58% right on T7’s questions, against 76% on Trace-and-Predict’s (§6.4). The authors read this as T7’s questions being more challenging (§7.2.1).
Participant complaints: Study 1 participants cited missing context and no hints after wrong answers, and some were confused when their own solution differed from the AI’s (§4.5.7). Study 2 participants cited lack of flexibility, time cost and hard-to-read feedback (§6.6.1).
Limits the authors state: If the AI’s code is wrong, engaging before the reveal is wasted, because the code is hidden (§7.1). The line-by-line reveal also doesn’t match how code is really built (§7.2.1).

### What kinds of problems does T7 do well on?

The paper does not name a problem type where T7 excels. What it says:

All tasks were algorithm-heavy. They needed decomposition, pattern recognition, data representation, abstraction and algorithm design (§7.1).
T7 works at the “Create” level because the code is hidden and users must predict the logic (§3.7).
It gave the best match between what learners thought they could do and what they could do (r=.26), with no higher task load than Baseline (§6.5, §6.4).
Participants valued the step-by-step guidance and the logical thinking it required (§6.6.1).

# Problems used and learning objectives

The paper names no individual problems and lists no per-task learning objectives. It describes the tasks by topic and format:

Study 1 (n=82): Undergraduates in a data structures course. The pre-test was 5 multiple-choice code-tracing questions on stack and queue. There were 4 training tasks (two on stacks, two on queues). The evaluation was 2 manual coding tasks without AI.
Study 2 (n=42): Another data structures class. There were 3 topics: stacks, queues and deques, each with a 5-minute warm-up and a 15-minute main task. The evaluation was 6 fill-in-the-blank tasks with 3 to 5 key lines erased.
The only stated goal: Learn stack, queue and deque concepts, then apply them to a similar task without AI.
Not tested: conditionals or intro-level tasks.

“Kazemitabaar et al. do not state learning objectives per task.

# Rewrite steps 2–8 of the T7 trace

Step 2: Validate the age
Our program now has variables for the customer’s age and student status. The next subgoal is to check that the age is valid. The assignment says an age below 0 or above 120 is invalid, so this rule must be checked before any ticket price is chosen.
Log: Q2 asked for the two invalid-age conditions and why this check goes first. The student first said “0 or less” (3/5), then wrote age < 0 and age > 120 after a hint (5/5). Revealed: the if (age < 0 || age > 120) block. The “why first” part was never answered.

Step 3: Children
The program has now rejected invalid ages, so every age left is between 0 and 120. The next subgoal is to find the children. The assignment says customers under 12 pay $5, so the rule must include ages below 12 and leave age 12 for the next category.
Log: Q3 asked why < 12 and not <= 12, and what happens at exactly 12. The student got the boundary right but said seniors pay $8 (4/5, corrected to $6). Revealed: else if (age < 12). The question already contained the condition.

Step 4: Seniors
The program has now handled children, so the remaining ages are 12 to 120. The next subgoal is to find the seniors. The assignment says customers 65 and older pay $6, and age 65 itself counts as a senior.
Log: Q4 asked why >= 65 and not > 65. The student answered correctly in his own words (5/5). Revealed: else if (age >= 65). The condition was in the question.

Step 5: Students
The program has now handled children and seniors, so the remaining ages are 12 to 64. The next subgoal is to decide who gets the student price. The assignment says students in this range pay $8, and we only need to check student status because the age range has already been narrowed.
Log: Q5 asked why is_student alone isn’t enough. The student said age matters for fair pricing but never said that a child or senior student shouldn’t get $8. It still scored 4/5, and the feedback supplied the missing point. Revealed: else if (is_student).

Step 6: Regular adults
The program has now handled students, so the only customers left are those aged 12 to 64 who are not students. The next subgoal is to give them the regular price. The assignment says they pay $12, and no further check is needed because every other case has been ruled out.
Log: Q6 asked why a final else is enough. The student explained the elimination well (5/5). Revealed: the final else.

Step 7: Review the full program
The program now covers every case: invalid age, children, seniors, students and regular adults. The next subgoal is to look at the finished program as a whole, so all the lines are shown together.
Log: No question. The AI showed the full C++ solution, including the includes, main and cin lines that no question had covered.

Step 8: Check the order of the conditions
The complete program is now shown. The last subgoal is to test the order of the conditions with one example. A 65-year-old student fits both the senior rule and the student rule, so the order decides which price is used.
Log: Q7 asked which price applies, $6 or $8, and why order matters. The student said $6 because the first matching branch runs (5/5). The AI then gave a final assessment of “35/35”, but the table adds up to 33.


# Build the choices table, one row per step

**T7 (current experiment log)**

| Step | AI choice | Why it matters | Tie to conditionals | Choices |
|---|---|---|---|---|
| Opening | Lists all 7 subgoals up front, in the order invalid → child → senior → student → regular → review | The student sees the plan before thinking, so he never designs the order | Check order is the core of an if/else-if chain | Algorithm |
| 1. Inputs | Asks "why both inputs?" and reveals only `int age; bool is_student;`. Input reading is held back until the end | Types come from the spec, so there's no real choice. The question checks that both inputs matter | Low. The two inputs feed the age ranges and the student flag | Understand |
| 2. Invalid age | Puts the invalid check first. Restates the 0–120 rule in the question. Asks "what" and "why first" together. The retry hint says "0 and 120 are both valid" | The "why first" part went unanswered, and the hint supplied the boundary | Check order and boundaries | Algorithm, Edge cases |
| 3. Children | Puts `< 12` in the question and asks about exactly 12 | The condition is given, so the student only justifies it | Boundary, and `else if` makes the branches exclusive | Edge cases |
| 4. Seniors | Puts `>= 65` in the question and checks seniors before students | Same: decision supplied. Seniors-first decides what a 65-year-old student pays | Boundary and check order | Edge cases, Algorithm |
| 5. Students | Reveals `else if (is_student)` with no age test, after a weak 4/5 answer | The student check works only because earlier branches narrowed the age | Exclusive branches: a condition's meaning depends on what came before | Algorithm |
| 6. Regular | Asks why a final `else` is enough | Tests the "everything left" idea | Exclusive branches | Algorithm |
| 7. Review | Shows the full code with no questions. Includes `cin` and the 0/1 bool, with no input prompts or `endl` | Input format is decided silently | Low | Implement |
| 8. Final check | Picks one test case, a 65-year-old student, after all code is shown | It's the only test, chosen by the AI, and it traces rather than designs a test | Check order, exclusive branches | Testing |

**T6 (your log)**

| AI choice | Why it matters | Tie to conditionals | Choices |
|---|---|---|---|
| Shows the whole finished solution first | The student never builds or chooses anything | Order, boundaries and branches are all decided for him | Understand, Algorithm, Implement |
| Asks about lines 4–9, 10–12, 13–18 and 19–24. Skips 1–3 and 25–26 | It sets what the student thinks about | Nothing asked about boundaries or why senior is checked before student | Algorithm, Edge cases |
| Only "why" questions about finished code | The student justifies afterward instead of constructing | Order and boundaries are defended, not worked out | Algorithm |
| Hints point at the answer, and feedback gives the answer in the first reply | It breaks the 3-attempt rule from the paper (§3.6) | Removes the struggle that conditionals need | Algorithm |
| Generous scoring, a final 16/20 table and an overall feedback paragraph | The overall feedback credits things the student never said | None directly | Understand |
| Never tests boundary values | Nobody tests anything | Boundaries are never tried | Testing |

**T1 (new log)**

| AI choice | Why it matters | Tie to conditionals | Choices |
|---|---|---|---|
| Writes the whole program with line-by-line explanations | The student does nothing, as expected for a baseline | Everything is decided for him | Understand, Algorithm, Implement |
| Invalid first, then `< 12`, `>= 65`, student, else | Same order as the other runs | Check order and boundaries | Algorithm |
| Explains in the overall explanation why the order matters | It gives the reasoning T7 asks the student to produce in Q5–Q7 | Check order and exclusive branches | Algorithm |
| Adds `double ticket_price` and stores the price before printing | Not in the spec, and the other runs print directly | Low | Implement |
| Prompts, bool as 1/0, explains `||` and `return 0` | Format and syntax choices made for him | Low | Implement |
| No test cases, and boundaries not explained as boundaries | Nothing is tested | Boundaries sit in the code unexplained | Testing |

**Patterns**
- **T1 and T6:** the AI owns everything, and the student has no decision.
- **T7:** the student produces only the Q2 condition. The AI sets the order up front and embeds the boundaries in the questions.
- **Testing and edge cases:** the AI always chooses them, or nobody does.
