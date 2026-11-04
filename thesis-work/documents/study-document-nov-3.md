# Who Decides? Decision-Level Control of AI Help for Novice Programmers

Sundar Raj · Study document, Nov 3, 2026

This document puts the whole study in one place: where the idea came from, what the research says, the framework as it stands, the practice experiments I ran, and what is still open. The research questions are the Oct 27 ones. The framework is the only focus for now.

## 1. The question

When a beginner uses AI to solve a programming problem, which decisions should the student own, and which ones can the AI own, so that the student still learns and keeps what they learned?

## 2. How I got here

It started with a motivation paper that was shared with me. I was already thinking about decision-level control in programming. Most of us use AI the wrong way now. The whole world depends on it for basic problems, and this is very common with CS1 students and early programmers. I wanted to study levels of autonomy between students and AI, so I started looking for papers.

Then I found the main paper [1], and I realized it was already running experiments in the area I wanted to work on. I went through it with Dr. Gilliland and Dr. Astorga. The paper tests seven techniques that make students engage with AI-generated code, and Lead-and-Reveal came out best. I tried their open-source demo app [18] and a few examples myself. What I noticed is that in every technique the AI makes all the decisions. The student only answers questions and follows the path the AI set.

The direction came from their future work section. They talk about a hierarchy of decisions, and that pointed me to decision-level control. I proposed this, and we had a few meetings. My research questions did not line up, and I was told I first need to define what a "decision" is here and rework the research questions. I also dropped the word "autonomy" and use the level of decision control in problem solving instead, because autonomy is too broad to test.

## 3. The problem

AI tools can now give a full solution for most intro programming problems. So a beginner can finish the work without making the decisions that actually build the skill [1, 3]. Jackson makes a similar point about LLMs in education: they are very good at coding when closely guided, but what they produce can look like real student work while holding little real understanding [16].

The papers I read show this in a few ways:

- Students who used AI freely did well while practicing, but worse once the AI was taken away.
- Struggling students skipped the planning part and jumped straight to code. They also thought they did better than they actually did.
- Students who let the AI write the whole solution in one prompt did the worst later, when they had to change code on their own [11].

Some tools try to fix this by adding friction, meaning the student has to work with the AI's code before using it. This helps a bit. But in these tools the AI still makes every decision. What we don't know is which decisions the student needs to own for learning to happen.

## 4. What has been done so far

**The main paper.** Kazemitabaar et al. [1] tested seven cognitive engagement techniques plus a baseline with undergrads from a data structures course (N=82, then N=42). They placed the techniques in a design space using Bloom's taxonomy and the ICAP levels, and by timing: does the student engage before the code is revealed, or after? None of the techniques beat the baseline on the no-AI coding test in a significant way. Lead-and-Reveal was the only one where students' confidence matched their real skill. In every technique the AI made the decisions, and the paper never changed who makes which decision. The authors say that when AI solves tasks for the user on its own, it could hurt the user's decision-making skills, and that a more engaged, user-involved AI might lead to better decisions and better mental models [1].

**Problem-solving stages.** Loksa et al. [2] taught students six problem-solving stages, from reading the prompt again to testing the code. They ran it with 48 high school students in two web development summer camps, and found it increased productivity, independence, self-efficacy, metacognitive awareness and growth mindset. Their work did not involve AI. I use these stages as the base for how I split decisions.

**Planning.**

- Struggling students skipped early planning when they had AI [3].
- Planning hints were linked with higher grades [12].
- When students ask AI on their own, they mostly ask for debugging help, almost never for planning [12, 14].
- Teachers worried that showing pseudo-code gives away the algorithm [4].

**Control between the student and the AI.** Students say they want more control, teachers want more guardrails, and both like "teacher sets the limit, student picks inside it" [6, 7]. But these were surveys, and no learning was measured. Studies that did test control with learning outcomes were in physics and math, not programming [8, 9].

