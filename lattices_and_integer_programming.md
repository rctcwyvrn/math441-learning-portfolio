# Learning portfolio: Cryptography, Lattice problems, and integer programming

plan: discuss LLL -> what it is, why it was made, applications to knapsack and IP

- lattice problems are a popular way to develop cryptographic primitives
- based on a set of np hard problems without good solvers -> average case is also hard, not just worst case-hard
- more importantly, these np hard problems dont scale well in current quantum algorithms
- so post quantum crypto is pretty dominated by lattice algorithms
- some lattice problem examples (svp, cvp)
- one algorithm for solving these problems is LLL, which reduces the lattice to a smaller basis (?)
- here's how it works

- it turns out that LLL is also a method to solve integer programming problems with https://github.com/GaloisInc/blt
    - LLL provides a polynomial time algorithm for checking the feasibility of a point
    - you can reduce the optimization problem to a feasibility problem by guessing the optimal value using binary search
- https://github.com/GaloisInc/blt

- knapsack cryptosystem 
    - http://www.cs.sjsu.edu/faculty/stamp/papers/topics/topic16/Knapsack.pdf https://mathweb.ucsd.edu/~crypto/Projects/JenniferBakker/Math187/ 
    - one based on the knapsack problem
    - solvable by lattice methods