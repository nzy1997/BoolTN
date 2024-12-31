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


= Sat Problem
= Tropical Tensor Networks
== Optimal Branching
= Boolean Svd
== Integer Programming
== Simulated Annealing
#pagebreak()