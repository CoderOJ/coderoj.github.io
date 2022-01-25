---
title: USACO02FEB Cow Cycling 
mathjax: true
date: 2020-09-07 14:12:58
tags: 
  - Tutorial
  - Dp
---

# [USACO02FEB](https://www.luogu.com.cn/problem/P4953)

## Description

> 奶牛自行车队由N名队员组成，他们正准备参加一个比赛，这场比赛的路程共有D圈。 车队在比赛时会排成一条直线，由于存在空气阻力，当骑车速度达到每分钟$x$圈时，领头的  奶牛每分钟消耗的体力为$x^2$，其它奶牛每分钟消耗的体力为$x$。每头奶牛的初始体力值都是  相同的，记作$E$。如果有些奶牛在比赛过程中的体力不支，就会掉队，掉队的奶牛不能继续 参加比赛。每支队伍最后只要有一头奶牛能到终点就可以了。
>
> 比赛规定，最小的计时单位是分钟，在每分钟开始的时候，车队要哪头奶牛负责领头， 领头奶牛不能在这分数中内掉队，每分钟骑过的圈数也必须是整数。
>
> 请帮忙计划一下，采用什么样的策略才能让车队以最快的时间到达终点？
<!--more-->

## Tutorial

一道很好的`dp`题

### 状态

首先可以想到至少$O(E^n)$ 暴力记录每头奶牛的体力

### 优化

不难发现一个性质:

+ 存在一种最优解，带头的奶牛一直带头直到体力不支为之，换句话说，在任意时刻，所有不带头的奶牛体力相同

然后就可以有多项式复杂度的`dp`，令`dp[i][j][f][t]`表示 骑了`i`圈，还剩下`j`头奶牛，带头的体力为`f`，剩下的体力为`t` 时，最小的圈数

但是这样`dp`大概要$2\times 10^{10}$左右，还要进一步优化

另一个性质:

+ 由于不带头的奶牛从来没有带头过，所以有用的`dp`一定满足`t = E - i`

于是就可以把`dp`的最后一维压缩掉

复杂度: $O(N\cdot D\cdot E\cdot \sqrt{D})$

### 转移

一共两种转移

+ `dp[i][k][f] -> dp[i-t][k][f-t*t]`
+ `dp[i][k][f] -> dp[i-t][k-1][e-(d-(i-t))]`

#### 实现

```cpp
repb (i,d,1) repb (k,n,1) repb (f,e,1) repa (t,i) if (f-t*t>=0) {
    checkMin(dp[i-t][k][f-t*t], dp[i][k][f]+1);
    checkMin(dp[i-t][k-1][e-(d-(i-t))], dp[i][k][f]+1); }

```



上面的方法已经可以AC了，并且跑得不慢。

要知道这是02年的题，当时的编译器和机器下这样估计得T

### 再优化

发现一件事情，对于第一种转移，对于每个`k`，我们干的事情实际上是相同的

于是我们可以预处理出`f[i][j]`，表示在带头的牛体力为`i`且不掉队的情况下，骑`j`圈需要的最少时间

预处理时间复杂度$O(D\cdot E\cdot \sqrt{D})$

然后求出`F[i][j]`，表示`i`头牛，骑`j`圈的最小时间

答案即为`dp[n][d]`

转移:

+ `F[i-1][j-k]+f[E-d][k] -> F[i][j]`

复杂度$O(ND^2)$

总时间复杂度$O(DE\cdot \sqrt{D}+ND^2)$

#### 实现

```c++
memset(f,0x3f,sizeof(f));
for ( int i=0;i<=E;i++ ) f[i][0]=0;
for ( int i=1;i<=E;i++ ) 
	for ( int j=1;j<=D;j++ ) 
		for ( int k=1;k<=j&&k*k<=i;k++ ) 
			f[i][j]=min(f[i][j],f[i-k*k][j-k]+1);
memset(F,0x3f,sizeof(F));
F[0][0]=0;
for ( int i=1;i<=n;i++ ) 
	for ( int j=0;j<=D;j++ ) {
		int d=D-j;
		for ( int k=0;k<=j;k++ ) {
			F[i][j]=min(F[i][j],F[i-1][j-k]+f[E-d][k]);	} }
```
