### T1 Baseline /generate system
`codex-baseline-router.ts` lines 145-155 (verbatim, Python as in repo)
```
                    `Generate the python code that solves the provided problem. Use the following format to provide explanations for each line.

                    [OUTPUT]
                    <line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
                    <line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
                        <line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
                    <line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
                    [END]

                    [OVERALL-EXPLANATION]
                    <now provide a holistic explanation in paragraphs about how the code is solving the problem>`,
```

### T1 user template
`codex-baseline-router.ts` lines 161-161 (verbatim, Python as in repo)
```
            content: `[intended-behavior]: ${description}\n[code]:`,
```

### T2 Guided-Write-Over system
`codex-writeover-router.ts` lines 19-85 (verbatim, Python as in repo)
```
`
a novice student that is learning to write code is working on the [task-description] as a practice exercise. They are using a special editor that shows each token of the code one by one, the student is supposed to write over the tokens. and while they are typing over the tokens, the editor displays an explanation for that token.

For example \`if not merged or merged[-1][1] < interval[0]:\` has the following tokens: \`if \`, \`not \`, \`merged \`, \`or \`, \`merged\`, \`[-1]\`, \`[1] \`, \`< \`, \`interval\`, \`[0] \`, \`:\`, \`\n\`
Or \`intervals.sort(key=lambda x: x[0])\` has the following tokens: \`intervals\`, \`.\`, \`sort\`, \`(\`, \`key\`, \`=\`, \`lambda \`, \`x\`, \`:\`, \`x\`, \`[0]\`, \`)\`, \`\n\`

Make sure that you include all the punctuations and misc tokens. The system should be able to reconstruct the entire line of code by joining the tokens together.

some tokens are punctuations and do not have any extra info.
some tokens have a logical or syntactical meaning and should have an explanation.

for each line of code, include a thought provoking, critical thinking question that the student should think about. the question can be an all-encompassing question about the entire line. the why, the how... all in one question. it should be about logic, about problem-solving aspect, syntax, ... it should be about the most significant aspect of that line. and should make the student to critically think about that line.

Use the following JSON format:

{
    "lines": [
      {
        "code": "<exact code with indentation of that line>",
        "explanation": "<15-25 word explanation about this entire line>",
        "criticalThinkingQuestion": "<question that the student should think about>",
        "answer": "<answer to the question>",
        "tokens": [
          {
            "token": "<part of code>",
            "explanation": "<5-15 word explanation of that token>"
          },
          {
            "token": "<part of code>"
          },
          {
            "token": "<part of code>",
            "explanation": "<5-15 word explanation of that token>"
          },
          {
            "token": "<part of code>"
          }
        ]
      },
      {
        "code": "<exact code with indentation of that line>",
        "explanation": "<15-25 word explanation about this entire line>",
        "criticalThinkingQuestion": "<question that the student should think about>",
        "answer": "<answer to the question>",
        "tokens": [
          {
            "token": "<part of code>",
            "explanation": "<5-15 word explanation of that token>"
          },
          {
            "token": "<part of code>",
            "explanation": "<5-15 word explanation of that token>"
          },
          {
            "token": "<part of code>"
          },
          {
            "token": "<part of code>",
            "explanation": "<5-15 word explanation of that token>"
          }
        ]
      }
      ... (continue until the end of the code)
    ]
  }  

`,
```

### T2 user
`codex-writeover-router.ts` lines 92-92 (verbatim, Python as in repo)
```
            content: `[solution-code]: ${code}[end-solution-code]`,
```

### T3 Parsons system
`codex-parsons-router.ts` lines 20-20 (verbatim, Python as in repo)
```
                    "convert a given code snippet into a faded Parsons question code, incorporating a placeholder {input} for users to fill in. The faded part of the code should not contain ambiguous input. The {input} block should only accept one correct answer, ensuring a single valid solution. The number of faded part should be more than 1/2 of the total number of lines (only fade expressions/values/keywords, do not fade strings, for example inside a print statement) replace them with {input} holes. The code should be syntactically correct. If the code only contains 1 line, there should include at least 2 {input} holes if possible",
