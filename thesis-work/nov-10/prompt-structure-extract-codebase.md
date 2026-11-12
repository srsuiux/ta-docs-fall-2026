# Ready-to-test prompts (authentic repo wrapper): C++, problem.txt

Each block is the repo's system prompt followed by its user-message template, filled with `problem.txt`. In the web UI there is no system role, so each block goes into one message: system text first, then the user message. Only edit to the repo text: Python -> C++ (and `\`` / `\"` escapes removed). Nothing else changed, JSON templates included.
Placeholders: `<numbered code>` = the code from the T1 answer, one line per row (`1. ...`, `2. ...`), as the repo's `getCodeWithLine` does.

---

## T1: Baseline code + explanation
`codex-baseline-router.ts` `/generate`: system lines 145-155, user line 161.
```
Generate the C++ code that solves the provided problem. Use the following format to provide explanations for each line.

[OUTPUT]
<line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
<line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
    <line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
<line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
[END]

[OVERALL-EXPLANATION]
<now provide a holistic explanation in paragraphs about how the code is solving the problem>

[intended-behavior]: The Movie Ticket Discount Calculator
Inputs: age:int and is_student:bool 
Children (under 12): Ticket price is $5.
Seniors (65 and older): Ticket price is $6.
Students (ages 12 to 64 who are students): Ticket price is $8.
Regular adults (ages 12 to 64, not students): Ticket price is $12.
Invalid age (less than 0 or greater than 120): Print an error message like "Invalid age entered"
[code]:
```

---

## T6: Self-explanation
### A. Generate questions
`codex-selfexplain-router.ts` `/generateQuestion`: system lines 82-121, user line 129.
```
you are helping novice programmers learn about coding.
look at the above C++ [practice-code], group it into questions, the question can be either [multiple-choice] or [short-answer] inside each question, include the lines of code from the above [practice-code]. 

Use the following template:

The format should be an array of n items, where n is a number that can average the questions per 4-5 code lines. For example, a 10-line code snippet could have 2 questions, and 12-line code could have 3 questions, combinations of [multiple-choice]  and [short-answer].

example for <comma separated code line numbers based on solution-code> is [6] for the line 6, or [9,10] for line 9 and line 10.



# Template:
{
"format": <a list of format in combinations of "Short Answer" or "Multiple Choice" depends on the number of questions, in this example, I use ["Short Answer", "Multiple Choice"]>
"questions": [
  {
    "type": "Short Answer",
    "question": "<5-10 word question for the student to think about the "problem solving aspects" of the task>",
    "answer": "<10-15 word answer>",
    "question-code-lines": [
      "<comma separated code line numbers based on solution-code>"
    ],
    "question-code-lines-explained": "<exact lines of code> # <very concise explanation about the "purpose" and "functionality" of this code>"
  },
  {
    "type": "Multiple Choice",
    "question": "<5-10 word question for the student to think about the "problem solving aspects" of the task>",
    "answer": {
      "correct-choice": "<7-15 word correct answer>",
      "incorrect-choice-1": "<7-15 word plausible distractor>",
      "incorrect-choice-2": "<7-15 word plausible distractor>",
      "incorrect-choice-3": "<7-15 word plausible distractor>"
    },
    "question-code-lines": [
      "<comma separated code line numbers based on solution-code>"
    ],
    "question-code-lines-explained": "<exact lines of code> # <very concise explanation about the "purpose" and "functionality" of this code>"
  }
]
}

[task-description]: The Movie Ticket Discount Calculator
Inputs: age:int and is_student:bool 
Children (under 12): Ticket price is $5.
Seniors (65 and older): Ticket price is $6.
Students (ages 12 to 64 who are students): Ticket price is $8.
Regular adults (ages 12 to 64, not students): Ticket price is $12.
Invalid age (less than 0 or greater than 120): Print an error message like "Invalid age entered"
[solution-code]: <numbered code>[end-solution-code]
```

### B. Grade a student answer
`codex-selfexplain-router.ts` `/feedback`: system lines 29-38, user line 45.
```
You want to generate feedback for novice C++ programmers, based on the following input: takes in 5 values: a question (string), an code line (string), which provided the question context, an answer (string), which is the correct explanation and a response from the user (string). 
The question is an open-ended explanation of code snippets aimed at novice programmers. Your task is to generate a JSON output with the following structure:

# Use the following JSON template:
{
    "score": [a number between 0 and 5], 
    "feedback": "[10 to 15 words feedback]"
}

Design a system that can generate this JSON output based on the input values provided. The score should represent the quality or correctness of the response, ranging from 0 (poor) to 5 (excellent). The feedback should be a concise comment, consisting of 10 to 15 words, offering constructive feedback on the answer provided.

[code]: <code>
[line] <line of code the question is about>
[question] <question>
[answer] <correct answer from step A>
[user-response]<your answer>
```

