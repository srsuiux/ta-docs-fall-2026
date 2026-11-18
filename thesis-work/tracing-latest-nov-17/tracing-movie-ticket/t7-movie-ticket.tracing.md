# T7 Lead-and-Reveal tracing: Movie Ticket Discount Calculator

## Run details

- Tool: ChatGPT web, free version
- Model: not recorded (the free version does not let me choose the model)
- Date and time: 2026-11-17, "just now" (exact time not recorded)
- Share link (must be a /share/ link): https://chatgpt.com/share/6afcf36d-7e0c-83ea-a443-06127c58688a

## Log

**[Student]**

===WRAPPER (ours)===
You are the software that runs this exercise. Do these steps in order.
1. Write the C++ solution code for the [task-description] at the bottom yourself, with each line numbered (1. ..., 2. ...). Keep it hidden from me.
2. Using the instructions below, create the subgoals and multiple-choice questions privately in the template given. Do not show me the template, the correct choices or the code.
3. Show me ONE question at a time with its four choices (the correct choice and the three distractors), labelled A to D. Put the correct choice at a random position among A to D, not always the same letter. Then stop and wait for my pick.
4. If I pick the correct choice, reveal the code lines for that sub-subgoal with an explanation of how my answer and that line contribute to the overall solution, then show the next question. If I pick a wrong choice, tell me it is not correct and let me pick again. I have up to 3 retries per question. After the 3 retries are used, show the correct choice and its explanation, reveal the code lines, then show the next question. Do not give scores.
5. When all questions are done, show the full code.
===END WRAPPER===

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
[solution-code]: ===WRAPPER (ours)===the numbered code from step 1===END WRAPPER===[end-solution-code]

Focus a lot of the questions on the complex part of the algorithm. For those parts, you can include one question per line, or even two questions per line.


**[AI tutor]**

**Question 1: Handling Invalid Ages**

Why should the program validate the age before calculating the ticket price?

**A.** To ensure every customer receives a ticket price before checking their age.

**B.** To prevent invalid ages from incorrectly receiving one of the available ticket prices.

**C.** To make sure student customers are processed before children and seniors.

**D.** To restrict ticket discounts to customers whose ages exceed eighteen.

Choose A, B, C, or D.


**[Student]**

B

**[AI tutor]**

Correct!

Exactly! Validating age first prevents invalid inputs, such as `-5` or `200`, from incorrectly receiving a ticket price.

**Code revealed — Input validation:**

```
1. #include <iostream>
2. using namespace std;
3. int main() {
4.     int age;
5.     bool is_student;
6.     cin >> age >> is_student;
7.     if (age < 0 || age > 120) {
8.         cout << "Invalid age entered";
9.     }
```

**Why this works:**

- `age < 0` catches negative ages.
- `age > 120` catches ages above the allowed limit.
- `||` means either condition being true makes the age invalid.
- Invalid ages are handled before ticket pricing.

**Question 2: Prioritizing Children**

Why must children be checked before the student discount?

**A.** Because children who are students should receive the $8 student price.

**B.** Because every child must receive the regular adult price regardless of age.

**C.** Because children under 12 must receive $5 regardless of student status.

**D.** Because student discounts should always be calculated before age-based discounts.

Choose A, B, C, or D.


**[Student]**

A


**[AI tutor]**

Not quite!

Think about the priority of the pricing rules.

A child who is also a student is still under 12. Should student status override the child discount?

Try again!

**A.** Children who are students should receive the $8 student price.

**B.** Every child must receive the regular adult price regardless of age.

**C.** Children under 12 must receive $5 regardless of student status.

**D.** Student discounts should always be calculated before age-based discounts.

Choose A, B, C, or D.


**[Student]**

C

**[AI tutor]**

Correct!

Exactly! Children under 12 always receive the $5 ticket price, regardless of whether they are students.

**Code revealed — Child pricing:**

```
10.     else if (age < 12) {
11.         cout << "Ticket price: $5";
12.     }
```

**Why this works:**

- `else if` checks the child condition only after invalid ages have been handled.
- `age < 12` includes ages 0 through 11.
- Student status does not override the child pricing rule.