**Testing without AI.** Kazemitabaar et al. [5] used a no-AI post-test and a retention test one week later. Bastani et al. [10] and Sankaranarayanan [13] also showed why the no-AI test matters: the harm only shows up once the AI is gone.

## 5. The gap

From what I found, no one has split a programming problem into separate decisions and then tested who should own each one, the student or the AI.

- **No decision-level breakdown.** Current tools treat the problem as one block that the AI solves. The main paper itself says future tools should focus on breaking code down hierarchically and guiding users through the hierarchical decision-making process [1].
- **No test of who should own which decision.** Papers point to planning as important [3, 12], but no one has compared who should own which decision in programming using a no-AI test.
- **Students were assigned, not given agency.** Agency means students having control over their own decisions. In the main paper, participants were assigned to specific techniques, and the authors say future work could give users this agency and look at user preferences over time [1]. My study is a first step here.
- **Not true beginners.** The main paper used data structures students [1]. I want to study CS1 students, who are taking their first programming course and learning basic concepts. Data structures students are in a more advanced course on arrays, linked lists, stacks, queues, trees, graphs and algorithms.

## 6. The framework

### What a decision is

A problem has many decisions, and I will not study all of them, only the key ones. A decision is a conscious choice between two or more options [15, 17]. Not every action is a decision [15]. In this study, a decision is a choice for one of three categories needed to solve a programming problem:

| Decision category | What gets decided | My earlier types inside it |
|---|---|---|
| Algorithmic approach | The plan, and the steps and conditions of the plan | Approach, logic |
| Modeling of inputs | What to store, and how the inputs are handled | Data |
| Testing | Which inputs could break the code, and which tests to run | Edge cases |

The AI always writes the code (syntax). This keeps typing out of the study, so differences between conditions come only from the three categories.

Two things are not decisions:

- **Prerequisites.** Basic math and domain facts, like how the remainder works or that overtime pays more, are assumed knowledge.
- **Setup work.** Headers, includes, declaring variables, reading input, printing and the function layout are scaffolding. They do not become a fourth category.

**Approach and efficiency.** This study is about beginners, so an approach is judged only on whether it solves the problem, not on time or space efficiency. A beginner's first move is usually the straightforward one, the brute force, just to make it work. Any correct approach is accepted, and the AI builds on the student's approach even if a more efficient one exists. This matches the "search for solutions" stage in Loksa et al. [2].

**A caution from the research.** The authors of [15] interviewed professional developers and found that they rarely could reconstruct their code-focused choices between alternatives, so they called decision-making a poor lens for studying coding. Their participants were industry developers, not beginners on an intro problem. They also say tools that interrupt unconscious improvisation at critical points could improve quality [15], which is close to what I want to do.

### Conditions: the ownership levels

A condition is one version of the setup the student practices under. Between conditions I change one thing and keep everything else the same, so any difference in results comes from that one thing. Here, the one thing is which decision categories the student owns.

| Condition | Student owns | AI owns |
|---|---|---|
| L1 | Algorithmic approach | Modeling of inputs, testing, writing the code |
| L2 | Algorithmic approach, modeling of inputs | Testing, writing the code |
| L3 | Algorithmic approach, modeling of inputs, testing | Writing the code |

**Decision-level control** is the setting for each category: whether the student or the AI makes the choice. **Ownership** means the student decides, and decides when to ask the AI for help. This is different from the techniques in [1], where the AI chooses the approach, the order of the steps and the questions.

These levels replace my earlier conditions A (student plans), B (AI plans) and C (plain AI). The old labels were too generic and only covered planning decisions. Plain AI is the baseline already studied in [1], so it is not a condition here.

### Linking the decisions to Loksa's stages

To make sure the categories are not made up by me, I base them on the six stages of Loksa et al. [2]:

