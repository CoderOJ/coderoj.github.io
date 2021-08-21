---
title: Codeforces 932E
mathjax: true
date: 2020-07-21 16:42:29
tags:
- Tutorial
- Math
---

# [CodeForces - 932E](https://codeforces.com/problemset/problem/932/E)



## Description

>Calculate:
>$$
>\sum_{x=0}^{N}C_N^{x}\cdot x^k
>$$
>
>+ $1\leqslant N\leqslant 10^9,1\leqslant k\leqslant 5000$

<!--more-->


## Prefix Knowledge

+ Sterling numbers the second kind

  > Sterling numbers the second kind, which is written in $S(n,k)$, is defined as the number of ways to put $n$ different balls into $k$ same boxes.
  >
  > It can be calculated as below:
  > $$
  > \begin{aligned}
  > S(1,1)&=1 \\
  > S(n,k)&=S(n-1,k-1)+n\cdot S(n-1,k)
  > \end{aligned}
  > $$



## Solution

Use Stirling numbers the second kind to change the form of $x^k$

We have:
$$
x^k=\sum_{i=0}^{x}C_x^i\cdot i!\cdot S(k,i)
$$

> Proof: 
>
> Let's consider a problem: What's the number of ways to put $k$ different balls into $x$ different boxes.
>
> Obviously the answer is $x^k$.
>
> In another way, we may index $i$ that represents the number of boxes that have balls in, then the ways in this case is $S(k,i)$. And because the boxes are **different**, we should multiply $i!$
>
> Thus, the answer is also $\sum_{i=0}^{x}C_x^i\cdot i!\cdot S(k,i)$ 
>
> So now we have $x^k=\sum_{i=0}^{x}C_x^i\cdot i!\cdot S(k,i)$

Then we have:
$$
\begin{aligned}
Ans
&=\sum_{x=0}^{N}C_N^{x}\cdot x^k \\
&=\sum_{x=0}^N C_N^x\cdot \sum_{i=0}^{x}C_x^i\cdot i!\cdot S(k,i) \\
&=\sum_{x=0}^N \sum_{i=0}^{x}C_N^x\cdot C_x^i\cdot i!\cdot S(k,i) \\
&=\sum_{i=0}^N \sum_{x=i}^{N}C_N^x\cdot C_x^i\cdot i!\cdot S(k,i) \\
&=\sum_{i=0}^N S(k,i) \cdot \sum_{x=i}^{N}C_N^x\cdot C_x^i\cdot i! \\
\end{aligned}
$$
Then change the form of  $\sum_{x\in[i,n]} C_N^x\cdot C_x^i\cdot i!$

Notice that this is the answer to the problem: 

> What's the number of ways to choose $x$ objects(same) from $N$, then $i$ (different) from $k$ ? 

We may first index $i$, then consist the other $N-i$. They can be either chosen or not during the first round. 

Thus we have $\sum_{x\in[i,N]}C_{N}^x\cdot C_x^i\cdot i!=A_{N}^i\cdot 2^{N-i}$  

After,
$$
\begin{aligned}
Ans
&=\sum_{i=0}^N S(k,i) \cdot \sum_{x=i}^{N}C_N^x\cdot C_x^i\cdot i! \\
&=\sum_{i=0}^N S(k,i) \cdot A_N^i\cdot 2^{N-i} \\
\end{aligned}
$$
We may notice that when $i\geqslant k, \ \ S(k,i)=0$, so we just need to index $i$ from $0$ to $k$, not to $N$

Thus, the problem can be solved in $O(k^2)$ 



## Code

```cpp
const int N = 5005;
const int MOD = 1e9+7;
int s[N][N];
int n, k;

int power(int base, int exp) {
    if (exp < 0) return 0;
    int res=1;
    while (exp) {
        if (exp&1) (res*=base)%=MOD;
        (base*=base) %= MOD; exp >>=1; }
    return res; }
int inv(int u) { return power(u,MOD-2); }
int nAr(int n, int r) {
    int res=1;
    rep (i,r) (res*=(n-i)) %=MOD;
    return res; }
void initStirling() {
    s[1][1] = 1;
    repi (i,2,N-1) repa (j,i) s[i][j] = (s[i-1][j-1] + s[i-1][j]*j) % MOD; }

void init() {
    scanf(II,&n,&k); 
    initStirling();
}

void solve() {
    int ans=0;
    rep (j,k+1) { 
        (ans+= nAr(n,j) * power(2,n-j) % MOD * s[k][j] % MOD) %= MOD; }
    printf(IN,ans);
}


```

