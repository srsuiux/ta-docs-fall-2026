Who Decides? Decision-Level Control of AI Help for Novice Programmers 

Oct 7, 2026 · @Sundar Raj 

Introduction 

This is my thesis proposal draft worked so far, in which I want to share where I am right now, and get feedback before I start building the tool and before I send the IRB application.  

My main question is simple: when a beginner uses AI to solve a programming problem, which decisions should the student keep, and which ones can the AI take, so the student still learns. 

How I got here 

I started with a broad interest in student autonomy and AI in education, especially in learning programming. 

I read Kazemitabaar et al. [1] closely and also tried their Lead-and-Reveal app myself. 

One thing stood out to me. In all seven techniques, the AI writes the solution and makes the decisions. The student only reacts to what the AI gives. 

Their limitations point out the same way. Students were assigned a technique, and the authors say future tools should guide users "in the hierarchical decision-making process" [1]. 

After that I read around 15 related papers to check if someone had already done this. I have summarized papers, and I checked the main points against the papers myself. 

Then I wrote my first decision breakdown by hand, for a palindrome problem, using the same assessment format we use at YSU (I see these as a TA). 

The problem 

AI tools can now provide a full solution for most intro programming problems. So, a beginner can finish the work without making the decisions that actually build the skill [1, 3]. 

The papers I read show this in a few ways: 

Students who used AI freely did well while practicing, but worse once the AI was taken away. 

Strugling students skipped the planning part and jumped straight to code. They also thought they did better than they actually did. 

Students who let the AI write the whole solution in one prompt did the worst later, when they had to change code on their own [12]. 

Some tools try to fix this by adding friction, meaning the student has to work with the AI code before using it. This helps a bit. But in these tools the AI still makes every decision: the approach, the logic, the data and the edge cases. What we don't know is which of those decisions the student needs to keep for learning to happen. 

 

 

 

 

What has been done so far 

The main paper.  

Kazemitabaar et al. [1] tested seven "cognitive engagement techniques" plus a baseline with undergrads from a data structures course (N=82, then N=42). None of the techniques beat the baseline on the no-AI coding test in a significant way. Lead-and-Reveal was the only one where students' confidence matched their real skill. In every technique, the AI made the decisions. 

Problem-solving stages. Loksa et al. [2] taught students six problem-solving stages, from reading the prompt again to testing the code. Students who learned the stages got more done on their own and felt more confident. I use these stages as the base for how I split decisions. 

Planning seems to be the important part that matters. 

Struggling students skipped early planning when they had AI [3]. 

Planning hints were linked with higher grades [13]. 

When students ask AI on their own, they mostly ask for debugging help, almost never planning [13, 15]. 

Teachers worried that showing pseudo-code gives away the algorithm [4]. 

 
Control between the student and AI.  

Students say they want more control, teachers want more restrictions or guardrails, and both like "teacher sets the limit, student picks inside it" [6, 7]. But these were surveys, no learning was measured. Studies that did test control with learning outcomes were in physics and math, not programming [8, 9]. 

How to test it without AI.  

Kazemitabaar et al. [5] used a no-AI post-test and a retention test one week later. Bastani et al. [10] and Sankaranarayanan [14] also showed why the no-AI test is important: the harm only shows up once the AI is gone. 

The gap 

From what I found, no one has split a programming problem into separate decisions and then tested who should own each one, the student or the AI. 

No decision-level breakdown. Current tools treat the problem as one block that the AI solves. The main paper itself says "future tools should therefore focus on decomposing code hierarchically and guiding users in the hierarchical decision-making process" [1]. 

No test of who should own which decision. Papers point to planning as important [3, 13], but nobody compared students who keep planning vs students whose AI plans, in programming, with a no-AI test. 

Students were assigned, not given to the agency (students having control over their own decisions). The main paper says: "Participants were also assigned to specific techniques in our experiments… Future work could explore providing this agency and examine user preferences over time" [1]. My study is a first step here, by testing what happens when specific decisions are given back to the student. 

      

Not true beginners. The main paper used data structures for students [1]. I want to study CS1 students, undergrads students, early-stage degree students, who are real beginners. 

 

CS1 students → Students taking their first programming course. They are usually beginners learning basic programming concepts.  

Data Structures students → Students taking a more advanced programming course focused on data structures such as arrays, linked lists, stacks, queues, trees, graphs, and algorithms. 



Research questions and hypotheses 

I compare three ways the AI can help, which I call conditions: 

A. Student plans: the student makes the planning decisions (approach, logic, data, edge cases). The AI only helps turn that plan into code. 

B. AI plans: the AI makes the planning decisions and shows them. The student writes the code. 

C. Plain AI: the AI gives the full solution an explanation, like the baseline in [1]. 

(student is impacted by the use of the ai, outcome). 

Todo-Ref Rq-2: does the higher score of the a vs b and c still show one week later.  

 

-we should not put ai in control.context(Education& learning) 

 

RQ 

Question 

My hypothesis 

 

RQ1 

Do students score higher on a no-AI coding test after practicing in condition A, compared to B and C? 

Yes. A will be highest, because planning is the part students skip with AI. 

RQ2 

Does the difference(a/b/c) still show one week later? 

-todo ( rep),a, b and c 

