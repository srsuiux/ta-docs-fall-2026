## T6. Explain-before-Usage ( Understand | Interactive | Reveal & Engage )

This technique is motivated by prior work on self-explanation,
where learners were encouraged to explain the code. Researchers
found that this can be a successful intervention, increasing engagement with worked examples [110], and that the ability to explain
code has a significant relationship with the ability to write code
[77, 83, 109].
In this technique, after the AI generates the code, it is immediately displayed to the user. Immediately afterwards, an important
part of the code (determined by a second LLM prompt) is then
highlighted, followed by a short-answer question for the user to
answer. The user’s response is then evaluated via another LLM
prompt with feedback and a score from 0 to 5, based on accuracy
and completeness. The user has up to 3 attempts for each question,
with the correct answer automatically shown after the third try. A
total of 3-5 questions are asked from various parts of the generated
code, depending on the code’s complexity, after which the user can
proceed to using the code in the editor.
This technique also reaches the "Understand" level as it engages
users to interpret, explain, and infer meaning from existing code,
without moving towards higher cognitive processes. However, it
does this interactively, as users interact with AI to answer and
receive feedback on their explanations.


https://chatgpt.com/c/6af509cf-4e3c-83e9-b525-28d0c6d673a3


## Prompt


## Student

Generate the C++ code that solves the [task-description] below. Show it with each line numbered (1. ..., 2. ...). Show only the code, no explanation.

you are helping novice programmers learn about coding.
look at the above C++ [practice-code], group it into questions, the question can be either [multiple-choice] or [short-answer] inside each question, include the lines of code from the above [practice-code].

The number of questions n should be a number that can average the questions per 4-5 code lines. For example, a 10-line code snippet could have 2 questions, and 12-line code could have 3 questions.

Each question is a 5-10 word question for the student to think about the "problem solving aspects" of the task, and points to the code lines it is about. Each question has a 10-15 word answer that you keep to yourself.

Session rules:
- Use short-answer questions only. Ask 3 to 5 questions in total, from various parts of the code.
- Ask the questions ONE AT A TIME. Show the question and the code lines it is about, then stop and wait for my answer. Do not show the answer before I reply.
- Give feedback for novice C++ programmers on my answer. The score should represent the quality or correctness of my response, ranging from 0 (poor) to 5 (excellent). The feedback should be a concise comment, consisting of 10 to 15 words, offering constructive feedback on the answer provided. Reply in the form: Score: X/5. Feedback: ...
- I have up to 3 attempts for each question. After the third attempt, show the correct answer, then ask the next question.

[task-description]: The Movie Ticket Discount Calculator
Inputs: age:int and is_student:bool
Children (under 12): Ticket price is $5.
Seniors (65 and older): Ticket price is $6.
Students (ages 12 to 64 who are students): Ticket price is $8.
Regular adults (ages 12 to 64, not students): Ticket price is $12.
Invalid age (less than 0 or greater than 120): Print an error message like "Invalid age entered"


## Gpt Web Tutor

### C++ Practice Code

```
1.  #include <iostream>
2.  using namespace std;
3.  int main() {
4.      int age;
5.      bool is_student;
6.      cout << "Enter your age: ";
7.      cin >> age;
8.      cout << "Are you a student? (1 for yes, 0 for no): ";
9.      cin >> is_student;
10.     if (age < 0 || age > 120) {
11.         cout << "Invalid age entered" << endl;
12.     }
13.     else if (age < 12) {
14.         cout << "Ticket price: $5" << endl;
15.     }
16.     else if (age >= 65) {
17.         cout << "Ticket price: $6" << endl;
18.     }
19.     else if (is_student) {
20.         cout << "Ticket price: $8" << endl;
21.     }
22.     else {
23.         cout << "Ticket price: $12" << endl;
24.     }
25.     return 0;
26. }
```

### Question 1 of 4



Short answer

Lines 4–9


Why are both inputs needed before choosing a ticket price?

Think about what information determines the correct pricing category.

Write your answer in your own words.

## Student

to make sure the tickets is given only to student and follow the fair pricing

## Gpt Web Tutor

Score: 3/5.

Feedback: Good thinking about fair pricing. Also explain that age determines the age category, while student status identifies student discounts.

### Question 2 of 4



Short answer

Lines 10–12



Why must invalid ages be checked before pricing categories?

Think about what could happen if an invalid age reaches the pricing conditions.

## Student

to make sure the tickets is given only to student and follow the fair pricing

## Gpt Web Tutor

Score: 3/5.

Feedback: Good thinking about fair pricing. Also explain that age determines the age category, while student status identifies student discounts.

### Question 2 of 4


Short answer

Lines 10–12



Why must invalid ages be checked before pricing categories?

Think about what could happen if an invalid age reaches the pricing conditions.



## Student

so we process the valid ones.



## Gpt Web Tutor

Score: 4/5.

