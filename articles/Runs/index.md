---
title: Runs 学习笔记
tags:  String
---

# Runs 学习笔记

这个字符串菜鸡来填坑了。

照着孔姥爷的博客学的所以这篇博客会和孔姥爷的那篇很像~~一模一样~~

可能有一些 MathJax 炸了但应该问题不大。

## 一些记号和约定

+ 文章中的字符串下标从 $1$ 开始（代码中一般 index-0），$s\_i,s[i]$ 表示字符串 $s$ 的第 $i$ 个字符，$|s|$ 表示 $s$ 的长度
+ $ > $ 和 $ < $ 表示字典序的比较，空串的字典序最小
+ $\Sigma$ 表示字符集大小，$\Sigma^\*$ 表示字符集为 $\Sigma$ 的字符串，$\Sigma^+ = \Sigma^\* \setminus \{\epsilon\}$，即非空串集合。
+ $\epsilon$ 表示空串，$\\$$ 表示特殊字符，且 $\forall c \in \Sigma, \\$ > c\$
+ $\overline \Sigma = \Sigma \cup \{\$\}$， $\overline{\Sigma^\*}$ 表示字符集为 $\overline \Sigma$ 的字符串
+ 默认普通字符串中不包含特殊字符 $\\$$
+ $st, s+t$ 均表示字符串拼接
+ $s^k$ 表示 $s$ 重复 $k$ 次得到的字符串，$s^\infty$ 表示 $s$ 重复无限次得到的字符串
+ $s^R$ 表示 $s$ 翻转过后的字符串
+ $s[i:j]$ 表示 $s$ 的第 $i$ 位到第 $j$ 位构成的子串，若 $i > j$ 则为 $\epsilon$，$s[:i] = s[1:i], s[i:] = s[i:|s|]$
+ $s \prec t \Leftrightarrow s + \\$ < v, s \succ t \Leftrightarrow s > t + \\$$
+ $\operatorname{lcp}(s,t)$ 表示 $s$ 和 $t$ 的最长公共前缀
+ $\operatorname{period}$：整数 $l$ 是 $s$ 的一个 $\operatorname{period}$ 当且仅当 $\forall i \in [1, |s| - l], s\_i = s\_{i+l}$
+ $\operatorname{border}$：整数 $l$ 是 $s$ 的 $\operatorname{border}$ 当且仅当 $\forall i \in [1,l], s\_i = s\_{n - l + i}$ + 整循环串：$s$ 是一个整循环串当且仅当 $\exists t \in \Sigma^\*, s = t^k (k \geq 2)$
+ 循环串：$s$ 是一个循环串当且仅当 $\exists t \in \Sigma^\*, s = t^k + t[:p]$， 其中 $k$ 是任意整数，$p<|t|$
+ 最短循环节：长度最小的 $t$ 满足 $s = t^k (k \geq 2)$

## 一些前置结论

1. 若 $u \prec v$，则 $\forall w\_1, w\_2 \in \Sigma^\*, u + w\_1 \prec v + w\_2$，$\succ$ 同理。

## Lyndon Word

定义 $s$ 是一个 Lyndon Word 当且仅当 $s$ 比它所有的后缀都要小，即 $\forall i \in [2,|s|], s < s[i:]$。

比如 $\texttt{ababb}$ 是一个 Lyndon Word 而 $\texttt{abab}$ 不是。

### Lyndon 的一些性质

+ 若 $s$ 是一个 Lyndon Word，则 $\forall i \in [1, |s|-1], s[:i] \prec s[n-i+1:]$
+ 若 $u$ 和 $v$ 都是 Lyndon Word 且 $u < v$，则 $uv$ 也是 Lyndon Word

~~证明显然。~~

### Lyndon 分解

定义：把一个字符串分为若干 Lyndon Word，并且字典序单调不增。

