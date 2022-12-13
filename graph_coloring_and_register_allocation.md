---
title: "Graph coloring and register allocation"
author: Lily Lin
geometry: margin=2cm
output: pdf_document
colorlinks: true
---

The source code for this entry can be found at [https://github.com/rctcwyvrn/math441-learning-portfolio/blob/master/graph_coloring_and_register_allocation.md](https://github.com/rctcwyvrn/math441-learning-portfolio/blob/master/graph_coloring_and_register_allocation.md)


While implementing a compiler for CPSC 411 last year we had to implement a register allocator, which is a real world usage of graph coloring. It has some cool computational properties and it's use of graph coloring is pretty interesting so I thought I would write about it for my learning portfolio. It turns out that for register allocation of real programs, the problem is so large that even a greedy approximation is too slow and an even faster algorithm is required!

## What is register allocation and why is it important?

Register allocation is a key pass in a compiler and represents one of the major shifts in abstraction that a compiler targetting assembly takes. 

Abstractly speaking, a compiler lowers a high level language to a lower level language, so one can represent a compiler as a series of passes that take a feature/abstraction that exists in the higher level language and represent it equivalently in terms of the lower level language. Register allocation is one such pass that removes the abstraction of physical memory. For all but the lowest level programming languages, you don't want to have to consider where your variables are physically stored because it's extremely difficult to keep track of, therefore almost all languages will handle allocation of these variables to physical registers/memory locations in a register allocation pass.

So basically the register allocation pass just has to assign each variable to live in some part of physical memory, easy right? 

The first problem is that we can't have two variables living in the same location. How do we get around this? There's actually an easy fix for this, 64 bit architectures have massive address spaces so we can actually just assign each variable to it's own location in memory. This technique does in fact work as a register allocator, but it has a serious problem.

**Not all storage is created equal**, some are fast and some are slow. Typically the idea of CPU design is to have very fast storage very close to the CPU, and as you physically get farther and farther away from the CPU storage gets slower but much much larger. To do our previous strategy we would have to allocate all variables to RAM, and while we could allocate everything to faraway RAM memory where we have basically "infinite" space, our resulting programs will be **slow**. **Extremely slow**. Orders of magnitude slower. 

So why not just put everything into the faster memory? Well for that we have very limited space, with the fastest memory being registers, which we only have around 15 of at a time. However we now have the issue of having many variables in a program that want to live in a limited number of registers. Do we see where I'm going with this? Two variables can be assigned to the same register by the register allocator _as long as they aren't being used at the same time_. So the problem of assigning variables registers then becomes like the exam scheduling problem, where two variables (exams) who are both being used at the same time (there's a student in both) cannot be assigned to the same register (exam timeslot).

We've seen in class that this exam scheduling problem becomes a graph coloring problem, which we can then solve using a greedy algorithm. However it turns out that register allocation is actually different. In math 441, we've discussed many NP-complete problems, problems which take exponential time to solve optimally and quickly become unfeasible to solve optimally in a reasonable amount of time. Usually this leads us to approximate them using things like greedy algorithms. Register allocation actually goes even further, it is in fact _impossible_ to write a program that can produce optimal register allocations for all programs. The register allocation problem is in fact "unsolvable" 

Why?

## Why is register allocation hard?

Most people have heard of the [halting problem](https://en.wikipedia.org/wiki/Halting_problem), which is a problem proven by Alan Turing in 1986 to be impossible to write a program to solve. Not just slow, but impossible to write if you want it to be correct and stop on all inputs.

A lesser known fact is that the halting problem is in fact a special case of [Rice's theorem](https://en.wikipedia.org/wiki/Rice%27s_theorem), which states that _all non-trivial semantic properties of a program are undecidable_, meaning you cannot write a program (or more generally, a Turing machine) that can produce the right result and always halt. Rice's theorem is a massive buzzkill in general because it means that anything cool our compilers want to do is actually _impossible_ to do optimally for all programs. Sucks.

The part of Rice's theorem that applies to our plan for implementing a register allocator is the idea of knowing when each variable is in use. It turns out that knowing exactly if a pair of values will be used at the same time and thus have a conflict is impossible to solve generally, so we have to approximate it.

The actual algorithms employed by compilers to approximate usage conflicts are varied and complicated but the basic idea is 
1. Figure out how long a variable is "alive" for, which is essentially the lines of code between when it is first used and when it is last used
2. Produce one of those liveliness ranges for all variables
3. If two variables have overlapping liveliness ranges, then they are in conflict and cannot be allocated together

So this then results in a set of nodes and a set of conflict edges, which we can solve using graph coloring, with the caveat that we have slightly different rules for coloring. We have a set number of colors for registers, and then an "infinte" number of colors for locations that get allocated into RAM (which is called _spilling_).

## What algorithms do real compilers use?

Our first instict is probably to use a greedy algorithm like largest first, but it turns out that this is actually too slow! Our register allocator will need to assign many many locations so even the sort is too costly for the compiler. So what do we do?

In many other [real world compilers](https://gcc.gnu.org/wiki/RegisterAllocation) use a different heuristic for choosing which nodes to color first, one that only takes linear time. The [idea](https://dl.acm.org/doi/pdf/10.1145/872726.806984) is based on the fact that if you have 32 colors and a node that has less than 32 neighbors, then as long as you can color everything else, you must be able to color that node. Now this is always true, but it fails to hold if we repeat this process and remove more and more nodes. However this still gives a good heuristic on which nodes should be able to be colored last, so instead of doing an expensive sort what we can do is just repeatedly remove nodes that have fewer than _k_ edges and color those last 

This gives us the algorithm
1. Remove a node that has fewer than k edges
2. Check if removing that node made another node now have fewer than k edges, if so then go back to 1
3. Otherwise all nodes have k or more edges, so remove a random node and to go 2
4. Once all nodes have been removed, color them in the reverse order that they were removed in

This general strategy first described by Chaitin is generally quite successful and over the years the core structure of the algorithm has stayed the same, just with various additional heuristics on which nodes to remove.

### What about a normal graph coloring algorithm?

In the last section we discussed a graph coloring algorithm that runs in linear time by not having to sort the nodes, which you have to do for strategies like largest first. This raises the question though, how much does this focus on speed affect the resulting register allocation?

[This paper](https://apps.dtic.mil/sti/pdfs/ADA456095.pdf) customizes the `gcc` allocator to instead use an ILP and [an optimizer](https://www.ibm.com/analytics/cplex-optimizer) to solve the graph coloring problem the register allocator generates to see the differences in compiler runtime and produced binary runtime, and surprisingly it found that the coloring heuristic is in fact 99.9% able to color as well as the ILP version despite being much faster to run. 

In fact if the ILP is unable to consider additional properties of the register allocation problem (ie: more information from other analysis passes), the resulting ILP allocation is actually worse in many cases! Even with some of those addtional aspects added onto the ILP, the optimal coloring doesn't always beat the heuristic based coloring, for example in cases where the heuristic based allocator is able to correctly assign a register to an "ideal register" at the cost of causing many spills, knowing that this "ideal register" would be so good for performance that the additional spills don't matter. The ILP is unable to incorporate this and thus loses in some programs! 

The key observation that this paper makes is that this heuristic based allocator and it's implementations in modern compilers have the benefit of being highly customizable to the register allocation problem and the specific details of it, while the ILP version is "just" a graph coloring with some of the extra details tacked on, so the benefit of a slightly more optimal coloring is lost in the inability to consider real world details. 

It's interesting to see how what we learn in class might seem like it would be "optimal", but once it reaches the real world and its actual applications of these problems we might see that these algorithms can be beat by much simpler, purpose built algorithms like this register allocation heuristic.