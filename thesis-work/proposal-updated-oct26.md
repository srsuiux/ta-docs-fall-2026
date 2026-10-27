# Who Decides? Decision-Level Control of AI Help for Novice Programmers

Oct 26, 2026 · Sundar Raj

## Introduction

This is my thesis proposal draft as it stands today. I want to share where I am, and get feedback before I start building the tool and before I send the IRB application.

My main question is simple: when a beginner uses AI to solve a programming problem, which decisions should the student own, and which ones can the AI own, so that the student still learns and keeps what they learned?

### Terms used in this draft

Before going further, here are the main terms, in the order the question builds on them. Each one is defined once here, with where the definition comes from. If a definition is mine and not from a paper, it says so, and it is a working definition to be checked.

**1. Problem solving in programming.** The process of translating mental representations of problems and solutions into source code. Loksa et al. [2] describe it as six stages: reinterpret the problem prompt, search for analogous problems, search for solutions, evaluate a potential solution, implement a solution, and evaluate the implemented solution. The stages are listed in full later in this draft.

**2. Decision.** A conscious choice between two or more options [16, 18]. Not every action is a decision: "Not all intentional actions entail decisions" [16]. In this study, following Dr. Astroga, a decision is a choice for one of the categories required to solve a programming problem: algorithmic approach, modeling of inputs, or testing. The definition of a choice comes from [16, 18]; the three categories come from Dr. Astroga and are being checked against Loksa [2] (see "Linking the decisions to Loksa's stages").

> One caution from the research. The authors of [16] interviewed professional developers and found that they rarely could reconstruct code-focused choices between alternatives. They concluded that decision-making is a poor lens for studying coding. Their participants were industry developers, not beginners solving an intro problem, so this needs to be checked for novices. They also suggest that tools which interrupt unconscious improvisation at critical points could improve quality [16], which is close to what I want to do here.

**3. Ownership and decision-level control.** Decision-level control is the setting for each decision category, whether the student or the AI makes the choice. Ownership means the student makes that choice. These are my working terms. They come from the gap in [1]: in every technique the AI makes the decisions, and students are assigned a technique instead of having this control. The paper calls this missing control "agency" [1].

**4. Condition.** One version of the setup that the student practices under. This is a standard idea in experiment design: change one thing between conditions, and keep everything else the same. Here, the one thing is the ownership level (L1, L2, L3, defined later).

**5. Cognitive engagement and friction.** Kazemitabaar et al. [1] use cognitive engagement for how deeply a learner works with AI-generated code, and friction for the extra work a technique adds before the learner can use the code. Without engagement, learners can get an "illusion of learning" [1].

**6. No-AI test and retention test.** The no-AI test is a coding test the student does alone after practicing. The retention test is the same kind of test one week later. Both follow the design in [5]. They matter because the harm of AI only shows up once the AI is gone [10, 14].

**7. Confidence match (calibration).** How close a student's own guess of their skill is to their real test score [1].

**8. Novice.** A student in their first college programming course (CS1), with at most one semester of programming before. This is my working definition for the study. The main paper used data structures students [1].

**9. Quality of AI use.** How well students use the AI within their level, for example asking for explanations rather than answers, and checking what the AI gives. This came from Dr. Robert Gilliland's comment. It is a working term, and how to measure it is still open.

**10. Leak.** When the AI gives away a decision that was supposed to stay with the student. This is my working term.

### How I got here

I started with a broad interest in student autonomy and AI in education, especially in learning programming. Autonomy is too broad to test, so I narrowed it down to something I can change and measure: the level of decision control in problem solving, meaning who makes each decision, the student or the AI.

I read the work of Kazemitabaar et al. [1] closely. They designed seven cognitive engagement techniques for AI-generated code, and I tried three of them myself (the baseline, explain-before-usage and Lead-and-Reveal), playing the student with a free GPT as the tutor, because their open-source project needs an API key. I also tried their Lead-and-Reveal demo app. In every technique, the AI picks the approach, decides how the problem is broken down, and writes the solution. The student only answers the AI's questions and follows the path the AI has set. In Lead-and-Reveal, the student cannot say "I will do this part, and I need help with that part."

