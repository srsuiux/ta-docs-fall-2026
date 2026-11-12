
## T7. Lead-and-Reveal ( Create | Interactive | Engage & Reveal)
This technique draws inspiration from CS Unplugged activities
[6], which teach core concepts without any coding, and have been
shown to improve computational thinking skills [9]. We integrate
this with scaffolded self-explanation using Socratic questioning,
which has proven to enhance coding comprehension [105].
After the code is generated, it is not displayed to the user. Instead, a second prompt is used to generate Socratic multiple-choice
questions which are then displayed on one side of the interface.
These questions scaffold the step-by-step process of solving the
task and prompting the user in “what needs to be done at each
step of the algorithm/solution” in a structured format. After the
user picks the correct answer (where they have up to three retries),
its corresponding line of code (which is the next line) will be displayed on the right with an explanation about how their answer
and that line contributes to the overall solution. As each question
is answered, its corresponding line of code will be progressively
revealed on the right of the interface. This process is continued
until all lines of the generated code is revealed and then the user
can proceed to use the code in their editor.
Design Space of Cognitive Engagement Techniques with AI-Generated Code
This technique reaches the “Create” level as it engages users
in creating a novel solution. They are prompted to interactively
engage with the AI in hypothesizing and determining the next step
in an algorithm. Since the code is not initially displayed, they are
required to predict the logic, which stimulates creative thinking.


https://chatgpt.com/share/6af52d70-81fc-83e9-91c8-3efc586e0d0f

# Student

```text
# Overview:
Write the C++ [solution-code] for the [task-description] below and keep it hidden from the student.
you are helping novice programmers learn about coding. Look at your [solution-code] and the [task-description], then divide the code into a list of [subgoal] items. For each [subgoal], provide a concise [title] and then divide it into [sub-subgoal-items]. The student has only be given the [task-description] and cannot see the [solution-code], instead you, the assistant that is helping this novice student learn about coding by asking a series of leading questions. These leading questions are short-answer question about each sub-subgoal parts of the task. These questions are supposed to promote critical thinking, problem solving, algorithmic thinking, and computational thinking, and help the student think about the task before they see the code. The student does not know about the [solution-code], they have only be given the [task-description]. You show the questions one by one. If the student correctly answers the leading question, you reveal the code lines associated with that [sub-subgoal] and then show the next question.

# Important Notes:
[sub-subgoal-items] can be one line of code, can be a function definition, can be the `for item in items` part of a loop, can be a return statement. Make sure that for more complicated sub-subgoals, there are multiple questions. Sometimes, a single line of code also deserves its own question, such as a for loop (asking questions about how many times we need to check, what items, what indices, from what index to what index), or the if statement (what different states can X be when Y, how can we make sure Z, etc.).

[code-lines-to-be-revealed]: the lines of code from [solution-code] related to that [sub-subgoal-item].

[question]: the questions should focus on conceptual misunderstandings, common mistakes that students might make, missing corner-cases and edge-cases, incorrect assumptions that students might make, off-by-one errors, incorrect choice of data types, overlooking the behavior of a program or algorithm for special or extreme values, and other logical errors. Each question will help the student to think deeply about "how" this task needs to be solved (focusing on the logic, on the important data representations, operations, etc.) ... the code for that subgoal will only be revealed if the student answers the question about that part correctly. Make sure that all lines of code from [solution-code] are covered with the [sub-subgoals] and [questions], even misc lines, or purely syntactic lines like a function definition. For example, the function definition line should also become a [subgoal] and the [question] can ask about the inputs, and how the input is represented, using what data types. The leading questions should make the student think about the logic, particularly the what, why, and how of actions.

Focus a lot of the questions on the complex part of the algorithm. For those parts, you can include one question per line, or even two questions per line.

# Session rules:
- Before each question, give a short context of what the student has worked out so far, then ask the question.
- Ask ONE question at a time, then stop and wait for the student's answer. Do not show the code or the answer before the student replies.
- The student's answer to the [question] is about the next part of the not-revealed code, which the student has not seen. Check if it makes sense based on the overall code solution, the not-revealed code, and your sample answer. Return: Correctness: <0-5>. Feedback: <20-30 words about what the student got correctly and a small hint at what they are missing about the not-revealed code>. Scoring: if empty, jibberish, or completely wrong then 0. If partially correct and missing important details (like the value something needs to be set to, compared with, etc.) then 1 or 2 (based on how much is missing). If the answer is almost correct, but has a small mistake, then 3. If the answer is correct, but missing some details, then 4. If the answer is perfect, then 5.
- If correctness is 4 or 5, reveal the code lines for that sub-subgoal (with line numbers) with a one-line explanation, then show the next question. Otherwise give the feedback and let the student try again. After 3 tries, reveal the code lines and continue.
- When all questions are done, show the full code.

# Amendment:
The student is learning if/conditional statements, so they do not know loops yet. The student already knows basic syntax (includes/imports, main, variables and data types, input and output, how conditions and loops are written). Do not teach, explain, or quiz any syntax. The purpose of this session is to build the student's logic and problem-solving: figuring out what the program needs to do, in what order, and why.

[task-description]: The Movie Ticket Discount Calculator
Inputs: age:int and is_student:bool
Children (under 12): Ticket price is $5.
Seniors (65 and older): Ticket price is $6.
Students (ages 12 to 64 who are students): Ticket price is $8.
Regular adults (ages 12 to 64, not students): Ticket price is $12.
Invalid age (less than 0 or greater than 120): Print an error message like "Invalid age entered"
```

