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
