---
title: Code Jam 2021 Round 1C
tags: 
  - Tutorial
---

# Code Jam 2021 Round 1C 

今年 Code Jam 时间是真的阴间，1A 和省选冲，1B 在半夜，1C 在尴尬的 5 点，2 也因为一些奇怪的原因打不了~~我还要 T-Shirt~~

说起来这几年真越来越卷了，Qualification Round 两千多个 AK，我最后一个 MO 题没写直接 rk 3k+， ~~19 年只有不到 500 个 AK~~。
CF 上有个曾经 Master 的老哥去年 1A rank 600 今年直接进不了。

想着 R1 都不过太逊了，于是决定还是打一下 R1C。
没吃晚饭就开打了，~~靠着下午吃的蛋糕撑到了夜宵~~

题目还是一如既往的偏思维，区分度仍然很迷(?)

最后 52 秒极限过 C，直接从 rk 1700+ 到 rk 102 就很爽

还有谷歌怎么这么咕咕咕的啊，按 1A 和 1B 的情况来看代码查重要跑个四五天才能出终榜。

# A. Closest Picks

## Description

懒得翻了，直接原题面扔上来：

>  You are entering a raffle for a lifetime supply of pancakes. $N$ tickets have already been sold. Each ticket contains a single integer between 1 and $K$, inclusive. Different tickets are allowed to contain the same integer. You know exactly which numbers are on all of the tickets already sold and would like to maximize your odds of winning by purchasing two tickets (possibly with the same integer on them). You are allowed to choose which integers between 1 and $K$, inclusive, are on the two tickets.
>
>  You know you are the last customer, so after you purchase your tickets, no more tickets will be purchased. Then, an integer *c* between 1 and $K$, inclusive, is chosen uniformly at random. If one of your tickets is strictly closer to *c* than all other tickets or if both of your tickets are the same distance to *c* and strictly closer than all other tickets, then you win the raffle. Otherwise, you do not win the raffle.
>
>  Given the integers on the $N$ tickets purchased so far, what is the maximum probability of winning the raffle you can achieve by choosing the integers on your two tickets optimally?
>
>  $N \leq 30,K \leq 10^9$

## Tutorial

$N$ 很小，所以随便来。

考虑原先的 tickets 把 $1$ 到 $K$ 划分成很多段，然后自己选的两张要么在同一段里要么分别在两段。

如果两张在同一段的话显然一张头一张尾可以覆盖整段。

不在同一段的话假设段长为 $L$， 那么一张可以覆盖的长度为 $\lceil \dfrac{L}{2} \rceil$，放在最长的两段即可，注意首尾也有可能。

时间复杂度 $O(n \log n)$

## Code

赛时写的非常丑，赛后有重新写了一遍

```cpp
constexpr int N = 35;
int n, k, a[N];
int case_num = 1;

void preInit() { } 
void init() {
  n = sc.n(); k = sc.n();
  for (int i: range(n)) a[i] = sc.n();
  std::sort(a, a+n); } 

void solve() {
  Vector<int> bars { a[0] - 1, k - a[n-1] };
  for (int i=0; i+1<n; ++i) bars.push_back((a[i+1] - a[i]) / 2);
  std::sort(bars.begin(), bars.end(), std::greater<int>());
  int ans1 = bars[0] + bars[1];

  int ans2 = std::max(a[0] - 1, k - a[n-1]);
  for (int i=0; i+1<n; ++i) checkMax(ans2, a[i + 1] - a[i] - 1);

  printf("Case #%d: %.12lf\n", case_num++, 
         1.0 * std::max(ans1, ans2) / k); }
```

# B. Roaring Years

## Description

定义一个数是好的，当且尽当它能被写成 $a \\# a+1 \\# a+2 \\# \cdots \\# a+k(k\geq 1)$，其中 $\\#$ 表示十进制表示下字符串的拼接。

给定一个数 $n$，求最小的大于 $n$ 的好的数。

$n \leq 10^{18}$

## Tutorial

场上写了一个很阴间的做法，然后 F 了。

一个简洁的做法是枚举 $k$，然后再二分 $a$ 的值，显然它有单调性。

## Code

```python
def gen(a, n):
    res = ""
    for i in range(n):
        res = res + str(a)
        a += 1
    return int(res)

def main():
    n = int(input())
    ans = 10 ** 100
    for length in range(2, 18):
        l, r = 1, 10 ** 20
        while l < r:
            mid = (l + r) // 2
            if gen(mid, length) > n:
                r = mid
            else:
                l = mid + 1
        pos = gen(l, length)
        if ans > pos:
            ans = pos
    return ans

T = int(input())
for i in range(T):
    print("Case #{}: {}".format(i + 1, main()))
```

# C. Double or NOTing

## Description

给定两个二进制串 $s,t$，每次操作可以将 $s$ 二进制翻转（零变一一变零）或者乘二（后面加零），每次操作删除多余前导零，问最少多少次能把 $s$ 变成 $t$

Test Set 1: $|s|, |t| \leq 8$

Test Set 2: $|s|, |t| \leq 100$

## Tutorial

一开始先打算写的暴力，然后没注意到 "0" 乘二以后还是 "0" 不是 "00" 所以暴力一直没过。当时认为答案上界是 $3n$ 或者 $2n + O(1)$，以为搜的不够深，但是再深就 TLE 了。事实证明长度为 8 的时候答案最多只有 15。

感觉暴力没前途以后尝试了一下正解，想出了一个感觉靠谱的做法但还是因为乘二的原因 WA 了。然后就一直拍拍不出来，最后几分钟意识到乘二的问题，改掉以后就在大约还剩 50 秒左右的时候过了。

先考虑一个简单的性质。如果操作中有两个连续的 NOT，那么我们一定可以把这两个 NOT 一起放到操作序列的最后，显然答案不会更劣。

然后发现我们可以控制的一定是 $t$ 的一段后缀，所以可以枚举后缀的长度，尝试构造出这个后缀，然后判断前面的部分是否符合要求。

具体的，对于一段连续的零或一，不断乘二，然后在在零一的边界二进制翻转，最后再不断翻转去除多余的高位。

注意第一步也可能是翻转，所以要考虑两种情况。

时间复杂度 $O(n^3)$，实现的精细一点可以做到 $O(n^2)$，不知道有没有更优的做法。

## Code

```python
def trim(n):
    while len(n) > 1 and n[0] == "0":
        n = n[1:]
    return n

def noting(n):
    return trim("".join(map(lambda c: "1" if c == "0" else "0", n)))

def doubling(n):
    if n == "0":
        return "0"
    return n + "0"

def doit(f, t, param):
    pos = param[0] if len(param) >= 1 else " "
    ans = 0
    for c in param:
        if c != pos:
            f = noting(f)
            ans += 1
        f = doubling(f)
        ans += 1
        pos = c
    if pos == "1":
        f = noting(f)
        ans += 1

    while len(f) > len(t):
        f = noting(noting(f))
        ans += 2
    if f == t:
        return ans
    return 10 ** 100

def main():
    a, b = input().split()
    ans = 10 ** 100
    lb = len(b)
    for i in range(lb+1):
        # 第一步是 doubling
        ans = min(ans, doit(a, b, b[lb-i:]))
        # 第一步是 noting
        ans = min(ans, doit(noting(a), b, b[lb-i:]) + 1)
    if ans >= 10 ** 100:
        return "IMPOSSIBLE"
    return ans

T = int(input())
for i in range(T):
    print("Case #{}: {}".format(i + 1, main()))
```

