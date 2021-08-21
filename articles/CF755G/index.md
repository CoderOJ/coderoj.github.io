---
title: Codeforces 755G
date: 2020-11-24 18:32:33
mathjax: true
tags:
  - Tutorial
  - Math
  - Poly
---

# [CF755G](https://www.luogu.com.cn/problem/CF755G)

## Description

$n$ balls stand a row. You can select exactly $m$ groups of them,
each consisting either a single ball or two neighbouring balls.
Each ball can only be in one group.

for all $m$ in $[1,k]$
you need to output the number of such divisions.

## Tutorial

let $f(n,m)$ to be the answer of selecting $m$ groups in $n$ balls.

let

$$
F_n(x) = \sum_{k \geq 0}^{\infty} f(n,k) x^k
$$

Because

$$
f(n,k) = f(n-1,k) + f(n-1,k-1) + f(n-2,k-1)
$$

We have

$$
F_n = (1+x)F_{n-1} + xF_{n-2}
$$

It can be proved that there exist a $Z$ that for all $n$

$$
F_n = Z * F_{n-1}
$$

Then we have

$$
\begin{aligned}
Z^2 F_{n-2} &= Z (1+x)F_{n-2} + F_{n-2} \\
Z^2 - (1+x) Z - 1 &= 0 \\
Z &= \frac{1+x\pm\sqrt{1+6x+x^2}}{2} \\
Z_1 &= \frac{1+x+\sqrt{1+6x+x^2}}{2}, \\
Z_2 &= \frac{1+x-\sqrt{1+6x+x^2}}{2} \\
\end{aligned}
$$


Therefore

$$
F_n = C_1Z_1^{n} + C_2Z_2^{n}
$$

As is obviously that

$$
F_0(x) = 1,
F_1(x) = 1 + x
$$

So we can solve $C_1, C_2$

$$
C_1 = \frac{Z_1}{\sqrt{1+6x+x^2}},
C_2 = \frac{-Z_2}{\sqrt{1+6x+x^2}}
$$

Then $F_n$ shoud be

$$
F_n = \frac{Z_1^{n+1} - Z_2^{n+1}}{\sqrt{1+6x+x^2}}
$$

Obviously

$$
\begin{aligned}[]
[x^0] Z_2 &= 0 \\
Z_2^{n+1}(x) &\equiv 0 \pmod{x^{n+1}}
\end{aligned}
$$

So there is no need to calculate $Z_2$

$$
F_n = \frac{1}{\sqrt{1+6x+x^2}} (\frac{1+x+\sqrt{1+6x+x^2}}{2})^{n+1}
$$

And this can be solved in $O(k \log k)$

## Code:

[include1](https://gitee.com/coderoj/code/blob/master/creats/Scanner.h)
[include2](https://gitee.com/coderoj/code/blob/master/Math/Poly/main.h)

```cpp
int main() {
  using namespace Polys;
  int _n = sc.n();
  int _k = sc.n();
  int k = std::max(3, _k+1);
  Poly Delta(k);
  Delta[0] = 1;
  Delta[1] = 6;
  Delta[2] = 1;
  Delta = Delta.sqrt();
  Poly Z = Delta;
  Z[0] += Int(1);
  Z[1] += Int(1);
  Z *= Int(1) / Int(2);
  int n = (_n+1) % MOD;
  Z = Z.pow(n,n);
  Z *= Delta.inv();
  for (int i = 1; i <= _k; ++ i) {
    printf("%u ", i <= _n ? static_cast<unsigned>(Z[i]) : 0);
  }
  return 0;
}
```
