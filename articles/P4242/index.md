---
title: Lougu P4242 树上的毒瘤
date: 2020-10-14 19:21:14
tags: 
	- Tutorial 
	- LCT 
	- VTree
	- Dp
mathjax: true
---

# [P4242](https://www.luogu.com.cn/problem/P4242)

真 毒瘤题。LCT/树剖 + 虚树 + 点分/换根dp，码量有点小大

<!--more-->

前置题目：[SDOI2011染色](https://www.luogu.com.cn/problem/P2486)，[SDOI2011消耗战(虚树板子)](https://www.luogu.com.cn/problem/P2495) ~~(这题怎么这么喜欢SDOI2011啊)~~

那道题是这个的简化版，只对两个点进行查询，而这题要对一堆点查询。

多次查询对一堆点保证总点数大小的显然是虚树。

考虑如何构建这个虚树并保留足够的信息。设虚树中每条边的边权为原树上两个端点之间颜色段数 $-1$，不难证明任意两点间的答案等于路径上边权和$+1$

所以现在要求的就是虚树上每个点到其他点距离的和，经典题，换根dp或者点分就行了

复杂度 $O(n \log n)$ 或者 $O(n \log^2 n)$，取决于用树剖还是LCT（其实LCT大常数应该差不多）

我写的LCT和换根dp，目前最优解，其实还有很多优化空间（比如ST表LCA什么的）。

## code :

```cpp
#define rep(i,n) for (int i=0;i<n;i++)
#define repa(i,n) for (int i=1;i<=n;i++)
#define repb(i,a,b) for (int i=a;i>=n;i--)

const int N = 100005;

struct LCT {
    struct Node {
        Node *s[2], *f;
        int c, lc, rc, tot;
        int rev, tag;
        Node() { s[0]=s[1]=f=NULL; c=lc=rc=tot=rev=0; }

        bool isRoot() {
            if (f==NULL) return 1;
            return this!=f->s[0] && this!=f->s[1]; }
        int getSon() {
            return f->s[1] == this; }
        void pushUp() {
            if (s[0]==NULL && s[1]==NULL) { lc=rc=c; tot=1; }
            else if (s[0]==NULL) { lc=c; rc=s[1]->rc; tot=s[1]->tot + (c!=s[1]->lc); }
            else if (s[1]==NULL) { lc=s[0]->lc; rc=c; tot=s[0]->tot + (c!=s[0]->rc); }
            else {
                lc=s[0]->lc; rc=s[1]->rc;
                tot = s[0]->tot + s[1]->tot + 1 - (s[0]->rc==c) - (c==s[1]->lc) ; } }
        void pushRev() {
            rev ^= 1; swap(s[0],s[1]); swap(lc,rc); }
        void pushTag(int nc) {
            tag=1; c=lc=rc=nc; tot=1; }
        void pushDown() {
            if (tag) { rep (i,2) if (s[i]!=NULL) { s[i]->pushTag(c); } }
            if (rev) { rep (i,2) if (s[i]!=NULL) { s[i]->pushRev(); } }
            tag = rev = 0; } 
        void push() {
            if (!isRoot()) f->push();
            pushDown(); }
        void rotate() {
            int ss = getSon();            
            Node *uu=this, *ff=f, *aa=ff->f, *cc = s[!ss];
            if (!ff->isRoot()) aa->s[ ff->getSon() ] = uu;
            ff->s[ss] = cc; ff->f = uu;
            uu->s[!ss] = ff; uu->f = aa;
            if (cc!=NULL) cc->f = ff;
            ff->pushUp(); uu->pushUp(); }
        void _splay() {
            if (isRoot()) return;
            if (f->isRoot()) { rotate(); return; }
            ( getSon() == f->getSon() ? f : this ) -> rotate(); rotate();
            _splay(); }
        void splay() {
            push(); _splay(); }
        void access() {
            Node *uu=this, *ss=NULL;
            while (uu!=NULL) {
                uu->splay(); uu->s[1]=ss; uu->pushUp(); 
                ss=uu; uu=uu->f; } }
        void makeRoot() {
            access(); splay(); pushRev(); }
    };

    Node p[N];

    void link(int u, int v) {
        p[u].makeRoot(); p[u].f=&p[v]; }
    void split(int u, int v) {
        p[u].makeRoot(); p[v].access(); p[v].splay(); }
    void update(int u, int v, int c) {
        split(u,v); p[v].pushTag(c); }
    int query(int u, int v) {
        split(u,v); return p[v].tot; }
};

struct Tree {
    int ef[N], en[N*2], ev[N*2], ec;
    Tree () { memset(ef,-1,sizeof(ef)); memset(en,-1,sizeof(en)); ec = 0; }
    void addEdge (int u, int v) {
        en[ec] = ef[u]; ef[u] = ec; ev[ec] = v; ec++;
        en[ec] = ef[v]; ef[v] = ec; ev[ec] = u; ec++; }
    void clear(int u) { ef[u] = -1; }
    void clearAll() { ec = 0; }
};

struct Tree1 : public Tree {
    int ew[N*2];
    void addEdge (int u, int v, int w) { w--;
        en[ec] = ef[u]; ef[u] = ec; ev[ec] = v; ew[ec] = w; ec++;
        en[ec] = ef[v]; ef[v] = ec; ev[ec] = u; ew[ec] = w; ec++; }
     
    int sz[N]; long long sum[N], ans[N];
    void clear(int u) { this->Tree::clear(u); sz[u] = 0; }
    void dfs0 (int u, int f) {
        sum[u] = 0; 
        for (int e=ef[u]; e!=-1; e=en[e]) if (ev[e] != f) {
            dfs0(ev[e], u); 
            sz[u] += sz[ev[e]]; sum[u] += 1LL*sz[ev[e]]*ew[e] + sum[ev[e]]; } }
    void dfs1 (int u, int f, long long ups) {
        ans[u] = ups + sum[u];
        for (int e=ef[u]; e!=-1; e=en[e]) if (ev[e] != f) {
            dfs1(ev[e], u, ups + 1LL*ew[e]*(sz[1]-sz[ev[e]]) + sum[u]-sum[ev[e]]-1LL*ew[e]*sz[ev[e]]); } }
} T1;

struct Tree0 : public Tree {
    static const int B = 20;
    LCT T; 
    int d[N], fa[N][B], dfn[N], dfnCnt;

    void addEdge(int u, int v) {
        this->Tree::addEdge(u,v); T.link(u,v); }
    void dfs(int u, int f) {
        dfn[u] = dfnCnt++; d[u] = d[f]+1;
        fa[u][0] = f; rep (i,B-1) { fa[u][i+1] = fa[ fa[u][i] ][i]; }
        for (int e=ef[u]; e!=-1; e=en[e]) if (ev[e] != f) {
            dfs(ev[e], u); } } 
    void init(int _n) {
        repa (i,_n) { int w; scanf(I,&w); T.update(i,i,w); }  }
    void pre() {
        dfnCnt=0; dfs(1,0);  }
    void up(int &u, int d) {
        repb (i,B-1,0) { if ((d>>i) & 1) { u = fa[u][i]; } } }
    int lca(int u, int v) {
        if (d[u] < d[v]) { swap(u,v); } up(u, d[u]-d[v]); 
        repb (i,B-1,0) { if (fa[u][i] != fa[v][i]) { u = fa[u][i]; v = fa[v][i]; }  }
        return u==v ? u : fa[u][0]; }
    
    int st[N], stTop;
    void VT (int u[], int n, Tree1 &Tg) {
        sort(u, u+n, [this](int a, int b) { return dfn[a]<dfn[b]; });
        stTop=0; if (u[0]!=1) { st[stTop++] = 1; } Tg.clearAll(); Tg.clear(1);
        rep (i,n) {
            while (stTop > 1) {
                int f=st[stTop-1], ff=st[stTop-2], l=lca(u[i],f); 
                if (l == f) { break; }
                else if (dfn[l] <= dfn[ff]) { Tg.addEdge(ff,f,T.query(ff,f)); stTop--; }
                else { Tg.clear(l); Tg.addEdge(l,f,T.query(l,f)); stTop--; st[stTop++] = l; break; } }
            Tg.clear(u[i]); st[stTop++] = u[i]; }
        while (stTop > 1) { int f = st[stTop-1], ff = st[stTop-2]; Tg.addEdge(f,ff,T.query(f,ff)); stTop--; } 
        rep (i,n) Tg.sz[u[i]] = 1; }
} T0;

```
