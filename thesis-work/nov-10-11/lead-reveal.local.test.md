# Lead-and-Reveal local test: Movie Ticket Discount Calculator

## Setup

I ran the codebase locally and tested it with the config from the env. The authors were using the gpt-4 models because this is the past study. We switched to the gpt-4o models and it worked well. Below are the interaction logs, step by step.

## Task description

```text
The Movie Ticket Discount Calculator
Inputs: age:int and is_student:bool 
Children (under 12): Ticket price is $5.
Seniors (65 and older): Ticket price is $6.
Students (ages 12 to 64 who are students): Ticket price is $8.
Regular adults (ages 12 to 64, not students): Ticket price is $12.
Invalid age (less than 0 or greater than 120): Print an error message like "Invalid age entered"
```

## Step 1. Generate Code Using GPT

Code Solution:

```python
def calculate_ticket_price(age:int, is_student:bool)->str:
    if age < 0 or age > 120:
        return "Invalid age entered"
    elif age < 12:
        return "$5"
    elif age >= 65:
        return "$6"
    elif is_student:
        return "$8"
    else:
        return "$12"
```

## Step 2. Generate Line by Line Explanation

```text
def calculate_ticket_price(age:int, is_student:bool)->str: 
- Defines a function named 'calculate_ticket_price' that takes two parameters: 'age' (an integer) and 'is_student' (a boolean), and returns a string.
    if age < 0 or age > 120: 
- Checks if the 'age' is less than 0 or greater than 120, which are considered invalid ages.
        return "Invalid age entered" 
- Returns the string "Invalid age entered" if the age is invalid, handling the error case.
    elif age < 12: 
- Checks if the 'age' is less than 12, which qualifies for a child ticket price.
        return "$5" 
- Returns the string "$5" for children under 12, as per the pricing rules.
    elif age >= 65: 
- Checks if the 'age' is 65 or older, which qualifies for a senior ticket price.
        return "$6" 
- Returns the string "$6" for seniors 65 and older, as per the pricing rules.
    elif is_student: 
- Checks if the person is a student, applicable for ages 12 to 64.
        return "$8" 
- Returns the string "$8" for students aged 12 to 64, as per the pricing rules.
    else: 
- Handles the case for regular adults who are not students and are aged between 12 and 64.
        return "$12" 
- Returns the string "$12" for regular adults aged 12 to 64 who are not students, as per the pricing rules.
```

## Step 3. Generate Decomposition

Important Decision / Decomposition JSON:

```json
{
    "hierarchical-decisions-being-made": [
        {
            "decision": "check if the age is less than 0 or greater than 120",
            "reason": "to validate the input age and ensure it falls within a realistic and acceptable range for human ages"
        },
        {
            "decision": "return 'Invalid age entered' if the age is outside the valid range",
            "reason": "to provide feedback to the user that the input age is not acceptable"
        },
        {
            "decision": "check if the age is less than 12",
            "reason": "to determine if the person is a child and apply the corresponding ticket price"
        },
        {
            "decision": "return '$5' if the age is less than 12",
            "reason": "children under 12 have a discounted ticket price of $5"
        },
        {
            "decision": "check if the age is 65 or older",
            "reason": "to determine if the person is a senior and apply the corresponding ticket price"
        },
        {
            "decision": "return '$6' if the age is 65 or older",
            "reason": "seniors 65 and older have a discounted ticket price of $6"
        },
        {
            "decision": "check if the person is a student",
            "reason": "to determine if the person qualifies for a student discount"
        },
        {
            "decision": "return '$8' if the person is a student",
            "reason": "students between the ages of 12 and 64 have a discounted ticket price of $8"
        },
        {
            "decision": "return '$12' for regular adults",
            "reason": "adults between the ages of 12 and 64 who are not students pay the regular ticket price of $12"
        }
    ]
}
```

## Step 4. Generate Lead and Reveal

Lead and Reveal JSON:

