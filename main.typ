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


== 

#let multiplier-block(loc, size, sij, cij, pij, qij, pijp, qipj, sipjm, cimj) = {
  import draw: *
  rect((loc.at(0) - size/2, loc.at(1) - size/2), (loc.at(0) + size/2, loc.at(1) + size/2), stroke: black, fill: white)
  circle((loc.at(0) + size/2, loc.at(1) - size/2), name: sij, radius: 0)
  circle((loc.at(0) - size/2, loc.at(1) - size/4), name: cij, radius: 0)
  circle((loc.at(0) - size/2, loc.at(1) + size/4), name: qipj, radius: 0)
  circle((loc.at(0), loc.at(1) + size/2), name: pij, radius: 0)
  circle((loc.at(0) + size/2, loc.at(1) + size/4), name: qij, radius: 0)
  circle((loc.at(0), loc.at(1) - size/2), name: pijp, radius: 0)
  circle((loc.at(0) - size/2, loc.at(1) + size/2), name: sipjm, radius: 0)
  circle((loc.at(0) + size/2, loc.at(1) - size/4), name: cimj, radius: 0)
}

#let multiplier(m, n, size: 1) = {
  import draw: *
  for i in range(m){
    for j in range(n) {
      multiplier-block((-2 * i, -2 * j), size, "s" + str(i) + str(j), "c" + str(i) + str(j), "p" + str(i) + str(j), "q" + str(i) + str(j), "p" + str(i) + str(j+1) + "'", "q" + str(i+1) + str(j) + "'", "s" + str(i+1) + str(j - 1) + "'", "c" + str(i - 1) + str(j) + "'")
    }
  }
  for i in range(m){
    for j in range(n){
      if (i > 0) and (j < n - 1) {
        line("s" + str(i) + str(j), "s" + str(i) + str(j) + "'", mark: (end: "straight"))
      }
      if (i < m - 1){
        line("c" + str(i) + str(j), "c" + str(i) + str(j) + "'", mark: (end: "straight"))
      }
      if (j > 0){
        line("p" + str(i) + str(j), "p" + str(i) + str(j) + "'", mark: (start: "straight"))
      }
      if (i > 0){
        line("q" + str(i) + str(j), "q" + str(i) + str(j) + "'", mark: (start: "straight"))
      }
    }
  }
  for i in range(m){
    let a = "p" + str(i) + "0"
    let b = (rel: (0, 0.5), to: a)
    line(a, b, mark: (start: "straight"))
    content((rel: (0, 0.3), to: b), text(14pt)[$p_#i$])


    let a2 = "s" + str(i+1) + str(-1) + "'"
    let b2 = (rel: (-0.4, 0.4), to: a2)
    line(a2, b2, mark: (start: "straight"))
    content((rel: (-0.2, 0.2), to: b2), text(14pt)[$0$])

    let a3 = "s" + str(i) + str(n - 1)
    let b3 = (rel: (0.4, -0.4), to: a3)
    line(a3, b3, mark: (end: "straight"))
    content((rel: (0.2, -0.2), to: b3), text(14pt)[$m_#(i+m - 1)$])

  }
  for j in range(n){
    let a = "q0" + str(j)
    let b = (rel: (0.5, 0), to: a)
    line(a, b, mark: (start: "straight"))
    content((rel: (0.3, 0), to: b), text(14pt)[$q_#j$])

    let a2 = "q" + str(m) + str(j) + "'"
    let b2 = (rel: (-0.5, 0), to: a2)
    line(a2, b2, mark: (end: "straight"))


    let a3 = "c" + str(-1) + str(j) + "'"
    let b3 = (rel: (0.5, 0), to: a3)
    line(a3, b3, mark: (start: "straight"))
    content((rel: (0.3, 0), to: b3), text(14pt)[$0$])
  
    if (j < n - 1) {
      let a4 = "c" + str(m - 1) + str(j)
      let b4 = "s" + str(m) + str(j) + "'"
      bezier(a4, b4, (rel: (-1, 0), to: a4), (rel: (-0.5, -1), to: a4), mark: (end: "straight"))
    } else {
      let a4 = "c" + str(m - 1) + str(j)
      line(a4, (rel: (-0.5, 0), to: a4), mark: (end: "straight"))
      content((rel: (-0.8, 0), to: a4), text(14pt)[$m_#(j+m)$])
    }
    if (j < n - 1) {
      let a5 = "s0" + str(j)
      let b5 = (rel: (0.4, -0.4), to: a5)
      line(a5, b5, mark: (end: "straight"))
      content((rel: (0.2, -0.2), to: b5), text(14pt)[$m_#j$])
    }
  }
}

#figure(canvas({
  import draw: *
  let i = 0
  let j = 0
  multiplier(5, 5, size: 1.0)
}), caption: [])

#figure(canvas({
  import draw: *
  multiplier-block((0, 0), 1.0, "so", "co", "pi", "qi", "po", "qo", "si", "ci")
  line("si", (rel:(-0.5, 0.5), to:"si"), mark: (start: "straight"))
  content((rel:(-0.75, 0.75), to:"si"), text(14pt)[$s_i$])
  line("ci", (rel:(0.5, 0), to:"ci"), mark: (start: "straight"))
  content((rel:(0.75, 0), to:"ci"), text(14pt)[$c_i$])
  line("pi", (rel:(0, 0.5), to:"pi"), mark: (start: "straight"))
  content((rel:(0, 0.75), to:"pi"), text(14pt)[$p_i$])
  line("qi", (rel:(0.5, 0), to:"qi"), mark: (start: "straight"))
  content((rel:(0.75, 0), to:"qi"), text(14pt)[$q_i$])
  line("po", (rel:(0, -0.5), to:"po"), mark: (end: "straight"))
  content((rel:(0, -0.75), to:"po"), text(14pt)[$p_i$])
  line("qo", (rel:(-0.5, 0), to:"qo"), mark: (end: "straight"))
  content((rel:(-0.75, 0), to:"qo"), text(14pt)[$q_i$])
  line("so", (rel:(0.5, -0.5), to:"so"), mark: (end: "straight"))
  content((rel:(0.75, -0.75), to:"so"), text(14pt)[$s_o$])
  line("co", (rel:(-0.5, 0), to:"co"), mark: (end: "straight"))
  content((rel:(-0.75, 0), to:"co"), text(14pt)[$c_o$])
  content((5, 0), text(14pt)[$2c_o + s_o = p_i q_i + c_i + s_i$])

  let gate(loc, label, size: 1, name:none) = {
    rect((loc.at(0) - size/2, loc.at(1) - size/2), (loc.at(0) + size/2, loc.at(1) + size/2), stroke: black, fill: white, name: name)
    content(loc, text(14pt)[$label$])
  }
  set-origin((-1.5, -3))
  line((4.5, 0), (-1, 0))  // q
  line((3, 1), (3, -4.5))  // p
  let si = (-1, 1)
  let ci = (4.5, -2.5)
  gate((0.5, -0.5), [$and$], size: 0.5, name: "a1")
  gate((2.5, -0.5), [$and$], size: 0.5, name: "a2")
  gate((2.0, -2.5), [$and$], size: 0.5, name: "a3")
  gate((0.5, -2.5), [$or$], size: 0.5, name: "o1")
  gate((1.5, -1.5), [$xor$], size: 0.5, name: "x1")
  gate((3.5, -3.5), [$xor$], size: 0.5, name: "x2")
  line("a2", (2.5, 0))
  line("x1", (1.5, -0.5))
  line("a2", (3, -0.5))
  line("a2", "a1")
  line("a1", "o1")
  line("a3", "o1")
  line("o1", (rel: (-1.5, 0), to: "o1"))
  line(si, "a1")
  line(ci, "a3")
  line((3.5, -2.5), "x2")
  let turn = (1.5, -3.5)
  line("x1",(rel: (0.5, -2.5), to: si), (rel: (0.5, -0.5), to: si))
  line("x1", turn, "x2")
  line("x2", (rel: (1, -1), to: "x2"))
  line("a3", (2.0, -0.5))
  rect((-0.75, -4), (4, 0.75), stroke: (dash: "dashed"))

  let gate_with_leg(loc, label, size: 1, name:none) = {
    gate(loc, label, size: size, name: name)
    line(name, (rel: (0.5, 0), to: name))
    line(name, (rel: (-0.5, 0), to: name))
    line(name, (rel: (0, 0.5), to: name))
  }
  gate_with_leg((6, 0), [$xor$], size: 0.5, name: "x3")
  content((8, 0), text(14pt)[$= mat(mat(0, 1; 1, 0); mat(1, 0; 0, 1))$])

  gate_with_leg((6, -2), [$or$], size: 0.5, name: "o3")
  content((8, -2), text(14pt)[$= mat(mat(1, 0; 0, 0); mat(0, 1; 1, 1))$])

  gate_with_leg((6, -4), [$and$], size: 0.5, name: "a4")
  content((8, -4), text(14pt)[$= mat(mat(1, 1; 1, 0); mat(0, 0; 0, 1))$])
}), caption: [])

== Simulated Annealing
#pagebreak()