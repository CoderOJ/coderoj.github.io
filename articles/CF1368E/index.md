---
title: CodeForces 1368E
tags:
  - Tutorial
  - Constructive
---

# [CodeForces 1368E](https://codeforces.com/problemset/problem/1368/E)

## Tutorial

神仙题

这个 $\frac47$ 似乎提示性很强的样子，不难想到拆成 $\frac{4}{1 + 2 + 4}$

这启示我们把点分为三个集合 $A, B, C$，满足限制 $|C| \leq 2|B| \leq 4|A|$，然后把 $C$ 集合中的点全部删除

考虑如何限制集合的大小关系，题目中保证一个点最多只有两条出边，那么如果我们有两个集合 $U,V$ 满足 $V$ 中的点都有一条来自 $U$ 的入边，就可以得到 $|V| \leq 2|U|$

按照这个思路，我们可以如下定义三个集合：

+ A: 没有入边或者所有入边来自 $C$
+ B: 至少有一条入边来自 $A$，没有入边来自 $B$
+ C: 至少有一条入边来自 $B$

不难证明一定能这样划分。

题目中给定的图是 DAG，所以可以直接按照拓扑序逐个确定。

## Code

```c
enum color_t
{
  color_a, 
  color_b,  
  color_c
};

enum color_t col[N];

void solve()
{
  scanf("%d%d", &n, &m);
  clear_graph();
  for (int i=0; i<m; ++i)
  {
    int u, v;
    scanf("%d%d", &u, &v);
    add_edge(v, u);
  }

  col[1] = color_a;
  for (int u=2; u<=n; ++u)
  {
    col[u] = color_a;
    for (struct edge_t *i = e[u]; i; i = i->next)
    {
      if (col[i->v] == color_b)
        col[u] = color_c;
      if (col[u] != color_c && col[i->v] == color_a)
        col[u] = color_b;
    }
  }
    
  int cnt = 0;
  for (int i=1; i<=n; ++i)
    if (col[i] == color_c)
      cnt++;
  printf("%d\n", cnt);
  for (int i=1; i<=n; ++i)
    if (col[i] == color_c)
      printf("%d ", i);
  puts("");
}
```



