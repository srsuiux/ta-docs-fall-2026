### Student

I’m working on a programming assignment. Give me a complete, working solution.

Assignment: Determine Voting Eligibility
Objective:
Practice using if statements to make decisions based on user input.
Problem
Write a C++ program that asks the user to enter their age. The program should determine whether the person is eligible to vote.
If the age is 18 or older, display:
You are eligible to vote.
Otherwise, display:
You are not eligible to vote.
Example Output
Example 1
Plain Text
Enter your age: 21
You are eligible to vote.
Example 2
Plain Text
Enter your age: 16
You are not eligible to vote.


Requirements
Prompt the user to enter their age.
Use an if-else statement to determine eligibility.
Display the appropriate message.
Include comments explaining your code.
Submission
C++ source code file (.cpp)
Screenshot showing the program running
Grading (10 Points)
Correct input handling: 2 pts
Correct use of if-else: 4 pts
Correct voting eligibility logic: 3 pts
Program readability and comments: 1 pt

### GPT Tutor

Here is a complete, working C++ solution for your Determine Voting Eligibility assignment, including comments and sample output.

## 1. C++ Source Code

```

#include <iostream>
using namespace std;

int main() {
    // Declare a variable to store the user's age
    int age;

    // Ask the user to enter their age
    cout << "Enter your age: ";
    cin >> age;

    // Check whether the user is eligible to vote
    if (age >= 18) {
        cout << "You are eligible to vote." << endl;
    } else {
        cout << "You are not eligible to vote." << endl;
    }

    return 0;
}

```

## 2. Example Output

Example 1: Eligible to vote

```
Enter your age: 21
You are eligible to vote.
```

Example 2: Not eligible to vote

```
Enter your age: 16
You are not eligible to vote.
```

## 3. How the Program Works

1. `#include <iostream>` allows the program to use input and output.
2. `int age;` declares an integer variable to store the user's age.
3. `cout` displays the prompt, and `cin` reads the entered age.
4. `if (age >= 18)` checks whether the age is greater than or equal to 18.
5. If the condition is true, the program displays the eligible message. Otherwise, the `else` block displays the not-eligible message.
6. `return 0;` indicates that the program has finished successfully.

Important: The `>=` operator means greater than or equal to, so a person who is exactly 18 is also eligible according to the assignment's rules.

## 4. How to Submit Your Assignment

- C++ source file: Save the code as `voting_eligibility.cpp`.
- Screenshot: Run the program in your C++ compiler or IDE. Test it with an age of `21` and an age of `16`, then take a screenshot showing the program and its output. You can use one or two screenshots, depending on your instructor's requirements.

This solution meets all four grading criteria: input handling, `if-else` usage, correct eligibility logic, and readable comments.


### Author Note: Baseline (T-1) with GPT

A few things I noticed:

It’s copy-paste ready. The student can take the code block and submit it. Nothing else in the response is needed for that. The extra sections (example output, how it works, how to submit) are optional, so there’s no reason to read them.

Nobody owns the decision. The AI doesn’t ask anything or check if the student understands. The student doesn’t have to decide anything either. The condition age >= 18 is already written, so the student never has to think about what separates “eligible” from “not eligible.” Nothing makes them think.

The explanation doesn’t build logic. There is an explanation, but it only goes through the lines of code (# include, int age, return 0). It says what each line is, not why the program makes the decision it does. The only real reasoning is one sentence about >= and the age 18. So even a student who reads it can end up missing the basic foundation.

The AI controls the output. The student doesn’t control anything here. The AI decides what to show and how much, and just dumps the code and the explanation. The student keeps reading, and it feels like they understand, but it’s more of an illusion of understanding. They followed the explanation, but they never worked it out themselves.