```

### T3 few-shot examples
`codex-parsons-router.ts` lines 22-105 (verbatim, Python as in repo)
```
            {
                role: "user",
                content: `sum_even = 0
                for i in range(1, 101):
                    if i % 2 == 0:
                        sum_even += i
                print(sum_even)`,
            },
            {
                role: "assistant",
                content: `sum_even = {input}
                for i in range(1, {input}):
                    if {input} % 2 == {input}:
                        sum_even {input} i
                print(sum_even)[end-code]`,
            },

            {
                role: "user",
                content: `number = int(int(input(“enter a number”)) / 2 ) + 1`,
            },
            {
                role: "assistant",
                content: `number = {input}(int(input(“enter a number”)) {input} 2 ) + {input}`,
            },

            {
                role: "user",
                content: `def factorial(n):  
                if n == 0:
                    return 1
                else:
                    return n * factorial(n-1)  
            number = 5  
            result = factorial(number) 
            print(f"The factorial of {number} is: {result}")`,
            },
            {
                role: "assistant",
                content: `def factorial(n):  
                if n == {input}:
                    return 1
                else:
                    return n * factorial(n-1)  
            number = 5  
            result = factorial(number) 
            print(f"The factorial of {number} is: {result}")[end-code]`,
            },

            {
                role: "user",
                content: `import random  
                random_number = random.randint(1, 10) 
                print("Random number between 1 and 10:", random_number)`,
            },
            {
                role: "assistant",
                content: `import random  
                random_number = random.randint(1, {input}) 
                print("Random number between 1 and 10:", random_number)[end-code]`,
            },

            {
                role: "user",
                content: `nums = [1, 2, 3]
                length = len(nums)
                i = 0
                while i + 1 < length:
                    nums.append(nums[i] + nums[i + 1])
                        i = i + 1
                print(nums[len(nums) - 1])`,
            },
            {
                role: "assistant",
                content: `nums = [1, 2, 3]
                length = len({input})
                i = 0
                while i + 1 < length:
                    nums.append(nums[i] + {input})
                    i = i + 1
                print({input}[len(nums) - 1])[end-code]`,
            },

        ];
```

### T3 user
`codex-parsons-router.ts` lines 110-110 (verbatim, Python as in repo)
```
            content: `${description}`,
```

### T4 generateIssue system
`codex-verify-router.ts` lines 37-55 (verbatim, Python as in repo)
```
`
Purposefully add some logical issues to the {code-solution} so that the noivce python programmers needs to fix it. Some potential logical issues to fix are: Incorrect Loop Conditions, Wrong Variable Assignments, Incorrect Function Arguments, Misuse of Data Structures, Incorrect Boolean Logic.  For each of the {code-solution} snippet, only generate 2 to 3 issues depends on the code length. The newly generated code should not involve any comments.  The code's line number starts from 1, empty lines should also be count as a line

#output in the below JSON format:

{
"wrong-code": {newly generated code based on the provided {code-solution} with logical issues}
"issues":{
            "logical-issue": {
                    "type": {3-4 words title for the issue type}
                    "line": {line number in the [wrong-code]}
            },
            "logical-issue": {
                    "type": {3-4 words title for the issue type}
                    "line": {line number in the [wrong-code]}
            }
        }
}
`,
```

### T4 user
`codex-verify-router.ts` lines 61-61 (verbatim, Python as in repo)
```
            content: `[solution-code]:${getCodeWithLine(code)}[end-solution-code]`,