---

## T7: Lead-and-Reveal
### A. Generate the leading questions
`codex-reveal-router.ts` `/generateQuestion`: system lines 29-138, user lines 145-147.
```
# Overview:
you are helping novice programmers learn about coding. Look at the provided C++ [solution-code] and the [task-description], then divide the provided code into a list of [subgoal] items. For each [subgoal], provide a concise [title] and then divide it into [sub-subgoal-items]. The student has only be given the [task-description] and cannot see the [solution-code], instead you, the assistant that is helping this novice student learn about coding by asking a series of leading questions. These leading questions are multiple-choice question about each sub-subgoal parts of the task. These questions are supposed to promote critical thinking, problem solving, algorithmic thinking, and computational thinking, and help the student think about the task before they see the code. The student does not know about the [solution-code], they have only be given the [task-description. Our system shows the mcq-questions that you generate, one by one. If the student correctly answers the leading question, our system will reveal the code lines associated with that [sub-subgoal] and then the system displays the next question.

# Important Notes:
[sub-subgoal-items] can be one line of code, can be a function definition, can be the `for item in items` part of a loop, can be a return statement. Make sure that for more complicated sub-subgoals, there are multiple questions. Sometimes, a single line of code also deserves its own question, such as a for loop (asking questions about how many times we need to check, what items, what indices, from what index to what index), or the if statement (what different states can X be when Y, how can we make sure Z, etc.).

[code-lines-to-be-revealed]: a comma separated list of numbers that represent the lines of code from [solution-code] related to that [sub-subgoal-item].

[mcq-question]: the provided choices in the distractors [incorrect-choice] should be "plausible" but incorrect answers: these distractors are reasonable answers that might be selected if a student did not think deeply about the task, missed edge-cases and over-generalized, and did not think critically enough. These "plausible" choices should focus on conceptual misunderstandings, common mistakes that students might make, missing corner-cases and edge-cases, incorrect assumptions that students might make, off-by-one errors (such as looping one time too many, or too few), incorrect choice of data structures, overlooking the behavior of a program or algorithm for special or extreme values, and other logical errors. Each question will help the student to think deeply about "how" this task needs to be solved (focusing on the logic, on the important data representations, operations, etc.) ... the code for that subgoal will only be revealed if the student answers the question about that part correctly. Make sure that all lines of code from [solution-codes] are covered with the [sub-subgoals] and [mcq-questions], even misc lines, or purely syntactic lines like a function definition. For example, the function definition line (e.g. `def function_name(input_val)`) should also become a [subgoal] and the [mcq-question] can ask about the inputs, and how the input is represented, using what data types. For example: "what type best represents an interval?" The leading questions should make the student think about the logic, particularly the what, why, and how of actions.



# Generate using the following JSON template precisely:
{
  "subgoals": [
    {
      "title": "<2-5 word concise title for this subgoal>",
      "sub-subgoal-items": [
        {
          "leading-questions": [
            {
              "mcq-question": "<multiple-choice question>",
              "correct-choice": "<7-15 word correct answer>",
              "incorrect-choice-1": "<7-15 word plausible distractor>",
              "incorrect-choice-2": "<7-15 word plausible distractor>",
              "incorrect-choice-3": "<7-15 word plausible distractor>"
            },
            {
              "mcq-question": "<multiple-choice question>",
              "correct-choice": "<7-15 word correct answer>",
              "incorrect-choice-1": "<7-15 word plausible distractor>",
              "incorrect-choice-2": "<7-15 word plausible distractor>",
              "incorrect-choice-3": "<7-15 word plausible distractor>"
            },
            {
              "mcq-question": "<multiple-choice question>",
              "correct-choice": "<7-15 word correct answer>",
              "incorrect-choice-1": "<7-15 word plausible distractor>",
              "incorrect-choice-2": "<7-15 word plausible distractor>",
              "incorrect-choice-3": "<7-15 word plausible distractor>"
            },
          ],
          "code-lines-to-be-revealed": [<comma separated code line numbers based on solution-code>]
        },
        {
          "leading-questions": [
            {
              "mcq-question": "<multiple-choice question>",
              "correct-choice": "<7-15 word correct answer>",
              "incorrect-choice-1": "<7-15 word plausible distractor>",
              "incorrect-choice-2": "<7-15 word plausible distractor>",
              "incorrect-choice-3": "<7-15 word plausible distractor>"
            },
            {
              "mcq-question": "<multiple-choice question>",
              "correct-choice": "<7-15 word correct answer>",
              "incorrect-choice-1": "<7-15 word plausible distractor>",
              "incorrect-choice-2": "<7-15 word plausible distractor>",
              "incorrect-choice-3": "<7-15 word plausible distractor>"
            },
          ],
          "code-lines-to-be-revealed": [<comma separated code line numbers based on solution-code>]
        },
      ]
    },
    {
      "title": "<2-5 word concise title for this subgoal>",
      "sub-subgoal-items": [
        {
          "leading-questions": [
            {
              "mcq-question": "<multiple-choice question>",
              "correct-choice": "<7-15 word correct answer>",
              "incorrect-choice-1": "<7-15 word plausible distractor>",
              "incorrect-choice-2": "<7-15 word plausible distractor>",
              "incorrect-choice-3": "<7-15 word plausible distractor>"
            }
          ],
          "code-lines-to-be-revealed": [<comma separated code line numbers based on solution-code>]
        },
        {
          "leading-questions": [
            {
              "mcq-question": "<multiple-choice question>",
              "correct-choice": "<7-15 word correct answer>",
              "incorrect-choice-1": "<7-15 word plausible distractor>",
              "incorrect-choice-2": "<7-15 word plausible distractor>",
              "incorrect-choice-3": "<7-15 word plausible distractor>"
            },
            {
              "mcq-question": "<multiple-choice question>",
              "correct-choice": "<7-15 word correct answer>",
              "incorrect-choice-1": "<7-15 word plausible distractor>",
              "incorrect-choice-2": "<7-15 word plausible distractor>",
              "incorrect-choice-3": "<7-15 word plausible distractor>"
            },
            {
              "mcq-question": "<multiple-choice question>",
              "correct-choice": "<7-15 word correct answer>",
              "incorrect-choice-1": "<7-15 word plausible distractor>",
              "incorrect-choice-2": "<7-15 word plausible distractor>",
              "incorrect-choice-3": "<7-15 word plausible distractor>"
            }
          ],
          "code-lines-to-be-revealed": [<comma separated code line numbers based on solution-code>]
        },
      ]
    },
  ]
}

[task-description]: The Movie Ticket Discount Calculator
Inputs: age:int and is_student:bool 
Children (under 12): Ticket price is $5.
Seniors (65 and older): Ticket price is $6.
Students (ages 12 to 64 who are students): Ticket price is $8.
Regular adults (ages 12 to 64, not students): Ticket price is $12.
Invalid age (less than 0 or greater than 120): Print an error message like "Invalid age entered"
[solution-code]: <numbered code>[end-solution-code]

Focus a lot of the questions on the complex part of the algorithm. For those parts, you can include one question per line, or even two questions per line.
```

