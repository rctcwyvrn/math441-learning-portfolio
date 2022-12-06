# Learning portfolio: Solving mixed-integer linear programming with scipy 

## What's wrong with linprog?
During class when we want to solve integer programming problems we've used the same `scipy` `linprog` solver that we used for linear programming, but just with the `integrality` parameter set. In class we've claimed that this produces the "optimal" solution for these integer programming problems and we've seen that integer programming is much more efficient than using a bruteforce combinatorial method. Some of the examples of problems we've solved using this method are NP-complete, problems that are currently unknown to be solvable in polynomial time. 

While reading the register allocation paper they mention that the ip solver finds the 'optimal graph coloring', which seems weired to me. do ip solvers actualy solve ip problems optimally???

This seems to present us with a contradiction
- NP-complete problems like sudoku can be represented using an IP problem
- IP problems can be solved optimally and efficiently using `linprog`'s integer programming solver
- It is currently unknown if NP-complete problems can be efficiently solved

So I believe there's some details that we glossed over when using `linprog` in class. Obviously `linprog` doesn't imply P=NP so we must be missing something here

Possibility #1: `linprog` fails to find the optimal solution in all cases. Maybe it only solves IP problems optimally _most_ of the time

Possibility #2: `linprog` explodes in runtime in some edge cases. Maybe it only has a polynomial average runtime, but an exponential worst case runtime

It seems likely that the real reason is some combination of the two, so let's find out!

## Mixed integer linear programming (MIP)

Mixed-integer linear programming problems are things we've encountered over and over while analyzing problems in class so I don't need to explain why they're important.

But how do solvers account for the fact that some of the parameters must be integers? Linear programming typically solves for values over the reals. How does it handle binary values like what we've seen in many IP decision variables? You can't just round to the nearest integer if you have a value between 0 and 1.

linprog is a wrapper around highs https://highs.dev/

how does highs solve MIP problems? https://en.wikipedia.org/wiki/HiGHS_optimization_solver#Mixed_integer_programming branch-and-cut solver?

https://www.sciencedirect.com/science/article/abs/pii/S0167819120301071  "However, finding the optimal answer of ILP models is an NP-Hard problem and remains a computational challenge. " aha! it isn't optimal! so there must be cases where these algorithms fail.

so what i want to know is, how and why do branch and cut methods fail?

https://en.wikipedia.org/wiki/Branch_and_cut 
- branch and bound
- cutting planes for tightening linear programming relaxations

so how exactly does branch and bound work?
1. solve the linear equivalent with simplex
2. use cutting plane to find additional constraints 
    - constraints that any feasible integer solution must satisfy, but that the current solution does not
        - we know that this optimal value must be >= the best integral solution
        - so it essentially bounds which integral solutions we want to look at in general
    - add these constraints and solve again, hoping that the new solution is "less fractional"

from here we want to explore a tree of problems to find the best solution that is both optimal and integer
- we want to generate a tree of problems to explore
- the tree should cover the entire search space
- the branches of a node should be "related" to that problem in some way
- because of ^, we should ignore all the children of a node if we determine that a node is not as good as our current solution
    - only keep solutions that are better than our current best integer solution, even if they arent integer
        - the relaxed solution gives an upper bound on the true integral solution for this problem -> prune it if the upper bound is bad
    - ^ keep their children in the tree
    - keep searching for integer solutions, save the best integer solution that we have
- stop when all branches have been pruned and there's nothing left to search

from this we can guess that the worst case will always involve searching the entire tree
- computational complexity concept: adverserial input
- given whatever branching algorithm, i can give you a problem that makes you never prune any branches and end up searching the entire tree
- worst case time is exp

branching methods
- the crux of the algorithm
- how to branch so that pruning makes sense
- branch on a variable
    - choose a variable with a fractional part
    - create two subproblems -> one where its bounded to be less than or eq to the floor, and one where its bounded to be greater than or eq to the ceiling
- how to choose the variable?
    - choose the most infeasible -> closest to 0.5
    - approximate the change in objective function when each variable is branched on -> choose the one predicted to have the greatest change
    - test each candidate variable to see how it changes the objective function -> then choose the one _known_ to be teh best

cutting planes
- a way of refining a solution that is not integral
- if we solve the relaxed LP and get a non-integral solution, logically it either lies inside the lattice of integral points or outside of it
- there's a theorem that states there must exist a linear inequality (a hyperplane) that seperates the convex hull of the lattice and the optimal solution
    - we want the hyperplane to seperate them
    - set the equality to accept the convex hull but not the LP optimal
- by adding this constraint we can refine the solution iteratively

how do we solve the subproblems in a way that will usually get us feasible integer solutions?
- https://en.wikipedia.org/wiki/Linear_programming_relaxation
- just convert the integer bounds into continuous real number bounds lmao
- but theres more to it -> how to determine the quality of the solution