Their paper points in the same direction. Students were assigned a technique, and the authors say future tools should guide users "in the hierarchical decision-making process" [1]. They also say that when AI solves tasks for the user on its own, it could hurt the user's decision-making skills, and that a more engaged, user-involved AI might lead to better decisions and better mental models [1].

After that I read relevant papers and tried to map their abstracts to my question, to see if someone had already done this.

This idea came together over time. Dr. Astroga and I have been discussing programming and problem solving from the beginning, and the decisions, categories and ownership levels in this draft grew out of those discussions.

---

## The problem

AI tools can now provide a full solution for most intro programming problems. So, a beginner can finish the work without making the decisions that actually build the skill [1, 3]. Jackson makes a similar point about LLMs in education: they are very good at coding when closely guided, but the work they produce can look like real student work while holding little real understanding [17].

The papers I read show this in a few ways:

- Students who used AI freely did well while practicing, but worse once the AI was taken away.
- Struggling students skipped the planning part and jumped straight to code. They also thought they did better than they actually did.
- Students who let the AI write the whole solution in one prompt did the worst later, when they had to change code on their own [12].

Some tools try to fix this by adding friction, meaning the student has to work with the AI code before using it. This helps a bit. But in these tools the AI still makes every decision. What we do not know is which decisions the student needs to own for learning to happen.

---

## What has been done so far

### The main paper

Kazemitabaar et al. [1] tested seven cognitive engagement techniques plus a baseline with undergrads from a data structures course (N=82, then N=42). They placed the techniques in a design space using Bloom's taxonomy and the ICAP levels, and by timing: whether the student engages before the code is revealed or after. None of the techniques beat the baseline on the no-AI coding test in a significant way. Lead-and-Reveal was the only one where students' confidence matched their real skill. In every technique, the AI made the decisions, and the paper never assigned or changed who makes which decision.

### Problem-solving stages

Loksa et al. [2] taught students six problem-solving stages, from reading the prompt again to testing the code. They ran this with 48 high school students in two web development summer camps, and found that it increased productivity, independence, self-efficacy, metacognitive awareness and growth mindset. Their work did not involve AI. I use these stages as the base for how I split decisions.

### Planning

- Struggling students skipped early planning when they had AI [3].
- Planning hints were linked with higher grades [13].
- When students ask AI on their own, they mostly ask for debugging help, almost never for planning [13, 15].
- Teachers worried that showing pseudo-code gives away the algorithm [4].

### Control between the student and the AI

Students say they want more control, teachers want more restrictions or guardrails, and both like "teacher sets the limit, student picks inside it" [6, 7]. But these were surveys, and no learning was measured. Studies that did test control with learning outcomes were in physics and math, not programming [8, 9].

### Testing without AI

Kazemitabaar et al. [5] used a no-AI post-test and a retention test one week later. Bastani et al. [10] and Sankaranarayanan [14] also showed why the no-AI test is important: the harm only shows up once the AI is gone.

---

## The gap

From what I found, no one has split a programming problem into separate decisions and then tested who should own each one, the student or the AI.

**No decision-level breakdown.** Current tools treat the problem as one block that the AI solves. The main paper itself says "future tools should therefore focus on decomposing code hierarchically and guiding users in the hierarchical decision-making process" [1].

**No test of who should own which decision.** Papers point to planning as important [3, 13], but no one has compared who should own which decision in programming with a no-AI test.

**Students were assigned, not given agency.** Agency means students having control over their own decisions. The main paper says: "Participants were also assigned to specific techniques in our experiments… Future work could explore providing this agency and examine user preferences over time" [1]. My study is a first step here, by testing what happens when specific decisions are given to the student.

**Not true beginners.** The main paper used data structures students [1]. I want to study CS1 students, who are real beginners.