### B. Grade a short answer
`codex-reveal-router.ts` `/feedbackFromRevealShortAnswer`: system lines 196-203, user line 209.
```
I have been asked this [question] about the next part of the [not-revealed-code] that I haven't seen yet (so it's hidden to me). This is part of an exercise to help me think deeply about what this [not-revealed-code] is supposed to do and how it contributes to the [overall-code-solution]. Here is my [my-answer] to the [question]. Check if it makes sense based on the [overall-code-solution], [not-revealed-code], and the [sample-solution]

Please return a JSON object with the following format:
{
    "correctness": <0-5>, // if empty, jibberish, or completely wrong then 0. if partially correct and missing important details (like the value something needs to be set to, compared with, etc.) then 1 or 2 (based on how much is missing). If the answer is almost correct, but has a small mistake, then 3. If the answer is correct, but missing some details, then 4. If the answer is perfect, then 5.
    0 means wrong, 2 means partially correct (for example if the question is what should we use for X and what should we do with it, then if I only answer one part correctly, then I should receive 2). But then 5 means that I have answered perfectly with sufficient detail about [not-revealed-code].
    "feedback": "<20-30 word of explanation about what I got correctly and a small hint at what I am missing about the [not-revealed-code]>"
}

[question]: <question>
[my-answer]: <your answer>

[sample-solution]: <answer from step A>
[not-revealed-code]: <the code lines for this step>
[overall-code-solution]: <full code>
```
