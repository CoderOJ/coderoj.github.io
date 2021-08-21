---
title: Codeforces 601D
date: 2020-10-27 09:37:22
mathjax: true
tags:
  - Tutorial	
  - DsuOnTree
  - Hash
---

# [CF601D](https://www.luogu.com.cn/problem/CF601D) [Acyclic Organic Compounds](https://codeforces.com/problemset/problem/601/D)

## Description

+ 给定一颗有根树，每个点上有一个字符。
+ 对于一个节点 $u$ 的子树，从 $u$ 到子树中某一个节点的路径上的字符可以组成一个字符串（可能只有一个字符），定义所有不同的字符串的个数为 $\operatorname{dif}(u)$ 。
+ 对于每个点$u$，求$\operatorname{dif}(u)$。

<!--more-->

## Tutorial

怎么大家都写的是Trie树合并啊。

我写的是哈希， ~~喜提最慢解和最长代码（~~

对于每一个节点我们求出它到子树中所有点的字符串哈希值的集合，每个点的答案就是集合的大小。~~

对于一个字符串的哈希值，我们可以很方便的得到在这个字符串前面加一个字符后的哈希值，并且不依赖与这个字符串的长度。

现在的问题在于如何合并子树信息，还有如何全局在头上加字符。

### 合并子树信息

dsu on tree 的板子。具体的，我们首先预处理出每个点的重儿子，然后在第二遍 dfs 统计答案的时候，对于正在处理的点 u，我们发现他的儿子的信息在以后不会使用到，就可以直接把他的信息赋成它重儿子的信息，然后暴力把轻儿子的信息合并上去。

>  ~~无论你是推式子的 log n − log s​ 选手， 还是运算次数每加一规模减半的毛估估大师，都可以轻松得到正确的复杂度。~~

关于细节，如果合并的时候不想写指针或者数组模拟什么的，可以考虑用 c++11 里的`std::move`，以`std::set`举例，`setA = std::move(setB)` 的时间复杂的是 $\mathcal O(1)$ 的，代价是以后不能（不建议）访问 `setB`，在本题中显然没有问题。

### 全局在开头加字符

这也是一种套路。对于每个 `set`  额外再维护两个全局偏移量  `mul` 和 `add`，表示这个对于这个 `set` 中的元素 `u`，其真实值为 `u * mul + add`。

插入 `v` 的时候，我们在模意义下求出 `(v - add) / mul` 然后再把它丢到 `set` 里去。

全局加的时候修改 `add`，全局乘的时候要把 `mul` 和 `add` 都更新。



然后就做完了。

## Code

[完整代码](https://gitee.com/coderoj/cts/blob/master/tmp/CF601D/main.cpp)

由于我代码里的模板什么实在是太长了，这里放一个便于理解的版本

~~写个题都有虚基类多继承和运行时多态这种事情应该只有我干的出来吧~~

```cpp
#define rep(i,n) for (int i=0;i<n;i++)
#define repa(i,n) for (int i=1;i<=n;i++)


// Intm 是模意义下的整数
class Intm {
    static const unsigned long long MOD;
    //...
};
const unsigned long long Intm::MOD = 999999137;

struct HashSet {
    struct Int : public Intm {
        Int () : Intm(0) {}
        Int (unsigned long long _a) : Intm(_a) {} 
        // 因为要丢进set所以还需要比较函数
        bool operator < (const Int& B) const { return a < B.a; } 
    };
    // 哈希种子（这道题要双模所以很慢）
    static const Int SEED1, SEED2;
    
    set <pair<Int,Int>> st;
    Int mul1, add1;
    Int mul2, add2;
    
    HashSet () { mul1=mul2=1; add1=add2=0; }
    
    // 从重儿子哪里继承过来
    void inherit(HashSet &B) {
        // 移动赋值语义，以后不对B进行访问
        st = std::move( B.st );
        mul1 = B.mul1; add1 = B.add1; 
        mul2 = B.mul2; add2 = B.add2; 
    }
    
    // 在头上加入一个字符
    inline void push(Int del) {
        mul1 *= SEED1; add1 *= SEED1; add1 += del; 
        mul2 *= SEED2; add2 *= SEED2; add2 += del; 
    }
    
    // 插入哈希值
    inline void insert(pair<Int,Int> u) {
        u.L -= add1; u.L /= mul1;
        u.R -= add2; u.R /= mul2;
        st.insert(u); 
    }
    
    // 暴力合并
    inline void merge(HashSet &B) {
        for (auto u: B.st) {
            u.L *= B.mul1; u.L += B.add1;
            u.R *= B.mul2; u.R += B.add2;
            insert(u); 
        } 
    }
    
    inline int size() {
        return st.size(); 
    }
};

const HashSet::Int HashSet::SEED1 = 17;
const HashSet::Int HashSet::SEED2 = 13;

const int N = 300005;

// Tree的模板
template <int N> class TreeBase {
    // 点集
    Nodes getNodes(int u);
    //...
};

// 和树有关的部分
struct Tr : public TreeBase<N> {
    using Tree::TreeBase<N>::getNodes;

    // sz: 子树大小 ws: 重儿子 val: 节点字符
    int sz[N], ws[N], val[N];
    Tr () { memset(sz,0,sizeof(sz)); memset(ws,0,sizeof(ws)); }
    
    // 预处理重儿子
    void dfs1(int u, int f) {
        sz[u] = 1; int mv = 0;
        auto vs = getNodes(u);
        for (int v: vs) if (v!=f) {
            dfs1(v,u); sz[u] += sz[v]; 
            if (checkMax(mv, sz[v])) { ws[u] = v; } 
        } 
    }

    int ans[N];
    HashSet st[N];
    void dfs2(int u, int f) {
        auto vs = getNodes(u);
        for (int v: vs) if (v!=f) { dfs2(v,u);  }
        // 从重儿子处继承
        if (ws[u] != 0) { st[u].inherit(st[ws[u]]);  }
        // 加上自己的信息
        st[u].insert( pr(0,0) );
        // 暴力合并轻儿子
        for (int v: vs) if (v!=f && v!=ws[u]) {
            st[u].merge( st[v] ); 
        }
        // 在所有串前面加上该节点自己的字符
        st[u].push( val[u] ); 
        ans[u] += st[u].size(); 
    }
};

Tr T;
int n;

int main() {
    n = read(); 
    repa (i,n) T.ans[i] = read();
    // 这里字符串的长度不固定所以'a'必须从1开始，不然长度不等的'aa...a'会判重
    repa (i,n) T.val[i] = readChar()-'a'+1;
    rep (i,n-1) { int u=sc.n(), v=sc.n(); T.addEdge(u,v); }
    T.dfs1(1,0);
    T.dfs2(1,0);
    int mx=0, cnt=0;
    repa (i,n) {
        if (mx < T.ans[i]) { mx = T.ans[i]; cnt = 1; }
        else if (mx == T.ans[i]) { cnt++; } 
    }
    printf(IN,mx); printf(IN,cnt);
}

```

