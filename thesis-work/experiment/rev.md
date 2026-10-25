# Experimental Note.

T6 (Explain-Before-Usage) session on small C++ problem (Voting Eligibility). The AI tutor (GPT) gave the full solution first, then asked some questions, one at a time. The student answered each one, got a score from 0 to 5, and retried to answer when the answer is not complete or marked as complete.

The ai decides everything here.  and The student only explains The ai chose the approach, the logic, the variables, the condition, and the output of the code. The student here has never made a decision.

It's one way and the tutor picks the questions, picks which lines to ask about, and scores the answers. The student can't change any of the questions and all.

It's "understand after the fact type of the chat" The student reads the finished code and describes it in the own words. That is the act of the problem solving -what can be a word which is act, and preception of problem solving via a basic thinking and interactions., not problem solving.

The questions are mostly "what does this line do." Q1, Q2 and Q4 are about reading code (variable and input, the ">=" check, "return 0"). That's close to the syntax the prompt says not to teach.

The feedback loop engagement is good. Short feedback, a score, on what's missing kept the student engaged.


The student never tries to find the why  and also either ai or student both ,nobody assk the why the 18 is the cutoff and it did not raise the hypothetical edge cases, like can age taken be -ve, or so, although all this are hypothetical as we cant really say that age can be negative, tha's a basic logic, still it is valid to think as those i beleive to be the real decisions.

Scoring is  very generous. some scoring cases -->"We are coming out of main and returning 0" got 5/5. A student can score well by paraphrasing code they're looking at, so the score may show "can read" rather than "understands."

The retry feedback leaks the answer to the code. When student fails to answer,and retries to, then in such cases the answer is almost leaking, but it could be a small hint, as student is trying to get there. 

There's no check for the illusion of learning. The student only sees the solution and basically just about it and we can't really see that either we can write the code or not.

The student has no control over the process. They can't ask for a hint instead of the solution, pick which parts to attempt, or choose how much help to get. The student's own note says the same thing: the solution is exposed up front and they can just paste it.

The assignment is too small to show anything. There are almost no decisions in it, so this technique can't be judged on it.

The problem is very small for this use cases so thre is almost no decisions, in it. the overall decision for this programming problem can be**


What's needed for decision-level control (my thesis angle)

my thesis question is who decides what. Break the problem into the layers 
i already planned: approach, logic, data, edge cases, syntax. Then look at T6 layer by layer:

| Layer | Who decides in T6 |
|---|---|
| Approach (what the program must do, in what order) | AI |
| Logic (the condition, the threshold) | AI |
| Data (what to store, which type) | AI |
| Edge cases (exactly 18, negatives) | AI, and never even discussed |
| Syntax | AI |

here the student decides nothing, so T6 is basically the baseline itself i guess, and it is the questtions interactions added on the top of it.  That fits what actually the dr G, said in the last meeting when we are discusing and shaping the RQ's: the full-AI condition is the baseline from the prior paper but still there is a differentiation from the true baselie. whch directly exposes the solution. and also here we got the exposed solution first and learned later. it's a baseline + interactions.

Things that could be added at the decision level: