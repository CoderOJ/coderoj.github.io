($article
  ((tag Tutorial DsuOnTree Hash)
   (title . "Codeforces 601D")
   (date . "")
   (mathjax . #t))
  ((h2 (id . "description")) "Description")
  (ul
   (li "给定一颗有根树，每个点上有一个字符。")
   (li
    "对于一个节点 $u$ 的子树，从 $u$ 到子树中某一个节点的路径上的字符可以组成一个字符串（可能只有一个字符），定义所有不同的字符串的个数为 $\\operatorname{dif}(u)$ 。")
   (li "对于每个点$u$，求$\\operatorname{dif}(u)$。"))
  ((h2 (id . "tutorial")) "Tutorial")
  (p "怎么大家都写的是Trie树合并啊。")
  (p "我写的是哈希，" (del "喜提最慢解和最长代码（"))
  (p "对于每一个节点我们求出它到子树中所有点的字符串哈希值的集合，每个点的答案就是集合的大小。~~")
  (p "对于一个字符串的哈希值，我们可以很方便的得到在这个字符串前面加一个字符后的哈希值，并且不依赖与这个字符串的长度。")
  (p "现在的问题在于如何合并子树信息，还有如何全局在头上加字符。")
  ((h3 (id . "%E5%90%88%E5%B9%B6%E5%AD%90%E6%A0%91%E4%BF%A1%E6%81%AF"))
   "合并子树信息")
  (p
   "dsu on tree 的板子。具体的，我们首先预处理出每个点的重儿子，然后在第二遍 dfs 统计答案的时候，对于正在处理的点 u，我们发现他的儿子的信息在以后不会使用到，就可以直接把他的信息赋成它重儿子的信息，然后暴力把轻儿子的信息合并上去。")
  (blockquote
   (p
    (del
     "无论你是推式子的 log n − log s\u200B 选手， 还是运算次数每加一规模减半的毛估估大师，都可以轻松得到正确的复杂度。")))
  (p
   "关于细节，如果合并的时候不想写指针或者数组模拟什么的，可以考虑用 c++11 里的"
   (code "std::move")
   "，以"
   (code "std::set")
   "举例，"
   (code "setA = std::move(setB)")
   "的时间复杂的是 $\\mathcal O(1)$ 的，代价是以后不能（不建议）访问"
   (code "setB")
   "，在本题中显然没有问题。")
  ((h3
    (id
     .
     "%E5%85%A8%E5%B1%80%E5%9C%A8%E5%BC%80%E5%A4%B4%E5%8A%A0%E5%AD%97%E7%AC%A6"))
   "全局在开头加字符")
  (p
   "这也是一种套路。对于每个"
   (code "set")
   " 额外再维护两个全局偏移量 "
   (code "mul")
   "和"
   (code "add")
   "，表示这个对于这个"
   (code "set")
   "中的元素"
   (code "u")
   "，其真实值为"
   (code "u * mul + add")
   "。")
  (p
   "插入"
   (code "v")
   "的时候，我们在模意义下求出"
   (code "(v - add) / mul")
   "然后再把它丢到"
   (code "set")
   "里去。")
  (p "全局加的时候修改" (code "add") "，全局乘的时候要把" (code "mul") "和" (code "add") "都更新。")
  (p "然后就做完了。")
  ((h2 (id . "code")) "Code")
  (p
   ((a
     (href . "https://gitee.com/coderoj/cts/blob/master/tmp/CF601D/main.cpp"))
    "完整代码"))
  (p "由于我代码里的模板什么实在是太长了，这里放一个便于理解的版本")
  (p (del "写个题都有虚基类多继承和运行时多态这种事情应该只有我干的出来吧"))
  (pre
   ((code (class . "lang-cpp"))
    "#define rep(i,n) for (int i=0;i<n;i++)\n"
    "#define repa(i,n) for (int i=1;i<=n;i++)\n"
    "// Intm 是模意义下的整数\n"
    "class Intm {\n"
    "   static const unsigned long long MOD;\n"
    "   //...\n"
    "};\n"
    "const unsigned long long Intm::MOD = 999999137;\n"
    "struct HashSet {\n"
    "   struct Int : public Intm {\n"
    "       Int () : Intm(0) {}\n"
    "       Int (unsigned long long _a) : Intm(_a) {} \n"
    "       // 因为要丢进set所以还需要比较函数\n"
    "       bool operator < (const Int& B) const { return a < B.a; } \n"
    "   };\n"
    "   // 哈希种子（这道题要双模所以很慢）\n"
    "   static const Int SEED1, SEED2;\n"
    "   set <pair<Int,Int>> st;\n"
    "   Int mul1, add1;\n"
    "   Int mul2, add2;\n"
    "   HashSet () { mul1=mul2=1; add1=add2=0; }\n"
    "   // 从重儿子哪里继承过来\n"
    "   void inherit(HashSet &B) {\n"
    "       // 移动赋值语义，以后不对B进行访问\n"
    "       st = std::move( B.st );\n"
    "       mul1 = B.mul1; add1 = B.add1; \n"
    "       mul2 = B.mul2; add2 = B.add2; \n"
    "   }\n"
    "   // 在头上加入一个字符\n"
    "   inline void push(Int del) {\n"
    "       mul1 *= SEED1; add1 *= SEED1; add1 += del; \n"
    "       mul2 *= SEED2; add2 *= SEED2; add2 += del; \n"
    "   }\n"
    "   // 插入哈希值\n"
    "   inline void insert(pair<Int,Int> u) {\n"
    "       u.L -= add1; u.L /= mul1;\n"
    "       u.R -= add2; u.R /= mul2;\n"
    "       st.insert(u); \n"
    "   }\n"
    "   // 暴力合并\n"
    "   inline void merge(HashSet &B) {\n"
    "       for (auto u: B.st) {\n"
    "           u.L *= B.mul1; u.L += B.add1;\n"
    "           u.R *= B.mul2; u.R += B.add2;\n"
    "           insert(u); \n"
    "       } \n"
    "   }\n"
    "   inline int size() {\n"
    "       return st.size(); \n"
    "   }\n"
    "};\n"
    "const HashSet::Int HashSet::SEED1 = 17;\n"
    "const HashSet::Int HashSet::SEED2 = 13;\n"
    "const int N = 300005;\n"
    "// Tree的模板\n"
    "template <int N> class TreeBase {\n"
    "   // 点集\n"
    "   Nodes getNodes(int u);\n"
    "   //...\n"
    "};\n"
    "// 和树有关的部分\n"
    "struct Tr : public TreeBase<N> {\n"
    "   using Tree::TreeBase<N>::getNodes;\n"
    "   // sz: 子树大小 ws: 重儿子 val: 节点字符\n"
    "   int sz[N], ws[N], val[N];\n"
    "   Tr () { memset(sz,0,sizeof(sz)); memset(ws,0,sizeof(ws)); }\n"
    "   // 预处理重儿子\n"
    "   void dfs1(int u, int f) {\n"
    "       sz[u] = 1; int mv = 0;\n"
    "       auto vs = getNodes(u);\n"
    "       for (int v: vs) if (v!=f) {\n"
    "           dfs1(v,u); sz[u] += sz[v]; \n"
    "           if (checkMax(mv, sz[v])) { ws[u] = v; } \n"
    "       } \n"
    "   }\n"
    "   int ans[N];\n"
    "   HashSet st[N];\n"
    "   void dfs2(int u, int f) {\n"
    "       auto vs = getNodes(u);\n"
    "       for (int v: vs) if (v!=f) { dfs2(v,u);  }\n"
    "       // 从重儿子处继承\n"
    "       if (ws[u] != 0) { st[u].inherit(st[ws[u]]);  }\n"
    "       // 加上自己的信息\n"
    "       st[u].insert( pr(0,0) );\n"
    "       // 暴力合并轻儿子\n"
    "       for (int v: vs) if (v!=f && v!=ws[u]) {\n"
    "           st[u].merge( st[v] ); \n"
    "       }\n"
    "       // 在所有串前面加上该节点自己的字符\n"
    "       st[u].push( val[u] ); \n"
    "       ans[u] += st[u].size(); \n"
    "   }\n"
    "};\n"
    "Tr T;\n"
    "int n;\n"
    "int main() {\n"
    "   n = read(); \n"
    "   repa (i,n) T.ans[i] = read();\n"
    "   // 这里字符串的长度不固定所以'a'必须从1开始，不然长度不等的'aa...a'会判重\n"
    "   repa (i,n) T.val[i] = readChar()-'a'+1;\n"
    "   rep (i,n-1) { int u=sc.n(), v=sc.n(); T.addEdge(u,v); }\n"
    "   T.dfs1(1,0);\n"
    "   T.dfs2(1,0);\n"
    "   int mx=0, cnt=0;\n"
    "   repa (i,n) {\n"
    "       if (mx < T.ans[i]) { mx = T.ans[i]; cnt = 1; }\n"
    "       else if (mx == T.ans[i]) { cnt++; } \n"
    "   }\n"
    "   printf(IN,mx); printf(IN,cnt);\n"
    "}\n"))
  (br))
