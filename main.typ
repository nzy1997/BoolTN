#import "@preview/cetz:0.2.2": canvas, draw, tree
#import "@preview/unequivocal-ams:0.1.1": ams-article, theorem, proof
#import "@preview/suiji:0.3.0": *
#show link: set text(blue)


#set math.equation(numbering: "(1)")

#show: ams-article.with(
  title: [Tropical Tensor Networks for Boolean Inference],
  authors: (
    (
      name: "Zhongyi Ni",
    ),
  ),
  abstract: [],
  bibliography: bibliography("refs.bib"),
)

// The ASM template also provides a theorem function.
#let definition(title, body, numbered: true) = figure(
  body,
  kind: "theorem",
  supplement: [Definition (#title)],
  numbering: if numbered { "1" },
)

= Introduction
== Sat Problems
Satisability problem is a classic NP-complete problem. Given a Boolean formula, the problem is to determine whether there is an assignment of truth values to the variables that makes the formula true. 

A $k$-SAT problem is a special case of the SAT problem where each clause has exactly $k$ literals. The 3-SAT problem is the most famous $k$-SAT problem. It is known that the 3-SAT problem is NP-complete and the 2-SAT problem is in P. Here is an example of a 3-SAT problem:

$
(x or y or z) and (not x or y or z) and (not x or not y or z) and (x or not y or z)
$

A Circuit SAT problem is a special case of the SAT problem where the formula is a boolean circuit. A boolean circuit is a directed acyclic graph where each node is a gate and each edge is a wire. The input nodes are the nodes without incoming edges and the output nodes are the nodes without outgoing edges. The gates are the nodes with both incoming and outgoing edges. The gates can be AND, OR, or NOT gates. The Circuit SAT problem is to determine whether there is an assignment of truth values to the input nodes that makes the output nodes true. Here is an example of a Circuit SAT problem:(TODO: a figure of a circuit here)

== Tropical Tensor Networks
The tropical semiring is a semiring defined on $overline(bb(R)) = bb(R) union {-infinity} $ with the addition is defined as the maximum and the multiplication is defined as the addition:
$
a plus.circle b = max(a, b),
a times.circle b = a + b
$
The identity of the addition is $-infinity$ and the identity of the multiplication is 0. Since
$
a plus.circle (-infinity) = (-infinity) plus.circle a = max(a, -infinity) = a \
a times.circle 0 = 0 times.circle a = a + 0 = a
$

A tropical tensor network is a tensor network where the elements of the tensor are in $overline(bb(R))$ and the tensor contraction is defined by the tropical semiring.(TODO: a figure and a example of tropical tensor network here)

== Representing SAT Problems with Tropical Tensor Networks
We can represent a clause of a $k$-SAT problem or a gate of a Circuit SAT problem with a tropical tensor network. A clause of a $k$-SAT problem is a rank-$k$ tensor with bound dimension 2 on each mode. Here is an example of a clause of a 3-SAT problem:
$
(x or y or not z) arrow T(x, y, z) = cases(
  -infinity "if" (x,y,z) = (0,0,1),
  0 "else",
) $
Similarly, we can also represent a gate of a Circuit SAT problem with a tropical tensor network. Here is an example of a AND gate:
$
(x and y = z) arrow T(x, y,z) = cases(
  -infinity "if" (x,y,z) = (1,1,0),
  -infinity "if" z= 1 "and" (x,y) != (1,1),
  0 "else",
) $
The satisability problem becomes a tensor contraction problem. When the elments of the outcome tensor are all $-infinity$, the formula is unsatisfiable. Otherwise, the formula is satisfiable and the positions of 0 indeicate the configuration of the variables that makes the formula true. (TODO: a figure of the tensor contraction here)

Tropical tensor networks can also represent zeroth-order logic or Propositional calculus by adding the "implying tensor":
$
  (A arrow.r.double B ) arrow T(A,B) = cases(
  -infinity "if" (A,B) = (1,0),
  0 "else",
) $
== Optimal Branching
Branching is an exactly way to solve the Satisability problem. Naively, branching is to choose a variable and branch the formula into two subformulas by assigning the variable to true and false. Generally, we can branch on more than one variable at a time. OptimalBranching.jl(https://github.com/ArrogantGao/OptimalBranching.jl) is a Julia package for solving combinatorial optimization problems with branch-and-reduce method. In BooleanInference.jl(https://github.com/nzy1997/BooleanInference.jl), we use OptimalBranching.jl to solve the Satisability problem by branching on the variables. However, since the connection beteween the variables maybe not sparse enough, the branching table maybe too large to solve. 
= Boolean SVD
Singular value decomposition (SVD) is an important tool in tensor network contraction. To contract the tropical tensor network, we try to find the SVD decomposition of tropical tensor networks. The general SVD decomposition of tropical matries is an NP-complete problem@shitov2014complexity. Our boolean SVD problem is defined as follows:

Boolean SVD Problem: Given an $m times n$ Boolean matrix $C_(m times n)$, are there two Boolean matrices $A_(m times k)$ and $B_(k times n)$ such that $C = A times.circle B$.

== Integer Programming
We can solve the Boolean SVD problem by integer programming. $C = A times.circle B $ is equivalent 
$
C_(i,j) = and.big_(l=1)^k A_(i,l) or B_(l,j)
$
Here we use a auxiliary variable $D_(i,l,j)$ to represent $A_(i,l) and B_(l,j)$ and get the following integer programming problem:

$
min 1\ 
s.t. D_(i,l,j) <= A_(i,l)\ 
D_(i,l,j) <= B_(l,j) \ 
D_(i,l,j) >= A_(i,l) + B_(l,j) - 1\
C_(i,j) <= sum_(l=1)^k D_(i,l,j)\ 
D_(i,l,j) <= C_(i,j)\ 
A_(i,l), B_(l,j), D_(i,l,j) in {0,1}
$
== Simulated Annealing
#pagebreak()