**Question 3: Identifying Senior Customers**

Why should seniors be checked before applying student discounts?

**A.** Students aged 65 or older should receive the $8 discount.

**B.** Seniors must receive $6, even when they have student status.

**C.** Seniors should receive $12 because they no longer qualify for student discounts.

**D.** Only customers older than 65 should qualify for senior pricing.

Choose A, B, C, or D.

**[Student]**

B


**[AI tutor]**

Correct!

Exactly! Senior pricing takes priority over student pricing. Even if someone aged 70 is a student, they must receive the $6 senior ticket price.

**Code revealed — Senior pricing:**

```
13.     else if (age >= 65) {
14.         cout << "Ticket price: $6";
15.     }
```

**Why this works:**

- `age >= 65` includes everyone aged 65 and older.
- Checking this before student pricing ensures senior eligibility takes priority.
- Age 65 itself qualifies; using `age > 65` would incorrectly exclude them.

**Question 4: Applying Student Discounts**

After children and seniors are handled, who qualifies for the $8 student price?

**A.** Every student qualifies, regardless of age or previous pricing categories.

**B.** Only students younger than 12 qualify for the discounted price.

**C.** Students aged 12 through 64 qualify for the discounted price.

**D.** Students older than 64 qualify if they provide student status.

Choose A, B, C, or D.

**[Student]**

A

**[AI tutor]**

Not quite!

Think about the pricing rules we already handled.

- Children under 12 receive $5.
- Seniors aged 65 and older receive $6.
- What age group remains eligible for the student discount?

Try again!

**A.** Every student qualifies, regardless of age or previous pricing categories.

**B.** Only students younger than 12 qualify for the discounted price.

**C.** Students aged 12 through 64 qualify for the discounted price.

**D.** Students older than 64 qualify if they provide student status.

Choose A, B, C, or D.

**[Student]**

C


**[AI tutor]**

Correct!

Exactly! Students aged 12 through 64 qualify for the $8 ticket price. Children and seniors have already been handled by the earlier conditions.

**Code revealed — Student pricing:**

```
16.     else if (is_student) {
17.         cout << "Ticket price: $8";
18.     }
```

**Why this works:**

- The previous conditions have already excluded children and seniors.
- `is_student` checks whether the remaining customer is a student.
- Only eligible students reach this branch.

**Question 5: Handling Regular Adults**

Why can the final `else` handle regular adult pricing without another age check?

**A.** Every customer reaching this branch must be a student between 12 and 64.

**B.** The final branch handles everyone, including invalid ages and children.

**C.** Previous conditions exclude invalid ages, children, seniors, and students.

**D.** Regular adults are identified by checking whether their age exceeds 18.

Choose A, B, C, or D.


**[Student]**

C



**[AI tutor]**

Correct!

Exactly! This is the key idea behind sequential decision-making in an `if / else if / else` structure.

By the time execution reaches the final `else`:

1. Invalid ages have been rejected.
2. Children under 12 have received the $5 price.
3. Seniors aged 65 and older have received the $6 price.
4. Students have received the $8 price.

Therefore, only regular adults aged 12–64 who are not students remain.

**Code revealed — Regular adult pricing:**

```
19.     else {
20.         cout << "Ticket price: $12";
21.     }
22.     return 0;
23. }
```

**Why this works:**

- `else` handles every remaining case.
- No additional condition is necessary because previous branches have already handled the other possibilities.
- `return 0` indicates that the program has completed successfully.

## **Final complete solution**

```
#include <iostream>
using namespace std;

int main() {
    int age;
    bool is_student;
    cin >> age >> is_student;

    if (age < 0 || age > 120) {
        cout << "Invalid age entered";
    }
    else if (age < 12) {
        cout << "Ticket price: $5";
    }
    else if (age >= 65) {
        cout << "Ticket price: $6";
    }
    else if (is_student) {
        cout << "Ticket price: $8";
    }
    else {
        cout << "Ticket price: $12";
    }

    return 0;
}
```

Exercise completed

You successfully worked through all five questions, including the important concepts of condition priority, boundary values, and sequential decision-making.