# Gpt AI tutor



We'll solve the Movie Ticket Discount Calculator step by step.

I'll guide you through the problem using short-answer questions. You haven't seen the solution code, so focus on understanding the decisions the program needs to make and why.

We'll work through these subgoals:

1. Understand and collect the inputs.
2. Validate the customer's age.
3. Determine whether the customer qualifies for the children's ticket price.
4. Determine whether the customer qualifies for the senior ticket price.
5. Determine whether the customer qualifies for the student discount.
6. Handle regular adult ticket pricing.
7. Review the complete solution.

You don't need to write C++ syntax. Focus on the program's logic and decision-making.

### Subgoal 1: Understand the inputs

Before calculating a ticket price, the program needs to know two things about the customer:

- Their age.
- Whether they are a student.

Question 1:

Why do we need both the customer's age and their student status? Could we determine the correct ticket price using age alone? Explain your reasoning.


# Gpt AI tutor


We'll solve the Movie Ticket Discount Calculator step by step.

I'll guide you through the problem using short-answer questions. You haven't seen the solution code, so focus on understanding the decisions the program needs to make and why.

We'll work through these subgoals:

1. Understand and collect the inputs.
2. Validate the customer's age.
3. Determine whether the customer qualifies for the children's ticket price.
4. Determine whether the customer qualifies for the senior ticket price.
5. Determine whether the customer qualifies for the student discount.
6. Handle regular adult ticket pricing.
7. Review the complete solution.

You don't need to write C++ syntax. Focus on the program's logic and decision-making.

### Subgoal 1: Understand the inputs

Before calculating a ticket price, the program needs to know two things about the customer:

- Their age.
- Whether they are a student.

Question 1:

Why do we need both the customer's age and their student status? Could we determine the correct ticket price using age alone? Explain your reasoning.


# Student

based on the student status or the seniors, or the kids, we have the different pricing, so for the fair pricing we need to check either the age or the user is student.


# Gpt AI tutor

Correctness: 5/5

Feedback: Excellent! You recognized that age determines whether someone qualifies as a child or senior, while student status determines eligibility for the student discount among customers aged 12–64.

Code revealed — Subgoal 1: Understand the inputs

```
int age;
bool is_student;
```

Explanation: We need the customer's age and student status because both influence which ticket price applies.

### Subgoal 2: Validate the customer's age

Before assigning a ticket price, we must make sure the age is valid.

The task defines a valid age as being between 0 and 120, inclusive.

Question 2:

What two age conditions would make a customer's age invalid? Why should the program check for invalid ages before checking children's, senior, or student pricing?

# Student

the age is greater than the 120, or equal or equal to zero or less.

# Gpt AI tutor