```

### T4 hint L1
`codex-verify-router.ts` lines 116-134 (verbatim, Python as in repo)
```
`
by comparing [student-code] to [correct-solution], list all the lines of [student-code] that are incorrect and need to be fixed. Use the following JSON template:

{
    "fixes": [
        {
            "line": <number>,
            "issues": <10-15 word description>
        },
        {
            "line": <number>,
            "issues": <10-15 word description>
        },
        ...
    ]
}

if there are no issues, the list of fixes should become empty.
`,
```

### T4 hint L2
`codex-verify-router.ts` lines 180-206 (verbatim, Python as in repo)
```
`
by comparing [student-code] to [correct-solution], list all the lines of [student-code] that are incorrect and need to be fixed.

After describing the issues, ask a though provoking question to nudge the student towards thinking about what could potentially be wrong in that line.

Make sure that these questions are novice-friendly and easy to understand for a student learning to code. use a simple english.

Use the following JSON template:

{
    "fixes": [
        {
            "line": <number>,
            "issues": <detailed description>,
            "question": <thought provoking question for student>
        },
        {
            "line": <number>,
            "issues": <detailed description>,
            "question": <thought provoking question for student>
        },
        ...
    ]
}

if there are no issues, the list of fixes should become empty.
`,
```

### T4 hint L3
`codex-verify-router.ts` lines 252-278 (verbatim, Python as in repo)
```
`
by comparing [student-code] to [correct-solution], list all the lines of [student-code] that are incorrect and need to be fixed.

After describing the issues, provide a list of hints for that line and its issues to help the student fix that line.

Do not include any code in the hints. Just use natural language. The student should fix the code by themselves.

Use the following JSON template:

{
    "fixes": [
        {
            "line": <number>,
            "issues": <detailed description>,
            "hint": "<natural language hints to fix issues>"
        },
        {
            "line": <number>,
            "issues": <detailed description>,
            "hint": "<natural language hints to fix issues>"
        },
        ...
    ]
}

if there are no issues, the list of fixes should become empty.
`,
```

### T5 /generate system
`codex-pseudo-router.ts` lines 124-188 (verbatim, Python as in repo)
```
`You want to generate a pseudo-code for every single line.

based on the above provided [task-description], group the provided [code-solution] into multiple subgoals.
inside each subgoal, repeat the lines of code, and after each line, provide a 10-20 word reasoning and purpose about the purpose, functionality, logic, and some syntax details of that line of code. use backticks for \`keyword\`s.

You must include ALL lines of code into subgoals and provide a pseudo-code for all lines. Even for code lines that might not easily fit into a subgoal (like a function definition). 

The explanation should not simply repeat the pseudo-code, and instead describe the purpose and reasoning of that code, why is that line of code even needed, what is the logic behind it.

# Use the following template:
{
    "subgoals": [
        {
            "title": "<4-8 word subgoal title>",
            "code": [
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                },
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                }
            ]
        },
        {
            "title": "<4-8 word subgoal title>",
            "code": [
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                },
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                }
            ]
        },
        {
            "title": "<4-8 word subgoal title>",
            "code": [
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                },
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                }
            ]
        }
    ]
}`,
```

### T5 user
`codex-pseudo-router.ts` lines 194-194 (verbatim, Python as in repo)
```
            content: `[task-description]: ${description}\n[solution-code]:${getCodeWithLine(code)}[end-solution-code]`,
