---
title: CTSC2018-青蕈领主
date: 2020-11-20 14:01:20
mathjax: true
tags:
  - Math
  - Poly
---

# [CTSC2018 青蕈领主](https://www.luogu.com.cn/problem/P4566)

## Description

定义一个排列中的一段区间是连续的，
当且仅当这个排列中的最大值与最小值的差为这段区间的长度  $-1$。

对于一个长度为 $n$ 的排列，
给定对于 $i \in [1,n]$，以 $i$ 这个位置结尾的最长连续区间的长度 $L_i$。

询问满足条件的排列的个数（不存在输出`-1`）。

<!--more-->

## Tutorial

### Part 1 无解的判定

不难发现，如果存在 $l_1,r_1,l_2,r_2(r_2\geqslant l_1)$，
使得 $[l_1, r_1]$ 和 $[l_2,r_2]$ 都是合法区间，那么 $[l1, r2]$ 也必然为合法区间。

所以存在解等价于 所有区间两两要么相互包含要么不相交，
并且 $L_n = n$。

### Part 2 $L = \{1,1,\cdots,1,n\}$ 时的子问题

令 $f_n$​ 表示满足 $L_i=1\space (i\in [1,n])$ 的长度为 $n+1$ 的排列数量。

使用类似与错位排列的方法求解。

考虑将长度为 $n$ 的排列中每个元素 $+1$，再插入一个 $1$ 来得到一个长度为 $n+1$ 的排列

分两种情况：

+ 原先排列合法。  
此时插入的 $1$ 只要不在 $2$ 的边上即可。  
证明：假设存在一个长度大于 $3$ 的区间不合法，那么由于 $1$ 是里面的最小值，把 $1$ 拿掉以后，
序列的长度和极差都会减 $1$，这样这个区间在原序列中也一定不合法，矛盾。  
对答案的贡献： $n \times f(n)$。

+ 原先排列不合法。  
此时只能有一个极大非法区间。  
证明：
假设存在两个没有交的非法区间，插入一个 1 并不会使两个非法区间同时消失，即不会变得合法。  
设这个极大非法区间为 $[l,l+k-1]$，显然有 $2 \leqslant k \leqslant n-1$。  
对于某个给定的 $k$，这个区间有 $n-k$ 种选取方案。  
这个区间因为插入一个数以后合法，因此方案数就是 $f(l)$。  
然后把这个区间缩成一个点，
相当于序列长度减少了 $k-1$，所以是方案数是长度为 $f(n-k+2)$ 的序列的方案数，
即为$f(n-k+1)$。  
所以对于某一个的 $k$，其对答案的贡献为 $(n-k)f(k)f(n-k+1)$  
这种情况对答案的贡献： $\sum_{2 \leqslant k \leqslant n-1}(n-k)f(k)f(n-k+1)$

所以我们就有递推式：

$$
f(n+1) = n \times f(n) + \sum_{2\leqslant k\leqslant n-1} (n-k)f(k)f(n-k+1)
$$

### Part 3 如何快速求 $f$

发现 $n \leqslant 10000$，所以我们并不能暴力递推这个数列。

这个递推形式看上去很像分治FFT，但这里与分治FFT模板有所不同。

按照一般的分治FFT思路，我们在求 $[l,m]$ 区间对 $[m+1,r]$ 的贡献的时候，
是把 $[l,m]$ 和 $[0,r-l]$ 这个区间卷起来，

但在这道题中 $[0,r-l]$ 区间中 $f$ 的值可能仍未确定。

解决办法是把 $f(k)\times f(n-k+1)$ 的贡献算在 $\max(k, n-k+1)$ 上，
而不是一般的 $k$ 上。

这样可以保证卷的区间已经求出。

并且我们注意到 $(n-k)f(k)f(n-k+1) + (k-1)f(n-k+1)f(k) = (n-1)f(k)f(n-k+1)$

所以只要给系数乘上 $n-1$ 即可。

这部分的 code：

```cpp
// add 表示模意义下的 +=
// mul 是多项是乘法

void cdq(int l, int r)
{
  if (l == r) {
    add(f[l], 1ll * f[l-1] * (l-1) % MOD);
    return;
  }
  int mid = (l + r) / 2;
  cdq(l, mid);
  int len = mid - l + 1;
  static int _a[N*2+10], _b[N*2+10];
  for (int i = l; i <= mid; ++ i) {
    _a[i - l] = 1ll * f[i] * (i-1) % MOD;
    _b[i - l] = f[i];
  }
  mul(_a, _b, len, len);
  for (int i = std::max(l << 1, mid + 1); i <= r; ++ i) {
    add(f[i], _a[i - (l<<1)]);
  }
  if (l != 2) {
    int d = std::min(l - 1, r - l);
    for (int i = 2; i <= d; ++ i)
      _a[i-2] = f[i];
    for (int i = l; i <= mid; ++ i)
      _b[i-l] = f[i];
    ntt::mul(_a, _b, d-1, mid-l+1);
    for (int i = std::max(l+2, mid+1); i<=r; ++i)
      add(f[i], 1ll * _a[i-l-2] * (i-2) % MOD);
  }
  cdq(mid+1, r);
}
```

### Part 4 扩展到原问题

由 Part 1 可知，原问题中的区间一定构成了一个树形结构。

考虑在儿子答案已知的情况下求点 $u$ 的方案数。

由于每个儿子都是一段连续区间，而这些连续区间不能合并。

不难想到把每个儿子表示的区间缩成一个点，这样加上这个点本身，
组合的方案数为 $f(\deg u)$

所以这个点的答案为儿子的方案书之积乘上 $f(\deg u)$

用一个栈维护这个过程即可

这部分的 code：

```cpp
typedef std::pair<int, int> Inter;
typedef std::pair<Inter, int> Val;
int n = read();
for (int i = 0; i < n; ++ i)
  a[i] = read();
std::stack <Val> st;
for (int i = 0; i < n; ++ i) {
  Inter pos(i-a[i]+1, i);
  int pans = 1;
  int cnt = 0;
  while (!st.empty() && st.top().first.first >= pos.first) {
    pans = 1ll * pans * st.top().second % MOD;
    st.pop();
    cnt++;
  }
  if (!st.empty() && st.top().first.second >= pos.first) {
    puts("0");
    return;
  }
  pans = 1ll * pans * f[cnt] % MOD;
  st.push( Val(pos, pans) );
  printf("%d\n", st.top().second);
}
```