形式化地说，对于一个字符串 $s$，若 $t\_1 + t\_2 + \cdots + t\_n = s, \forall i \in [1,n], t\_i \text{ is a Lyndon Word}$ 且 $\forall i>j, t\_i \geq t\_j$，那我们称 $t\_1 \cdots t\_n$ 为 $s$ 的一个 Lyndon 分解。

通常采用 Duval 算法求 Lyndon 分解。

#### Duval 算法

考虑依次插入字符，维护当前的 Lyndon 分解。

我们假设分解形式为 $T + t^k + t[:p]$，其中 $T = t_1t_2\cdots t_m$ 且满足 $t_1 \geq t_2 \geq \cdots \geq t_m > t$

设当前加入的字符为 $c$，$u = t[p + 1]$，分类讨论：

+ $c = u$，则转移到分解 $T + t^k + t[:p+1]$
+ $c < u$，则 $T \gets T + t + \cdots + t\text{(for m times)}$，并转移到分解 $T + (t + c)$
+ $c > u$，则 $t^k + t[:p] + c$ 是一个 Lyndon Word，则转移到 $T + (t^kt[:p]c)^1 + \epsilon$

具体地，我们考虑维护一个三元组 $(i,j,k)$ 其中 $i$ 是 $t+t[:p]$ 的首字母位置，$[j,k)$ 是最后一个循环节。

那么就可以如下转移：

+ $c = u: (i,j,k) \gets (i, j+1, k+1)$
+ $c < u: (i,j,k) \gets (k, k, k+1)$
+ $c > u: (i,j,k) \gets (i, i, k+1)$

代码如下:

```c
struct duval_triple
{
  int index;
  int loop_l, loop_r;
};

static int *duval(int *dest, const char *src)
{
  struct duval_triple pos = { 0, 0, 1 };

  while (src[pos.index])
  {
    pos.loop_l = pos.index;
    pos.loop_r = pos.index + 1;
    while (src[pos.loop_r] && 
           src[pos.loop_l] <= src[pos.loop_r])
    {
      if (src[pos.loop_l] < src[pos.loop_r])
        pos.loop_l = pos.index;
      else pos.loop_l++;
      pos.loop_r++;
    }
    int len = pos.loop_r - pos.loop_l;
    while (pos.index <= pos.loop_l)
    {
      pos.index += len;
      *dest++ = pos.index;
    }
  }
  return dest;
}
```

### Lyndon 数组

定义：对于一个字符串 $s$，定义 $\lambda_i$ 表示从 $i$ 开始的最长 Lyndon Word 的终止位置，
即 $s[i:\lambda_i]$ 是一个 Lyndon 且 $\forall j > \lambda_i s[i:j]$ 不是 Lyndon Word。

性质：若 $u$ 是一个 Lyndon Word，$s$ 的 Lyndon 分解是 $t_1t_2\cdots t_n$，那么 $u < t_1 \Leftrightarrow u+s < s$

证明：

+ $u < t_1 \Rightarrow u+s < s$  
  若 $u \prec t_1$，那么根据前置结论 1，有 $u+s < t_1 + (t_2\cdots t_n)$  
  否则有 $|u| < |t_1|$，设 $l=|t_1|-|u|$，那么由于 $t_1$ 是 Lyndon，$t_1[:l] < t_1[|t_1|-l+1:]$
+ $u+s < s \Rightarrow u < t\_1$  
  考虑使用反证法，即证明 $u\geq t\_1 \Rightarrow u+s\geq s$  
  同理若 $u \succ t\_1$，则 $u+s > t\_1 + (t\_2\cdots t\_n)$  
  否则 $|u| \geq |t\_1|, u[:|t\_1|] = t\_1$，设 $l=|u|-|t\_1|$，则由 Lyndon 的性质可得 $u[|u|-l+1:] \succ u \geq t\_1 \geq t\_2$，所以 $u[:l] + u[|u|-l+1:] \succ t\_1 + t\_2$，即 $u+s\geq s$

算法实现：