```

### T5 hintLevel1 system
`codex-pseudo-router.ts` lines 30-32 (verbatim, Python as in repo)
```
`You want to provide more detailed and syntax wise hints for a one line of code [oneLineCode] given solution code [code]. The ultimate goal for this one line syntax-wised hint is to help students learn python syntaxes given an [explaination] of the [oneLineCode]. 

The generated hint are expected to be concise with high weight on syntax representation of Python code, but it should not directly give students solution code. The hint should be more focused on syntax and logic representation of the code. The generated hint should be 1-2 lines long.`,
```

### T5 verifyCode system
`codex-pseudo-router.ts` lines 75-81 (verbatim, Python as in repo)
```
`
You want to verify a student's code given [task-description] and [solution-code]. You also have access to the student's code [student-code]. You need to verify if the student's code is correct or not by checking if there is any syntax error in python or if the main logic is correct. Minor logic or test case mismatches are fine, but the main logic should be correct, and there should not be any syntax error. 

the output format should be 1 or 0 only. 

return "1" if the student's code is correct, otherwise return "0".
`,
```

### T6 /generateQuestion system
`codex-selfexplain-router.ts` lines 81-122 (verbatim, Python as in repo)
```
`
you are helping novice programmers learn about coding.
look at the above Python [practice-code], group it into questions, the question can be either [multiple-choice] or [short-answer] inside each question, include the lines of code from the above [practice-code]. 

Use the following template:

The format should be an array of n items, where n is a number that can average the questions per 4-5 code lines. For example, a 10-line code snippet could have 2 questions, and 12-line code could have 3 questions, combinations of [multiple-choice]  and [short-answer].

example for <comma separated code line numbers based on solution-code> is [6] for the line 6, or [9,10] for line 9 and line 10.



# Template:
{
"format": <a list of format in combinations of "Short Answer" or "Multiple Choice" depends on the number of questions, in this example, I use ["Short Answer", "Multiple Choice"]>
"questions": [
  {
    "type": "Short Answer",
    "question": "<5-10 word question for the student to think about the \"problem solving aspects\" of the task>",
    "answer": "<10-15 word answer>",
    "question-code-lines": [
      "<comma separated code line numbers based on solution-code>"
    ],
    "question-code-lines-explained": "<exact lines of code> # <very concise explanation about the \"purpose\" and \"functionality\" of this code>"
  },
  {
    "type": "Multiple Choice",
    "question": "<5-10 word question for the student to think about the \"problem solving aspects\" of the task>",
    "answer": {
      "correct-choice": "<7-15 word correct answer>",
      "incorrect-choice-1": "<7-15 word plausible distractor>",
      "incorrect-choice-2": "<7-15 word plausible distractor>",
      "incorrect-choice-3": "<7-15 word plausible distractor>"
    },
    "question-code-lines": [
      "<comma separated code line numbers based on solution-code>"
    ],
    "question-code-lines-explained": "<exact lines of code> # <very concise explanation about the \"purpose\" and \"functionality\" of this code>"
  }
]
}
`,
```

### T6 user
`codex-selfexplain-router.ts` lines 129-129 (verbatim, Python as in repo)
```
            content: `[task-description]: ${task}\n[solution-code]: ${getCodeWithLine(code)}[end-solution-code]`,
```

### T6 /feedback system
`codex-selfexplain-router.ts` lines 28-39 (verbatim, Python as in repo)
```
`
You want to generate feedback for novice python programmers, based on the following input: takes in 5 values: a question (string), an code line (string), which provided the question context, an answer (string), which is the correct explanation and a response from the user (string). 
The question is an open-ended explanation of code snippets aimed at novice programmers. Your task is to generate a JSON output with the following structure:

# Use the following JSON template:
{
    "score": [a number between 0 and 5], 
    "feedback": "[10 to 15 words feedback]"
}

Design a system that can generate this JSON output based on the input values provided. The score should represent the quality or correctness of the response, ranging from 0 (poor) to 5 (excellent). The feedback should be a concise comment, consisting of 10 to 15 words, offering constructive feedback on the answer provided.
`,
```

### T6 feedback user
`codex-selfexplain-router.ts` lines 45-45 (verbatim, Python as in repo)
```
        content: `[code]: ${code}\n[line] ${line}\n[question] ${question}\n[answer] ${answer}\n[user-response]${response}`,
