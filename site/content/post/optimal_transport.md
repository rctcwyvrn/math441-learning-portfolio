---
title: "A deep dive into optimal transport"
author: Lily Lin
geometry: margin=2cm
output: pdf_document
colorlinks: true
---

The source code for this entry can be found at [https://github.com/rctcwyvrn/math441-learning-portfolio/blob/master/optimal_transport.md](https://github.com/rctcwyvrn/math441-learning-portfolio/blob/master/optimal_transport.md)

A quick google search indicates that optimal transport is more than just a linear programming problem about moving resources, and has many far reaching applications

> This basic problem has a wealth of applications within mathematics (in the theory of partial differential equations, geometry, functional analysis, optimization, probability and so on) as well as in other fields (image processing, data science, economics, chemical physics etc.) and is currently an extremely active research area in both theory and applications.

> The Kanotorovich Initiative is dedicated towards research and dissemination of modern OT mathematics towards a wide audience of researchers, students, industry, policy makers and the general public.[^1]

In class we discussed the optimal transport problem and it seemed to just be a special case of network flows. **What is so special about optimal transport?**

The questions I want to answer are
- Why is this specific case of network flows so valued for study?
- What makes optimal transport so widely applicable?
- What are some unique problems that can be solved by optimal transport? We saw image recognition in class but what else can be done?
- What methods are there to solve optimal transport besides linear programming?

# What makes optimal transport special?

The key insight that seems to make OT special is the idea of moving probability distributions

1. Many many many things can be modelled as a probability distribution over a space. Things like images, words, people, or really anything with a structure that you can map to a vector space.
2. OT can be used to solve how one probability distribution can optimally be "transformed" into another space. Since so many things can be represented by probability distributions we'll see how this idea leads to widespread applications.

The way OT provides it's solution gives a number of other applications as well

3. It can say how "hard" it is to move one distribution to another, giving the ability to compare the "similarity" of probability distributions
4. It gives a continuous set of "inbetween" distributions, essentially interpolating the two distributions by moving the points in their optimal direction but not all the way

So from what I've read, it's these 4 benefits of OT that make it such a fruitful area of research. The first point makes it extremely flexible and applicable. Point 3 and 4 allow you to mathematically compute interesting things about probability distributions that you can't by other methods

And finally the point that ties it all together:

5. It can be formulated as a linear programming problem, which has many highly optimized solvers like `linprog` or `pulp`

# What are some stuff optimal transport can do?

The image recognition project idea that we discussed in class is a clear example of using that 3rd property, we can compare a given image (represented by a distribution) with a bunch of known images (also represented as distributions) and determine which one is the most similar, giving us some rudimentary image recognition

This blog post has many interesting examples [^2]. Let's look closely at the color transfer example

## Image color transfer using optimal transport

One thing someone might want to do is to map the colors of one image onto the general shape of another. In the example shown in the blog post [^2] optimal transport is used to map the colors of a daytime photo of the ocean and sky (mostly blues and whites) onto a sunset photo also of the ocean (mostly oranges, reds, and blacks).

![Color transfer photo](https://miro.medium.com/max/720/1*RDc5ZWTVJmUgOh5JW27qIA.webp)

How exactly does this work?

From my understanding, what is happening is first each pixel is mapped onto a point in the RGB R^3 space. We can then interpret these sets of points as our sources and sinks for optimal transport with costs as the euclidean metric. So this creates a mapping from a colored pixel in one image to a colored pixel in the other image, replacing the sunset image's pixels with the corresponding sink in the optimal transport solution results in the color transferred image.

But why does this work? Optimal transport will attempt to map one distribution to another because that results in the minimal amount of transport. So essentially black-ish sunset colors are mapped to black-ish daytime colors and light-ish sunset pixels are mapped to light-ish daytime pixels. So the distribution of reddish pixels are mapped onto the daytime distribution of blue-ish pixels. The result is that "bright" parts of the sunset image stay "bright", but they're now "bright" in the daytime image's distribution of colors.

Seeing a physical example of how this idea of mapping distributions is really cool!

## Automated translation using optimal transport

Another idea introduced in the blog post was the idea of using optimal transport for translation. I found the idea really interesting so looked more into it by reading this paper by Alvarez-Melis and Jaakkola [^3].

After trying to understand what I could, the conclusion is that... it's complicated

Creating a probability distribution out of a language of words is a well studied problem in NLP. Current state of the art techniques can use neural networks to form associations between words using a large corpus of text and use that to map each word to a vector where nearby words are similar in some way [^4]. 

So using techniques like `word2vec` we can create a probability distribution for each language and we want to use OT to map points of one language to another, but a concept of "distance" between the two distributions is complicated. What's the distance between "cat" and "katze"? They're just two points on two different distributions of words for their respective languages.

The core issue here is that each language could have a totally different meaning for points in it's distributions, so directly comparing a pair of vectors using something like a Euclidean metric would result in totally nonsensical results. To get around this problem the authors instead opt to use a Gromov-Wasserstein distance. 

This metric focuses on trying to map out the *overall structure of pairs in the different distributions*, rather than comparing one point in distribution A and one point in distribution B. 

How does it work? It measures how much it would make sense for a pair of words in language A to be mapped to a pair of words in language B by defining a distance between distances. If the distance between words a_1 and a_2 in language A is similar to that of b_1 and b_2 in language B, then it makes sense to pair a_1 to b_1 and a_2 to b_2.

An example of this could be the words for dog, cat, and rainbow in two different languages. In both languages, the words for "dog" and "cat" should be pretty similar to each other, so the metric would say that the pairs ("dog","cat") and ("Hund","Katze") are close to each other. Similarly the words for "dog" and "rainbow" should be pretty dissimilar in both, so ("dog","rainbow") and ("Hund","Regenbogen") are close to each other. Pairs that don't match would have a high distance in the Gromov-Wasserstein distance, for example ("dog","cat") and ("Hund","Regenbogen") have a high distance because "dog" and "cat" are similar, while "Hund" and "Regenbogen" are dissimilar.

So this metric gives a way of comparing distances between pairs of  words, and we can simply perform OT on the distribution of pairs rather than the distribution of individual words, the solution of which can be converted into a mapping of words between languages, giving us a translation between the two languages!

One major benefit of this method is that we never need to have any knowledge of how language A relates to language B, we only need to know the pairwise relationships of words _within_ each language, making this method extensible to other languages quickly. By using the Gromov-Wasserstein distance and not needing to compare points between the two distributions directly, this technique avoids the problem of having to understand each pair of languages on their own. Once each language is mapped to a distribution, it can be mapped to any other language distribution using this technique! Not only that but we don't even need to fully map each language to a distribution, all we need to do is understand all of the distances between pairs of words, which again simplifies the work required to get a translation.

Overall this sounds like a very cool technique and again a very interesting application of optimal transport.

## Optimal transport and machine learning

Now the last point that comes up often with optimal transport is it's relationship to machine learning, so let's dive into that a little by taking a look at this paper [^5]

> Examples where this approach is useful in machine learning (ML) are ubiquitous and include, for instance, prominent tasks such as training generative adversarial networks (GANs) (Arjovsky et al., 2017) where OT was successfully used to overcome the vanishing gradient problem, and domain adaptation (Courty et al., 2016) where its capacity to align two distributions was used to transfer a classifier across different domains

Interesting, it seems the two major applications are for assisting with training of the models and adapting a model to a new domain. The second application seems pretty intuitive, if we can map the space of a new input to the space that a machine learning model was trained on, we can quickly get a new model on the new input space. 

> Optimal Transport (OT) is a field of mathematics which studies the geometry of probability spaces. Among its many contributions, OT provides a principled way to compare and align probability distributions by taking into account the underlying geometry of the considered metric space.

Comparing this to the conclusion we came to earlier this suggests that the main contributions of OT are the ability to mathematically compare and align. The idea of comparing would be to determine cost of moving one distribution to another and the idea of aligning would be to smoothly interpolate from one distribution to another.

"Taking into account the underlying geometry of the metric space" is an interesting point though. Since we can define these distributions over really whatever space we want, we can also define our own ideas of distance (ie defining distance between images by rgb value instead of something else)

## Solvers for optimal transport

In class we reduced them to LP problems but what about specialized OT solvers? Are there any technqiues that provide better bounds than just linear programming?


Looking at this paper [^5] we see that there are indeed specialized solvers for OT problems, and not just that, there's also specialized solvers for specific _kinds_ of OT problems

> The library provides recent state-of-the-art solvers for various optimal transport problems related to statistics and machine learning. As mentioned earlier, POT has sub-modules dedicated to different problems. In this section, we give a short description of the provided OT solvers.

Looking at the provided `python` documentation [^6] for these functions we see that the solver for general OT problems is something called the "network simplex algorithm"  

Reading the wikipeida article on the network simplex algorithm [^7]:

> In mathematical optimization, the network simplex algorithm is a graph theoretic specialization of the simplex algorithm. The algorithm is usually formulated in terms of a minimum-cost flow problem. The network simplex method works very well in practice, typically 200 to 300 times faster than the simplex method applied to general linear program of same dimensions.

Woah. 200 to 300 times faster than an already pretty fast algorithm? How does it work?

The basic idea is:
1. Start with a solution, which in this case is a spanning tree of the graph. The analogy for this in the normal simplex algorithm is starting at a vertex of the polytope.
2. Attempt to pivot to a better solution by forming a cycle in the tree by adding a node to the tree (analogy: choose an entering variable), and then removing the "weakest link" (analogy: remove the optimal leaving variable). This results in a new spanning tree (analogy: new vertex of the polytope), with a higher value.
3. Now we repeat the process in the same way as the normal simplex: continue to pivot from vertex to vertex until the solution can't find a new entering variable. So the algorithm stops when there are no new edges to introduce that would increase the objective function

Huh that's cool, I wonder what exactly makes this faster than simplex. My intuition is that invertiing the matricies is harder than solving the inherently more "local" problem of considering only the cycle that gets added onto the spanning tree. The idea being that the matrix always has to contain all the variables since entering and leaving variables affect all the other values, while in the network simplex the addition of an edge only affects the local area that becomes a cycle.


# Conclusion

That wraps up my whirlwind tour of optimal transport, I hope you learned something about what makes it applicable to so many problems and what some of those problems are!

## References

[^1]: https://kantorovich.org/post/ot_intro/ 
[^2]: https://towardsdatascience.com/optimal-transport-a-hidden-gem-that-empowers-todays-machine-learning-2609bbf67e59 
[^3]: https://arxiv.org/pdf/1809.00013.pdf
[^4]: https://en.wikipedia.org/wiki/Word2vec
[^5]: https://www.jmlr.org/papers/volume22/20-451/20-451.pdf 
[^6]: https://pythonot.github.io/quickstart.html#optimal-transport-and-wasserstein-distance
[^7]: https://en.wikipedia.org/wiki/Network_simplex_algorithm