1. **Reinterpret problem prompt.** Understand, interpret and clarify the problem description.
2. **Search for analogous problems.** Use similar problems seen before to understand this one.
3. **Search for solutions.** Look for a solution that satisfactorily solves the problem, by adapting past solutions or finding them in textbooks, online, or from classmates or teachers.
4. **Evaluate a potential solution.** Check how well the solution would work, by mental simulation, sketching or prototyping, before writing it.
5. **Implement a solution.** Translate the solution into source code.
6. **Evaluate implemented solution.** Test and debug to see how well the code solves the problem.

| Decision type | Category | 1 Reread prompt | 2 Similar problems | 3 Find a solution | 4 Check the plan | 5 Write code | 6 Test |
|---|---|:---:|:---:|:---:|:---:|:---:|:---:|
| Approach | Algorithmic approach | ✓ | ✓ | ✓ | | | |
| Logic | Algorithmic approach | | | ✓ | ✓ | | |
| Data | Modeling of inputs | | | ✓ | | | |
| Edge cases | Testing | ✓ | | | ✓ | | |
| Syntax | Always the AI | | | | | ✓ | |

Loksa has no separate stage for data or for edge cases, so I added them as decision types. Stage 6 is about testing and debugging after the code exists, while my testing category is about choosing the tests. This mapping is still a first draft and needs to be checked stage by stage against the paper.

## 7. Research questions

The question behind all of this is what level of decisions to give the student and what level to give the AI, so that learning is highest and still there later. The retention time frame is one week.

| RQ | Question | What is measured |
|---|---|---|
| RQ1 | After practicing in L1, L2 or L3, how well can students solve problems on a no-AI coding test? | No-AI test score for each condition |
| RQ2 | Does the difference between L1, L2 and L3 still show one week later? | Retention test score for each condition |
| RQ3 | Is the quality of AI use related to how well students solve problems without AI, and is this different across ownership levels? | Quality of AI use, compared with the no-AI score, for each condition |

**Quality of AI use** means how well students use the AI within their level: asking for explanations rather than answers, working on their own decisions, and checking what the AI gives. How to measure it is still open.

I am not stating a hypothesis for any RQ yet. The direction of the results should come from the literature and from our meetings, not from my own assumption. If L1 and L3 turn out to score about the same, that is also a finding.

## 8. Study design

I am not building a tool right now. The goal is to settle the framework the experiment runs under.

- **Participants:** CS1 students.
- **Conditions:** L1, L2 and L3.
- **Problems:** the same set of small intro problems for every student (section 9).
- **Order:** each student gets the three conditions in rotated orders, and the orders can be repeated across students.
- **After practicing:** a no-AI test (RQ1), then a retention test one week later (RQ2).
- **Also collected:** a pretest for prior skill, a confidence score on each answer, and how well the student used the AI (RQ3).

**Variables.**

- Independent (what I change): the condition, L1, L2 or L3.
- Dependent (what I measure): the no-AI test score, the one-week retention score, the quality of AI use, and the confidence compared with the real score.
- Controlled (what I keep the same): the problems, the pretest score for prior skills, and the order of the conditions, which is rotated across students.

Every student gets the same set of problems. If one student got easy problems and another got hard ones, their scores would differ because of the problems and not because of L1, L2 or L3. The confidence score is how confident the student is about their own answer. The real score is the actual score the student received.

**Starter template (proposed, not confirmed).** The student gets a starter template, like LeetCode gives: the includes, the function name with parameters and return type, and an empty body. Everything inside is the student's, including how to treat the inputs and the logic.

**Scope (not confirmed).** Early CS1 topics: variables, conditionals, loops, functions, maybe arrays. Pointers and structures come late in the Fall 2026 CSIS 2610 term and are risky.

## 9. Practice problems at each level

These show what L1, L2 and L3 look like on real problems. In every level the AI writes the code. The two programs for problems 2 and 3 are in the appendix, and they compile and pass the tests listed.

### Problem 1: Palindrome checker