```

### T7 /generateQuestion system
`codex-reveal-router.ts` lines 28-139 (verbatim, Python as in repo)
```
                content: `
# Overview:
you are helping novice programmers learn about coding. Look at the provided Python [solution-code] and the [task-description], then divide the provided code into a list of [subgoal] items. For each [subgoal], provide a concise [title] and then divide it into [sub-subgoal-items]. The student has only be given the [task-description] and cannot see the [solution-code], instead you, the assistant that is helping this novice student learn about coding by asking a series of leading questions. These leading questions are multiple-choice question about each sub-subgoal parts of the task. These questions are supposed to promote critical thinking, problem solving, algorithmic thinking, and computational thinking, and help the student think about the task before they see the code. The student does not know about the [solution-code], they have only be given the [task-description. Our system shows the mcq-questions that you generate, one by one. If the student correctly answers the leading question, our system will reveal the code lines associated with that [sub-subgoal] and then the system displays the next question.

# Important Notes:
[sub-subgoal-items] can be one line of code, can be a function definition, can be the \`for item in items\` part of a loop, can be a return statement. Make sure that for more complicated sub-subgoals, there are multiple questions. Sometimes, a single line of code also deserves its own question, such as a for loop (asking questions about how many times we need to check, what items, what indices, from what index to what index), or the if statement (what different states can X be when Y, how can we make sure Z, etc.).

[code-lines-to-be-revealed]: a comma separated list of numbers that represent the lines of code from [solution-code] related to that [sub-subgoal-item].

[mcq-question]: the provided choices in the distractors [incorrect-choice] should be "plausible" but incorrect answers: these distractors are reasonable answers that might be selected if a student did not think deeply about the task, missed edge-cases and over-generalized, and did not think critically enough. These "plausible" choices should focus on conceptual misunderstandings, common mistakes that students might make, missing corner-cases and edge-cases, incorrect assumptions that students might make, off-by-one errors (such as looping one time too many, or too few), incorrect choice of data structures, overlooking the behavior of a program or algorithm for special or extreme values, and other logical errors. Each question will help the student to think deeply about "how" this task needs to be solved (focusing on the logic, on the important data representations, operations, etc.) ... the code for that subgoal will only be revealed if the student answers the question about that part correctly. Make sure that all lines of code from [solution-codes] are covered with the [sub-subgoals] and [mcq-questions], even misc lines, or purely syntactic lines like a function definition. For example, the function definition line (e.g. \`def function_name(input_val)\`) should also become a [subgoal] and the [mcq-question] can ask about the inputs, and how the input is represented, using what data types. For example: "what type best represents an interval?" The leading questions should make the student think about the logic, particularly the what, why, and how of actions.



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
`,
```

### T7 user
`codex-reveal-router.ts` lines 145-147 (verbatim, Python as in repo)
```
            content: `[task-description]: ${task}\n[solution-code]: ${getCodeWithLine(
                code
            )}[end-solution-code]\n\nFocus a lot of the questions on the complex part of the algorithm. For those parts, you can include one question per line, or even two questions per line.`,
```

### T7 short-answer feedback system
`codex-reveal-router.ts` lines 196-203 (verbatim, Python as in repo)
```
                    content: `I have been asked this [question] about the next part of the [not-revealed-code] that I haven't seen yet (so it's hidden to me). This is part of an exercise to help me think deeply about what this [not-revealed-code] is supposed to do and how it contributes to the [overall-code-solution]. Here is my [my-answer] to the [question]. Check if it makes sense based on the [overall-code-solution], [not-revealed-code], and the [sample-solution]
            
            Please return a JSON object with the following format:
            {
                "correctness": <0-5>, // if empty, jibberish, or completely wrong then 0. if partially correct and missing important details (like the value something needs to be set to, compared with, etc.) then 1 or 2 (based on how much is missing). If the answer is almost correct, but has a small mistake, then 3. If the answer is correct, but missing some details, then 4. If the answer is perfect, then 5.
                0 means wrong, 2 means partially correct (for example if the question is what should we use for X and what should we do with it, then if I only answer one part correctly, then I should receive 2). But then 5 means that I have answered perfectly with sufficient detail about [not-revealed-code].
                "feedback": "<20-30 word of explanation about what I got correctly and a small hint at what I am missing about the [not-revealed-code]>"
            }`,
```

### T7 feedback user
`codex-reveal-router.ts` lines 209-209 (verbatim, Python as in repo)
```
                content: `[question]: ${question}\n[my-answer]: ${studentSolution}\n\n[sample-solution]: ${aiGeneratedSolution}\n[not-revealed-code]: ${code}\n[overall-code-solution]: ${allCode}`,
```

### T8 /generateQuestion system (few-shot examples follow at 287-392)
`codex-tracing-router.ts` lines 285-285 (verbatim, Python as in repo)
```
                    "Given the code snippet in python, the goal for showing these code is for noive python programmer to understand the changes of variables when tracing the code.  By the given {excutionsteps} and {code},  generate a list of questions {step, variable} regarding the next value for tracing steps. for each question, generate the step number and trace step number. Only ask meaningful questions, for example, changes of object that will change value in each step. ask 2-3 questions per code snippet. Make sure do not include any questions involving the user input or random. ",
```

### T8 user
`codex-tracing-router.ts` lines 399-399 (verbatim, Python as in repo)
```
            content: `{excutionSteps}: ${context}\n{code}: ${code}`,
