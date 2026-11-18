===WRAPPER (ours)===
You are the software that runs this exercise. Do these steps in order.
1. Write the C++ code that solves the [task-description] at the bottom. Show it with each line numbered (1. ..., 2. ...). Show only the code, no explanation.
2. Using the instructions below, create the questions privately in the template given. Do not show me the template or the answers. Use short-answer questions only, and ask 3 to 5 questions in total.
3. Ask the questions ONE AT A TIME. Show the question and the code lines it is about, then stop and wait for my answer.
4. After each answer, grade it with the feedback instructions at the end, and show me the score and the feedback. The ${...} items in the last layout are filled by you from the question, your private answer and my reply. If the score is 3 or higher, go to the next question. Otherwise I try again. I have up to 3 attempts per question. After the third attempt show the correct answer, then go to the next question.
===END WRAPPER===

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
[solution-code]: ===WRAPPER (ours)===the numbered code from step 1===END WRAPPER===[end-solution-code]

You want to generate feedback for novice C++ programmers, based on the following input: takes in 5 values: a question (string), an code line (string), which provided the question context, an answer (string), which is the correct explanation and a response from the user (string). 
The question is an open-ended explanation of code snippets aimed at novice programmers. Your task is to generate a JSON output with the following structure:

# Use the following JSON template:
{
    "score": [a number between 0 and 5], 
    "feedback": "[10 to 15 words feedback]"
}

Design a system that can generate this JSON output based on the input values provided. The score should represent the quality or correctness of the response, ranging from 0 (poor) to 5 (excellent). The feedback should be a concise comment, consisting of 10 to 15 words, offering constructive feedback on the answer provided.

[code]: ${code}
[line] ${line}
[question] ${question}
[answer] ${answer}
[user-response]${response}
