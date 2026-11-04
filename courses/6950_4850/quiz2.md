# Quiz 02 – Chapter 8: Physical Database Design
CSCI 4850 / 6950 · Fall 2026 · 20 questions · 1 point each · 20 points

**Instructions:** This quiz covers Chapter 8: Physical Database Design (sequential files, hash files, Btrees and B+trees, bitmap indexes, and index selection). It has 20 questions, 1 point each (20 points total).
- Questions 1–15 are multiple choice. Choose the one best answer.
- Questions 16–20 are fill in the blank. Type one word or short term in each blank. Spelling matters, but capital letters do not.

---

## Part A – Multiple Choice (Q1–15)

**1. Which file structure is the simplest?**
- A. Sequential file ✅
- B. Hash file
- C. Btree
- D. Bitmap index

**2. In an unordered sequential file, records are stored in which order?**
- A. Key order
- B. Insertion order ✅
- C. Alphabetical order
- D. Random order

**3. A hash file is best for which kind of access?**
- A. Sequential search
- B. Range search
- C. Fast access by a unique key value ✅
- D. Columns with few values

**4. What is the typical hash function used in hash files?**
- A. Log function
- B. Average function
- C. Count function
- D. Mod (remainder) function ✅

**5. Hash files have poor performance for which kind of search?**
- A. Sequential search ✅
- B. Search by unique key
- C. Single row lookup
- D. Exact match search

**6. A static hash file usually needs reorganization when it is more than about ____ full.**
- A. 10%
- B. 70% ✅
- C. 30%
- D. 100%

**7. A Btree is what kind of tree?**
- A. Binary tree
- B. Linked list
- C. Multi-way (bushy) tree ✅
- D. Hash table

**8. A Btree gives good performance for which searches?**
- A. Only sequential search
- B. Only key search
- C. Neither sequential nor key search
- D. Both sequential search and key search ✅

**9. The cost of a Btree operation mostly depends on the tree's:**
- A. Height ✅
- B. Width
- C. Number of columns
- D. Root name

**10. In a B+tree, all keys are stored in which nodes?**
- A. Root node only
- B. Leaf nodes ✅
- C. Middle nodes only
- D. No nodes

**11. A bitmap index is best for columns with:**
- A. Many unique values
- B. Frequent updates
- C. Long text
- D. Few values ✅

**12. In a bitmap index, how much space is used for each row?**
- A. One bit ✅
- B. One byte
- C. One page
- D. One table

**13. The main tradeoff when selecting indexes is:**
- A. Rows vs. columns
- B. Users vs. tables
- C. Retrieval speed vs. update speed ✅
- D. Color vs. size

**14. Which column is a good candidate for a clustering index?**
- A. A frequently updated column
- B. A long text column
- C. A column that is never used in queries
- D. The primary key ✅

**15. A frequently updated column is:**
- A. The best index candidate
- B. Not a good index candidate ✅
- C. Always the primary key
- D. Required to have a bitmap index

---

## Part B – Fill in the Blank (Q16–20)
Pattern match, case-insensitive, extra spaces ignored.

**16.** The ______ function is the typical hash function used in hash files.
- Answer: **mod** (accepts: mod, modulo, modulus, mod function)
- Pattern: `(?i)^\s*mod(ulo|ulus)?(\s+function)?\s*$`

**17.** In a ______, all keys are redundantly stored in the leaf nodes.
- Answer: **B+tree** (accepts: B+tree, B+ tree, B+-tree, B+ trees)
- Pattern: `(?i)^\s*B\s*\+\s*-?\s*trees?\s*$`

**18.** When two different key values hash to the same address, it is called a ______.
- Answer: **collision** (accepts: collision, collisions, a collision)
- Pattern: `(?i)^\s*(a\s+)?collisions?\s*$`

**19.** A ______ index is useful for stable columns with few values.
- Answer: **bitmap** (accepts: bitmap, bit map, bit-map, bitmap index)
- Pattern: `(?i)^\s*bit\s*-?\s*maps?(\s+index(es)?)?\s*$`

**20.** The ______ of a Btree mostly decides the number of physical record accesses for an operation.
- Answer: **height** (accepts: height, the height)
- Pattern: `(?i)^\s*(the\s+)?height\s*$`

---

## Answer Key
| Q | Ans | Q | Ans | Q | Ans | Q | Ans |
|---|---|---|---|---|---|---|---|
| 1 | A | 6 | B | 11 | D | 16 | mod |
| 2 | B | 7 | C | 12 | A | 17 | B+tree |
| 3 | C | 8 | D | 13 | C | 18 | collision |
| 4 | D | 9 | A | 14 | D | 19 | bitmap |
| 5 | A | 10 | B | 15 | B | 20 | height |