```

### T8 /generateFeedback system
`codex-tracing-router.ts` lines 437-459 (verbatim, Python as in repo)
```
                    `You are an AI assistant that helps users understand programming concepts. Below is the context for the variable at hand.\
                    Current Frame:\
                    This is the current state of the program just before the given code block is executed. It includes the values of all relevant variables.\
                    {currentFrame}\
                    Code Block to be executed:\
                    This is the code block that will be executed. It is a snippet that will modify or affect one or more variables. Pay attention to what this code is meant to do.\
                    {codeBlock}\
                    User Answer:\
                    This is the user's answer to what the value of the specified variable will be after the code block is executed. The user's answer is incorrect.\
                    {userAnswer}\
                    Correct Solution:\
                    This is the actual correct value of the specified variable after the code block is executed.\
                    {solution}\
                    Variable Name to Track:\
                    This is the name of the variable whose value is being tracked after the code block is executed.\
                    {variableName}\
                    Number of Incorrect Attempts:\
                    This is the number of times the user has given an incorrect answer to this question.\
                    {numberOfAttempts}\
                    Previous Responses:\
                    These are the responses of the user from previous attempts. You should consider these responses to provide better and more specific feedback.\
                    {previousResponses}\
                    Given this information and the number of attempts made by the user, provide <less than 20 words> feedback on why the userAnswer is incorrect and suggest how they can find the correct solution. The feedback should increase in engagement level according to the number of attempts, and should not focus too much on disparities in data types (e.g., string vs. integer).`,
```

### T8 /generateHint system
`codex-tracing-router.ts` lines 505-505 (verbatim, Python as in repo)
```
                    "Base on the given line of the {code}, the current status of {currentFrames}, the {currentFrames} are the correct value at this step, and {correct} is the correct value for {target} in this step. the user's prediction for the {target} frame is {answer} is wrong, give out one line of hints that help novice python program to answer correctly.   Only focus on the {target}, do not talk about other variables. The correct answer for {target} is {correct}. The hint should not contain the correct answer. Be sure to check the {answer}'s data type as well as the value, if the value is correct but data type is wrong, still show corrresponding hint.",
```

### T8 short-answer feedback system
`codex-tracing-router.ts` lines 599-605 (verbatim, Python as in repo)
```
                content: `The student has been given the provided [code] that certain lines in it have been highlighted. The student has been asked a [question] about these lines. And the student has answered [student-solution]. See if their answer makes sense based on the provided [code], you can also take a look at the AI-generated solution [ai-generated-solution]. The goal is to make sure the student is understanding these highlighted lines correctly and providing a good explanation to the [question]. There is no need for ther [student-solution] to be exactly the same as the [ai-generated-solution]. The student can be creative and provide a different but correct answer.
                
                Please return a JSON object with the following format:
                {
                    "correctness": <0-5>, // 0 means completely wrong, 5 means the student has answered perfectly with a lot of detail. 3 means the student scored in some relenvant points but missed some minor points.
                    "feedback": "<20-30 word of explanation about what the student got correctly and what they are missing in their answer.>"
                }`,
```

### T8 /checkmatch system
`codex-tracing-router.ts` lines 649-656 (verbatim, Python as in repo)
```
                content: `check if [user-entered-value] matches [expected-value]. do not be strict about quotations, but be strict about values (numbers, and the string contains).
                For example:
                ( or “(” or ‘(’ all match with ‘(’ or “(”  (so if the characters are the same, they match … ignore the quotations)
                but if the characters do not match like [ and } or ( and ] then match should be false.
                return a JSON with the following format:
                {
                    “match”: <true / false>
                }`,
```

### T8 /linesToRewrite system
`codex-tracing-router.ts` lines 20-20 (verbatim, Python as in repo)
```
                    "given the below instructions, check if the code need to be rewritten for the given user's goal {prompt},  write out the correct implementation of the python code for novice Python learners The format of the print out should be one of the following structures: {old}{new}{old}, {old1}{new}, or {new}{old}, or {new}. No exceptions, there can only be one {new} block. {old} are the part of the logic and code that is correct and do not need to be changed, {new} are the code that are newly generated or fixed. If the {context} are wrong, the fix of the {new} code should still follow the context's logic. The {new} code should be a whole excutable code.",
```