| Level | The student decides | The AI does |
|---|---|---|
| L1 | Compare from both ends and stop at the first mismatch | Handles the inputs (the string, two index variables left and right, ignore case), picks the test cases, writes the code |
| L2 | The approach, plus: ignore case and spaces, use two index variables, left and right | Picks the test cases, writes the code |
| L3 | The approach, the inputs, plus the tests: "abba", "", "a", "Racecar" | Writes the code |

### Problem 2: Positive, negative, zero, odd, even

Input: `number: int`. The output is two labels per number, a sign and a parity. Zero counts as even, so `0` gives "Zero, Even". The problem text does not say this, so it still needs to be confirmed.

| Level | The student decides | The AI does |
|---|---|---|
| L1 | **Algorithm:** two separate checks, one for sign and one for parity. Handle zero explicitly. Print both labels | Modeling (one `int`, negatives and zero allowed, two text labels). Picks the tests. Writes the code |
| L2 | The algorithm, plus **modeling:** one `int` including negatives and zero, and two labels as output | Picks the tests. Writes the code |
| L3 | The algorithm, the modeling, plus **testing:** `7`, `8`, `-3`, `-4`, `0`, `2147483647` | Writes the code |

The tricky inputs are `0` and `-3`. In C++, `-3 % 2` is `-1`, so an `== 1` check for odd fails.

### Problem 3: Movie ticket discount

Inputs: `age: int` and `is_student: bool`.

- Under 12: $5
- 65 and older: $6
- Students aged 12 to 64: $8
- Other adults aged 12 to 64: $12
- Age below 0 or above 120: print "Invalid age entered"

| Level | The student decides | The AI does |
|---|---|---|
| L1 | **Algorithm:** check validity first, then under 12, then 65 and over, then student vs. regular. The student flag only matters for ages 12 to 64 | Modeling (`age` as `int`, `is_student` as `bool`, price as a whole number, how to represent "invalid"). Picks the tests. Writes the code |
| L2 | The algorithm, plus **modeling:** how to represent an invalid age (a message, or a special return value such as -1) and what the function returns | Picks the tests. Writes the code |
| L3 | The algorithm, the modeling, plus **testing:** `(11,1)`, `(12,1)`, `(12,0)`, `(64,1)`, `(65,0)`, `(0,0)`, `(120,0)`, `(-1,0)`, `(121,1)` | Writes the code |

The decisions that matter most are the order of the checks and the boundaries at 11/12 and 64/65. If the validity check is not first, age `-1` gets a $5 child ticket and age `150` gets a $6 senior ticket. A person under 12 or over 64 who ticks "student" still pays the child or senior price.

### Problem 4: Payroll (asked for by Dr. Gilliland)

A C++ function `calculatePay(hours, rate)`. Hours up to 40 are paid at the normal rate, and hours above 40 are paid at 1.5 times the rate. The target concept is if/else. The problem statement describes the situation without saying "multiply."

- 30 hours at $10 gives 300.
- 45 hours at $10 gives 475.

The breakdown into L1, L2 and L3 is not written yet. The 40-hour overtime rule is my choice for this problem.

## 10. Experiments so far

### Trying the techniques from the main paper

To understand how the techniques work, I played the student myself and used the free version of GPT as the tutor, with no earlier chats or saved data. The project in [1] is open source [18], but it needs an API key. The free GPT also cannot reliably store the code just because it is told to, since it works from the conversation context in real time. The assignment was a simple C++ one, Determine Voting Eligibility: ask for the age, print "You are eligible to vote." for 18 or older, and otherwise "You are not eligible to vote." It was graded out of 10: input handling 2, if-else 4, eligibility logic 3, readability and comments 1.

**Baseline (T1).** The AI gives the full code and a detailed explanation right away. The student does not have to do anything, so nobody owns the decision. The explanation goes line by line through the code, so it says what each line is but not why the program makes the decision it does. The student can keep reading and feel they understand, but it is more of an illusion of understanding, because they never worked it out.

