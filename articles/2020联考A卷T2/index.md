---
title: 2020 联考 A 卷 D1T2
date: 2020-11-22 18:15:24
mathjax: true
tags:
  - Math
  - Tutorial
---

# [[省选联考 2020 A 卷] 组合数问题](https://www.luogu.com.cn/problem/P6620)

## Description

给定 $n,x,p$ 和一个 $m$ 度多项式，求：

$$
\sum_{k=0}^{n} ​f(k) x^k \binom{n}{k}
$$

在模 $p$ 意义下的值。

## Tutorial

考虑把 $f$ 转为下降幂多项式，设 
$$
f(x) = \sum_{i=0}^m b_ix^{\underline i}
$$
所求即为：
$$
\sum_{k=0}^n \sum_{i=0}^{m} b_i k^{\underline i}x^k \binom{n}{k}
$$
我们有：
$$
\begin{aligned}
\binom{n}{k} k^{\underline i} &= \frac{n!}{k!(n-k)!} \frac{k!}{(k-i)!}  \\
&= \frac{(n-i)!n^{\underline i}}{(n-k)!(k-i)!} \\
&= \binom{n-i}{k-i}n^{\underline i}
\end{aligned}
$$
所以：
$$
\begin{aligned}
\sum_{k=0}^n \sum_{i=0}^{m} b_i k^{\underline i}x^k \binom{n}{k} 
&= \sum_{k=0}^n\sum_{i=0}^{m} \binom{n}{k} k^{\underline{i}} b_i x^k \\
&= \sum_{k=0}^n\sum_{i=0}^{m} \binom{n-i}{k-i} n^{\underline{i}} b_i x^k \\
&= \sum_{i=0}^{m} n^{\underline{i}} b_i \sum_{k=i}^n \binom{n-i}{k-i} x^k \\
&= \sum_{i=0}^{m} n^{\underline{i}} b_i x^i \sum_{k=0}^{n-i} \binom{n-i}{k} x^k \\
&= \sum_{i=0}^{m} n^{\underline{i}} b_i x^i (x+1)^{n-i} \\
\end{aligned}
$$

直接 $O(m)$ 计算。转下降幂直接暴力即可，总复杂度 $O(m^2)$

## Code

```cpp
constexpr int N = 1005;
int n, x, p, m;
int a[N], b[N];

int stir[N][N];
void initStir() {
  stir[0][0] = 1;
  for (int i = 1; i <= m; ++i) {
    for (int j = 1; j <= i; ++j) {
      stir[i][j] = (stir[i - 1][j - 1] + 1ll * j * stir[i - 1][j]) % p; } } }

void pow_to_down() {
  for (int i = 0; i <= m; ++i) {
    for (int j = 0; j <= i; ++j) {
      b[j] = (b[j] + 1ll * stir[i][j] * a[i]) % p; } } }

int power(int a, int b) {
  int r = 1;
  for (; b; b >>= 1) {
    if (b & 1) {
      r = 1ll * r * a % p; }
    a = 1ll * a * a % p; }
  return r; }

void preInit() { } void init() {
  n = sc.n(); x = sc.n(); p = sc.n(); m = sc.n();
  for (int i : range(m + 1)) {
    a[i] = sc.n(); } }
void solve() {
  initStir();
  pow_to_down();
  logArray(b, b + n + 1);
  int n_down = 1, x_pow = 1;
  int ans = 0;
  for (int i = 0; i <= m; ++i) {
    ans = (ans + 1ll * n_down * b[i] % p * x_pow % p * power(x + 1, n - i)) % p;
    n_down = 1ll * n_down * (n - i) % p; x_pow = 1ll * x_pow * x % p; }
  printf("%d\n", ans); }
```
