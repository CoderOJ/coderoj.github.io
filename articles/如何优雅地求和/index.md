---
title: 「清华集训2016」如何优雅地求和
tags:
  - Tutorial
  - Math
  - Poly
---

# [「清华集训2016」 如何优雅地求和](https://uoj.ac/problem/269)

## Description

给定 $n,x$ 和 $m$ 次多项式 $f$ （给出 $0 \cdots m$ 的点值） ，求

$$
\sum_{k=0}^n f(k) \binom{n}{k} x^k (1-x)^{n-k}
$$

## Tutorial

设 $f$ 转化为下降幂多项式时的系数为 $b_0 \cdots b_m$

使用类似于联合省选组合数问题的技巧，我们有
$$
\begin{aligned}
\sum_{k=0}^n f(k)\binom{n}{k} x^k (1-x)^{n-k}
&= \sum_{k=0}^n \sum_{i=0}^{m} b_i k^{\underline i} \binom{n}{k} x^k (1-x) ^{n-k} \\
&= \sum_{k=0}^n \sum_{i=0}^{m} b_i n^{\underline i} \binom{n-i}{k-i} x^k (1-x) ^{n-k} \\
&= \sum_{i=0}^{m} b_i n^{\underline i} \sum_{k=i}^n \binom{n-i}{k-i} x^k (1-x) ^{n-k} \\
&= \sum_{i=0}^{m} b_i n^{\underline i} x^i \sum_{k=0}^{n-i} \binom{n-i}{k} x^{k} (1-x) ^{n-i-k} \\
&= \sum_{i=0}^{m} b_i x^i n^{\underline i} &(1)
\end{aligned}
$$
接下来考虑如何求 $b_i$，当然可以先插值再转为下降幂，但出题人给点值~~显然~~不是用来恶心人的，考虑直接通过点值求 $b_i$

因为
$$
x^n = \sum_k \begin{Bmatrix} n\\k \end{Bmatrix} x^{\underline k}
$$
设 $f$ 的普通幂系数为 $a_0 \cdots a_m$，我们有
$$
\begin{aligned}
b_i &= \sum_j \begin{Bmatrix} j\\i \end{Bmatrix} a_j &(2)
\end{aligned}
$$
然后考虑一个恒等式
$$
\sum_{m} \binom{k}{m} \begin{Bmatrix} n\\m \end{Bmatrix} m! = k^n
$$
这很容易用组合意义证明

二项式反演得到
$$
\begin{aligned}
m! \begin{Bmatrix} n\\m \end{Bmatrix} &= \sum_k \binom{m}{k} k^n(-1)^{m-k} \\
   \begin{Bmatrix} n\\m \end{Bmatrix} &= \frac1{m!}\sum_k \binom{m}{k} k^n(-1)^{m-k} \\ 
\end{aligned}
$$
~~我怎么把第二类斯特林数·行的式子推了一遍~~

带入 $(2)$，得到
$$
\begin{aligned}
b_i &= \sum_j \begin{Bmatrix} j\\i \end{Bmatrix} a_j \\
&= \frac1{i!} \sum_j \sum_k \binom{i}{k}k^j(-1)^{i-k} a_j \\
&= \frac1{i!} \sum_k \binom{i}{k}(-1)^{i-k} \sum_j a_j k^j \\
&= \frac1{i!} \sum_k \binom{i}{k}(-1)^{i-k} f(k) \\
&= \sum_k \frac{f(k)}{k!} \frac{(-1)^{i-k}}{(i-k)!} \\
\end{aligned}
$$
这十分的卷积，显然可以 $O(m \log m)$ 计算

然后把算出来的$b_i$ 带回 $(1)$ 就好了

### UPD0