**Explain-before-usage (T6).** The AI writes the full code, then decides how to split it into pieces and which question goes with each piece. The student's answers do not change the code. They only unlock the next piece. Thinking is required, which makes it better than the baseline, but the AI guides every step. Since the questions show up first and the whole solution is visible, it can feel like there is no control. Still, answering the questions was motivating, and it felt like more control than the baseline.

**Lead-and-Reveal (T7).** The AI asks questions and reveals the code line by line based on the student's answers. There are up to three tries per question, and after that the tutor reveals the line. Here is where the decisions sit:

- The AI picks the approach, because the solution is already chosen and saved.
- The AI decides how the problem breaks into steps, and what the student sees and when.
- The decisions are at line level, one line of code at a time.
- Only one answer is accepted, so it can feel like guessing toward the AI's answer. After three tries the line is revealed, which felt like my decision was being overridden.
- The student cannot say "I will do this part, I need help with that part." So the student cannot decide.

I ran two prompts for this one. The first used multiple-choice quizzes. I only had to pick an option, which needs less thinking. The second was conversation-driven: I write my answers in the chat, and I can use the hints to explore the topic more. It had better interaction and more control than the first, and it asked more of me. These runs were only to understand the techniques. They are not part of my study.
### Practice problems at the three levels

I worked out how the framework applies to the practice problems in section 9, and compiled the two programs to check they work. A second even/odd run with the current study is planned, and a basic experiment based on it will go under `experiment/current-study/`.

## 11. What is still open

**On the framework**

- **The categories may blend.** Both Dr. Gilliland and Dr. Astorga raised that modeling and testing may blend into the algorithmic approach, so the three categories may not separate cleanly. My view is that most of the weight sits in the algorithmic approach, and I am open to broadening it or redefining things so nothing overlaps. Problem 3 (the validity check and the `-1` return) is where modeling and the algorithm overlap most. In problem 2, `-3 % 2` shows the same thing.
- **The categories need one rule.** Right now they are defined by examples. I need one sentence per category and one rule for putting any decision in a category.
- **Modeling is thin for single-number problems.** I need to decide whether to defend it as types and ranges, or as choosing a structure.
- **The most important decision.** Dr. Gilliland asked which one decision matters most and why. I do not have my answer yet. One idea is to find it from data, by seeing which part students struggle with most on a no-AI test that is marked by part.
- **The design.** The student always owns the algorithm in L1 to L3, so the study cannot show it matters most unless a condition is added where the AI owns it. Or I change the question to what the design really tests, which is whether owning more decisions helps.
- **The stages idea.** Whether to treat the categories as stages of one process (setup, then core logic) and split ownership along those stages. Not decided.

**On measurement**

- How to score the no-AI test by part, one mark per category, and whether to save chat logs with timestamps. A rubric is static and misses the live experience of the student.
- How to measure the quality of AI use, and how to tell when the AI gave away a decision that was supposed to stay with the student (a leak).
- Whether the brute-force statement needs more citations than Loksa [2].

**On the experiment**

- Whether each student doing all three levels is a problem, since what they learn in the first level carries into the next and can muddy the one-week retention test. I need to decide between groups per level and rotated order, and say why.
- The problem set is not locked: palindrome, positive/negative/odd/even, movie ticket, payroll. Zero as even is unresolved.
- The payroll problem still needs its L1, L2 and L3 breakdown.
- Where the study sits on the data-structure ladder: single variables, up to arrays, or beyond.
- Whether the input step should show in the syntax-removed even/odd view.
- Rerun the programming-problem experiment with the problems shared by Dr. Astorga, and talk to Dr. Gilliland about the design.

**On the references**

- [15] and [17] still need authors and titles.
- Confirm that the three categories can be backed by a source, or state them as Dr. Astorga's framing.
- Check the working terms (ownership, decision-level control, novice, quality of AI use, leak) against the literature, or keep them marked as working.

