# Repo prompts, "novice" check, and the 4-5 lines rule

Source repo: `code-engagement-techniques/` (Kazemitabaar et al., arXiv 2410.08922).
Exact prompt text for every row below is in `repo-prompts-verbatim.md`. It was copied by line range, not retyped. The repo is all Python; the C++ runs changed only that word.

## 1. Where each prompt lives

All files are in `code-engagement-techniques/packages/server/routes/`.

| Tech | File | Lines |
|---|---|---|
| T1 Baseline | `codex-baseline-router.ts` `/generate` | system 145-155, user 161 |
| T2 Write-Over | `codex-writeover-router.ts` | system 19-85 |
| T3 Parsons | `codex-parsons-router.ts` | system 20, few-shots 22-105 |
| T4 Verify | `codex-verify-router.ts` | generate 37-55, hints 116-278 |
| T5 Pseudo | `codex-pseudo-router.ts` | 124-188 |
| T6 Explain | `codex-selfexplain-router.ts` | generate 81-122, feedback 28-39 |
| T7 Reveal | `codex-reveal-router.ts` | generate 28-139, feedback 196-203 |
| T8 Tracing | `codex-tracing-router.ts` | question 285, feedback 437-459, hint 505 |

Notes:

- **T6 duplicates.** `codex-selfexplain-router.ts` has a second `/feedback` route (line 324) and a `/question` route (line 161) with an older, different prompt. The T6 flow uses the `/generateQuestion` (line 73) and `/feedback` (line 21) pair listed above.
- **Unused routers.** `codex-hierarchical-router.ts` and `codex-token-router.ts` are mounted in `server.ts`, but I found no client call to them, so they are left out. The hierarchical prompt says "novice child".

## 2. "Novice" in each prompt

**T1 has no "novice" anywhere.** The baseline prompt is a bare "Generate the python code that solves the provided problem" with no audience. Your T1 assumption holds.

| Tech | "novice" in the prompt? |
|---|---|
| T1 | **No.** Its other route, `/generateFeedback`, doesn't use it either. |
| T2 | Yes: "a novice student that is learning to write code" |
| T3 | **No.** No "novice" and no "student" either. |
| T4 | Yes, in 2 of 4 prompts: "noivce python programmers" (typo, line 38) and "novice-friendly" (hint L2). Hint L1 and L3 don't say it. |
| T5 | **No** in generate, hint or verify. The hint says "students learn python syntaxes". |
| T6 | Yes, in both prompts: "helping novice programmers" and "novice python programmers" |
| T7 | Yes in generate ("novice programmers", "novice student"). **No** in the short-answer feedback prompt. |
| T8 | Yes in 3 prompts ("novice Python learners", "noive python programmer", "novice python program"). **No** in the feedback and short-answer prompts. |

**Takeaway:** T1, T3 and T5 have no novice framing. T4, T7 and T8 are patchy, and their feedback prompts mostly lack it. T1 is your baseline, so the AI there isn't told who the learner is, while T6 and T7 are. That is an uncontrolled difference in the replication.

## 3. Why one question per 4-5 lines in T6?

**Conclusion: no. Neither the paper nor the repo gives a reason for the 4-5 line rule.**

**What I checked** (paper text extracted from the arXiv PDF, 19 pages; repo files listed in section 1):

- Paper: every passage that mentions Explain-before-Usage / T6, and the T6 description (Section 3.6), the implementation paragraph, the participant feedback on T6 (4.5.6), the discussion of engagement timing, the V2 redesign (Section 5), and the limitations. I also searched the whole text for "4-5", "per 4", "pilot", "lines of code" and "question".
- Repo: the T6 server prompt (`codex-selfexplain-router.ts`) and the T6 client code (`self-explanation.tsx`, `responses/self-explain.tsx`).

**What the paper says about T6:**

- It is motivated by prior work on self-explanation (explaining code helps learners, and explaining relates to writing).
- The AI highlights an important part of the code, asks a short-answer question, and scores the answer 0-5. The user gets up to 3 attempts, and the answer is shown after the third.
- "A total of 3-5 questions are asked from various parts of the generated code, depending on the code's complexity." This is the only statement on question count, and it gives no reason for the number.
- Participants said T6 helped them understand each step but stayed "surface level" and covered "little bits" of the code, not the whole.
- In the V2 redesign, T6 was merged into Trace-and-Predict (Section 5.2), so it was not refined on its own. No change to the question count is described.

