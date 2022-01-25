($article
  ((tag Tutorial Constructive) (title . "CodeForces 1368E"))
  ((h2 (id . "tutorial")) "Tutorial")
  (p "神仙题")
  (p "这个 $\\frac47$ 似乎提示性很强的样子，不难想到拆成 $\\frac{4}{1 + 2 + 4}$")
  (p
   "这启示我们把点分为三个集合 $A, B, C$，满足限制 $|C| \\leq 2|B| \\leq 4|A|$，然后把 $C$ 集合中的点全部删除")
  (p
   "考虑如何限制集合的大小关系，题目中保证一个点最多只有两条出边，那么如果我们有两个集合 $U,V$ 满足 $V$ 中的点都有一条来自 $U$ 的入边，就可以得到 $|V| \\leq 2|U|$")
  (p "按照这个思路，我们可以如下定义三个集合：")
  (ul
   (li "A: 没有入边或者所有入边来自 $C$")
   (li "B: 至少有一条入边来自 $A$，没有入边来自 $B$")
   (li "C: 至少有一条入边来自 $B$"))
  (p "不难证明一定能这样划分。")
  (p "题目中给定的图是 DAG，所以可以直接按照拓扑序逐个确定。")
  ((h2 (id . "code")) "Code")
  (pre
   ((code (class . "lang-c"))
    "enum color_t\n"
    "{\n"
    " color_a, \n"
    " color_b,  \n"
    " color_c\n"
    "};\n"
    "enum color_t col[N];\n"
    "void solve()\n"
    "{\n"
    " scanf(\"%d%d\", &n, &m);\n"
    " clear_graph();\n"
    " for (int i=0; i<m; ++i)\n"
    " {\n"
    "   int u, v;\n"
    "   scanf(\"%d%d\", &u, &v);\n"
    "   add_edge(v, u);\n"
    " }\n"
    " col[1] = color_a;\n"
    " for (int u=2; u<=n; ++u)\n"
    " {\n"
    "   col[u] = color_a;\n"
    "   for (struct edge_t *i = e[u]; i; i = i->next)\n"
    "   {\n"
    "     if (col[i->v] == color_b)\n"
    "       col[u] = color_c;\n"
    "     if (col[u] != color_c && col[i->v] == color_a)\n"
    "       col[u] = color_b;\n"
    "   }\n"
    " }\n"
    " int cnt = 0;\n"
    " for (int i=1; i<=n; ++i)\n"
    "   if (col[i] == color_c)\n"
    "     cnt++;\n"
    " printf(\"%d\\n\", cnt);\n"
    " for (int i=1; i<=n; ++i)\n"
    "   if (col[i] == color_c)\n"
    "     printf(\"%d \", i);\n"
    " puts(\"\");\n"
    "}\n"))
  (br))
