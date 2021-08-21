---
title: Conclusion on Catalan number
date: 2020-11-25 11:20:27
mathjax: true
tags: 
  - Math
  - Poly
---

# Study note on Catalan Number

<!--more-->

$$
\begin{aligned}
c_0 &= 1 \\
c_n &= \sum_{k=0}^{n-1} c_kc_{n-k-1} &(x \geq 1)
\end{aligned}
$$

Define
$$
C(x) = \sum_{k=0}^\infty c_k x^k
$$
Then
$$
\begin{aligned}
C^2(x) &= \sum_{k=0}^{\infty} \sum_{j=0}^{k}c_jc_{k-j}x^k \\
&= \sum_{k=0}^{\infty}c_{k+1}x^k \\
xC^2(x)&= -1 + C(x)
\end{aligned}
$$
Therefore
$$
\begin{aligned}
xC^2-C+1 &= 0 \\
C &= \frac{1\pm\sqrt{1-4x}}{2x} \\
\end{aligned} \\
$$
$$
\begin{aligned}
&\because [x^0]C = 0 \\
&\therefore C = \frac{1-\sqrt{1-4x}}{2x}
\end{aligned}
$$
Then consider how to solve $\sqrt{1-4x}$

Because
$$
(1+x)^\alpha = \sum_{k=0}^{\infty}\binom{\alpha}{k}x^k
$$
We have
$$
\begin{aligned}
(1-4x)^{\frac{1}{2}}
&= \sum_{k=0}^{\infty}\binom{\frac{1}{2}}{k}(-4x)^k \\
&= \sum_{k=0}^{\infty}\frac{(\frac{1}{2})^{\underline{k}}}{k!}(-4x)^k \\
&= \sum_{k=0}^{\infty}\frac{(-\frac{1}{2})^{\overline{k}}}{k!}(4x)^k \\
&= \sum_{k=0}^{\infty}\frac{(k-\frac{3}{2})^{\underline{k}}}{k!}(4x)^k \\
&= -\frac{1}{2}\sum_{k=0}^{\infty}\frac{(k-\frac{3}{2})^{\underline{k-1}}}{k!}(4x)^k \\
&= -\sum_{k=0}^{\infty}\frac{(2k-3)!!}{k!}(2x)^k \\
&= -{2}\sum_{k=0}^{\infty}\frac{(2k-3)!!}{k!} \frac{(2k-2)!!}{(k-1)!} x^k \\
&= -{2}\sum_{k=0}^{\infty}\frac{(2k-2)!}{k!(k-1)!} x^k \\
&= -{2}\sum_{k=0}^{\infty}\frac{1}{k}\binom{2k-2}{k-1} x^k \\
\end{aligned}
$$

Here we need to define $x^\underline{-1}$ as $\frac{1}{x}$, otherwise there are some edge cases.

Pay attention to where $2$ and $\frac{1}{2}$ appear and disappear.

Therefore
$$
\begin{aligned}
C(x) 
&= \frac{1 + 2\sum_{k=0}^{\infty}\frac{1}{k}\binom{2k-2}{k-1} x^k}{2x} \\
&= \sum_{k=1}^{\infty}\frac{1}{k}\binom{2k-2}{k-1} x^{k-1} \\ 
&= \sum_{k=0}^{\infty}\frac{1}{k+1}\binom{2k}{k} x^{k} \\ 
\end{aligned}
$$
As is obviously we have
$$
c_n = \frac{1}{n+1}\binom{2n}{n}
$$