- **CS1 students:** students taking their first programming course. They are usually learning basic programming concepts.
- **Data structures students:** students taking a more advanced course focused on arrays, linked lists, stacks, queues, trees, graphs and algorithms.

---

## Decisions, categories and ownership levels

### What a decision means in this study

A problem has N decisions, and I will not study all of them. I will study the key ones. As defined above, a decision is a choice for one of the categories required to solve a programming problem. The three categories are:

| Decision category | What gets decided | My earlier types inside it |
|---|---|---|
| Algorithmic approach | The plan, and the steps and conditions of the plan | Approach, logic |
| Modeling of inputs | What to store, and how the inputs are handled | Data |
| Testing | Which inputs could break the code, and which tests to run | Edge cases |

The AI always writes the code (syntax). This keeps the typing out of the study, so the difference between conditions comes from the three categories only.

**Algorithmic approach and efficiency.** This study is about beginners, so the approach is judged only on whether it solves the problem, not on its time or space efficiency. A beginner's first move is usually the straightforward one, the brute force, just to make it work. Any correct approach is accepted, and the AI builds on the student's approach even if a more efficient one exists. This matches the "search for solutions" stage in Loksa et al. [2], where programmers look for a solution that satisfactorily solves the problem.

### Conditions: the ownership levels

A condition is one version of the setup that the student practices under. Between conditions I change one thing and keep everything else the same, so any difference in the results comes from that one thing. In this study, the one thing is which decision categories the student owns. So the conditions are the ownership levels.

| Condition | Student owns | AI owns |
|---|---|---|
| L1 | Algorithmic approach | Modeling of inputs, testing, writing the code |
| L2 | Algorithmic approach, modeling of inputs | Testing, writing the code |
| L3 | Algorithmic approach, modeling of inputs, testing | Writing the code |

**Decision-level control** is the setting for each category, whether the student or the AI makes the choice. **Ownership** means owning the decision: the student decides, and decides when to ask the AI for help. This is different from the techniques in [1], where the AI chooses the approach, the order of the steps and the questions.

These conditions replace my earlier A, B and C. The earlier labels (logic, data, edge cases) were too generic to be conditions, and they covered only the planning decisions. The earlier condition C, plain AI, is the baseline already studied in [1], so it is not a condition here.

### Example: palindrome checker

| Level | The student decides | The AI does |
|---|---|---|
| L1 | Compare from both ends and stop at the first mismatch | Handles the inputs (the string, two index variables left and right, ignore case), picks the test cases, writes the code |
| L2 | The approach, plus: ignore case and spaces, use two index variables, left and right | Picks the test cases, writes the code |
| L3 | The approach, the inputs, plus the tests: "abba", "", "a", "Racecar" | Writes the code |

---

## Linking the decisions to Loksa's stages

To make sure the decision categories are not made up by myself, I base them on the six problem-solving stages of Loksa et al. [2]:

