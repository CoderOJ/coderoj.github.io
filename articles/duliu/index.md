---
title: 毒瘤题选做
tags:
  - Tutorial
---

放假这几天不如写点毒瘤题

# [BOJ19017 Automorphism](https://www.acmicpc.net/problem/19017)

xza 课间上的题，似乎他自己都没写过。

## Description

给你一棵树，初始状态下只有一个结点，以下两种操作：

+ 在一个点的下方加入一个新点
+ 询问某个子树的自同构数量（有取模）

## Tutorial

先考虑静态的问题。

每个点的贡献是儿子子树同构数阶乘的积，子树同构除了树哈希也没什么其他做法。

然后考虑动态加入一个点产生的影响。显然哈希值和对答案贡献的改变只存在于根到这个点的链上，暴力跳父亲可以获得 $O(n^2)$ 的时间复杂度。

不难发现假如我们对整棵树重链剖分（此处的重儿子定义为严格重儿子，即大小严格大于其他兄弟的儿子，一个点可能没有重儿子，但时间复杂度同样正确），跳父亲时重链上的边一定不会对答案产生影响。然后我们需要维护重链上哈希值的变化。

考虑常规的树哈希方式：用子树哈希值作为关键字将儿子排序，然后在 dfs 序上每个点对应的位置放上这个点的深度，然后做序列哈希。由于子树哈希值的变化会导致儿子顺序的改变，无法快速维护。考虑重链天然的性质，如果我们以子树大小为第一关键字，子树哈希值为第二关键字排序，那么重儿子的修改一定不会导致儿子顺序的变化，因此可以用 $O(1)$ 的信息标记一次修改，并且标记可以 $O(1)$ 合并。

具体的，我们还要对每个结点维护一棵平衡树记录该结点所有轻儿子的哈希值。这样便可以在 $O(\log n)$ 对一条轻边进行更新，同时可以 $O(\log n)$ 查询更新前后同构子树的数量。

重链剖分可以通过 LCT 动态维护，注意此时一条重链在 LCT 上对应一个联通块而非一棵 splay，否则无法进行 access

