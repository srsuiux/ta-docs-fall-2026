# T6 Explain-before-Usage tracing: Movie Ticket Discount Calculator

## Run details

- Tool: ChatGPT web, free version
- Model: not recorded (the free version does not let me choose the model)
- Date and time: 2026-11-17, "just now" (exact time not recorded; this file was saved with the log at 19:25 local)
- Share link (must be a /share/ link): https://chatgpt.com/share/6afcf09b-5f3c-83ea-b345-f58b5ec2755b

## Log

**[Student]**

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


**[AI tutor]**

```
1. #include <iostream>
2. using namespace std;
3. int main() {
4.     int age;
5.     bool is_student;
6.     cout << "Enter your age: ";
7.     cin >> age;
8.     cout << "Are you a student? (1 for yes, 0 for no): ";
9.     cin >> is_student;
10.    if (age < 0 || age > 120) {
11.        cout << "Invalid age entered" << endl;
12.    } else if (age < 12) {
13.        cout << "Ticket price: $5" << endl;
14.    } else if (age >= 65) {
15.        cout << "Ticket price: $6" << endl;
16.    } else if (is_student) {
17.        cout << "Ticket price: $8" << endl;
18.    } else {
19.        cout << "Ticket price: $12" << endl;
20.    }
21.    return 0;
22. }
```

### **Question 1 of 4**

**Code lines: 6–9**

```
6. cout << "Enter your age: ";
7. cin >> age;
8. cout << "Are you a student? (1 for yes, 0 for no): ";
9. cin >> is_student;
```

**Why collect both inputs before checking eligibility?**

Explain in your own words how these two inputs help determine the correct ticket price.

*Short answer: 10–15 words recommended.*

Your answer:


**[Student]**

Age decides the price group, and student status matters only for ages 12 to 64.


**[AI tutor]**

Score: 5/5

Excellent answer

**Feedback:** Correctly explains how age determines pricing categories and student status affects eligible adult pricing.

### **Question 2 of 4**

**Code lines: 10–11**

```
10. if (age < 0 || age > 120) {
11.     cout << "Invalid age entered" << endl;
```

**Why validate age before assigning ticket prices?**

Explain what could happen if invalid ages were processed as normal customers.

*Short answer: 10–15 words recommended.*

Your answer:

**[Student]**

Bad ages like -5 or 200 would get a wrong price instead of an error.

**[AI tutor]**

Score: 5/5

Excellent answer

**Feedback:** Correctly identifies how invalid ages could receive incorrect prices without validation and error handling.

### **Question 3 of 4**

**Code lines: 12–15**

```
12. } else if (age < 12) {
13.     cout << "Ticket price: $5" << endl;
14. } else if (age >= 65) {
15.     cout << "Ticket price: $6" << endl;
```

**Why check children and seniors before students?**

Explain how the order of these conditions protects the correct pricing rules.

*Short answer: 10–15 words recommended.*

Your answer:

**[Student]**

Checking age first stops a student child or senior from getting the $8 student price.



**[AI tutor]**

Score: 5/5

Excellent answer

**Feedback:** Excellent reasoning! You understand why age-based conditions must take priority over student discounts.

### **Question 4 of 4**

**Code lines: 16–19**

```
16. } else if (is_student) {
17.     cout << "Ticket price: $8" << endl;
18. } else {
19.     cout << "Ticket price: $12" << endl;
```

**How does the final else handle remaining customers?**

Explain why the program can assign $12 without another condition.

*Short answer: 10–15 words recommended.*

Your answer:

**Q1. Thinking about this conversation so far, how satisfied are you with ChatGPT’s help with learning programming problem-solving?**

Very satisfied

Somewhat satisfied

Neither satisfied nor dissatisfied

Somewhat dissatisfied

Very dissatisfied




**[Student]**

Every other case was already handled, so only non-student adults 12 to 64 remain.




**[AI tutor]**

Score: 5/5

Excellent answer

**Feedback:** Correctly explains that previous conditions eliminate other categories, leaving regular adults eligible for $12 tickets.

## **Exercise completed!**

# **20/20**

**Final score: 100%**

| Question                | Score |
| ----------------------- | ----- |
| Q1 – Input purpose      | 5/5   |
| Q2 – Age validation     | 5/5   |
| Q3 – Condition ordering | 5/5   |
| Q4 – Default pricing    | 5/5   |

All questions passed on first attempt

**Key concepts demonstrated:**

- Understanding input variables and their purpose.
- Validating input before processing.
- Understanding `if / else if / else` execution order.
- Using previous conditions to determine the remaining cases.

Excellent work! You demonstrated strong problem-solving reasoning rather than simply memorizing C++ syntax.