Feedback: Correct! Checking invalid ages first ensures only valid ages proceed through the ticket pricing decisions.

### Question 3 of 4


Short answer

Lines 13–18


Why are children and seniors checked as separate conditions?

Think about how their ticket prices differ from regular adults.


## Student

as they have different pricing


## Gpt Web Tutor

Score: 4/5.

Feedback: Correct! Children and seniors receive different discounted prices based on their age groups.

Question 4 of 4


Short answer

Lines 19–24


How does the program decide between student and regular pricing?

Think about what happens when `is_student` is true or false.


# Student

if the `is_student` is ture, the pricing is 8$ if false, if not kid or a senior the priocing is 12$.


## Gpt Web Tutor

Score: 5/5.

Feedback: Excellent! You correctly explained how student status determines the $8 discount versus the $12 regular price.

Session completed

### Final Results

| Question                  | Score |
| ------------------------- | ----- |
| 1. Input purpose          | 3/5   |
| 2. Invalid age validation | 4/5   |
| 3. Age-based pricing      | 4/5   |
| 4. Student pricing        | 5/5   |
| Total                     | 16/20 |

# 80%

Overall feedback: You understand the main problem-solving logic: collecting inputs, validating data, separating age categories, and applying conditional pricing. Continue practicing how multiple conditions work together in `if-else` structures.




# Observations from the t6 interactions.

What the AI decided, before the student did anything

- Here in the whole solution. The student never saw a initial state of the code or the template or so, and Given the eintire code in the first response. The AI chose the inputs and how they are read (cin>>, bool values which we type as 1 or 0).

- The order of the interactions after the code is reveled,  It put the invalid age check first, then child, then senior, then student, then regular. Here, that the order is the main conditonal logic, and it was decided for the student.
- For the boundries. The ai chose age < 12 and age >= 65, and treated 0 and 120 as valid. The student here never decided where the validations fails. 
- In terms of the code structure. the tutor in our case chose one if / else-if chain over separate ifs or nested ifs.  and the alternative ways to approach the problems were not shown to the student either via the code or via the interacitons happening after the code shown foloowups. 
- The AI tutor made 4 questions on lines 4-9, 10-12, 13-18 and 19-24 in the form of interacitons and it skipped lines 1-3, which is the headers inpout and th starting of the code main code entry points and 25-26(return 0, why it returns 0 and all). It asked nothing about the boundary values (11/12, 64/65, 0, 120) or why seniors are checked before students.

- In the Question type, AI tutor  picked “why” questions about code that was already written and it did not asked any questons regarding the extra edge cases and all. it did added and extras nobody asked for. Gpt AI tutor added “Think about...” hints, Question X of 4 headers, a final score table, a 16/20 total and an overall feedback paragraph. The prompt only asked for a score and feedback per answer.


# What the student made or was forced to make

- Gpt tutor here made no solution decisions, No input choice, no check order, no boundaries and no messages.
  Only one task: explain finished code. Four one-line answers defending decisions the AI had already made.
- Not forced to think. Each hint points straight at the answer. Q3 and Q4 answers repeat the hint almost word for word, and Q2’s answer is a restatement of the question.
- Not forced to fix anything. Even after 3/5, there was no retry. The feedback gave the missing part directly (“Also explain that   age determines the category), so the student could move on without working on the loosed points here.

- The answer leaks right away. The prompt said the student gets up to 3 attempts, and the correct answer is shown only after the     third try. That matches the paper’s T6 design. The tutor ignored that and put the answer into the first feedback. 

- The Scores look given is very generous. When i anaswered the question 3/4 “As they have different pricing” got 4/5 and “Correct!”, without saying how the prices differ or why the order matters.

- The overal feedback credits things given the studet has never said, it says the student understands the validating data and seperaing the age categories, and the student only wrote about the fair pricing, and valid ages and different pricings. 


- overall the interactions made me think in terms of answering the questions rather than solving the acutal problem, mapping into the pseudo code or converting into a code. maybe the engagement technique is all about the prompting, and it could have exposes the code and line by line instead and then then answring, but those are depending on the prompt structure. 

- Here one more thing I noticed was the understanding of the problem. So the AI assumed the student have understood the problem, and I think for this T6 interaction, yes, it actually assumes that student have understand the problem, and then it didn't even ask to the student about the problem understanding and the try to cover the basics. And if I fail to answer some of the questions, it gives me the basic feedback and then expose the answers directly. And it doesn't even try to it doesn't give us the hints, or we can retry and we can get the score more or so. But it's actually, I think it's more of a prompt structure how we have designed, and the same technique the T6 follows. I think this is more of the prompt fixing, and basically a design fixes for the T6. As we are trying to replicate this, I'm pretty sure it doesn't make sense here to point out the design is wrong, because we're trying to replicate the thing in here.



## So in the presepective of our study how this all interaciotns will go let's analyxze.

