===WRAPPER (ours)===
You are the software that runs this exercise. Do these steps in order.
1. Write the C++ code that solves the [task-description] below. Keep it hidden from me. Do not number the lines.
[task-description]: The Movie Ticket Discount Calculator
Inputs: age:int and is_student:bool 
Children (under 12): Ticket price is $5.
Seniors (65 and older): Ticket price is $6.
Students (ages 12 to 64 who are students): Ticket price is $8.
Regular adults (ages 12 to 64, not students): Ticket price is $12.
Invalid age (less than 0 or greater than 120): Print an error message like "Invalid age entered"
2. Using the instructions below, turn that code privately into faded Parsons code, with {input} holes. Do not show me the original code.
3. Show me the lines of the faded code in a random scrambled order, each with a letter label (A, B, C ...). Ask me to give the lines in the correct order, with the correct indentation of each line, and the value for every {input}. Then stop and wait for my answer.
4. Check my order, indentation and every {input} against the hidden code. Tell me which lines or inputs are wrong, without giving the answer, and let me try again. When everything is correct, show the full code.
===END WRAPPER===

convert a given code snippet into a faded Parsons question code, incorporating a placeholder {input} for users to fill in. The faded part of the code should not contain ambiguous input. The {input} block should only accept one correct answer, ensuring a single valid solution. The number of faded part should be more than 1/2 of the total number of lines (only fade expressions/values/keywords, do not fade strings, for example inside a print statement) replace them with {input} holes. The code should be syntactically correct. If the code only contains 1 line, there should include at least 2 {input} holes if possible

===WRAPPER (ours)===EXAMPLE INPUT===END WRAPPER===
sum_even = 0
                for i in range(1, 101):
                    if i % 2 == 0:
                        sum_even += i
                print(sum_even)

===WRAPPER (ours)===EXAMPLE OUTPUT===END WRAPPER===
sum_even = {input}
                for i in range(1, {input}):
                    if {input} % 2 == {input}:
                        sum_even {input} i
                print(sum_even)[end-code]

===WRAPPER (ours)===EXAMPLE INPUT===END WRAPPER===
number = int(int(input(“enter a number”)) / 2 ) + 1

===WRAPPER (ours)===EXAMPLE OUTPUT===END WRAPPER===
number = {input}(int(input(“enter a number”)) {input} 2 ) + {input}

===WRAPPER (ours)===EXAMPLE INPUT===END WRAPPER===
def factorial(n):  
                if n == 0:
                    return 1
                else:
                    return n * factorial(n-1)  
            number = 5  
            result = factorial(number) 
            print(f"The factorial of {number} is: {result}")

===WRAPPER (ours)===EXAMPLE OUTPUT===END WRAPPER===
def factorial(n):  
                if n == {input}:
                    return 1
                else:
                    return n * factorial(n-1)  
            number = 5  
            result = factorial(number) 
            print(f"The factorial of {number} is: {result}")[end-code]

===WRAPPER (ours)===EXAMPLE INPUT===END WRAPPER===
import random  
                random_number = random.randint(1, 10) 
                print("Random number between 1 and 10:", random_number)

===WRAPPER (ours)===EXAMPLE OUTPUT===END WRAPPER===
import random  
                random_number = random.randint(1, {input}) 
                print("Random number between 1 and 10:", random_number)[end-code]

===WRAPPER (ours)===EXAMPLE INPUT===END WRAPPER===
nums = [1, 2, 3]
                length = len(nums)
                i = 0
                while i + 1 < length:
                    nums.append(nums[i] + nums[i + 1])
                        i = i + 1
                print(nums[len(nums) - 1])

===WRAPPER (ours)===EXAMPLE OUTPUT===END WRAPPER===
nums = [1, 2, 3]
                length = len({input})
                i = 0
                while i + 1 < length:
                    nums.append(nums[i] + {input})
                    i = i + 1
                print({input}[len(nums) - 1])[end-code]

===WRAPPER (ours)===THE CODE TO CONVERT===END WRAPPER===
===WRAPPER (ours)===the code from step 1, without line numbers===END WRAPPER===