Correctness: 3/5

Feedback: You correctly identified ages greater than 120 as invalid. However, age zero is valid according to the task; only negative ages are invalid. Think about the inclusive lower boundary.

Try again — Question 2:

What should the two invalid-age conditions be, considering that age 0 and age 120 are both valid?


# Student

age < 0  and. age > 120

# Gpt AI tutor

Correctness: 5/5

Feedback: Exactly! An age below 0 or above 120 is invalid. Notice that age 0 and age 120 remain valid because both boundaries are inclusive.

Code revealed — Subgoal 2: Validate the customer's age

```
if (age < 0 || age > 120) {
    cout << "Invalid age entered";
}
```

Explanation: We reject ages outside the valid range before calculating ticket prices. Either invalid condition is enough to reject the input.

### Subgoal 3: Determine children's ticket pricing

Now that we know the age is valid, consider the first pricing category.

Children younger than 12 receive a ticket for $5.

Question 3:

Why should we check whether the customer's age is less than 12 rather than checking whether it is less than or equal to 12? What would happen to a customer who is exactly 12 years old?


# Student

if the customer is 12 years old, it falls under the non kids category, and the pricing is different for that case, it is 8$ if it is student, and if they are seniours, then itis 8$ otherwise it is 12$.

# Gpt AI tutor

Correctness: 4/5

Feedback: Good reasoning! Exactly 12 is not a child and must be evaluated under another pricing category. One correction: seniors pay $6, not $8; $8 is the student price.

Code revealed — Subgoal 3: Children's ticket pricing

```
else if (age < 12) {
    cout << "Ticket price: $5";
}
```

Explanation: Customers younger than 12 receive the children's price. A customer exactly 12 years old moves to the next pricing category.

### Subgoal 4: Determine senior ticket pricing

We have handled children. Now consider older customers.

The task defines seniors as customers who are 65 years old or older. They receive a ticket for $6.

Question 4:

Why must we check whether the age is greater than or equal to 65 instead of simply checking whether it is greater than 65? What pricing mistake could happen to someone who is exactly 65?

# Student

as per the questions, the definiton of the senior is the age equal and greather than 65.  if we do the > 65, we lost the handling for age 65.  if they are exactluy 65 the pricing is 6$ as they are seniors.


# Gpt AI tutor

Correctness: 5/5

Feedback: Perfect! You correctly identified the boundary condition. Using greater than 65 would exclude customers exactly 65 years old, causing them to receive incorrect pricing.

Code revealed — Subgoal 4: Senior ticket pricing

```
else if (age >= 65) {
    cout << "Ticket price: $6";
}
```

Explanation: Customers aged 65 or older qualify for the senior discount, including those exactly 65.

### Subgoal 5: Determine student ticket pricing

We have handled children and seniors. Now we need to consider customers between 12 and 64.

These customers receive:

- $8 if they are students.
- $12 if they are not students.

Question 5:

Why isn't checking `is_student == true` alone sufficient to determine whether someone qualifies for the $8 student ticket? What additional condition must we consider, and why?

# Student

because the pricing for the student is 8$, and for non student and non seniors and non childerns is 12$, so for the fair and correct indentification of age is important here.

# Gpt AI tutor

Correctness: 4/5

Feedback: Good! You understand that age determines which pricing category applies. The important detail is that student status only qualifies someone aged 12 through 64 for the $8 discount.

Code revealed — Subgoal 5: Determine student ticket pricing

```
else if (is_student) {
    cout << "Ticket price: $8";
}
```

Explanation: Because children and seniors have already been handled, reaching this condition means the customer is between 12 and 64. We can now check student status.

### Subgoal 6: Handle regular adult ticket pricing

We have now handled:

- Children: $5.
- Seniors: $6.
- Students aged 12–64: $8.

One category remains: regular adults aged 12–64 who are not students.

Question 6:

Why can we use the final `else` condition to assign the $12 regular adult price without checking the customer's age and student status again? Explain what we already know about a customer who reaches this point.



# Student

in the order from top we handled all the cases, and now it remains down to the people who are not studnet, not seniors, and not childrens, and the vlaid age here, so all remains is the one case which is we are handling that is 12-64, regular adult, so we just need a else case for that and its pricing is 12$


