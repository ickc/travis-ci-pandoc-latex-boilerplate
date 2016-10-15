---
title: MathJax Equation References
...

A test of Equation References
=============================

------------------------------------------------------------------------

Here is a labeled equation:

\begin{equation}
x+1\over\sqrt{1-x^2} \label{ref1}
\end{equation}

with a reference to ref1: $\ref{ref1}$ , and another numbered one with no
label: $$x+1\over\sqrt{1-x^2}$$

This one uses \\nonumber:
$$x+1\over\sqrt{1-x^2}\nonumber$$

------------------------------------------------------------------------

Here's one using the equation environment:

\begin{equation}
x+1\over\sqrt{1-x^2}
\end{equation}

and one with equation\*
environment:

\begin{equation*}
x+1\over\sqrt{1-x^2}
\end{equation*}

------------------------------------------------------------------------

This is a forward reference $\ref{ref2}$ and another $\eqref{ref2}$
for the following equation:

\begin{equation}
x+1\over\sqrt{1-x^2}\label{ref2}
\end{equation}

More math:

$$x+1\over\sqrt{1-x^2}$$

Here is a ref inside math:
$\ref{ref2}+1$ and text after it.

\begin{align} 
x& = y_1-y_2+y_3-y_5+y_8-\dots 
&& \text{by \eqref{ref1}}\\ 
& = y'\circ y^* && \text{(by \eqref{ref3})}\\ 
& = y(0) y' && \text {by Axiom 1.} 
\end{align} 

Here's a bad ref $\ref{ref4}$ to a
nonexistent label.

------------------------------------------------------------------------

An alignment:

\begin{align}
a&=b\label{ref3}\cr
&=c+d
\end{align}

and a starred one:

\begin{align*}
a&=b\cr
&=c+d
\end{align*}