**Side idea (parked).** The Fall 2026 CSIS 2610 topic list covers what to write, but it does not list how to decide what to write. This rests only on the topic list, so I need to check with Dr. Astorga whether labs or lectures cover it.

## 12. Advisor input and where it went

**Dr. Astorga**

- What "decision" and "decision-level control" mean, and which decisions are essential for learning: a decision is a choice for one of three categories: algorithmic approach, modeling of inputs, testing. Which ones are essential is what the study is for.
- What a condition is: the ownership levels L1, L2, L3.
- Approach, logic, data and edge cases should be grouped as algorithmic approach, modeling of inputs and testing: done. The old types stay as the breakdown inside each category.
- "Planning decisions": dropped. The three categories replace it.
- Experiments might be okay, and talk through the setup with Dr. Gilliland.

**Dr. Gilliland**

- The plain AI baseline is already studied in [1], so it cannot be a condition: removed.
- Define what a decision is here and rework the research questions: done.
- Quality of AI use with respect to the decision choices: now RQ3.
- He flagged the hypotheses, so I am not stating any for now.
- Asked for the payroll problem, and asked which decision is the most important.

**My own change:** "autonomy" became the level of decision control in problem solving.

## 13. Terms

Where a definition is mine and not from a paper, it says so.

1. **Problem solving in programming.** Turning mental pictures of the problem and the solution into source code. Loksa et al. [2] describe it as six stages.
2. **Decision.** A conscious choice between two or more options [15, 17]. Here, a choice for one of the categories needed to solve a programming problem: algorithmic approach, modeling of inputs, or testing.
3. **Ownership and decision-level control.** Decision-level control is the setting for each decision category: whether the student or the AI makes the choice. Ownership means the student makes that choice. These are my working terms. They come from the gap in [1], where the AI makes the decisions and students are assigned a technique. The paper calls this missing control "agency" [1].
4. **Condition.** One version of the setup the student practices under. Only one thing changes between conditions, the ownership level (L1, L2, L3).
5. **Cognitive engagement and friction.** Kazemitabaar et al. [1] use cognitive engagement for how deeply a learner works with AI-generated code, and friction for the extra work a technique adds before the learner can use the code. Without engagement, learners can get an "illusion of learning" [1].
6. **No-AI test and retention test.** The no-AI test is a coding test the student does alone after practicing. The retention test is the same kind of test one week later. Both follow the design in [5].
7. **Confidence match (calibration).** How close a student's own guess of their skill is to their real test score [1].
8. **Novice.** A student in their first college programming course (CS1), with at most one semester of programming before. This is my working definition.
9. **Quality of AI use.** How well students use the AI within their level, for example asking for explanations rather than answers, and checking what the AI gives. A working term.
10. **Leak.** When the AI gives away a decision that was supposed to stay with the student. A working term.

## Appendix: the programs the AI writes (the same at every level)

Positive, negative, zero, odd, even:

```cpp
#include <iostream>
using namespace std;

int main() {
    int number;
    cout << "Enter an integer: ";
    cin >> number;

    if (number > 0) {
        cout << "Positive";
    } else if (number < 0) {
        cout << "Negative";
    } else {
        cout << "Zero";
    }

    cout << ", ";

    if (number % 2 == 0) {
        cout << "Even" << endl;
    } else {
        cout << "Odd" << endl;
    }

    return 0;
}
```

Movie ticket discount:

```cpp
#include <iostream>
using namespace std;

int ticketPrice(int age, bool isStudent) {
    if (age < 0 || age > 120) {
        return -1;
    } else if (age < 12) {
        return 5;
    } else if (age >= 65) {
        return 6;
    } else if (isStudent) {
        return 8;
    } else {
        return 12;
    }
}

int main() {
    int age;
    bool isStudent;
    cout << "Enter age: ";
    cin >> age;
    cout << "Student? (1 = yes, 0 = no): ";
    cin >> isStudent;

    int price = ticketPrice(age, isStudent);

    if (price == -1) {
        cout << "Invalid age entered" << endl;
    } else {
        cout << "Ticket price: $" << price << endl;
    }

    return 0;
}
```

