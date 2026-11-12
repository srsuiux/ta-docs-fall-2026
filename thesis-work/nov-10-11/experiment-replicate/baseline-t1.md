
T1: T1. Baseline

In the Baseline technique, after the user provides the input prompt,
the AI generates code and a detailed explanation using an initial
prompt, and it is displayed to the user, similar to tools like ChatGPT.
The level of engagement is completely optional and up to users.
This technique induces little engagement, therefore classified as
passive engagement.

T1 - Baseline: Users can directly use the generated code
and accompanying explanation without any required engagement.

https://chatgpt.com/share/6af506b3-a82c-83e9-ac3b-f815d4c86f66

```text
Generate the C++ code that solves the provided problem. Use the following format to provide explanations for each line.

[OUTPUT]
<line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
<line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
    <line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
<line of code> ### <explanation of line of code in natural language, and how it is solving the problem, also explain important functions or syntax elements used>
[END]

[OVERALL-EXPLANATION]
<now provide a holistic explanation in paragraphs about how the code is solving the problem>

[intended-behavior]: The Movie Ticket Discount Calculator
Inputs: age:int and is_student:bool
Children (under 12): Ticket price is $5.
Seniors (65 and older): Ticket price is $6.
Students (ages 12 to 64 who are students): Ticket price is $8.
Regular adults (ages 12 to 64, not students): Ticket price is $12.
Invalid age (less than 0 or greater than 120): Print an error message like "Invalid age entered"
[code]:
```


[OUTPUT]

```
#include <iostream>  ### Includes the iostream library, which provides input and output functionality, such as cin and cout.

using namespace std;  ### Allows us to use standard C++ features like cin and cout without writing std:: before them.

int main() {  ### Defines the main function, where the program begins execution.

    int age;  ### Declares an integer variable named age to store the customer's age.

    bool is_student;  ### Declares a Boolean variable named is_student to store whether the customer is a student (true or false).

    double ticket_price;  ### Declares a variable to store the calculated ticket price.

    cout << "Enter your age: ";  ### Displays a message asking the user to enter their age.

    cin >> age;  ### Reads the age entered by the user and stores it in the age variable.

    cout << "Are you a student? (1 for Yes, 0 for No): ";  ### Asks the user whether they are a student. The user enters 1 for Yes or 0 for No.

    cin >> is_student;  ### Reads the user's response and stores it as a Boolean value.

    if (age < 0 || age > 120) {  ### Checks whether the entered age is invalid. The || operator means OR, so either condition being true makes the age invalid.

        cout << "Invalid age entered" << endl;  ### Displays an error message when the age is less than 0 or greater than 120.

    } else if (age < 12) {  ### Checks whether the customer is younger than 12. This condition handles children.

        ticket_price = 5;  ### Assigns a ticket price of $5 to children.

        cout << "Ticket price: $" << ticket_price << endl;  ### Displays the calculated ticket price.

    } else if (age >= 65) {  ### Checks whether the customer is 65 or older. This condition handles senior citizens.

        ticket_price = 6;  ### Assigns a ticket price of $6 to senior citizens.

        cout << "Ticket price: $" << ticket_price << endl;  ### Displays the calculated ticket price.

    } else if (is_student) {  ### Checks whether the customer is a student. Because earlier conditions have been checked, the customer's age must be between 12 and 64.

        ticket_price = 8;  ### Assigns a discounted ticket price of $8 to eligible students.

        cout << "Ticket price: $" << ticket_price << endl;  ### Displays the calculated ticket price.

    } else {  ### Handles customers between 12 and 64 who are not students.

        ticket_price = 12;  ### Assigns the regular adult ticket price of $12.

        cout << "Ticket price: $" << ticket_price << endl;  ### Displays the calculated ticket price.

    }  ### Marks the end of the if-else decision structure.

    return 0;  ### Ends the main function and indicates that the program executed successfully.

}  ### Marks the end of the main function.
```

[END]

[OVERALL-EXPLANATION]

The program calculates a movie ticket price based on the customer's age and student status. It starts by including the iostream library, which allows the program to receive input from the user through `cin` and display information using `cout`.

First, the program asks the user to enter their age and whether they are a student. The age is stored in an integer variable, while student status is stored in a Boolean variable. In this program, the user enters `1` for Yes and `0` for No.

After collecting the inputs, the program uses an `if-else if-else` decision structure to determine the correct ticket price. It checks the conditions in a particular order:

1. Invalid age: If the age is less than 0 or greater than 120, the program displays an error message.
2. Children: If the age is less than 12, the ticket price is $5.
3. Seniors: If the age is 65 or older, the ticket price is $6.
4. Students: If the age is between 12 and 64 and the customer is a student, the ticket price is $8.
5. Regular adults: If none of the previous conditions apply, the customer is between 12 and 64 and is not a student, so the ticket price is $12.

The order of these conditions is important because the program must first eliminate invalid ages and identify children and seniors before checking student status. This ensures that children and seniors receive their designated prices regardless of whether they are students.

Finally, the program displays the calculated ticket price and uses `return 0` to indicate that execution has completed successfully.


# Observations from the interactions. 

- Direct output as expected.
- the code comes with the explanations for each steps this is good to understand what is happening in the code.
- The experiment output is differnt from the experiment 1 we ran in the last time. as it was the third person prompt wrapper, which was due the prompt structure being used as the last experimt there was no explanations provided, after the code, and no comments were given. 
- The output is clean, and as there is nothing as a student can decide and this is a baseline approach so we can;t expect more from the LLM as it;s more of the direct way of asking help to the AI. 


---

## Experiment Summary (T1 Baseline)

**Task:** Movie Ticket Discount Calculator (C++).
**Technique:** T1 Baseline. The student gives the problem to the AI and gets back the full code with a line-by-line explanation and an overall explanation. Nothing is required from the student.

**What happened:**
- The AI returned the full solution in one response: all the code, a `###` explanation for every line, and an overall explanation.
- The AI decided everything: the inputs and how they are read, the check order (invalid age, child, senior, student, regular adult), the boundaries (`age < 12`, `age >= 65`), and the messages.
- The student made no decisions and did no work. Using the code is fully optional engagement, so this is passive engagement.

## Observations (cleaned)

- The output was direct, as expected.
- The code comes with an explanation for each line, which helps in understanding what the code is doing.
- This output is different from experiment 1, which we ran last time. That run used the third-person prompt wrapper, so the output had no explanations after the code and no comments. The difference comes from the prompt structure.
- The output is clean. Since this is the baseline, the student has nothing to decide, and we can't expect more from the LLM when the student asks for help in the most direct way.