Understanding the problem: here the AI modeled the inputs and outputs.
Algorithm: the AI chose the check order.
Implementation: the AI wrote the C++ code
Testing and edge cases: nobody did it. No boundary values were ever tried, by the AI or the student.
The student’s only part: justifying the AI’s decisions afterward.

raw:And also in terms of the, let's look this from the perspective of our study, how this interaction will go. And first, the understanding the problem. The AI has actually never prompted the users to the student for the clarification and so on. It's more of a design thing, as I already stated in the feedback section. And the AI actually model all the inputs and outputs. And let's think about the algorithm. AI chooses to check the order, and it exposed the order decision control to the student. And the implementation, AI wrote the whole C++ code, and testing and regarding the edge cases, nobody actually did it. No boundary values over tried, and the AI or the student. And the student's only part actually is to define the answers based on the questioning the student. The AI has been asked, and we are basically trying to defend our answers, and then there is no involvement of basically decision controls and thinking. I think the decision control make a little bit of a override here.


---

## Experiment Summary (T6 Explain-before-Usage)

**Task:** Movie Ticket Discount Calculator (C++).
**Technique:** T6 Explain-before-Usage. The AI shows the full code first, then asks short-answer questions about parts of it. The student gets a score from 0 to 5 and feedback, with up to 3 attempts per question.

**What happened:**
- The AI showed the full numbered code (26 lines) in the first response.
- It then asked 4 questions: lines 4-9, 10-12, 13-18, and 19-24.
- Scores were 3/5, 4/5, 4/5, and 5/5, for a total of 16/20 (80%).
- The student gave a one-line answer to each question and never retried. The student could move on after every answer.

## Observations (cleaned)

**What the AI decided before the student did anything**
- The student never saw an initial state of the code or a template. The whole solution came in the first response.
- The AI chose the inputs and how they are read (`cin >>`, and a bool typed as 1 or 0).
- The AI chose the order of the checks: invalid age first, then child, senior, student, and regular adult. This order is the main conditional logic, and it was decided for the student.
- The AI chose the boundaries `age < 12` and `age >= 65`, and treated 0 and 120 as valid. The student never decided where the validation fails.
- The AI chose one `if / else-if` chain instead of separate ifs or nested ifs. The student was not shown the alternatives, either in the code or in the follow-up questions.
- The 4 questions skipped lines 1-3 (the header and the start of `main`) and lines 25-26 (`return 0`). The AI asked nothing about the boundary values (11/12, 64/65, 0, 120) or why seniors are checked before students.
- The AI asked "why" questions about code that was already written. It did not ask about extra edge cases.
- GPT added extras that nobody asked for: "Think about..." hints, "Question X of 4" headers, a final score table, a 16/20 total, and an overall feedback paragraph. The prompt only asked for a score and feedback per answer.

**What the student made or was forced to make**
- The tutor made no solution decisions for the student to make: no input choice, no check order, no boundaries, and no messages. The only task was to explain finished code. The four one-line answers defended decisions the AI had already made.
- The student was not forced to think. Each hint points straight at the answer. The answers to Q3 and Q4 repeat the hint almost word for word, and the answer to Q2 restates the question.
- The student was not forced to fix anything. Even after 3/5, there was no retry. The feedback gave the missing part directly ("Also explain that age determines the age category..."), so the student could move on without working on the missing points.
- The answer leaked right away. The prompt said the student gets up to 3 attempts and the correct answer is shown only after the third try. That matches the paper's T6 design. The tutor ignored it and put the answer in the first feedback.
- The scores were very generous. "As they have different pricing" for Q3 got 4/5 and "Correct!", without saying how the prices differ or why the order matters.
- The overall feedback credits things the student never said. It says the student understands validating data and separating age categories. The student only wrote about fair pricing, valid ages, and different pricing.
- Overall, the interaction made me think about answering the questions, not about solving the actual problem, mapping it to pseudocode, or turning it into code. The engagement technique may be mostly about the prompt. The AI could have shown the code line by line and asked questions after each part, but that depends on the prompt structure.
- The AI assumed the student had understood the problem. It never asked about the problem or tried to cover the basics. When I fail a question, it gives basic feedback and then shows the answer directly. It gives no hints and no retry to improve the score. I think this is a prompt-structure issue and a design issue of T6. Since we are replicating T6, it doesn't make sense to say the design is wrong.

## Study perspective (decision stages)

- **Understanding the problem:** The AI modeled the inputs and outputs. It never asked the student for clarification.
- **Algorithm:** The AI chose the check order. The order decision was not given to the student.
- **Implementation:** The AI wrote the whole C++ code.
- **Testing and edge cases:** Nobody did it. No boundary values were tried, by the AI or the student.
- **The student's only part:** Justifying the AI's decisions afterward. There was no real decision control for the student here, and decision control was largely overridden by the AI.