**What the repo says:**

- The "4-5 code lines" rule appears once, in the prompt (`codex-selfexplain-router.ts:87`), with its 10-line and 12-line examples. There is no comment, doc or commit note explaining it.
- The client does not set a question count. It shows whatever the LLM returns, so the number comes only from the prompt.
- The client moves a student on at a score of 3 or more (a code comment says "4/5"), or after 3 attempts. The paper doesn't mention this score threshold.

**Mismatch with your T6 run:**

- Your code was 26 lines, so the repo rule gives about 5-6 questions, but the paper says 3-5 in total.
- You got 4 because your edited prompt says "3 to 5 questions in total".
- The paper's version is a fixed range. The repo prompt scales with code length.

**How to write it up:** call the 4-5 line figure an unexplained design choice by the authors (a rule of thumb in their prompt), not something the paper supports. If you need the real reason, the only route is to ask the authors.

## 4. Why isn't "novice" in every prompt?

**Conclusion: nobody says why. The paper is silent on prompt wording, and the repo has no comment or doc about it. The git history shows the prompts were written one at a time over about 14 months, with no shared template.**

### What the paper says

- "Novice" is used for the participants and the literature, not for the prompts. The participants were 82 students from an undergraduate data structures course, which the paper calls "novice programmers recruited from intermediate-level computer science programming courses".
- The paper says prompts and source code are on GitHub (this repo) and never discusses how a prompt should address the learner.
- It does not say the AI was told the learner's level, and it doesn't say a shared audience line was used across techniques.
- Section 5 says "all techniques, including the Baseline" were updated to give line-by-line explanations on hover. It does not mention prompt wording or "novice".

### What the repo says

- The repo has no comment, readme note or doc about the learner level in prompts. The readme is only `yarn install` and `yarn dev`.
- The repo has its own git history (191 commits, 2023-06-01 onward), so I traced when each prompt got its wording:

| Prompt | Written | "novice" in the current prompt? |
|---|---|---|
| Baseline `/generate` | first written 2023-06-03 with "novice children… for the first time", rewritten 2024-08-06 | **No** (removed) |
| Pseudo | 2023-06-09 (rewritten 2024-01-14) | No |
| Hierarchical (unused) | 2023-06-24 | Yes, "novice child" |
| Write-Over | 2023-07-25 | Yes |
| Parsons | 2023-08-08 | No (never had it) |
| Self-explain (T6) | 2023-08-16 | Yes |
| Tracing | 2023-10-10 | Yes, in 3 prompts |
| Verify | 2023-11-09 | Yes, in 2 of 4 (the typo "noivce" appears here) |
| Lead-and-Reveal | 2024-01-04 | Yes |

### The one change we can see: the baseline

- The baseline prompt began as "generate a short python code snippet for a novice child that is learning to code for the first time… Use novice-friendly terms".
- On **2024-08-06**, commit `c1fe05e` ("trace and predict UI changes and lead reveal constants") replaced it. That commit changed 11 files and also added the baseline and lead-reveal task constants. The new prompt is the current "Generate the python code that solves the provided problem. Use the following format… `<line of code> ### <explanation>`".
- This matches the paper's Section 5 statement that the Baseline was updated to line-by-line explanations. The commit message doesn't mention the prompt, so **the link between the two is my inference, not something stated.**

### What this means for you

- The inconsistency is real but undocumented. The most likely cause (my inference) is that each prompt was written separately, at different times, and the baseline was rewritten for the line-by-line format. The typos in the tracing and verify prompts ("noive", "noivce") also suggest no shared template.
- The repo is the final state. I didn't check whether Study 1 used the same prompts as these. This is **[UNVERIFIED]**.
- For your replication: T1 gets no learner description while T6 and T7 do, so adding or dropping "novice" is a variable you control. Your thesis participants already know basic C++, so state which level your prompts assume and apply it to every condition.
- To get the actual reason, ask the authors (their emails are in the paper).


