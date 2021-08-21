---
title: 支配树学习笔记
tags: 
  - Graph
  - Tree
---

# 支配树学习笔记

## 定义

对于一个有向图 $G$ 和起点 $s$，定义 $u$ 支配 $v$ 当且仅当所有从 $s$ 到 $v$ 的路径都经过点 $u$。支配树即所有支配关系构成的树。

不失一般性，在后文中都假设起点 $s$ 能到达图中的所有点。

## DAG 上的做法

考虑按照拓扑序构建支配树。一开始树中仅有 $s$ 结点。

按照拓扑序，当处理点 $u$ 的时候，所有有边连向 $u$ 的点在支配树上的位置都已经确定。显然点 $u$ 在支配树上的父亲是那些点在支配树上的 $\operatorname{lca}$，直接倍增处理即可。

## 一般图上的做法

没有特殊说明，后文中结点的大小关系均指 $\operatorname{dfn}$ 的大小关系，一个结点的父亲/祖先均指这个点在 dfs 树上的父亲/祖先。

### 定义

如果对与点 $u,v$ 满足存在路径 $u\to v_1 \to \cdots \to v_k \to v$ 且 $\forall i \in [1,k], u_i > v$ ，那么我们称 $u$ 是 $v$ 的**半支配点**。

显然一个点的半支配点有多个，定义 $u$ 的**最小半支配点**为 $\operatorname{semi}(u)$

### 性质

#### 1. $\operatorname{semi}(u)$ 一定是 $u$ 的祖先

证明：

显然点 $u$ 的自己满足存在路径的条件，因此 $\operatorname{semi}(u) \leq u$ 

那么考虑假设 $\operatorname{semi}(u)$ 不是 $u$ 的祖先。由于非树边一定从 $\operatorname{dfn}$ 大的连向 $\operatorname{dfn}$ 小的，所以 $(\operatorname{semi}(u),v_1)$ 这条边只能是树边。 如果 $(\operatorname{semi}(u),v_1)$ 是树边，那么根据 $\operatorname{semi}(u) < u < v$，可以推出 $u$ 在 $\operatorname{semi}(u)$ 的子树中，矛盾。

#### 2. 删除原图非树边，加入形如 $(\operatorname{semi}(u), u)$ 的边，支配关系不变

证明：

形如 $(\operatorname{semi}(u), v)$ 的边在原图中对应一条路径，所以新图中不会引入新的路径，因此原图中的支配关系在新图中必然存在。

然后我们只需要证明对于新图中的支配关系 $(x,u)$ 一定在原图中存在。

新图中支配关系 $(x,u)$ 存在，当且仅当 $x$ 到 $u$ 路径上的任意点 $y$ 满足 $\operatorname{semi}(y) \geq x$。

而如果在原图中支配关系 $(x,u)$ 不存在，即在原图中存在一条不经过 $x$ 的路径 $s \to \cdots \to a \to b \to \cdots \to u(a < x < b)$，那么考虑 $b\to \cdots \to u$ 与 $x\to \cdots \to u$ 的第一个交点 $c$ （$c$ 可能等于 $u$）， 应有 $\operatorname{semi}(c) \leq a$， 矛盾，所以新图中的支配关系都在原图中存在。

### 做法

先求出所有点的最小半支配点，然后删除非树边，加入形如 $(\operatorname{sami}(u), u)$ 的边，此时我们得到了一个与原图支配等价的 DAG，直接套用 DAG 上的做法即可（有更优秀的做法但我不会）。

接下来问题转化为如何求出所有的最小半支配点

考虑一条边 $u \to v$，根据大小关系分类讨论

+ $u < v$，那么 $u$ 是 $v$ 的半支配点
+ $u > v$，那么对于满足 $p > v$ 的 $u$ 的祖先 $p$，$p$ 的半支配点都是 $u$ 的半支配点

显然这覆盖到了所有半支配点的情况。

然后做法就比较显然了。按照 $\operatorname{dfn}$ 倒序枚举每一个点 $u$，考虑所有 $x\to u$ 的边，如果 $x < u$  就用 $x$ 更新 $\operatorname{semi}(u)$，不然就用 $x$ 的所有满足 $p > u$ 的祖先 $p$ 的 $\operatorname{semi}(p)$ 更新 $\operatorname{semi}(u)$，用带权并查集优化即可。 

## 实现

```cpp
#include "https://gitee.com/coderoj/code/raw/master/creats/pipe.h"

constexpr int N = 300005;
constexpr int B = 20;
Vector<int> e[N], eb[N], ed[N], due[N];
int n, m;

int dfn[N], fa[N], semi[N], f[N][B], d[N], size[N], dfncnt=0;
void dfs(int u) {
  dfn[u] = dfncnt++;
  for (int v: e[u]) if (dfn[v] == -1) {
    fa[v] = u; dfs(v); } }

bool dfn_cmp(int u, int v) { return dfn[u] < dfn[v]; }

struct Dsu {
  int p[N], semi[N];
  Dsu() { 
    range(N)
    | ranges::foreach([&](int i) { p[i] = semi[i] = i; }); }

  int get(int u) { 
    if (u == p[u]) { return p[u]; }
    int pa = get(p[u]);
    semi[u] = std::min(semi[u], semi[p[u]], dfn_cmp); 
    return p[u] = pa; }

  void merge(int u, int v) { 
    u=get(u); v=get(v); p[v] = u; } 
} st;

int lca(int u, int v) {
  if (d[u] < d[v]) { std::swap(u,v); }
  int delta = d[u] - d[v]; for (int i=0;i<B;++i) if (delta & (1<<i)) { u=f[u][i]; }
  for (int i=B-1; i>=0; --i) if (f[u][i] != f[v][i]) { u=f[u][i]; v=f[v][i]; }
  return u==v ? u : f[u][0]; }
void init_f(int u, int ufa) {
  f[u][0] = ufa; d[u] = d[ufa] + 1;
  for (int i: range(B-1)) { f[u][i+1] = f[f[u][i]][i]; } }

void dfs1(int u) {
  size[u] = 1;
  for (int v: ed[u]) { 
    dfs1(v); size[u] += size[v]; } }

void preInit() { } void init() {
  n = sc.n(); m = sc.n();
  range(m)
  | ranges::foreach([](int){
    int u = sc.n(), v = sc.n();
    e[u].push_back(v); eb[v].push_back(u); });
} void solve() {
  memset(dfn, -1, sizeof(dfn)); dfs(1);
  for (int i: range(1, n+1)) { semi[i] = i; }

  Vector dfn_id = 
  Vector<int>(range(2,n+1)) 
  | ranges::sortby(dfn_cmp)
  | ranges::reverse;

  dfn_id
  | ranges::foreach([](int u) {
    eb[u] 
    | ranges::foreach([=](int x) {
      st.get(x); 
      semi[u] = std::min(semi[u], st.semi[x], dfn_cmp); 
      st.semi[u] = semi[u]; });

    due[dfn[u]] 
    | ranges::foreach([=](int x) { 
      st.merge(fa[x], x); });

    if (u != 1) { due[dfn[fa[u]]].push_back(u); } });

  std::move(dfn_id)
  | ranges::reverse
  | ranges::foreach([](int u) {
    int f = lca(fa[u], semi[u]);
    ed[f].push_back(u); init_f(u,f); });

  dfs1(1);

  std::cout << (
    Vector<int>(range(1,n+1)) 
    | ranges::transform([](int u) { return size[u]; })
  ) << std::endl;
}
```

