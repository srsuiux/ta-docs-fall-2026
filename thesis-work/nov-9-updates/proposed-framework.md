# Proposed Framework: Decision-Level Ownership of AI Help for Novice Programmers

Status: draft

## 1. Introduction

AI tools can now write a complete solution to most introductory programming problems, so a beginner can finish an assignment without making the decisions that build the skill. This framework splits a programming problem into four decisions and gives each decision one owner, the student or the AI. It is meant to show which decisions a student needs to make personally in order to learn the skill and keep it.

---

## 2. The problem

When the AI writes the whole solution, practice no longer requires the student to decide anything. In a lab study, some students used AI to speed up code they had already planned, while others struggled and finished believing they had done better than they had (Prather et al., 2024). In another study, students who asked for a whole solution in one prompt scored highest on writing tasks and lowest on later tasks where they had to modify code (Kazemitabaar et al., 2023b). A study of techniques for engaging with AI-generated code points to hierarchical decision-making and user agency as directions for future work (Kazemitabaar et al., 2024). This framework gives a way to state which decisions the student owns, so that the effect of each one can be studied.

---

## 3. The four decisions

| # | Decision | Question it answers | What it is | The owner writes |
| --- | --- | --- | --- | --- |
| 1 | Understand the problem | What is being asked? | Work out what the problem asks. Describe the input (kind, range, how it ends) and the output: each output value, what it comes from, and its form. Work a normal example by hand. | A restatement, an output table, and the starter code that takes the input |
| 2 | Design the algorithm | What are the steps, and what data do they need? | Decide the steps in order, what repeats, what is chosen between, when it stops, and what must be remembered. | The design, as plain steps, pseudocode or a flowchart |
| 3 | Implement it | How do the steps become code? | Turn the design into C++: types, how input is read, syntax, and how C++ behaves. | The code |
| 4 | Testing and edge-case validation | What test cases, including boundary and unusual situations, should be used to verify the solution's correctness? | Choose test cases (normal, boundary and unusual), work out the expected result of each by hand, run or trace the solution, compare, and find where any difference comes from. | The cases, their expected results, and what was found |

The starter code in decision 1 only takes the input. When the input repeats until an end marker, the repeating belongs to decision 2.

Edge cases are handled in decision 4. When a case shows a problem, the fix goes back to decision 2 or 3 and is made by that decision's owner.

Automated tests, practice on similar problems, and explaining the solution afterwards are not decisions. Automated tests are a fixed setting: they run the same way for every student and report pass or fail only.

---

## 4. What is inside each decision

Each decision groups several smaller steps that appear in a common ten-step list of programming problem solving.

| Ten-step list | Decision |
| --- | --- |
| 1 Understand the problem, 2 Identify inputs and outputs, 3 Identify constraints | 1 Understand the problem |
| 4 Choose an approach, 5 Design the algorithm, 6 Select data structures | 2 Design the algorithm |
| 7 Choose implementation techniques | 3 Implement it |
| 8 Handle edge cases, 9 Test the solution, 10 Evaluate and improve | 4 Testing and edge-case validation |

Steps 4 and 5 are hard to tell apart for a student, which is why they share one decision. Step 10 is limited here to correctness. The source of the ten-step list is still to be identified.

---

## 5. Ownership

Each decision has one owner, the student or the AI.

- The owner does the step, writes its part (including the code), and decides when it is done.
- The order of the decisions is free. Ownership stays fixed when the work goes back to an earlier decision.
- A leak is any content from a student-owned decision that the AI gives, in words or in code.

| # | If the student owns it | If the AI owns it |
| --- | --- | --- |
| 1 | The student writes the restatement, output table and starter code. The AI helps only through the help steps in section 6. | The AI writes them and explains. The student reads, asks questions, and says what is unclear. |
| 2 | The student writes the steps and the data. The AI can trace them on an example and report only that a result differs. | The AI writes the steps and says why. The student reads, asks, and builds decisions 3 and 4 on them. |
| 3 | The student writes the code. The AI helps through the help steps. | The AI writes the code from the design and explains it. The student reads, asks, and says where it does not match the design. |
| 4 | The student writes the cases, expected results and findings. The AI reports only that a result differs. | The AI writes the cases, runs them and explains. The student adds any case that seems missing. |

---

## 6. Help on a student-owned decision

Help goes up in small steps, and each step used is logged. These steps are a first version, taken from one trial problem.

| Step | What the AI may give |
| --- | --- |
| 1 | That the result differs from what is expected, not why |
| 2 | Which part the difference is in |
| 3 | A general fact, with an example from a different problem |
| 4 | What kind of problem it is, not the fix |
| 5 | The fix (counted as a hand-over) |

---

## 7. Basis in earlier work

The decisions are adapted from the stages of problem solving described by Loksa et al. (2016): reinterpreting the prompt, searching for analogous problems and for solutions, evaluating a potential solution, implementing it, and evaluating the implemented solution. Those stages describe how a student solves a problem and were studied as something students can be taught. The addition here is that each decision is given an owner, and the student's ability is then tested alone, decision by decision.

---

## 8. Open points

- Syntax help (a missing include, a format call): free but logged, or counted as one of the help steps.
- The line between decisions 1 and 2: ideas such as "keep the biggest so far" are placed in decision 2. Not yet confirmed.
- Decision 3 is close to translation into C++, so the weight of the framework sits in decisions 1, 2 and 4.
- The exact form of each written output, for each problem.

## References

Full entries and links are in [02_references.md](../02_references.md).

- Kazemitabaar et al. (2023b). Koli Calling '23. https://doi.org/10.1145/3631802.3631806
- Kazemitabaar et al. (2024). https://arxiv.org/abs/2410.08922
- Loksa et al. (2016). CHI 2016. https://doi.org/10.1145/2858036.2858252
- Prather et al. (2024). ICER 2024. https://arxiv.org/abs/2405.17739