从后往前加字符，考虑维护一个单调栈 $t$ 表示当前后缀的 Lyndon 分解（$t\_0$ 是栈顶），满足 $t\_i \geq t\_{i+1}$

假设我们当前加入的字符为 $c$。设 $s=c$，每次判断是否有 $s < t\_0$，如果是就 $s \gets s+t\_0$  并弹出栈顶。重复上述步骤直到满足单调性，再将 $s$ 插入栈中。此时 $\lambda\_i$ 就是 $s$ 的右端点。

复杂度瓶颈在于求 $\operatorname{lcp}$，总复杂度 $O(n \log n)$ 或 $O(n)$。

## Runs 

### 定义

定义三元组 $(i,j,p)$ 是 $s$ 的一个 run，当且仅当 $s[j+1] \neq s[j-p+1], s[i] \neq s[i+p-1]$ 且 $s[i:i+p-1]$ 是 $s[i:j]$ 长度最小的出现至少两次的循环节（不一定为整循环节）。

人话就是循环次数至少为 2 的循环串，并且不能往左右延伸。

比如在 $\texttt{ababababba}$ 这个串中：

+ $(1, 8, 2)$ 是一个 run
+ $(3, 8, 2)$ 不是，因为可以继续向左延伸
+ $(1, 8, 4)$ 不是，因为 $\texttt{abab}$ 不是 $\texttt{abababab}$ 的最小 period
+ $(6, 10, 3)$ 不是，因为 $\texttt{abb}$ 没有出现最少 2 次。

Runs: 定义 $\operatorname{Runs}(s)$ 为所有 $s$ 的 run 的集合。

指数：定义一个 run $(l,r,p)$ 的指数为 $\frac{r-l+1}{p}$，即 period $p$ 在 $[l:r]$ 中出现的次数，记为 $e(l,r,p)$

偏序关系：定义两种偏序关系 $<\_0, <\_1$，其中 $<\_0$ 一般表示字典序较小， $<\_1$ 一般表示字典序较大。  
$\ell \in \\{0,1\\}$ 表示一种偏序关系，$\overline \ell$ 表示与 $\ell$ 相反的偏序关系，$< \_\ell$ 表示 $\ell$ 对应的偏序关系。  
在 $<\_\ell$ 上定义的 Lyndon Word 意为将比较定义为 $<\_\ell$ 定义下的 Lyndon Word。

Lyndon Root：定义 $s[\lambda\_l:\lambda\_r]$ 是 $(i,j,p)$ 在 $ <\_\ell $ 上的 Lyndon Root，
当且仅当 $[\lambda\_l, \lambda\_r] \in [i,j]$ 且 $s[\lambda\_l, \lambda\_r]$ 是一个定义在 $<\_\ell$ 上的 Lyindon Word。

run 的类型：run $(i,j,p)$ 是 $\ell(\ell \in \{0,1\})$ 型的，当且仅当 $s[j-p+1] <\_\ell s[j+1]$。

$l\_\ell(p)$：$l\_\ell(p)$ 表示以位置 $p$ 开头的最长定义在 $\ell$ 上的 Lyndon Word （就是 Lyndon 数组）

### 推论

+ 对于 $\ell$ 型 run，其所有定义在 $<\_\ell$ 上的 Lyndon Root $\lambda = [\lambda\_l, \lambda\_r]$ 都有 $\lambda = l\_\ell(\lambda\_l)$，
即所有 Lyndon Root 都是同起点中的最长的 Lyndon Word。

不难发现对于$\ell$ 型 run $(i,j,p)$，$\forall p \in [i,j], |l\_\ell(p)| \leq j - p + 1$，也就是不存在跨于这个 run 的 Lyndon Word。

+ 对于任意 run $r(i,j,p)$，其所有 Lyndon Root 左端点不重复。

证明比较显然，考虑每一个开始位置，显然 Lyndon Root 的长度小于等于 $p$，根据 Duval 算法的过不难发现小于等于循环节的 Lyndon Word 仅有一个。

