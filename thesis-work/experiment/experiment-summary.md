I have selected three engagement techniques from the paper.

1. Baseline (T1)

which is the baseline - just direct interactions or engagemnt with the AI

- The AI makes every decision in one go. e.g Approach, logic, data, edge cases and syntax all come together as competed code. The student never has to make any of those calls.

- The decisions that matter most for learning go first. Approach and logic are the hard thinking for a early stage programmer or Students, and the AI provides them before the students have tried.

2. explain before usage (T6)

- The AI tutor, which dumps the code and interacts with the student in such a way that the student has to answer questions, reveals parts of the code based on the interactions, and leads the student to understand each step or line of code. This keeps the student leanring in the lopp which is backed by the decisions but the decisions here are made by the AI. 

- The AI writes the full code, then decides how to split it into pieces and which question goes with each piece. The student’s answers don’t change what the code is. They only unlock the next piece.

The Experiment log with the GPT. 
[explain-before-usage/explain-before-usase.md]

3. Lead and Reveal (T7)

- This is the best outcome of the paper. It interacts with the student by asking questions and revealing relevant parts of the code based on the student's answers. These interactions guide the student toward understanding the code and building the final solution. The student has a maximum of three attempts to answer each question correctly. If all three attempts fail, the tutor reveals the correct code for that line.

- The decision level issue I find here is that all the interactions and all the control are with the AI tutor. The AI decides everything here, and the student only answers the questions and follows the path the AI has set.

- T6, is Better than the baseline because the student has to think here but the thinking is guided by the AI tutor at every step of interactions, the student has never own the devision. Here the owning means that deciding when i choose what decison and when i need to ask AI for Help. 
- The AI tutor picks the apporach as per the paper, the solution is already choosen and saved, and student actually never decides how to solve the problem. 
- The AI tutor picks what is logged in the interactons, and what are the steps being saved in order, that means the AI decides how the problem breaks into the decisions, and the student sees the code in which ai wants to show the student. 
- It fel't like guessig towards the answer, as the guess also needs thinking but - needs to work on this. 
- And the only valid answer or correct answer it locked in, otherwise it keep prompting for the answeer from the user, and in 3 retries it and finally it reveals the code, as it feels like the decision were bieng obverridden.
- The decision are here line level, each lines of code the Ai reveals. 
- Student can;t say that i will do this part and i will do this i need help and hints and all. so the student can;t decide. 

The Experiment log with the GPT. 
[baseline/t7-lead-reveal-iter1.md]
[baseline/t7-lead-reveal-iter2.md]

All these experiments were conducted using the free web version of GPT.

According to the paper, the authors released the project as open source on GitHub. However, the project requires an API key to test it. Therefore, I decided to use the free version of GPT and use the underlying LLM as the tutor.

Since the free version of GPT uses baseline models, I realized that GPT cannot reliably store the code simply by instructing it to do so, as it processes everything in real time based on the context provided throughout the conversation.





