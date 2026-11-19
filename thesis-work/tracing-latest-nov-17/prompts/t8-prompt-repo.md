===WRAPPER (ours)===
You are the software that runs this exercise. Do these steps in order.
1. Write the C++ code that solves the [task-description] below. Show it to me with each line numbered (1. ..., 2. ...).
[task-description]: The Movie Ticket Discount Calculator
Inputs: age:int and is_student:bool 
Children (under 12): Ticket price is $5.
Seniors (65 and older): Ticket price is $6.
Students (ages 12 to 64 who are students): Ticket price is $8.
Regular adults (ages 12 to 64, not students): Ticket price is $12.
Invalid age (less than 0 or greater than 120): Print an error message like "Invalid age entered"
2. Pick one sample input. Privately work out {excutionSteps} for it, in the same JSON form as the examples below. Do not show me the steps.
3. Using the first instruction below, create the 2 to 3 {step, variable} questions privately.
4. Ask me one question at a time. Tell me the line of that step and the values of the variables before it runs, and ask what the value of the variable will be after it runs. Then stop and wait for my answer.
5. If my answer is wrong, give me feedback using the feedback instruction and the hint instruction below, and let me try again. I have up to 3 attempts per question. After the third wrong attempt show the correct value, then go to the next question.
6. When all questions are done, show me the full code.
===END WRAPPER===

Given the code snippet in C++, the goal for showing these code is for noive C++ programmer to understand the changes of variables when tracing the code.  By the given {excutionsteps} and {code},  generate a list of questions {step, variable} regarding the next value for tracing steps. for each question, generate the step number and trace step number. Only ask meaningful questions, for example, changes of object that will change value in each step. ask 2-3 questions per code snippet. Make sure do not include any questions involving the user input or random. 


## Decisions the AI made

The code: a nested if/else, price starting at 0, cin for the inputs, and the output text.
The sample input: age = 30, is_student = true, which leads to the student branch.
Which steps to ask about: line 7 and line 23, both on price. It skipped the if conditions and the cin lines.
How many questions: 2, one at a time.
What to show before each question: the line of code, plus the current values of age, is_student and price.
Hints: a short “Think about...” sentence under each question, given before the student answered. The wrapper meant hints for wrong answers, so this was extra.
Skipping the condition check: for Q2 it said “assume the program has reached line 23”, so the student never had to work out which branch runs.
Feedback: “Correct!” plus a one-line reason.
Wrap-up: the full code and a “learning takeaway” paragraph.
A wrong claim: it said price was uninitialized before line 7, and listed age and is_student as already set, even though they come from cin later.

## Decisions the student made (only these, and they were small)

Answered Q1 with 0 and Q2 with 8.
Accepted each question as asked. No hint was needed, no retry, no pushing back.
Answered by reading the line itself (= 0, = 8) rather than working out the conditions above it.
Moved on right after each “Correct!”


Link: https://chatgpt.com/share/6aff40a4-ab64-83ea-98b3-e3364b49186f