### Runs 的求解

对于两种 run 分别求解再去重。

先求出所有的 $l\_\ell$，即求出 Lyndon 数组。

我们令 $p\_i = s[\_\ell(i) : l\_\ell(i)]$，观察其往左往右能延伸到最远的地方 $s[l\_i':r\_i']$。对于三元组 $(l\_i', r\_i', |p\_i|)$，我们只需要判断是否满足 $|p\_i| \geq \frac{r\_i'-l\_i'+1}{2}$ 即可。

不难证明这样一定能找到所有的 run，至此完成了 Runs 的求解。

### 代码

```cpp
#include <bits/stdc++.h>

constexpr int N = 1000005;
constexpr int B = 2333;

char str[N];
uint64_t s[N];
int n;

uint64_t h[N], bs[N];
uint64_t get(int l, int r)
{
  return h[r] - h[l - 1] * bs[r - l + 1];
}

int lcp(int x, int y)
{
  int l = 1, r = n - std::max(x, y) + 1, res = 0;
  while (l <= r)
  {
    int mid = (l + r) >> 1;
    if (get(x, x + mid - 1) == get(y, y + mid - 1))
      l = mid + 1, res = mid;
    else
      r = mid - 1;
  }
  return res;
}

int lcs(int x, int y)
{
  int l = 1, r = std::min(x, y), res = 0;
  while (l <= r)
  {
    int mid = (l + r) >> 1;
    if (get(x - mid + 1, x) == get(y - mid + 1, y))
      l = mid + 1, res = mid;
    else
      r = mid - 1;
  }
  return res;
}

bool cmp(int l1, int r1, int l2, int r2)
{ // s[l1:r1]<s[l2:r2]
  int l = lcp(l1, l2);
  if (l > std::min(r1 - l1, r2 - l2))
    return r1 - l1 < r2 - l2;
  return s[l1 + l] < s[l2 + l];
}
struct runs
{
  int i, j, p;
  runs(int i = 0, int j = 0, int p = 0) : i(i), j(j), p(p)
  {
  }
  bool operator==(const runs a) const
  {
    return i == a.i && j == a.j && p == a.p;
  }
  bool operator<(const runs a) const
  {
    return i == a.i ? j < a.j : i < a.i;
  }
};

std::vector<runs> ans;
int st[N], t, run[N];

void lyndon()
{
  t = 0;
  for (int i = n; i; i--)
  {
    st[++t] = i;
    for (; t > 1 && cmp(i, st[t], st[t] + 1, st[t - 1]); t--)
      ;
    run[i] = st[t];
  }
}

void init()
{
  bs[0] = 1;
  for (int i = 1; i <= n; i++)
    h[i] = h[i - 1] * B + s[i], bs[i] = bs[i - 1] * B;
}

void get_runs()
{
  for (int i = 1; i <= n; i++)
  {
    int l1 = i, r1 = run[i], l2 = l1 - lcs(l1 - 1, r1), r2 = r1 + lcp(l1, r1 + 1);
    if (r2 - l2 + 1 >= (r1 - l1 + 1) * 2)
      ans.push_back(runs(l2, r2, r1 - l1 + 1));
  }
}

int main()
{
  scanf("%s", str + 1);
  n = (int)std::strlen(str + 1);
  for (int i = 1; i <= n; i++)
    s[i] = (uint64_t)(str[i] - 'a' + 1);

  init();
  lyndon();
  get_runs();

  for (int i = 1; i <= n; i++)
    s[i] = 27 - s[i];

  lyndon();
  get_runs();
  sort(ans.begin(), ans.end());
  ans.erase(unique(ans.begin(), ans.end()), ans.end());

  printf("%d\n", (int)ans.size());
  for (auto u : ans)
    printf("%d %d %d\n", u.i, u.j, u.p);

  return 0;
}
```