突然发现我好傻逼，转下降幂完全不用那么烦
$$
\begin{aligned}
f(k) &= \sum_i b_ii! \times \frac{k^{\underline i}}{i!} \\
&= \sum_i b_i i! \binom{k}{i}
\end{aligned}
$$
直接二项式反演
$$
\begin{aligned}
b_k k! &= \sum_i (-1)^{k-i} \binom{k}{i} f(i) \\
b_k &= \sum_i \frac{(-1)^{k-i}}{(k-i)!} \frac{f(i)}{i!}
\end{aligned}
$$
我之前在干什么。。。

## Code 

一个 ntt 调了两个小时的我是屑

```cpp
// at https://gitee.com/coderoj/code/blob/master/creats/Scanner.h
#include "/home/jack/code/creats/Scanner.h"
#include <bits/stdc++.h>

constexpr int N = 65536;
constexpr int MOD = 998244353;
int n, m, x;
int a[N], b[N];

int power(int a, int b) {
  int r = 1;
  for (;b;b>>=1) {
    if (b & 1) { r = 1ll * r * a % MOD; }
    a = 1ll * a * a % MOD; }
  return r; }

inline void checkAdd(int& a) { a += a < 0 ? MOD : 0; }
inline void checkSub(int& a) { a -= a >= MOD ? MOD : 0; }

namespace polys {

void dft(int *const a, int n) {
  int len = (1 << n);
  static int rev[N], w[N], last_n = -1;
  if (last_n != n) { last_n = n;
    rev[0] = 0;
    for (int i=1; i<len; ++i) {
      rev[i] = (rev[i>>1] >> 1) | ((i&1) << (n-1)); }
    for (int i=0; i<n; ++i) {
      int p = 1 << i; int pw = power(3, (MOD-1) / p / 2); w[p] = 1;
      for (int j=p+1; j<p+p; j++) { w[j] = 1ll * w[j-1] * pw % MOD; } } }
  for (int i=0; i<len; ++i) if (i < rev[i]) { std::swap(a[i], a[rev[i]]); }
  for (int l=1; l<len; l<<=1) {
    for (int i=0; i<len; i+=2*l) {
      for (int j=0; j<l; ++j) {
        int t = 1ll * a[i + l + j] * w[l + j] % MOD;
        checkAdd(a[i + l + j] = a[i + j] - t);
        checkSub(a[i + j] += t); } } }
}

void idft(int *const a, int n) {
  int len = 1 << n;
  std::reverse(a+1, a+len);
  dft(a, n);
  int inv_len = power(len, MOD-2);
  for (int i=0; i<len; ++i) {
    a[i] = 1ll * a[i] * inv_len % MOD; } }

void mulp(int *const a, int *const b, int _n) {
  int l=1, n=0;
  while (l < 2*_n-1) { l *= 2; n++; }
  dft(a, n); dft(b, n);
  for (int i=0; i<l; ++i) { a[i] = 1ll * a[i] * b[i] % MOD; }
  idft(a, n);
}
 
}

int fac[N], ifac[N];

int main () {
  n = sc.n(); m = sc.n(); x = sc.n();
  for (int i=0; i<=m; ++i) { a[i] = sc.n(); }
  fac[0]=ifac[0]=1; for (int i=1;i<=m;++i) { fac[i] = 1ll * fac[i-1] * i % MOD; ifac[i] = power(fac[i], MOD-2); }

  for (int i=0; i<=m; ++i) { a[i] = 1ll * a[i] * ifac[i] % MOD; }
  for (int i=0; i<=m; ++i) { b[i] = ifac[i]; if (i % 2) { b[i] = MOD - b[i]; } }
  polys::mulp(a, b, m+1);
  int ans = 0;
  int x_pow = 1, n_down = 1;
  for (int i=0; i<=m; ++i) {
    ans = (ans + 1ll * a[i] * x_pow % MOD * n_down) % MOD;
    x_pow = 1ll * x_pow * x % MOD; n_down = 1ll * n_down * (n-i) % MOD; }
  printf("%d\n", ans);

  return 0;
}

```
