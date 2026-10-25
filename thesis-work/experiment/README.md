# Testing Cognitive Engagement Techniques T1:Baseline, T4:Verify & Review, T7:Lead and Reveal With Simulated Student and Keeping Log for the Study Reference

## Experiment Overview

This experiment tests three techniques from *Exploring the Design Space of Cognitive Engagement Techniques with AI-Generated Code for Enhanced Learning* ([arXiv:2410.08922](https://arxiv.org/pdf/2410.08922)). Each technique is applied to the same programming assignment. The experimenter takes the role of the student and interacts directly with a GenAI assistant (GPT, Free version, No Pervious data and cache present), working through the assignment under each technique.

Experimenting with this techniques firsthand provides practical and the real understanding of how each one works and how GenAI supports a student in each case. This understanding serves as a reference for my own experiment and study.

## Programming Problem

**Assignment: Determine Voting Eligibility** (C++)

- **Objective:** Practice using if statements to make decisions based on user input.
- **Task:** Ask the user for their age. If the age is 18 or older, display `You are eligible to vote.` Otherwise, display `You are not eligible to vote.`

| Example | Output |
|---|---|
| Input `21` | `Enter your age: 21` / `You are eligible to vote.` |
| Input `16` | `Enter your age: 16` / `You are not eligible to vote.` |

**Requirements**

- Prompt the user to enter their age.
- Use an if-else statement to determine eligibility.
- Display the appropriate message.
- Include comments explaining the code.

**Submission:** a C++ source file (`.cpp`) and a screenshot of the program running.

**Grading (10 points)**

| Criterion | Points |
|---|---|
| Correct input handling | 2 |
| Correct use of if-else | 4 |
| Correct voting eligibility logic | 3 |
| Program readability and comments | 1 |

## Goal

Find out how modern GenAI helps a student solve the problem under three different interaction approaches. By playing the student in each one, the experimenter documents how each technique behaves and how the AI supports the student, so the findings can be reused as a reference.

## Techniques

| ID | Technique | Level | Documentation |
|---|---|---|---|
| T1 | Baseline | n/a | [t1-baseline.md](t1-baseline.md) |
| T7 | Lead-and-Reveal | Create / Interactive / Engage & Reveal | [t7-lead-and-reveal.md](t7-lead-and-reveal.md) |
| T4 | Verify-and-Review | Evaluate / Constructive / Engage & Reveal | [t4-verify-and-review.md](t4-verify-and-review.md) |