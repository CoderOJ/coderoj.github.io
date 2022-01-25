($article
  ((tag Tutorial) (title . "Codeforces 835F") (date . "") (mathjax . #t))
  ((h2 (id . "description")) "Description")
  (ul (li "求带权基环树拆除一条环上边以后直径的最小值。"))
  ((h2 (id . "tutorial")) "Tutorial")
  (p "找环，发现对答案产生贡献的有两种：")
  (ul (li "环上的点的子树直径") (li "环上两点深度+距离的和"))
  (p "第一种直接树性dp即可，这里着重说明第二种情况。")
  (p "我们把它抽象出来，这个相当于给定" (code "a") "数组，求")
  ((script (type . "math/tex; mode=display"))
   "\\max _{i < j} \\{ a[i] + a[j] + dis[i][j] \\}")
  (p "这是一个环型dp问题。其他题解似乎都要分类讨论，这里给一种更简洁的做法：")
  (p "常规操作：破环为链，然后把" (code "a") "数组在后面复制一份。")
  (p
   "由于已经破环为链，所以$i,j$之间的路径是唯一的，即$dis[i][j] = dis[i][n] - dis[j][n]$ (这里的$n$指链上最后一个点)")
  (p "所以有：")
  ((script (type . "math/tex; mode=display"))
   "\\max _{i < j} \\{ a[i] + a[j] + dis[i][j] \\} = \\max _{i \\neq j} \\{ (a[i] + dis[i][n]) + (a[j] - dis[j][n]) \\}")
  (p "注意我们将$<$改为了$\\neq$，不难证明这样并不影响答案，因为")
  ((script (type . "math/tex; mode=display"))
   "\\forall i>j, (a[i] + dis[i][n]) + (a[j] - dis[j][n]) < (a[j] + dis[j][n]) + (a[i] - dis[i][n])")
  (p "现在我们可以分开计算$(a[i] + dis[i][n]) $ 和 $ (a[j] - dis[j][n])$。")
  (p
   "考虑如何维护形如$(a[i] + dis[i][n])$的东西，也就是快速将所有的$a[i]+dis[i][n]$转移到$a[i]+dis[i][n+1]$")
  (p "这相当与一个数据结构，需要支持以下操作：")
  (ul (li "加入一个数") (li "将所有的数$+x$") (li "查询最大值") (li "删除一个数（按加入的顺序）"))
  (p "对于全局加减操作，我们可以维护一个全局差值，$+x$的时候仅修改这个值，插入的时候先减掉这个值再插入。")
  (p "单调队列可以维护所有的数的相对大小，不过我觉得太复杂就用了" (code "multiset"))
  (p "这部分的code:")
  (pre
   ((code (class . "lang-cpp"))
    "typedef pair < int , int > pr\n"
    "struct Ds {\n"
    "   multiset <pr> st;\n"
    "   int g;\n"
    "   Ds () { st.clear(); g=0; }\n"
    "   void insert(pr u) {\n"
    "       u.first -= g; st.insert(u); \n"
    "   }\n"
    "   void erase(pr u) {\n"
    "       st.erase(st.find(u)); \n"
    "   }\n"
    "   void globalAdd(int u) {\n"
    "       g += u; \n"
    "   }\n"
    "   pair<pr,pr> queryMax() {\n"
    "       pr a = (*st.rbegin()); a.first += g;\n"
    "       pr b = *(++st.rbegin()); b.first += g;\n"
    "       return { a,b }; \n"
    "   }\n"
    "};\n"))
  (p "看到代码可能会有两处疑问：")
  (ul
   (li
    (p
     "为什么"
     (code "queryMax()")
     "还要返回次大值？因为之前式子里的前提是$i\\neq j$。如果我们查询出来发现$(a[i] + dis[i][n]) $ 和 $ (a[j] - dis[j][n])$ 取最大时$i,j$相等，那么就需要使用一个的最大值$+$另一个的次大值"))
   (li
    (p
     "为什么"
     (code "erase()")
     "那里没有"
     (code "u.first -= g;")
     "？应为在这里我们并不知道加入这个数的时候"
     (code "g")
     "值是多少，所以这一步操作我们要放到外面进行。")))
  (p
   "可以用两个这个东西分别维护$(a[i] + dis[i][n])$ 和 $(a[j] - dis[j][n])$。这样就是$\\mathcal {O} (\\log n) $")
  (p "然后就是dp的过程，前面把所有操作封装好了以后就很清晰了：")
  (pre
   ((code (class . "lang-cpp"))
    "long long ans = 0x3f3f3f3f3f3f3f3f;\n"
    "Ds l,r;\n"
    "for (int i=0;i<n*2;i++) {  //这里n已经提前赋值为环的长度。\n"
    "   // 更新l,r中的信息\n"
    "   l.globalAdd(b[i]); r.globalAdd(-b[i]);\n"
    "   l.insert({a[i],i}); r.insert({a[i],i});\n"
    "   if (i>=n) {\n"
    "       l.erase({a[i-n]-bSum[i-n],i-n}); r.erase({a[i-n]+bSum[i-n],i-n}); \n"
    "   }\n"
    "   // 更新答案\n"
    "   if (i>=n-1) {\n"
    "       auto ll = l.queryMax(), rr = r.queryMax();\n"
    "       if (ll.first.second == rr.first.second) { // 若取最大值时i,j相等\n"
    "           checkMin(ans, max(ll.second.first+rr.first.first , ll.first.first+rr.second.first)); \n"
    "       } else { // 不等\n"
    "           checkMin(ans, ll.first.first + rr.first.first); \n"
    "       } \n"
    "   }\n"
    "}\n"))
  (p "最后记得把这里的" (code "ans") "和之前求出的子树直径最大值取个max。")
  (br))
