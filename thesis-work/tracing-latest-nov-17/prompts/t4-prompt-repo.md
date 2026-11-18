===WRAPPER (ours)===
You are the software that runs this exercise. Do these steps in order.
1. Write the C++ code that solves the [task-description] below. Keep it hidden from me. Number the lines internally (1. ..., 2. ...).
[task-description]: The Movie Ticket Discount Calculator
Inputs: age:int and is_student:bool 
Children (under 12): Ticket price is $5.
Seniors (65 and older): Ticket price is $6.
Students (ages 12 to 64 who are students): Ticket price is $8.
Regular adults (ages 12 to 64, not students): Ticket price is $12.
Invalid age (less than 0 or greater than 120): Print an error message like "Invalid age entered"
2. Using the first instruction below (Generate issues), create the wrong code privately with the issues added. Do not show me the format. Show me only the wrong code, without line numbers. Then stop and wait.
3. I will send you my fixed code. Compare it with the correct code. If it is correct, show the correct code and stop. If it is not correct, wait for me to ask for a hint.
4. Each time I ask for a hint, give the next level, one level per request, using the hint instructions below in order: level 1, then level 2, then level 3. Compare my latest code with the correct code each time.
===END WRAPPER===

Purposefully add some logical issues to the {code-solution} so that the noivce C++ programmers needs to fix it. Some potential logical issues to fix are: Incorrect Loop Conditions, Wrong Variable Assignments, Incorrect Function Arguments, Misuse of Data Structures, Incorrect Boolean Logic.  For each of the {code-solution} snippet, only generate 2 to 3 issues depends on the code length. The newly generated code should not involve any comments.  The code's line number starts from 1, empty lines should also be count as a line

#output in the below JSON format:

{
"wrong-code": {newly generated code based on the provided {code-solution} with logical issues}
"issues":{
            "logical-issue": {
                    "type": {3-4 words title for the issue type}
                    "line": {line number in the [wrong-code]}
            },
            "logical-issue": {
                    "type": {3-4 words title for the issue type}
                    "line": {line number in the [wrong-code]}
            }
        }
}

[solution-code]:===WRAPPER (ours)===the numbered code from step 1===END WRAPPER===[end-solution-code]

===WRAPPER (ours)===HINT LEVEL 1===END WRAPPER===
by comparing [student-code] to [correct-solution], list all the lines of [student-code] that are incorrect and need to be fixed. Use the following JSON template:

{
    "fixes": [
        {
            "line": <number>,
            "issues": <10-15 word description>
        },
        {
            "line": <number>,
            "issues": <10-15 word description>
        },
        ...
    ]
}

if there are no issues, the list of fixes should become empty.

[student-code]:${getCodeWithLine(studentCode)}[end-student-code][correct-solution]${getCodeWithLine(code)}[end-correct-solution]

===WRAPPER (ours)===HINT LEVEL 2===END WRAPPER===
by comparing [student-code] to [correct-solution], list all the lines of [student-code] that are incorrect and need to be fixed.

After describing the issues, ask a though provoking question to nudge the student towards thinking about what could potentially be wrong in that line.

Make sure that these questions are novice-friendly and easy to understand for a student learning to code. use a simple english.

Use the following JSON template:

{
    "fixes": [
        {
            "line": <number>,
            "issues": <detailed description>,
            "question": <thought provoking question for student>
        },
        {
            "line": <number>,
            "issues": <detailed description>,
            "question": <thought provoking question for student>
        },
        ...
    ]
}

if there are no issues, the list of fixes should become empty.

[student-code]:${getCodeWithLine(studentCode)}[end-student-code][correct-solution]${getCodeWithLine(code)}[end-correct-solution]

===WRAPPER (ours)===HINT LEVEL 3===END WRAPPER===
by comparing [student-code] to [correct-solution], list all the lines of [student-code] that are incorrect and need to be fixed.

After describing the issues, provide a list of hints for that line and its issues to help the student fix that line.

Do not include any code in the hints. Just use natural language. The student should fix the code by themselves.

Use the following JSON template:

{
    "fixes": [
        {
            "line": <number>,
            "issues": <detailed description>,
            "hint": "<natural language hints to fix issues>"
        },
        {
            "line": <number>,
            "issues": <detailed description>,
            "hint": "<natural language hints to fix issues>"
        },
        ...
    ]
}

if there are no issues, the list of fixes should become empty.

[student-code]:${getCodeWithLine(studentCode)}[end-student-code][correct-solution]${getCodeWithLine(code)}[end-correct-solution]
