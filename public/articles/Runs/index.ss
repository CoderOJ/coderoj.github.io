($article
  ((tag String) (title . "Runs 学习笔记"))
  (p "这个字符串菜鸡来填坑了。")
  (p "照着孔姥爷的博客学的所以这篇博客会和孔姥爷的那篇很像" (del "一模一样"))
  (p "可能有一些 MathJax 炸了但应该问题不大。")
  ((h2
    (id . "%E4%B8%80%E4%BA%9B%E8%AE%B0%E5%8F%B7%E5%92%8C%E7%BA%A6%E5%AE%9A"))
   "一些记号和约定")
  (ul
   (li
    "文章中的字符串下标从 $1$ 开始（代码中一般 index-0），$s_i,s[i]$ 表示字符串 $s$ 的第 $i$ 个字符，$|s|$ 表示 $s$ 的长度")
   (li "$ > $ 和 $ < $ 表示字典序的比较，空串的字典序最小")
   (li
    "$\\Sigma$ 表示字符集大小，$\\Sigma^*$ 表示字符集为 $\\Sigma$ 的字符串，$\\Sigma^+ = \\Sigma^* \\setminus {\\epsilon}$，即非空串集合。")
   (li "$\\epsilon$ 表示空串，$\\$$ 表示特殊字符，且 $\\forall c \\in \\Sigma, \\$ > c$")
   (li
    "$\\overline \\Sigma = \\Sigma \\cup {$}$， $\\overline{\\Sigma^*}$ 表示字符集为 $\\overline \\Sigma$ 的字符串")
   (li "默认普通字符串中不包含特殊字符 $\\$$")
   (li "$st, s+t$ 均表示字符串拼接")
   (li "$s^k$ 表示 $s$ 重复 $k$ 次得到的字符串，$s^\\infty$ 表示 $s$ 重复无限次得到的字符串")
   (li "$s^R$ 表示 $s$ 翻转过后的字符串")
   (li
    "$s[i:j]$ 表示 $s$ 的第 $i$ 位到第 $j$ 位构成的子串，若 $i > j$ 则为 $\\epsilon$，$s[:i] = s[1:i], s[i:] = s[i:|s|]$")
   (li
    "$s \\prec t \\Leftrightarrow s + \\$ < v, s \\succ t \\Leftrightarrow s > t + \\$$")
   (li "$\\operatorname{lcp}(s,t)$ 表示 $s$ 和 $t$ 的最长公共前缀")
   (li
    "$\\operatorname{period}$：整数 $l$ 是 $s$ 的一个 $\\operatorname{period}$ 当且仅当 $\\forall i \\in [1, |s| - l], s_i = s_{i+l}$")
   (li
    "$\\operatorname{border}$：整数 $l$ 是 $s$ 的 $\\operatorname{border}$ 当且仅当 $\\forall i \\in [1,l], s_i = s_{n - l + i}$ + 整循环串：$s$ 是一个整循环串当且仅当 $\\exists t \\in \\Sigma^*, s = t^k (k \\geq 2)$")
   (li
    "循环串：$s$ 是一个循环串当且仅当 $\\exists t \\in \\Sigma^*, s = t^k + t[:p]$， 其中 $k$ 是任意整数，$p<|t|$")
   (li "最短循环节：长度最小的 $t$ 满足 $s = t^k (k \\geq 2)$"))
  ((h2 (id . "%E4%B8%80%E4%BA%9B%E5%89%8D%E7%BD%AE%E7%BB%93%E8%AE%BA"))
   "一些前置结论")
  (ol
   (li
    "若 $u \\prec v$，则 $\\forall w_1, w_2 \\in \\Sigma^*, u + w_1 \\prec v + w_2$，$\\succ$ 同理。"))
  ((h2 (id . "lyndon-word")) "Lyndon Word")
  (p
   "定义 $s$ 是一个 Lyndon Word 当且仅当 $s$ 比它所有的后缀都要小，即 $\\forall i \\in [2,|s|], s < s[i:]$。")
  (p "比如 $\\texttt{ababb}$ 是一个 Lyndon Word 而 $\\texttt{abab}$ 不是。")
  ((h3 (id . "lyndon-%E7%9A%84%E4%B8%80%E4%BA%9B%E6%80%A7%E8%B4%A8"))
   "Lyndon 的一些性质")
  (ul
   (li
    "若 $s$ 是一个 Lyndon Word，则 $\\forall i \\in [1, |s|-1], s[:i] \\prec s[n-i+1:]$")
   (li "若 $u$ 和 $v$ 都是 Lyndon Word 且 $u < v$，则 $uv$ 也是 Lyndon Word"))
  (p (del "证明显然。"))
  ((h3 (id . "lyndon-%E5%88%86%E8%A7%A3")) "Lyndon 分解")
  (p "定义：把一个字符串分为若干 Lyndon Word，并且字典序单调不增。")
  (p
   "形式化地说，对于一个字符串 $s$，若 $t_1 + t_2 + \\cdots + t_n = s, \\forall i \\in [1,n], t_i \\text{ is a Lyndon Word}$ 且 $\\forall i>j, t_i \\geq t_j$，那我们称 $t_1 \\cdots t_n$ 为 $s$ 的一个 Lyndon 分解。")
  (p "通常采用 Duval 算法求 Lyndon 分解。")
  ((h4 (id . "duval-%E7%AE%97%E6%B3%95")) "Duval 算法")
  (p "考虑依次插入字符，维护当前的 Lyndon 分解。")
  (p
   "我们假设分解形式为 $T + t^k + t[:p]$，其中 $T = t_1t_2\\cdots t_m$ 且满足 $t_1 \\geq t_2 \\geq \\cdots \\geq t_m > t$")
  (p "设当前加入的字符为 $c$，$u = t[p + 1]$，分类讨论：")
  (ul
   (li "$c = u$，则转移到分解 $T + t^k + t[:p+1]$")
   (li
    "$c < u$，则 $T \\gets T + t + \\cdots + t\\text{(for m times)}$，并转移到分解 $T + (t + c)$")
   (li
    "$c > u$，则 $t^k + t[:p] + c$ 是一个 Lyndon Word，则转移到 $T + (t^kt[:p]c)^1 + \\epsilon$"))
  (p "具体地，我们考虑维护一个三元组 $(i,j,k)$ 其中 $i$ 是 $t+t[:p]$ 的首字母位置，$[j,k)$ 是最后一个循环节。")
  (p "那么就可以如下转移：")
  (ul
   (li "$c = u: (i,j,k) \\gets (i, j+1, k+1)$")
   (li "$c < u: (i,j,k) \\gets (k, k, k+1)$")
   (li "$c > u: (i,j,k) \\gets (i, i, k+1)$"))
  (p "代码如下:")
  (pre
   ((code (class . "lang-c"))
    "struct duval_triple\n"
    "{\n"
    " int index;\n"
    " int loop_l, loop_r;\n"
    "};\n"
    "static int *duval(int *dest, const char *src)\n"
    "{\n"
    " struct duval_triple pos = { 0, 0, 1 };\n"
    " while (src[pos.index])\n"
    " {\n"
    "   pos.loop_l = pos.index;\n"
    "   pos.loop_r = pos.index + 1;\n"
    "   while (src[pos.loop_r] && \n"
    "          src[pos.loop_l] <= src[pos.loop_r])\n"
    "   {\n"
    "     if (src[pos.loop_l] < src[pos.loop_r])\n"
    "       pos.loop_l = pos.index;\n"
    "     else pos.loop_l++;\n"
    "     pos.loop_r++;\n"
    "   }\n"
    "   int len = pos.loop_r - pos.loop_l;\n"
    "   while (pos.index <= pos.loop_l)\n"
    "   {\n"
    "     pos.index += len;\n"
    "     *dest++ = pos.index;\n"
    "   }\n"
    " }\n"
    " return dest;\n"
    "}\n"))
  ((h3 (id . "lyndon-%E6%95%B0%E7%BB%84")) "Lyndon 数组")
  (p
   "定义：对于一个字符串 $s$，定义 $\\lambda_i$ 表示从 $i$ 开始的最长 Lyndon Word 的终止位置，\n"
   "即 $s[i:\\lambda_i]$ 是一个 Lyndon 且 $\\forall j > \\lambda_i s[i:j]$ 不是 Lyndon Word。")
  (p
   "性质：若 $u$ 是一个 Lyndon Word，$s$ 的 Lyndon 分解是 $t_1t_2\\cdots t_n$，那么 $u < t_1 \\Leftrightarrow u+s < s$")
  (p "证明：")
  (ul
   (li
    "$u < t_1 \\Rightarrow u+s < s$"
    (br)
    "若 $u \\prec t_1$，那么根据前置结论 1，有 $u+s < t_1 + (t_2\\cdots t_n)$"
    (br)
    "否则有 $|u| < |t_1|$，设 $l=|t_1|-|u|$，那么由于 $t_1$ 是 Lyndon，$t_1[:l] < t_1[|t_1|-l+1:]$")
   (li
    "$u+s < s \\Rightarrow u < t_1$"
    (br)
    "考虑使用反证法，即证明 $u\\geq t_1 \\Rightarrow u+s\\geq s$"
    (br)
    "同理若 $u \\succ t_1$，则 $u+s > t_1 + (t_2\\cdots t_n)$"
    (br)
    "否则 $|u| \\geq |t_1|, u[:|t_1|] = t_1$，设 $l=|u|-|t_1|$，则由 Lyndon 的性质可得 $u[|u|-l+1:] \\succ u \\geq t_1 \\geq t_2$，所以 $u[:l] + u[|u|-l+1:] \\succ t_1 + t_2$，即 $u+s\\geq s$"))
  (p "算法实现：")
  (p
   "从后往前加字符，考虑维护一个单调栈 $t$ 表示当前后缀的 Lyndon 分解（$t_0$ 是栈顶），满足 $t_i \\geq t_{i+1}$")
  (p
   "假设我们当前加入的字符为 $c$。设 $s=c$，每次判断是否有 $s < t_0$，如果是就 $s \\gets s+t_0$  并弹出栈顶。重复上述步骤直到满足单调性，再将 $s$ 插入栈中。此时 $\\lambda_i$ 就是 $s$ 的右端点。")
  (p "复杂度瓶颈在于求 $\\operatorname{lcp}$，总复杂度 $O(n \\log n)$ 或 $O(n)$。")
  ((h2 (id . "runs")) "Runs")
  ((h3 (id . "%E5%AE%9A%E4%B9%89")) "定义")
  (p
   "定义三元组 $(i,j,p)$ 是 $s$ 的一个 run，当且仅当 $s[j+1] \\neq s[j-p+1], s[i] \\neq s[i+p-1]$ 且 $s[i:i+p-1]$ 是 $s[i:j]$ 长度最小的出现至少两次的循环节（不一定为整循环节）。")
  (p "人话就是循环次数至少为 2 的循环串，并且不能往左右延伸。")
  (p "比如在 $\\texttt{ababababba}$ 这个串中：")
  (ul
   (li "$(1, 8, 2)$ 是一个 run")
   (li "$(3, 8, 2)$ 不是，因为可以继续向左延伸")
   (li "$(1, 8, 4)$ 不是，因为 $\\texttt{abab}$ 不是 $\\texttt{abababab}$ 的最小 period")
   (li "$(6, 10, 3)$ 不是，因为 $\\texttt{abb}$ 没有出现最少 2 次。"))
  (p "Runs: 定义 $\\operatorname{Runs}(s)$ 为所有 $s$ 的 run 的集合。")
  (p
   "指数：定义一个 run $(l,r,p)$ 的指数为 $\\frac{r-l+1}{p}$，即 period $p$ 在 $[l:r]$ 中出现的次数，记为 $e(l,r,p)$")
  (p
   "偏序关系：定义两种偏序关系 $<_0, <_1$，其中 $<_0$ 一般表示字典序较小， $<_1$ 一般表示字典序较大。"
   (br)
   "$\\ell \\in \\{0,1\\}$ 表示一种偏序关系，$\\overline \\ell$ 表示与 $\\ell$ 相反的偏序关系，$< _\\ell$ 表示 $\\ell$ 对应的偏序关系。"
   (br)
   "在 $<_\\ell$ 上定义的 Lyndon Word 意为将比较定义为 $<_\\ell$ 定义下的 Lyndon Word。")
  (p
   "Lyndon Root：定义 $s[\\lambda_l:\\lambda_r]$ 是 $(i,j,p)$ 在 $ <_\\ell $ 上的 Lyndon Root，\n"
   "当且仅当 $[\\lambda_l, \\lambda_r] \\in [i,j]$ 且 $s[\\lambda_l, \\lambda_r]$ 是一个定义在 $<_\\ell$ 上的 Lyindon Word。")
  (p
   "run 的类型：run $(i,j,p)$ 是 $\\ell(\\ell \\in {0,1})$ 型的，当且仅当 $s[j-p+1] <_\\ell s[j+1]$。")
  (p
   "$l_\\ell(p)$：$l_\\ell(p)$ 表示以位置 $p$ 开头的最长定义在 $\\ell$ 上的 Lyndon Word （就是 Lyndon 数组）")
  ((h3 (id . "%E6%8E%A8%E8%AE%BA")) "推论")
  (ul
   (li
    "对于 $\\ell$ 型 run，其所有定义在 $<_\\ell$ 上的 Lyndon Root $\\lambda = [\\lambda_l, \\lambda_r]$ 都有 $\\lambda = l_\\ell(\\lambda_l)$，\n"
    "即所有 Lyndon Root 都是同起点中的最长的 Lyndon Word。"))
  (p
   "不难发现对于$\\ell$ 型 run $(i,j,p)$，$\\forall p \\in [i,j], |l_\\ell(p)| \\leq j - p + 1$，也就是不存在跨于这个 run 的 Lyndon Word。")
  (ul (li "对于任意 run $r(i,j,p)$，其所有 Lyndon Root 左端点不重复。"))
  (p
   "证明比较显然，考虑每一个开始位置，显然 Lyndon Root 的长度小于等于 $p$，根据 Duval 算法的过不难发现小于等于循环节的 Lyndon Word 仅有一个。")
  ((h3 (id . "runs-%E7%9A%84%E6%B1%82%E8%A7%A3")) "Runs 的求解")
  (p "对于两种 run 分别求解再去重。")
  (p "先求出所有的 $l_\\ell$，即求出 Lyndon 数组。")
  (p
   "我们令 $p_i = s[_\\ell(i) : l_\\ell(i)]$，观察其往左往右能延伸到最远的地方 $s[l_i':r_i']$。对于三元组 $(l_i', r_i', |p_i|)$，我们只需要判断是否满足 $|p_i| \\geq \\frac{r_i'-l_i'+1}{2}$ 即可。")
  (p "不难证明这样一定能找到所有的 run，至此完成了 Runs 的求解。")
  ((h3 (id . "%E4%BB%A3%E7%A0%81")) "代码")
  (pre
   ((code (class . "lang-cpp"))
    "#include <bits/stdc++.h>\n"
    "constexpr int N = 1000005;\n"
    "constexpr int B = 2333;\n"
    "char str[N];\n"
    "uint64_t s[N];\n"
    "int n;\n"
    "uint64_t h[N], bs[N];\n"
    "uint64_t get(int l, int r)\n"
    "{\n"
    " return h[r] - h[l - 1] * bs[r - l + 1];\n"
    "}\n"
    "int lcp(int x, int y)\n"
    "{\n"
    " int l = 1, r = n - std::max(x, y) + 1, res = 0;\n"
    " while (l <= r)\n"
    " {\n"
    "   int mid = (l + r) >> 1;\n"
    "   if (get(x, x + mid - 1) == get(y, y + mid - 1))\n"
    "     l = mid + 1, res = mid;\n"
    "   else\n"
    "     r = mid - 1;\n"
    " }\n"
    " return res;\n"
    "}\n"
    "int lcs(int x, int y)\n"
    "{\n"
    " int l = 1, r = std::min(x, y), res = 0;\n"
    " while (l <= r)\n"
    " {\n"
    "   int mid = (l + r) >> 1;\n"
    "   if (get(x - mid + 1, x) == get(y - mid + 1, y))\n"
    "     l = mid + 1, res = mid;\n"
    "   else\n"
    "     r = mid - 1;\n"
    " }\n"
    " return res;\n"
    "}\n"
    "bool cmp(int l1, int r1, int l2, int r2)\n"
    "{ // s[l1:r1]<s[l2:r2]\n"
    " int l = lcp(l1, l2);\n"
    " if (l > std::min(r1 - l1, r2 - l2))\n"
    "   return r1 - l1 < r2 - l2;\n"
    " return s[l1 + l] < s[l2 + l];\n"
    "}\n"
    "struct runs\n"
    "{\n"
    " int i, j, p;\n"
    " runs(int i = 0, int j = 0, int p = 0) : i(i), j(j), p(p)\n"
    " {\n"
    " }\n"
    " bool operator==(const runs a) const\n"
    " {\n"
    "   return i == a.i && j == a.j && p == a.p;\n"
    " }\n"
    " bool operator<(const runs a) const\n"
    " {\n"
    "   return i == a.i ? j < a.j : i < a.i;\n"
    " }\n"
    "};\n"
    "std::vector<runs> ans;\n"
    "int st[N], t, run[N];\n"
    "void lyndon()\n"
    "{\n"
    " t = 0;\n"
    " for (int i = n; i; i--)\n"
    " {\n"
    "   st[++t] = i;\n"
    "   for (; t > 1 && cmp(i, st[t], st[t] + 1, st[t - 1]); t--)\n"
    "     ;\n"
    "   run[i] = st[t];\n"
    " }\n"
    "}\n"
    "void init()\n"
    "{\n"
    " bs[0] = 1;\n"
    " for (int i = 1; i <= n; i++)\n"
    "   h[i] = h[i - 1] * B + s[i], bs[i] = bs[i - 1] * B;\n"
    "}\n"
    "void get_runs()\n"
    "{\n"
    " for (int i = 1; i <= n; i++)\n"
    " {\n"
    "   int l1 = i, r1 = run[i], l2 = l1 - lcs(l1 - 1, r1), r2 = r1 + lcp(l1, r1 + 1);\n"
    "   if (r2 - l2 + 1 >= (r1 - l1 + 1) * 2)\n"
    "     ans.push_back(runs(l2, r2, r1 - l1 + 1));\n"
    " }\n"
    "}\n"
    "int main()\n"
    "{\n"
    " scanf(\"%s\", str + 1);\n"
    " n = (int)std::strlen(str + 1);\n"
    " for (int i = 1; i <= n; i++)\n"
    "   s[i] = (uint64_t)(str[i] - 'a' + 1);\n"
    " init();\n"
    " lyndon();\n"
    " get_runs();\n"
    " for (int i = 1; i <= n; i++)\n"
    "   s[i] = 27 - s[i];\n"
    " lyndon();\n"
    " get_runs();\n"
    " sort(ans.begin(), ans.end());\n"
    " ans.erase(unique(ans.begin(), ans.end()), ans.end());\n"
    " printf(\"%d\\n\", (int)ans.size());\n"
    " for (auto u : ans)\n"
    "   printf(\"%d %d %d\\n\", u.i, u.j, u.p);\n"
    " return 0;\n"
    "}\n"))
  (br))
