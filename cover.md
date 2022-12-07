---
title: "Cover letter"
author: Lily Lin
---

## Intro

Over the course of the term we got to learn about a number of optimization problems and saw how they could be solved using various libraries and techniques. While watching these problems get solved I often found myself wondering how things would go differently if some things were changed and that formed the basis of some of my learning portfolio entries. The rest of my learning portfolio entries are mainly focused on connecting problems we learned in class to other areas and seeing how these problems can be applied in different contexts.

My approach to exploring new problems is always to poke around and try new things. In class we would see an example of something that worked, but I would always wonder how changing this variable or using this slightly different strategy would affect the resulting solution.

- In [this](/math441-learning-portfolio/post/smaller_network_matrix_tests/) portfolio entry I explored the efficiency of the matrix representation of network flows we saw in class, and show that it's actually very inefficient and scales poorly
- In [this](/math441-learning-portfolio/post/alternative_nearest_neighbours/) portfolio entry I considered a different greedy algorithm for the Travelling Salesperson problem, one where instead of just locally looking for the nearest neighbour the algorithm instead looks ahead further in the tree of possibilities. This was inspired by chess and other game algorithms that look many moves ahead to choose the optimal one for the current turn.

Many problems also were a good fit for making pretty pictures, which is something I always enjoy doing. Many of these greedy algorithms can be quite abstract to reason about and are much more accessible when viewed visually. In [this](/math441-learning-portfolio/post/graph_coloring_animations/) entry I wrote code to generate random graphs and visualize a number of different greedy graph coloring strategies. Since the code must be run to generate new graphs, only a static set of graphs and animations are shown on this site

While reading about technology online we often come across various buzzwords and talks about how something or other is the "next big thing" and will "revolutionize the field". When reading about the optimal transport problem I was seeing a lot of those bold claims so I was decided to dive deep into _why_ people are so excited about optimal transport in [this](/math441-learning-portfolio/post/optimal_transport/) entry.

Being a student in computer science as well, part of why these problems are so interesting to computer scientists are their applications to real world problems. In some cases these applications are obvious, like route planning based on the Travelling Salesperson, but in other cases these connections are much deeper and are therefore very interesting to look at.

- In [this](/math441-learning-portfolio/post/graph_coloring_and_register_allocation/) entry I reflect on the problem of register coloring in compilers, show that it's just a graph coloring problem, and discuss how real world compilers solve this computationally difficult problem
- In [this](/math441-learning-portfolio/post/cryptography_and_lattices/) entry I discuss a real world application of a computationally hard problem, the knapsack problem, in a cryptographic context showing how to convert it into a one-way trapdoor for a public key cryptosystem.

Finally, I dive into a problem that bothered me throughout the term: If we're reducing all these NP-hard problems into integer programming and integer programming appears to be quickly solvable by `linprog`, doesn't that mean we have an efficient algorithm for solving NP-hard problems? Where's the catch? In my [last entry](/math441-learning-portfolio/post/how_does_linprog_ip_work/) I discuss this, explain why this doesn't contradict the NP-hardness of these problems, and implement a basic integer programming solver.

## Reflecting on the term

I had a lot of fun working on these over the course of the term, I haven't had any classes like this where both the lecture content and course work are completely free form and allow students to explore whatever they find interesting. I personally found that the lecture style lended well to inspiring questions and prompting me to want to look into these problems, so I never had a lack of ideas to work on. I will say that not being proficient at writing code would be a large roadblock as a lot of these these fun ideas really were best explored by writing code and seeing what would happen.