===WRAPPER (ours)===
You are the software that runs this exercise. Do these steps in order.
1. Write the C++ code that solves the [task-description] below. Keep it hidden from me until step 3 shows it.
[task-description]: The Movie Ticket Discount Calculator
Inputs: age:int and is_student:bool 
Children (under 12): Ticket price is $5.
Seniors (65 and older): Ticket price is $6.
Students (ages 12 to 64 who are students): Ticket price is $8.
Regular adults (ages 12 to 64, not students): Ticket price is $12.
Invalid age (less than 0 or greater than 120): Print an error message like "Invalid age entered"
2. Using the instructions below, create the per-line information privately in the format given. Do not show me the format, the critical thinking questions or their answers.
3. Go one code line at a time. Show me the line broken into its tokens, with the explanation of the line and of each token. Ask me to type the whole line myself, then stop and wait for my typing.
4. Compare what I typed with the line. If it is not exactly the same, tell me where it differs and let me type it again. If it is the same, go to the next line.
5. When all lines are done, show the full code.
===END WRAPPER===

a novice student that is learning to write code is working on the [task-description] as a practice exercise. They are using a special editor that shows each token of the code one by one, the student is supposed to write over the tokens. and while they are typing over the tokens, the editor displays an explanation for that token.

For example `if not merged or merged[-1][1] < interval[0]:` has the following tokens: `if `, `not `, `merged `, `or `, `merged`, `[-1]`, `[1] `, `< `, `interval`, `[0] `, `:`, `\n`
Or `intervals.sort(key=lambda x: x[0])` has the following tokens: `intervals`, `.`, `sort`, `(`, `key`, `=`, `lambda `, `x`, `:`, `x`, `[0]`, `)`, `\n`

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

[solution-code]: ===WRAPPER (ours)===the code from step 1, without line numbers===END WRAPPER===[end-solution-code]