1. **Reinterpret problem prompt.** Programming tasks typically begin with some description of a problem, which programmers must understand, interpret, and clarify. As with other forms of problem solving, this understanding is a cognitive representation of the problem used to organize one's "continuing work". The more explicit this interpretation process, the more likely a programmer will overcome ambiguities in the problem.
2. **Search for analogous problems.** Programmers draw upon problems they have encountered in the past, either in past programming efforts or perhaps in algorithmic activities they have encountered in life (e.g., sorting a stack of books or searching for one's name in a list). By reusing knowledge of related problems, programmers can better conceptualize a problem's computational nuances.
3. **Search for solutions.** With some understanding of a problem, programmers seek solutions that will satisfactorily solve the problem by adapting solutions they have used in the past or by finding solutions in textbooks, online, or from classmates or teachers.
4. **Evaluate a potential solution.** With a solution in mind, programmers must evaluate how well this solution will address the problem. This includes actions like feasibility assessments, mental algorithm simulations, or other techniques of sketching or prototyping a solution before implementing it.
5. **Implement a solution.** With an acceptable solution in mind, programmers must translate the solution into source code using their knowledge of languages and tools.
6. **Evaluate implemented solution.** After implementing a solution, programmers iteratively converge toward a solution by evaluating how well their current implementation solves the problem. This typically involves software testing and debugging.

First draft of the mapping between my decision types and the stages:

| Decision type | Category | 1 Reread prompt | 2 Similar problems | 3 Find a solution | 4 Check the plan | 5 Write code | 6 Test |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|
| Approach | Algorithmic approach | ✓ | ✓ | ✓ | | | |
| Logic | Algorithmic approach | | | ✓ | ✓ | | |
| Data | Modeling of inputs | | | ✓ | | | |
| Edge cases | Testing | ✓ | | | ✓ | | |
| Syntax | Always the AI | | | | | ✓ | |

Where it does not line up with Loksa:

- Loksa has no separate stage for data or for edge cases. I added them as decision types.
- Stage 6 (evaluate the implemented solution) is about testing and debugging after the code exists. It is not yet clear how it fits the testing category, which here is about choosing the tests.

This mapping is still a first draft and needs to be checked stage by stage against the paper.

---

## Research questions

The question behind all of this is what level of decisions to give the student, and what level to give the AI, so that learning is maximized and kept over time. The retention time frame is one week.

| RQ | Question | What is measured |
|---|---|---|
| RQ1 | After practicing in L1, L2 or L3, how well can students solve problems on a no-AI coding test? | No-AI test score for each condition |
| RQ2 | Does the difference between L1, L2 and L3 still show one week later? | Retention test score for each condition |
| RQ3 | Is the quality of AI use related to how well students solve problems without AI, and is this different across ownership levels? | Quality of AI use, compared with the no-AI score, for each condition |

**Quality of AI use** means how well students use the AI within their level: asking for explanations rather than answers, working on their own decisions, and checking what the AI gives. How to measure it is still open.

I am not stating a hypothesis for any RQ yet. The direction of the results should come from the literature and from the meeting with Dr. Astroga, not from my assumption.

---

## Variables

A variable is anything in the study that can be different from one student, or one situation, to another.

- **Independent variable (what I change):** the condition, L1, L2 or L3. It is changed on purpose, and the study does not affect it.
- **Dependent variables (what I measure):** the no-AI test score, the one-week retention score, the quality of AI use, and the confidence compared with the real score.
- **Controlled variables (what I keep the same):** the problems, the pretest score for prior skills, and the order of the conditions, which is rotated across students.

Every student gets the same set of problems (for example palindrome, reverse an array, count vowels). If one student got easy problems and another got hard ones, their scores would differ because of the problems and not because of L1, L2 or L3.

Students get the three conditions in rotated orders, shuffling L1, L2 and L3, and the orders can be repeated across students.

**Confidence score:** how confident the student is about their own answer.
**Real score:** the actual score the student received.

---

## To validate

- Confirm the conditions L1, L2 and L3 with Dr. Astroga, and test them on the palindrome example, then on the problems shared by Dr. Astroga.
- Check the mapping between the decision types and the Loksa stages against the paper.
- Decide whether the one-week retention test can be done when every student sees all three conditions, and how to keep problems and conditions apart.
- Find a way to measure the quality of AI use.
- Check whether the brute-force statement needs more citations than Loksa [2].
- Talk to Dr. Robert Gilliland about the experiment design.
- Add the full references for [16] (doi 10.1145/2915970.2915990), [17] (Jackson, "LLMs are not calculators", 2025) and [18] (edpsycinteractive.org/papers/prbsmbti.html, source of the general decision-making definition; author and year still to find) to the reference list.
- Confirm that Dr. Astroga's three categories can be backed by a source, or state them as his framing.
- Check the working definitions (ownership, decision-level control, novice, quality of AI use, leak) against the literature, or keep them marked as working definitions.