[AC 记录](https://www.acmicpc.net/source/32233708) 不过似乎要过了才能看，那就下面贴一下。


[{MDEXPAND code

<!-- {{{ -->

```cpp
#include "/home/jack/code/creats/gpl.hpp"

#include <bits/stdc++.h>

#include "/home/jack/code/creats/Scanner.hpp"
#include "/home/jack/code/creats/log.hpp"
// #include "/home/jack/code/creats/range.hpp"
#include "/home/jack/code/creats/util.hpp"
// #include "/home/jack/code/creats/Vector.hpp"

// #include "/home/jack/code/creats/STree.hpp"
// #include "/home/jack/code/creats/Tree.hpp"
// #include "/home/jack/code/creats/Graph.hpp"
#define INTM_FAST_64 long long
#include "/home/jack/code/creats/Intm.hpp"
// #include "/home/jack/code/Math/Poly/main.h"


// #define MULTIPLE_TEST_CASES_WITH_T
// #define MULTIPLE_TEST_CASES_WITHOUT_T
#include "/home/jack/code/creats/body.h"
// #define int long long

/** My code begins here **/

constexpr int MOD = 998244353;
constexpr int N = 300005;
using Int = Temps::Intm<MOD>;
Int inv[N];
uint64_t hash_cpow[N];

template <class T, size_t N>
struct pool_allocator
{
  T pool[N], *pos = pool;
  T *allocate()
  {
    return pos++;
  }
};

using hash_val_t = uint64_t;
using hash_ord_t = std::pair<size_t, hash_val_t>;
hash_ord_t hash_join(hash_ord_t a, hash_ord_t b)
{
  return hash_ord_t(a.first + b.first,
                    a.second + hash_cpow[a.first] * b.second);
}
hash_ord_t hash_det(hash_ord_t a, hash_ord_t b)
{
  return hash_ord_t(b.first - a.first,
                    b.second - a.second * hash_cpow[b.first - a.first]);
}

struct ftreap_node_t
{
  constexpr static auto ord_cmp = std::greater<hash_ord_t>();
  static std::mt19937_64 rand_eng;
  static pool_allocator<ftreap_node_t, N * 16> allocator;
  hash_ord_t hash_val;
  hash_ord_t hash_sum;
  ftreap_node_t *l = nullptr, *r = nullptr;
  unsigned long weight = rand_eng();
  size_t size = 1;

  void push_up()
  {
    size = 0;
    hash_sum = {0,0};
    if (l != nullptr)
    {
      size += l->size;
      hash_sum = hash_join(hash_sum, l->hash_sum);
    }
    size += 1;
    hash_sum = hash_join(hash_sum, hash_val);
    if (r != nullptr)
    {
      size += r->size;
      hash_sum = hash_join(hash_sum, r->hash_sum);
    }
  }
};
std::mt19937_64 ftreap_node_t::rand_eng(18100820);
pool_allocator<ftreap_node_t, N * 16> ftreap_node_t::allocator;
extern ftreap_node_t *t[N];

void ftreap_join(ftreap_node_t *&u, ftreap_node_t *l, ftreap_node_t *r)
{
  if (l == nullptr) { u = r; return; }
  if (r == nullptr) { u = l; return; }
  if (l->weight > r->weight)
    ftreap_join((u = l)->r, l->r, r);
  else
    ftreap_join((u = r)->l, l, r->l);
  u->push_up();
}

void ftreap_split(ftreap_node_t *&l, ftreap_node_t *&r,
                  ftreap_node_t *u, hash_ord_t thr)
{
  if (u == nullptr)
  {
    l = r = nullptr;
    return;
  }
  if (ftreap_node_t::ord_cmp(u->hash_val, thr))
    ftreap_split((l = u)->r, r, u->r, thr);
  else
    ftreap_split(l, (r = u)->l, u->l, thr);
  u->push_up();
}

// return key count (before)
size_t ftreap_erase_once(ftreap_node_t *&u, hash_ord_t val)
{
  // see("erase", &u - t, val);
  ftreap_node_t *a, *b, *c;
  ftreap_split(a, b, u, val);
  val.second--;
  ftreap_split(b, c, b, val);
  size_t res = b->size;
  ftreap_join(b, b->l, b->r);
  ftreap_join(a, a, b);
  ftreap_join(u, a, c);
  return res;
}

// return key count (after)
size_t ftreap_insert(ftreap_node_t *&u, hash_ord_t val)
{
  // see("insert", &u - t, val);
  ftreap_node_t *a, *b, *c, *d;
  d = ftreap_node_t::allocator.allocate();
  d->hash_val = d->hash_sum = val;
  ftreap_split(a, b, u, val);
  val.second--;
  ftreap_split(b, c, b, val);
  ftreap_join(b, b, d);
  size_t res = b->size;
  ftreap_join(a, a, b);
  ftreap_join(u, a, c);
  return res;
}

hash_ord_t ftreap_first(ftreap_node_t *u)
{
  while (u->l != nullptr)
    u = u->l;
  return u->hash_val;
}

// lct maintains the hash tuple of one's wson
struct lct_node_t
{
  lct_node_t *f = nullptr, *s[2] = {nullptr, nullptr};
  hash_ord_t val = {0,0}, join = {0,0};
  Int ans = 1, ans_mul = 1;
  bool is_root() { return f == nullptr || (f->s[0] != this && f->s[1] != this); }
  bool get_son() { return f->s[1] == this; }
  void push_join(hash_ord_t det) { val = hash_join(det, val); join = hash_join(det, join); }
  void push_mul(Int det_mul) { ans *= det_mul; ans_mul *= det_mul; }
  void push_down() 
  { 
    if (s[0] != nullptr) { s[0]->push_join(join); s[0]->push_mul(ans_mul); }
    if (s[1] != nullptr) { s[1]->push_join(join); s[1]->push_mul(ans_mul); }
    join = {0,0}; ans_mul = 1;
  }
  void push()
  {
    if (!is_root()) f->push();
    push_down();
  }
  void rotate()
  {
    lct_node_t *uu = this, *ff = f, *aa = ff->f;
    bool ss = uu->get_son();
    if (!ff->is_root()) aa->s[ff->get_son()] = uu;
    ff->f = uu; ff->s[ss] = uu->s[!ss];
    uu->f = aa; uu->s[!ss] = ff;
    if (ff->s[ss] != nullptr) ff->s[ss]->f = ff;
  }
  void splay()
  {
    push();
    while (!is_root())
    {
      if (f->is_root()) { rotate(); break; }
      (is_root() == f->is_root() ? f : this)->rotate();
      rotate();
    }
  }
  void access()
  {
    lct_node_t *uu = this, *ss = nullptr;
    while (uu != nullptr)
    {
      uu->splay(); uu->s[1] = ss;
      ss = uu; uu = uu->f;
    }
  }
};


lct_node_t p[N];
lct_node_t pp[N];
ftreap_node_t *t[N];
int fa[N], dep[N], ws[N];

void lct_link(int u)
{
  // see("LCT: link", u);
  p[u].access();
  p[u].splay();
  p[u].f = &p[fa[u]];
}

void lct_cut(int u)
{
  // see("LCT: cut", u);
  p[fa[u]].access();
  p[u].splay();
  p[u].f = nullptr;
}

void lct_reset(int u, hash_ord_t val)
{
  p[u].splay();
  p[u].val = val;
}

hash_ord_t get_hash(int u)
{
  p[u].access();
  p[u].splay();
  hash_ord_t ws_hash = p[u].val;
  hash_ord_t ot_hash = t[u]->hash_sum;
  see(u, ws_hash, ot_hash);
  return hash_join(ws_hash, ot_hash);
}

int get_top(int u)
{
  p[u].access();
  p[u].splay();
  lct_node_t *pos = &p[u];
  while (pos->s[0] != nullptr)
    pos = pos->s[0];
  pos->splay();
  return static_cast<int>(pos - p);
}

size_t get_size(int u)
{
  p[u].splay();
  return p[u].val.first + t[u]->hash_sum.first;
}

size_t get_smax_size(int u)
{
  if (t[u]->size == 1)
    return 0;
  return ftreap_first(t[u]).first;
}

void update_hash(int u, hash_ord_t u_ori, hash_ord_t u_cur)
{
  see(u, u_ori, u_cur);
  if (u == 1) return;

  const int f = fa[u];
  const size_t u_size = get_size(u);

  const hash_ord_t f_ori = get_hash(f);
  if (ws[f] != 0)
  {
    size_t fs_size = get_size(ws[f]);
    if (fs_size <= u_size)
    {
      assert(fs_size == u_size);
      ftreap_insert(t[f], get_hash(ws[f]));
      lct_cut(ws[f]);
      lct_reset(f, {0,0});
      ws[f] = 0;
    }
  }
  if (u_ori != (hash_ord_t){0,0})
  {
    const size_t ori_cnt = ftreap_erase_once(t[f], u_ori);
    // see("mod_div", f, ori_cnt);
    pp[f].access();
    pp[f].splay();
    pp[f].push_mul(inv[ori_cnt]);
  }
  if (ws[f] == 0 && get_smax_size(f) < u_size)
  {
    lct_link(u);
    lct_reset(f, u_cur);
    // see(f, u_cur);
    ws[f] = u;
  }
  else
  {
    size_t cur_cnt = ftreap_insert(t[f], u_cur);
    // see("mod_mul", f, cur_cnt);
    pp[f].access();
    pp[f].splay();
    pp[f].push_mul(cur_cnt);
  }
  const hash_ord_t f_cur = get_hash(f);

  int top = get_top(f);
  hash_ord_t top_ori, top_cur;
  if (top != f)
  {
    top_ori = get_hash(top);
    const hash_ord_t det = hash_det(f_ori, f_cur);
    see(det);
    int ff = fa[f];
    p[ff].access();
    p[ff].splay();
    p[ff].push_join(det);
    top_cur = get_hash(top);
  }
  else
  {
    top_ori = f_ori;
    top_cur = f_cur;
  }
  update_hash(top, top_ori, top_cur);
}

void preInit() 
{ 
  hash_cpow[0] = 1;
  hash_cpow[1] = 82061943317773333ull;
  for (int i = 2; i < N; i++)
    hash_cpow[i] = hash_cpow[i - 1] * hash_cpow[1];
  inv[1] = 1;
  for (int i = 2; i < N; i++)
    inv[i] = inv[MOD % i] * (MOD - MOD / i);
} 

int m;
void init() 
{ 
  m = sc.n(); 
  dep[1] = 1;
  ftreap_insert(t[1], {1,1});
}

void solve() 
{
  int u = 2;
  for (int i = 0; i < m; i++)
  {
    int opt = sc.n();
    if (opt == 0)
    {
      int f = sc.n(); 
      see("add", f, u);
      fa[u] = f;
      pp[u].f = &pp[f];
      dep[u] = dep[f] + 1;
      ftreap_insert(t[u], {1,dep[u]});
      update_hash(u, {0,0}, {1,dep[u]});
      u++;
    }
    else
    {
      int u = sc.n();
      pp[u].splay();
      std::cout << pp[u].ans << std::endl;
    }
  }
}
```

<!-- }}} -->

}]

# [UR#1 跳蚤国王下江南](https://uoj.ac/problem/23)

久闻其名的毒瘤题，不过写完以后久的其实还好？

## Description

给一棵 $n$ 个点的仙人掌，对于 $1 \leq l \leq n-1$ 求从 1 开始长度为 $l$ 的路径数量。

## Tutorial

看到仙人掌第一反应建圆方树，但这题因为只用考虑上下的路径，所以其实不用方点，直接把圆点连向方点的父亲即可。

求路径数不难想到点分治和 FFT，由于这是有根的问题所以点分治会略有不同。

对于一个分治中心所在的连痛块，我们定义这个联通块的根为深度最浅的那个点，也就是到 1 距离最小的那个点。对于这个联通块我们要求出联通块中所有点到当前联通块根的信息。因此合并答案的方式为：

当前联通块答案 = 点分中心上方答案 + 联通块根到点分中心的答案 $\times$ 点分中心所有儿子的答案的和

把一条权值为 $(a,b)$ 的边看成多项式 $x^a + x^b$，那么直接进行多项式乘法多项式加法即可。

考虑如何求联通块根到点分中心的答案。直接暴力枚举每条边再分治乘法可以做到 $O(\log^2n)$，但我们发现如果先对点分中心上方的联通块求答案，此时这段路径可以被分为 $O(\log n)$ 段 “点分中心-联通块根” 的路径。这些路径的答案都已经求出，直接合并即可。时间复杂度 $T(n) = T(\frac n2) + O(n \log n), T(n) = O(n \log n)$，算上点分的总时间复杂度为 $O(n \log^2 n)$

注意如果仙人掌上有很大的环，圆方树上的边权可能很大，在分治的时候要注意一些细节。合并儿子的时候如果直接乘上当前边的边权会被菊花卡掉，应该用位移再加的方式，保证代价不超过子树大小。

[AC 记录](https://uoj.ac/submission/504283)

# [火车司机出秦川](https://uoj.ac/problem/189)

跳蚤国王和共价大爷都写了，干脆把火车司机也写了

## Description

给定一棵仙人掌，边有边权，保证每个环长度都是奇数。

定义 $\operatorname{path}(u,v,0)$ 表示 $u$ 到 $v$ 的最短简单路径，$\operatorname{path}(u,v,1)$ 表示 $u$ 到 $v$ 的最长简单路径。

进行一下两种操作：

+ 修改某条边的边权
+ 给定 $k$ 条路径 $\operatorname{path}(u,v,t)\ (u,v \in [1,n], t \in \{0,1\})$，求这些路径并集覆盖的边的边权之和

## Tutorial

先解决树上问题，$k$ 条路径查询不难想到虚树，单点修改链查询可以用树状数组维护括号序。

扩展到仙人掌上需要建圆方树。此时一条有车经过的路径有三种类型：只走短路径、只走长路径、长短路径都走。所以也要维护三个树状数组进行链查询。此时边权的修改体现为一个方点的若干相邻儿子修改，在括号序列上仍然是相邻的一段，可以直接修改。

然后考虑查询部分。对于路径一端是方点的情况，不能直接把对应边的答案加到总答案里，应该对于每个方点记录环上哪些区间被覆盖，最后统计到答案里。


[AC 记录](https://uoj.ac/submission/504593)
