---
title: Codeforces 438E
date: 2020-11-29 18:13:41
tags: 
  - Math
  - Poly
  - Tutorial
---

# [CF438E](https://www.luogu.com.cn/problem/CF438E)

## Description

We define a tree valid if and only if on each node there is a number in $S$, and the value of this true is define as the sum of these numbers.

Given $n,m,S$, for each $k$ in $[1,m]$ find out the number of valid **binary** trees with $n$ nodes and value $k$.

<!--more-->

## Tutorial

Define the OGF to the answer as $F$, and $G(x) = \sum_{k=0}^\infty [k \in S]x^k$.

We know that a binary tree is defined as follow:

+ An empty tree is a binary tree
+ The combination of a root and two son binary trees(with order)

The there is clear that
$$
F(x) = 1 + G(x)F^2(x)
$$
So
$$
F(x) = \frac{2}{1 \pm \sqrt{1-4G(x)}}
$$
As is obviously that 
$$
[x^0]F(x) = 1
$$
We know the $\pm$ should be $+$

## Code

ref: [local](https://gitee.com/coderoj/cts/blob/master/tmp/CF438E/main.cpp), [complete](https://codeforces.com/contest/438/submission/99882580)

```cpp
#include "~/code/Math/Poly/main.h"

void solve()
{
  using namespace Polys;
  int n = sc.n(), m = sc.n();
  Poly A(m+1);
  rep (i,n) { 
    int u = sc.n();
    if (u <= m) A[u] -= 4; }
  A[0] = 1;
  A = A.sqrt();
  A[0] = 2;
  A = A.inv();
  A *= Int(2);
  repa (i,m) printf("%u\n", static_cast<unsigned>(A[i]));
}
```