```json
{
  "subgoals": [
    {
      "decisions-made-here": [
        "Check if the age is less than 0 or greater than 120 to validate the input age."
      ],
      "reasonings-behind-decisions": [
        "This ensures that the input age is within a realistic and acceptable range for human ages."
      ],
      "questions": [
        {
          "context-so-far": "We are starting to evaluate the input age to determine the appropriate ticket price. We need to ensure the age is valid.",
          "question": "What should we check first about the age?",
          "answer": "We should check if the age is less than 0 or greater than 120 to ensure it falls within a valid range. This helps in identifying invalid inputs early."
        }
      ],
      "subgoal-code-lines-to-be-revealed": [2]
    },
    {
      "decisions-made-here": [
        "Return 'Invalid age entered' if the age is outside the valid range."
      ],
      "reasonings-behind-decisions": [
        "Providing feedback to the user that the input age is not acceptable helps in understanding the error and correcting it."
      ],
      "questions": [
        {
          "context-so-far": "We have checked if the age is outside the valid range. Now we need to handle this invalid case.",
          "question": "What should we do if the age is invalid?",
          "answer": "We should return 'Invalid age entered' to inform the user that the age provided is not within the acceptable range."
        }
      ],
      "subgoal-code-lines-to-be-revealed": [3]
    },
    {
      "decisions-made-here": [
        "Check if the age is less than 12 to determine if the person is a child."
      ],
      "reasonings-behind-decisions": [
        "Children under 12 have a discounted ticket price, so we need to identify this age group."
      ],
      "questions": [
        {
          "context-so-far": "We have handled the invalid age case. Now, we need to determine if the person is a child.",
          "question": "How do we identify if the person is a child?",
          "answer": "We check if the age is less than 12 to determine if the person qualifies for the child ticket price."
        }
      ],
      "subgoal-code-lines-to-be-revealed": [4]
    },
    {
      "decisions-made-here": [
        "Return '$5' if the age is less than 12."
      ],
      "reasonings-behind-decisions": [
        "Children under 12 have a discounted ticket price of $5, so we need to apply this pricing."
      ],
      "questions": [
        {
          "context-so-far": "We have determined that the person is a child. Now, we need to apply the appropriate ticket price.",
          "question": "What should we return for children under 12?",
          "answer": "We should return '$5' as the ticket price for children under 12, reflecting their discounted rate."
        }
      ],
      "subgoal-code-lines-to-be-revealed": [5]
    },
    {
      "decisions-made-here": [
        "Check if the age is 65 or older to determine if the person is a senior."
      ],
      "reasonings-behind-decisions": [
        "Seniors 65 and older have a discounted ticket price, so we need to identify this age group."
      ],
      "questions": [
        {
          "context-so-far": "We have handled the child age group. Now, we need to determine if the person is a senior.",
          "question": "How do we identify if the person is a senior?",
          "answer": "We check if the age is 65 or older to determine if the person qualifies for the senior ticket price."
        }
      ],
      "subgoal-code-lines-to-be-revealed": [6]
    },
    {
      "decisions-made-here": [
        "Return '$6' if the age is 65 or older."
      ],
      "reasonings-behind-decisions": [
        "Seniors 65 and older have a discounted ticket price of $6, so we need to apply this pricing."
      ],
      "questions": [
        {
          "context-so-far": "We have determined that the person is a senior. Now, we need to apply the appropriate ticket price.",
          "question": "What should we return for seniors 65 and older?",
          "answer": "We should return '$6' as the ticket price for seniors 65 and older, reflecting their discounted rate."
        }
      ],
      "subgoal-code-lines-to-be-revealed": [7]
    },
    {
      "decisions-made-here": [
        "Check if the person is a student to determine if they qualify for a student discount."
      ],
      "reasonings-behind-decisions": [
        "Students between the ages of 12 and 64 have a discounted ticket price, so we need to identify this group."
      ],
      "questions": [
        {
          "context-so-far": "We have handled the senior age group. Now, we need to determine if the person is a student.",
          "question": "How do we identify if the person is a student?",
          "answer": "We check if the 'is_student' flag is true to determine if the person qualifies for the student ticket price."
        }
      ],
      "subgoal-code-lines-to-be-revealed": [8]
    },
    {
      "decisions-made-here": [
        "Return '$8' if the person is a student."
      ],
      "reasonings-behind-decisions": [
        "Students between the ages of 12 and 64 have a discounted ticket price of $8, so we need to apply this pricing."
      ],
      "questions": [
        {
          "context-so-far": "We have determined that the person is a student. Now, we need to apply the appropriate ticket price.",
          "question": "What should we return for students?",
          "answer": "We should return '$8' as the ticket price for students, reflecting their discounted rate."
        }
      ],
      "subgoal-code-lines-to-be-revealed": [9]
    },
    {
      "decisions-made-here": [
        "Return '$12' for regular adults who are not students."
      ],
      "reasonings-behind-decisions": [
        "Adults between the ages of 12 and 64 who are not students pay the regular ticket price, so we need to apply this pricing."
      ],
      "questions": [
        {
          "context-so-far": "We have handled all special cases. Now, we need to determine the ticket price for regular adults.",
          "question": "What should we return for regular adults?",
          "answer": "We should return '$12' as the ticket price for regular adults, reflecting the standard rate for this group."
        }
      ],
      "subgoal-code-lines-to-be-revealed": [10, 11]
    }
  ]
}
```

