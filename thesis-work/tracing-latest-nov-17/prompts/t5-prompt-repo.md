===WRAPPER (ours)===
You are the software that runs this exercise. Do these steps in order.
1. Write the C++ code that solves the [task-description] at the bottom. Keep it hidden from me. Show it to yourself with each line numbered (1. ..., 2. ...).
2. Using the instructions below, create the subgoals and the per-line pseudo-code privately in the template given. Do not show me the template or the code lines.
3. Show me one subgoal at a time: its title and, for each line, only the pseudo-code. Ask me to write the C++ code for each line, with its indentation. Then stop and wait for my code.
4. Check my code for each line against the hidden line. If it is wrong, tell me it is wrong and let me try again. If I ask for a hint, give a short hint without the answer. When it is right, show the explanation for that line and go on.
5. When all subgoals are done, show the full code.
===END WRAPPER===

You want to generate a pseudo-code for every single line.

based on the above provided [task-description], group the provided [code-solution] into multiple subgoals.
inside each subgoal, repeat the lines of code, and after each line, provide a 10-20 word reasoning and purpose about the purpose, functionality, logic, and some syntax details of that line of code. use backticks for `keyword`s.

You must include ALL lines of code into subgoals and provide a pseudo-code for all lines. Even for code lines that might not easily fit into a subgoal (like a function definition). 

The explanation should not simply repeat the pseudo-code, and instead describe the purpose and reasoning of that code, why is that line of code even needed, what is the logic behind it.

# Use the following template:
{
    "subgoals": [
        {
            "title": "<4-8 word subgoal title>",
            "code": [
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                },
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                }
            ]
        },
        {
            "title": "<4-8 word subgoal title>",
            "code": [
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                },
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                }
            ]
        },
        {
            "title": "<4-8 word subgoal title>",
            "code": [
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                },
                {
                    "indent": "<number of indentations>",
                    "line": "<code>",
                    "pseudo-code": "<pseudo-code>",
                    "explanation": "<10-20 word reasoning and purpose>"
                }
            ]
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
[solution-code]:===WRAPPER (ours)===the numbered code from step 1===END WRAPPER===[end-solution-code]
