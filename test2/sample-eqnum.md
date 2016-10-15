---
title: MathJax Equation Numbering
...

A test of Equation Numbering
============================

------------------------------------------------------------------------

Equation:
\begin{equation}
E = mc^2
\end{equation}

Equation\*:
\begin{equation*}
E = mc^2
\end{equation*}

------------------------------------------------------------------------

Brackets:
$$E = mc^2$$
Brackets tagged:
$$E = mc^2\tag{x}$$

------------------------------------------------------------------------

\begin{equation}
\begin{split} 
a& =b+c-d\\ 
& \quad +e-f\\ 
& =g+h\\ 
& =i 
\end{split} 
\end{equation} 

------------------------------------------------------------------------

Multline:

\begin{multline}
  a+b+c+d+e+f+g\\
  M+N+O+P+Q\\
  R+S+T\\
  u+v+w+x+y+z
\end{multline}

Multline*:

\begin{multline*}
  a+b+c+d+e+f+g\\
  M+N+O+P+Q\\
  R+S+T\\
  u+v+w+x+y+z
\end{multline*}

------------------------------------------------------------------------

Gather:

\begin{gather} 
a_1=b_1+c_1\\ 
a_2=b_2+c_2-d_2+e_2 
\end{gather} 

Gather*:

\begin{gather*} 
a_1=b_1+c_1\\ 
a_2=b_2+c_2-d_2+e_2 
\end{gather*} 

------------------------------------------------------------------------

Align:

\begin{align} 
a_1& =b_1+c_1\\ 
a_2& =b_2+c_2-d_2+e_2 
\end{align}

Align*:

\begin{align*} 
a_1& =b_1+c_1\\ 
a_2& =b_2+c_2-d_2+e_2 
\end{align*}

Align:

\begin{align} 
a_{11}& =b_{11}& a_{12}& =b_{12}\\ 
a_{21}& =b_{21}& a_{22}& =b_{22}+c_{22} 
\end{align}

Align with \notag and \tag:

\begin{align} 
a_{11}& =b_{11}& a_{12}& =b_{12}\notag\\ 
a_{21}& =b_{21}& a_{22}& =b_{22}+c_{22} \tag{y}
\end{align}

Align* with \tag:

\begin{align*} 
a_1& =b_1+c_1\tag{z}\\ 
a_2& =b_2+c_2-d_2+e_2 
\end{align*}
