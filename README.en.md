# Linear Algebra: Left Undone

[简体中文](README.md) | **English**

[Full English table of contents](CONTENTS.en.md)

The project introduction and the complete table of contents are available in English. The textbook and its accompanying exercises and solutions are currently written in Chinese.

## Why This Repository Exists

For many students, linear algebra is both one of their first university mathematics courses and their first encounter with abstract mathematics. It provides a foundation for many fields, but getting used to this new way of thinking can take time. In Zhejiang University's Turing Class, students work through two textbooks over two semesters: *University Mathematics: Algebra and Geometry* (《大学数学：代数与几何》) and *Linear Algebra Done Right*. The first begins with vector spaces and linear maps, while many engineering courses start with determinants. This helps students understand the main ideas early on, though the abstract starting point can be difficult for beginners. The second takes an approach more typical of a course for mathematics majors, developing the theory around operators.

We think that studying these two books well gives students a very solid foundation. In practice, though, not everyone finds this abstract approach easy to follow at first. There are many other good resources to turn to, including the advanced algebra textbooks of Weisheng Qiu and Qihong Xie, Gilbert Strang's work, and 3Blue1Brown's *Essence of Linear Algebra*. With so many different approaches, it is easy to feel lost. Students may also spend a lot of time on topics that are less relevant to their courses and exams. We wanted to bring the most useful material from these resources into one book, in an order that is easier to follow. We also wanted to include plenty of exercises to help students put what they learn into practice. That is how this project began.

There is another reason for writing it. Linear algebra is an old subject that is still growing. It grew out of the study of systems of linear equations, developed through centuries of interaction between algebra and geometry, and took on a more rigorous form with the rise of modern algebra. Today, topics such as linear algebraic groups remain active areas of research, and linear algebra has important uses across modern mathematics. By studying algebraic structures, readers also learn ways of thinking that they can use in other areas of mathematics.

Alongside the core material, we would like to show readers how linear algebra has developed and how it is used in other branches of mathematics. We hope this makes the book more enjoyable to read and helps answer a question many beginners ask: *what is linear algebra actually useful for?* A good answer requires both a deeper understanding of linear algebra and a sense of the mathematics beyond it. This wish to look a little further is behind our **Further Explorations**, and behind the title *Linear Algebra: Left Undone*.

## What the Textbook Covers

The book brings together two kinds of material: the core chapters and the **Further Explorations**.

**The core chapters** are designed to be read alongside the two textbooks used in Linear Algebra I and II for Zhejiang University's Turing Class. Using several textbooks as references, we explain abstract ideas step by step and show how different topics are connected. The chapters also include plenty of exercises with solutions and past exam problems to help students build their understanding and prepare for exams.

**Further Explorations** introduce connections between linear algebra and other areas of mathematics. We introduce topics in analysis and geometry, including Hilbert spaces, linear dynamical systems, differential geometry, and differential forms. Other topics include Lie groups and Lie algebras, knot theory in low-dimensional topology, graph theory in combinatorics, and category theory.

Through these topics, we hope to show how linear algebra is used and what readers can study next. We introduce more advanced subjects using ideas readers already know, and suggest further reading for anyone who wants to learn more. Some explorations are still outlines, and we hope to develop them as the book grows.

## Contributing

- The project is licensed under [Creative Commons Attribution–NonCommercial–ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/).
- `new` is the main development branch and the target for contributions. `main` contains the version for the autumn–winter semester of the 2022–2023 academic year.
- **Pull requests are the recommended way to contribute:** fork the repository, clone your fork, make your changes, and open a pull request against this repository. The changes will be reviewed and discussed before merging.
- For small corrections, such as typographical errors, or suggestions for improving the presentation, you can also open an issue or contact the maintainers by email or QQ.
- Please use `latexindent` to format your changes where possible. Pull requests are formatted and squash-merged into the repository.
- Contributors who are not repository collaborators should submit changes through a fork and pull request; they cannot push directly to this repository.
- Please preserve the existing chapter structure and place figures in `figs`. If you would like to change the file organization, open an issue or discuss it with the maintainers by email or QQ first.

## Building the PDFs

Run `make` from the repository root to build the textbook and the accompanying exercise solutions. The resulting PDFs are written to the `讲义` directory.

You can also build them with Docker:

```bash
docker run -v"$PWD":/app -w/app -eTERM=xterm --rm texlive/texlive:latest make
```