Yes, A will still be highest on the retention test. 

RQ3 

In condition A, does students' confidence match their real score better? 

Yes. Making their own decisions should give them a higher sense of what they can do. 

  

Higher – replaced – honest.  

 

 

Confidence score: How confident is the student about their own answer.  

Real score: The actual score the student has received. 

 

Variables:  

A variable is anything in my study which can be different from one student, or one situation 

To another.  It is called variable because it varies across different situations.  

In. My study, which conditions the student will gets. A, B , C.  

When we assign it to the student, all the A, B, C are the. Independent variables.  

Independent variables change on purpose (the conditions). They vary, but they are not impacted, they changed by their own. 

(does not impacted by the study) 

(Sugar is sweet, put into water, sweeter, analogy) 

Dependent variables is the result of the study, we measure to see if our change outcome (test score and the 

Confidence score)  

Controlled variables – other things that could affect my results, which we keep the same for all the students. E.g keepig same problems for all the students, and keeping only the order of the conditions 

Is altered, and the pretest score for the prior skills. 

 

Every student gets the same set of problems (for example palindrome, reverse an array, count vowels). 

Why: if one student got easy problems and another got hard ones, their scores would differ because of the problems, not because of A, B or C. 

 

Each students will get the three possibe orders. Shuffling A, B and C. and we can repeat the oder for students.  

 

 

 

What it is 

Independent (what I change) 

Condition: A, B or C 

Dependent (what I measure) 

No-AI test score, 1-week retention score, confidence vs real score 

Controlled 

Same Problems for all the students, only the order of the conditions is rotated, and the pretest score for the prior skills. 

 

 

Key terms 

Term 

What I mean by it 

Novice 

A student in their first college programming course (CS1), with at most one semester of programming before. 

Decision 

A choice the solver has to make to solve the problem, like which approach to use or what inputs could break the code. 

Planning decisions 

Approach, logic, data and edge cases. Everything before writing the actual code. 

Friction 

When the AI makes the student do some work before showing or using the code [1]. 

Leak 

When the AI gives away a decision that was supposed to stay with the student. 

No-AI test 

A coding test the student does alone, without any AI, after practicing. 

Retention test 

The same kind of test, one week later. 

Confidence match (calibration) 

How close a student's own guess of their skill is to their real test score [1]. 

 

How I break a problem into decisions-Current Reading.  

I split every problem into five decision types. To make sure this isn't made up by myself, I followed the Previous paper, based it on the six problem-solving stages from Loksa et al. [2]: 

Reinterpret problem prompt. Programming tasks typically begin with some description of a problem, which programmers must understand, interpret, and clarify. As with other forms of problem solving, this understanding is a cognitive representation of the problem used to organize one’s “continuing work”. The more explicit this interpretation process, the more likely a programmer will overcome ambiguities in the problem. 

Search for analogous problems. Programmers draw upon problems they have encountered in the past, either in past programming efforts or perhaps in algorithmic activities they have encountered in life (e.g., sorting a stack of books or searching for one’s name in a list). By reusing knowledge of related problems, programmers can better conceptualize a problem’s computational nuances. 

Search for solutions. With some understanding of a problem, programmers seek solutions that will satisfactorily solve the problem by adapting solutions they have used in the past or by finding solutions in textbooks, online, or from classmates or teachers. 

Evaluate a potential solution. With a solution in mind, programmers must evaluate how well this solution will address the problem. This includes actions like feasibility assessments, mental algorithm simulations, or other techniques of sketching or prototyping a solution before implementing it. 

Implement a solution. With an acceptable solution in mind, programmers must translate the solution into source code using their knowledge of languages and tools. 

Evaluate implemented solution. After implementing a solution, programmers iteratively converge toward a solution by evaluating how well their current implementation solves the problem. This typically involves software testing and debugging. 

 

 

--  

Impact of the learning outcome using AI, vs not using AI.  

 

 

      

 

The five decision types, with my palindrome example (first draft): 

Decisions 

What gets decided 

Palindrome checker(example) 

Approach 

The plan ( plan could be overall plan or just a plan). Plan is like a blueprint or not it could just be the basic outline 

Compare from both ends, or reverse the string and compare 

Logic 

The steps and conditions 

Loop until the two ends meet, stop at the first mismatch 

Data 

What to store and how 

Keep the string and two index variables 

Edge cases 

Which inputs could break it 

Empty string, one letter, mixed case, spaces 

Syntax 

How to write it in C++ 

std::string, indexing, while loop, tolower 

 

 

How they map to Loksa's stages: 

Decision 

1 Reread prompt 

2 Similar problems 

3 Find a solution 

4 Check the plan 

5 Write code 

6 Test 

Approach 

✓ 

✓ 

✓ 

 

 

 

Logic 

 

 

✓ 

✓ 

 

 

Data 

 

 

✓ 

 

 

 

Edge cases 

✓ 

 

 

✓ 

 

 

Syntax 

 

 

 

 

✓ 

 

 

Where it doesn't line up with Loksa: 

Loksa has no separate stage for data or edge cases 

 

The addition of the decision steps here. (data, and the Edge Cases).  

Decision steps or framework together, (approach, logic, data, edge cases, syntax.).  

 

 

 