## Step 5. Show Lead and Reveal (the interaction)

AI: Let's solve this task step by step. I'll give a brief description of each step and ask you a question. Focus on what needs to be done, and I'll guide you to the right answer.

### Round 1

- **AI:** We are starting to evaluate the input age to determine the appropriate ticket price. We need to ensure the age is valid.
- **Question:** What should we check first about the age?
- **Your answer:** age < 0 || age > 120
- **Explanation:** We should check if the age is less than 0 or greater than 120 to ensure it falls within a valid range. This helps in identifying invalid inputs early.
- **Code revealed:**

```python
if age < 0 or age > 120:
```

### Round 2

- **AI:** We have checked if the age is outside the valid range. Now we need to handle this invalid case.
- **Question:** What should we do if the age is invalid?
- **Your answer:** returh "invalid age entered"
- **Explanation:** We should return 'Invalid age entered' to inform the user that the age provided is not within the acceptable range.
- **Code revealed:**

```python
return "Invalid age entered"
```

### Round 3

- **AI:** We have handled the invalid age case. Now, we need to determine if the person is a child.
- **Question:** How do we identify if the person is a child?
- **Your answer:** age <= 12
- **Explanation:** We check if the age is less than 12 to determine if the person qualifies for the child ticket price.
- **Code revealed:**

```python
elif age < 12:
```

### Round 4

- **AI:** We have determined that the person is a child. Now, we need to apply the appropriate ticket price.
- **Question:** What should we return for children under 12?
- **Your answer:** Children (under 12): Ticket price is $5.
- **Explanation:** We should return '$5' as the ticket price for children under 12, reflecting their discounted rate.
- **Code revealed:**

```python
return "$5"
```

### Round 5

- **AI:** We have handled the child age group. Now, we need to determine if the person is a senior.
- **Question:** How do we identify if the person is a senior?
- **Your answer:** age >= 65
- **Explanation:** We check if the age is 65 or older to determine if the person qualifies for the senior ticket price.
- **Code revealed:**

```python
elif age >= 65:
```

### Round 6

- **AI:** We have determined that the person is a senior. Now, we need to apply the appropriate ticket price.
- **Question:** What should we return for seniors 65 and older?
- **Your answer:** Seniors (65 and older): Ticket price is $6.
- **Explanation:** We should return '$6' as the ticket price for seniors 65 and older, reflecting their discounted rate.
- **Code revealed:**

```python
return "$6"
```

### Round 7

- **AI:** We have handled the senior age group. Now, we need to determine if the person is a student.
- **Question:** How do we identify if the person is a student?
- **Your answer:** is_student will be true for the student
- **Explanation:** We check if the 'is_student' flag is true to determine if the person qualifies for the student ticket price.
- **Code revealed:**

```python
elif is_student:
```

### Round 8

- **AI:** We have determined that the person is a student. Now, we need to apply the appropriate ticket price.
- **Question:** What should we return for students?
- **Your answer:** Students (ages 12 to 64 who are students): Ticket price is $8.
- **Explanation:** We should return '$8' as the ticket price for students, reflecting their discounted rate.
- **Code revealed:**

```python
return "$8"
```

### Round 9

- **AI:** We have handled all special cases. Now, we need to determine the ticket price for regular adults.
- **Question:** What should we return for regular adults?
- **Your answer:** Regular adults (ages 12 to 64, not students): Ticket price is $12.
- **Explanation:** We should return '$12' as the ticket price for regular adults, reflecting the standard rate for this group.
- **Code revealed:**

```python
else:
return "$12"
```

### Final code

```python
def calculate_ticket_price(age:int, is_student:bool)->str:
    if age < 0 or age > 120:
        return "Invalid age entered"
    elif age < 12:
        return "$5"
    elif age >= 65:
        return "$6"
    elif is_student:
        return "$8"
    else:
        return "$12"
```

## Result

Great job! You have completed the task!


### Decisions the AI made

**Before the student saw anything (Steps 1 to 4)**

- **Wrote the whole solution** (Step 1). The student only gave the task description.
- **Chose the function form and return type.** The code is a function that returns a string. The task says "Print an error message", but the AI returns `"Invalid age entered"`. It also returns prices as strings (`"$5"`, `"$6"`), not numbers. *(App code: the Step 1 prompt tells the model to put the code in a function and output no comments, so some of this comes from the tool's prompt, not only the model.)*
- **Chose the check order:** invalid age, then child, then senior, then student, then regular adult.
- **Chose the boundaries:** `age < 0 or age > 120` is invalid (so 0 and 120 are valid), `age < 12` is a child, `age >= 65` is a senior.
- **Chose one `if / elif / else` chain,** where only one branch runs. No alternative structure was shown.
- **Wrote the decomposition** (Step 3): 9 decisions with a reason for each. It left out the function line.
- **Chose how to split the code into reveal steps** (Step 4): 9 subgoals with 1 question each, and each condition and its return value are separate steps. The last step reveals `else:` and `return "$12"` together (lines 10 and 11). The function line (line 1) is never asked about.

**During the interaction (Step 5)**

- **Set the order of the questions** (invalid, child, senior, student, regular).
- **Put the next step in the context text.** For example, Round 3: "Now, we need to determine if the person is a child." Round 5: "…a senior." Round 7: "…a student." Round 1 says "We need to ensure the age is valid." So the student was told which category comes next.
- **Restated the category in some question text.** Round 4 says "children under 12" and Round 6 says "seniors 65 and older".
- **Revealed the code after every answer.** The log shows no retry, no hint and no score.
  - Round 3 got the answer `age <= 12`, which does not match the task ("under 12"). The AI still revealed `elif age < 12:` with an explanation.
  - *(App code: an answer passes when its correctness score is above 2. The log does not show scores, so I can't tell what Round 3 scored.)*
- **Wrote every explanation** and the final "Great job!" message.
- **Never asked the student to test.** There was no boundary test (11 and 12, 64 and 65, 0 and 120) and no run of the code.

### Decisions the student made

- **Round 1:** `age < 0 || age > 120`. The student chose to check for invalid ages first and chose both limits correctly. The `||` is C++ style, and the AI's Python uses `or`.
- **Round 2:** `returh "invalid age entered"`. The student chose to return the message. It has a typo ("returh") and lower-case wording; the task says "Invalid age entered".
- **Round 3:** `age <= 12`. This is the student's one wrong boundary. The task says "under 12", so it should be `age < 12`. The reveal showed the correct line.
- **Round 5:** `age >= 65`. Correct boundary, written as code.
- **Round 7:** "is_student will be true for the student". Correct idea, written in words.
- **Rounds 4, 6, 8 and 9:** the student copied the matching line from the task description, for example `Children (under 12): Ticket price is $5.` These answers restate the task. They don't say what the code should return or how.

**Not decided by the student:** the function name and signature, return versus print, the data type of the prices, the `elif` chain, and the order of the checks beyond what the context text said. No test was written or run.

### Mapped to the four decision stages

| Stage | AI | Student |
|---|---|---|
| Understand the problem | Never asked the student to explain the problem | Gave the task description as the input |
| Design the algorithm | Chose the order, the chain, and the step split. Context text named the next category. | Chose "invalid first" and the logic of each condition in words or code |
| Implement | Wrote the full code, the function form and the return values | Wrote 3 conditions and 1 return message (Rounds 1, 2, 3, 5) in their own words |
| Test and edge cases | Never tested. The boundaries were set in the AI's code. | Got one boundary wrong (Round 3) and was never asked to check it |