## References

[1] Kazemitabaar, M., Huang, O., Suh, S., Henley, A. Z., & Grossman, T. (2025). Exploring the Design Space of Cognitive Engagement Techniques with AI-Generated Code for Enhanced Learning. IUI 2025. ACM. arXiv:2410.08922. https://arxiv.org/pdf/2410.08922

[2] Loksa, D., Ko, A. J., Jernigan, W., Oleson, A., Mendez, C. J., & Burnett, M. M. (2016). Programming, Problem Solving, and Self-Awareness: Effects of Explicit Guidance. CHI 2016, 1449-1461. https://faculty.washington.edu/ajko/papers/Loksa2016ProgrammingProblemSolving.pdf

[3] Prather, J., et al. (2024). The Widening Gap: The Benefits and Harms of Generative AI for Novice Programmers. ICER 2024.

[4] Kazemitabaar, M., et al. (2024). CodeAid: Evaluating a Classroom Deployment of an LLM-based Programming Assistant that Balances Student and Educator Needs. CHI 2024.

[5] Kazemitabaar, M., et al. (2023). Studying the Effect of AI Code Generators on Supporting Novice Learners in Introductory Programming. CHI 2023.

[6] Wu, Z., Tang, Y., & Ericson, B. (2025). Learner and Instructor Needs in AI-Supported Programming Learning Tools: Design Implications for Features and Adaptive Control. AIED 2025.

[7] Ma, B., Xie, Y., Li, H., Li, G., Chen, L., Shimada, A., & Konomi, S. (2026). Design Implications for Student and Educator Needs in AI-Supported Programming Learning Tools. arXiv.

[8] Dai, et al. (2025). How Students Use AI Feedback Matters: Experimental Evidence on Physics Achievement and Autonomy. arXiv.

[9] Long, Y. (2015). Supporting Learner-Controlled Problem Selection in Intelligent Tutoring Systems. PhD dissertation, Carnegie Mellon University.

[10] Bastani, H., Bastani, O., Sungu, A., Ge, H., Kabakci, O., & Mariman, R. (2025). Generative AI without guardrails can harm learning: Evidence from high school mathematics. PNAS, 122(26).

[11] Kazemitabaar, M., Hou, X., Henley, A. Z., Ericson, B., Weintrop, D., & Grossman, T. (2023). How Novices Use LLM-Based Code Generators to Solve CS1 Coding Tasks in a Self-Paced Learning Environment. Koli Calling 2023.

[12] Phung, T., Choi, H., Wu, M., Singla, A., & Brooks, C. (2025). Plan More, Debug Less: Applying Metacognitive Theory to AI-Assisted Programming Education. AIED 2025.

[13] Sankaranarayanan, S. (2026). Mitigating "Epistemic Debt" in Generative AI-Scaffolded Novice Programming using Metacognitive Scripts. L@S 2026.

[14] Ma, B., Li, H., Li, G., Chen, L., Shimada, A., & Konomi, S. (2026). AI-Assisted Help-Seeking Trajectories in Programming Education from an SRL-Informed Perspective. arXiv.

[15] Study of 104 developer interviews on coding decisions. https://doi.org/10.1145/2915970.2915990 (authors and title to add)

[16] Jackson, D. (2025). LLMs are not calculators. https://groups.csail.mit.edu/sdg/pubs/2025/jackson-ai-education.pdf

[17] General definition of decision-making. https://www.edpsycinteractive.org/papers/prbsmbti.html (author and year to add)

[18] Kazemitabaar, M., et al. Code engagement techniques (open-source project and Lead-and-Reveal demo app). https://github.com/MajeedKazemi/code-engagement-techniques · https://lead-and-reveal.vercel.app/