# Gpt AI tutor

Correctness: 5/5

Feedback: Excellent! You correctly used the previous conditions to narrow down the remaining possibilities. Anyone reaching the final `else` must be a valid-age, non-student adult aged 12–64.

Code revealed — Subgoal 6: Regular adult ticket pricing

```
else {
    cout << "Ticket price: $12";
}
```

Explanation: All other categories have already been handled, so the remaining customers automatically qualify for the regular adult price.

### Subgoal 7: Review the complete solution

You've now worked through all the pricing decisions.

Here is the complete C++ solution:

```
#include <iostream>
using namespace std;

int main() {
    int age;
    bool is_student;

    cin >> age;
    cin >> is_student;

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

### Final reasoning check

Before we finish, consider this test case:

- Age: 65
- Student status: true

Question 7: Which ticket price should the program assign, $6 or $8? Explain why the order of the conditions matters in this situation.

# Student

the program should assign the $6, as the program execution order matters, and at once one of those if, or elseif or else will execute in ths case it goes to the age>=65, and executes.



# Gpt AI tutor

Correctness: 5/5

Feedback: Excellent! You understand both condition ordering and mutually exclusive execution. Even though the customer is a student, the senior condition is checked first and assigns the $6 price. The remaining student condition is skipped.

### Final assessment

# 35/35

Excellent understanding of the problem-solving logic

| Area                   | Performance     |
| ---------------------- | --------------- |
| Understanding inputs   | 5/5             |
| Invalid-age validation | 5/5 after retry |
| Children's pricing     | 4/5             |
| Senior pricing         | 5/5             |
| Student pricing        | 4/5             |
| Regular adult pricing  | 5/5             |
| Condition ordering     | 5/5             |

### What you demonstrated

1. Boundary-value reasoning: You recognized why ages 0, 12, 65, and 120 need careful handling.
2. Conditional ordering: You understood why invalid ages must be checked first and senior pricing before student pricing.
3. Logical elimination: You correctly explained how the final `else` handles the remaining valid adult customers.
4. Mutually exclusive decisions: You understood that only one branch of the `if-else-if-else` chain executes.

One important takeaway: Conditional programming is not just about writing conditions. It is about deciding which conditions should be checked first, what each condition rules out, and what possibilities remain.

You've successfully completed the Movie Ticket Discount Calculator exercise!


# Observations from this interactions. 

- It really made me think hard actually. 
- The interactions was very clean and natural and flowing with the understanndng from the understanding the problem to the finding the answers for those logics. 
- The plan is in the order, with all the clear subgoals which are inputs, invalid age, child, senior, student, regular and all at the end the revision question. 
- The listing of the algo here, including the checking order, the student actually never designed that order and the questins from the foirst directly follow that order. 
- the overview is not the part of the promting, but its an additional step that it has added, it's for sure not a design gap from the t7 but a gpt did it by itself. 
- The boundaries questions were clear and contains all the cases, in q3 and q4 here the less than 12, rather than <= 12, and the >65 or why not just 65 and so on, and the invalid identificaiton of the ages those actualy the edge cases we need to think to determine the order of the xecution and for the proper validations. 
- The types. int age; bool is_student; came out with the Q1 reveal. Q1 never asked about types, and they came from the description. 
- there were no questions in the actually taking in inputs. e.g cin >> age;  as it apears directly in the complete code at the end.
- I checked the code, and i see that the cod ein the t1 baseline and this is diffrent. diffs are the varaible delarations for the ticket pricing and using this as a variable inthe cout statement

# analysis

I ran the quick analysis on my answers to the claude, and i got this. 

What the student did or had to do

Q2 is the only place he built a condition. His first answer said 0 was invalid, which is wrong. After the hint he wrote age < 0 and age > 120.
The other six questions ask him to justify decisions the AI had already made.
He used 1 of 3 retries.
Q4 and Q6 are real reasoning in his own words. Q7 is a correct trace.
Q3 has a factual slip (seniors pay $8). The AI caught it.
Q5 never answers the question. He didn’t say a child or senior student shouldn’t get $8. He still got 4/5 and the code.
No syntax, types, input method or test-case design was asked of him. That matches your amendment.

# Other things I noticed

The AI’s final score is wrong. It says 35/35, but the table adds up to 33/35 (5+5+4+5+4+5+5).
The code never leaked early. It stayed hidden until each reveall as this designed in such a way in promtong and we use live version of the llm as it does not reveal untill we trace down to end.
In T6 the feedback gave the answer away. In T7 the question carries the decision.
Boundaries were covered, unlike T6. 0, 12, 65 and 120 all came up. The AI picked them, and only one test case came at the end, after the full code was shown.


## So in the presepective of our study how this all interaciotns will go let's analyxze.

Understand the problem: partly shown, through the interactive session, the engagement was natural and forces me to understand the problem basics, and logics.
Algorithm: the AI chose the order, and he justified it.
Implement: the AI wrote every line.
Testing and edge cases: the AI chose the boundaries and the one test case. student only reasoned about them.


---

## Experiment Summary (T7 Lead-and-Reveal)

**Task:** Movie Ticket Discount Calculator (C++).
**Technique:** T7 Lead-and-Reveal. The AI keeps the code hidden and asks one question at a time. The student answers, and the matching lines of code are revealed only after a good answer (score 4 or 5, or after 3 tries).

**What happened:**
- The AI split the problem into 7 subgoals: inputs, invalid age, child, senior, student, regular adult, and a final review.
- The student answered 7 questions and used 1 of the 3 retries (Q2, invalid age). The first answer treated age 0 as invalid. After the hint, the student wrote `age < 0` and `age > 120`.
- The AI's final score says 35/35, but the table adds up to 33/35 (5+5+4+5+4+5+5). The AI's total is wrong.
- The code stayed hidden until each reveal, and the full code was shown only at the end.

## Observations (cleaned)

- It made me think hard.
- The interaction was clean, natural, and flowed well, from understanding the problem to finding the answers to the logic.
- The plan was in order, with clear subgoals: inputs, invalid age, child, senior, student, regular adult, and a revision question at the end.
- The AI listed the algorithm, including the check order. The student never designed that order, and the questions follow it directly.
- The overview at the start was not part of the prompt. GPT added it on its own, so it is not a design gap in T7.
- The boundary questions were clear and covered all the cases. Q3 and Q4 asked why `< 12` and not `<= 12`, and why `>= 65` and not `> 65`. The invalid-age check is also an edge case. These are the cases we need to think about to decide the execution order and the validation.
- The types `int age;` and `bool is_student;` were revealed after Q1. Q1 never asked about types. They came from the task description.
- No question covered reading the input (for example `cin >> age;`). It only appears in the complete code at the end.
- I compared the code with the T1 baseline code. They are different. The difference is the ticket price variable, which T1 declares and uses in the `cout` statement.

## Analysis

**What the student did or had to do**
- Q2 is the only place where the student built a condition.
- The other six questions ask the student to justify decisions the AI had already made.
- Q4 and Q6 are real reasoning in the student's own words. Q7 is a correct trace.
- Q3 has a factual slip (the student said seniors pay $8). The AI caught it.
- Q5 never answers the question. The student did not say that a child or senior who is a student should not get $8. It still got 4/5 and the code.
- No syntax, types, input method, or test-case design was asked of the student. This matches the amendment in the prompt.

**Other things I noticed**
- The code never leaked early. It stayed hidden until each reveal, because the prompt was written that way and the live LLM did not reveal anything until the end.
- In T6 the feedback gave the answer away. In T7 the question carries the decision.
- Boundaries were covered, unlike in T6. The values 0, 12, 65, and 120 all came up. The AI picked them. Only one test case came up, at the end, after the full code was shown.

## Study perspective (decision stages)

- **Understand the problem:** Partly. The interactive session was natural and pushed me to understand the basics and the logic of the problem.
- **Algorithm:** The AI chose the order, and the student justified it.
- **Implementation:** The AI wrote every line.
- **Testing and edge cases:** The AI chose the boundaries and the one test case. The student only reasoned about them.
