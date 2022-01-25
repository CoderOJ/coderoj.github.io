($article
  ((tag Tutorial Greedy Constructive) (title . "CodeForces 1379 E"))
  ((h2 (id . "description")) "Description")
  (p "给定参数 $n, k(1 \\leq n \\leq 10^5, 0 \\leq k \\leq n$，构造一棵二叉树，满足：")
  (ul
   (li "该二叉树有 $n$ 个节点")
   (li "不存在只有一个儿子的节点")
   (li
    "对于一个非叶子节点，记他的两个儿子对应子树的大小为 $A,B$。如果 $2A\\leq B$ 或者 $2B \\leq A$，那么这个点是“不平衡点”。你构造的二叉树需要恰好有 $k$ 个“不平衡点”。"))
  ((h2 (id . "tutorial")) "Tutorial")
  (p "挺牛逼的一个构造题，但细节有点多。")
  (p "首先每个点儿子数量是 0 或者 2，那么点数必然为奇数。")
  (p "然后考虑两种极端，即给定 $n$ 个点能够达成的最小的 $k$ 和最大的 $k$。")
  (p "最大的 $k$ 显然是造一条毛毛虫，$\\max k = \\dfrac{n-3}{2}$。")
  (p "最小的 $k$ 是造一棵完全二叉树，然后不难发现造出的是满二叉树时 $k=0$，不然 $k=1$。")
  (p "考虑如何证明这件事情：")
  (p
   "首先一个点左右子树的深度差至多为 $1$，然后要满足 $2A \\leq B$ 必然有 $A = 2^{k-1}-1$，$B=2^k-1$，所以不平衡的点必然满足左右儿子树都是满二叉树然后深度差为 $1$。")
  (p "显然这样的点在完全二叉树上最多只有一个。")
  (p "然后对任意 $k$ 的构造方法也不难了，先造一个 $k-1$ 个不平衡点的毛毛虫，然后在下面挂一个完全二叉树。")
  (p
   "这样做如果那个完全二叉树是满二叉树会出问题，于是考虑把最下面的某两个点接到根的那个没有儿子的儿子下面，在 $n$ 足够大的时候根依然是不平衡的，并且满二叉树上多了一个不平衡点。")
  (p "最后这样做有两个 border case：")
  (ul
   (li "$n = 2^p-1 (p \\in \\mathbf{N}),k=1$，这样无解")
   (li "$n = 9, k = 2$，这里把两个儿子拼上去以后根变得平衡了，枚举所有可能以后发现这样也是无解。"))
  ((h2 (id . "code")) "Code")
  (pre
   ((code (class . "lang-c"))
    "#include <stdio.h>\n"
    "#include <stdlib.h>\n"
    "void no_answer() __attribute__ ((noreturn));\n"
    "void no_answer() \n"
    "{\n"
    " puts(\"NO\");\n"
    " exit(0);\n"
    "}\n"
    "#define N 100005\n"
    "int fa[N];\n"
    "int main()\n"
    "{\n"
    " int n, k;\n"
    " scanf(\"%d%d\", &n, &k);\n"
    " int limit = (n - 3) / 2;\n"
    " if (limit < 0) limit = 0;\n"
    " if (n % 2 ==0) no_answer();\n"
    " if (k > limit) no_answer();\n"
    " if ((n & (n+1)) && k ==0) no_answer();\n"
    " if (!(n & (n+1)) && k == 1) no_answer();\n"
    " if (n == 9 && k == 2) no_answer();\n"
    " puts(\"YES\");\n"
    " int base = 2 * (k - 1);\n"
    " if (base < 0) base = 0;\n"
    " for (int i=1; i<base; i += 2)\n"
    " {\n"
    "   fa[i] = i - 2;\n"
    "   fa[i + 1] = i;\n"
    " }\n"
    " fa[base + 1] = base - 1;\n"
    " for (int i=base+2; i<=n; ++i) \n"
    " {\n"
    "   fa[i] = base + (i - base) / 2;\n"
    " }\n"
    " if (!((n - base) & (n - base + 1)) && k)\n"
    " {\n"
    "   fa[n] = 2;\n"
    "   fa[n - 1] = 2;\n"
    " }\n"
    " if (fa[1] < 0)\n"
    "   fa[1] = 0;  \n"
    " for (int i=1; i<=n; ++i)\n"
    "   printf(\"%d%c\", fa[i], \" \\n\"[i == n]);\n"
    " return 0;\n"
    "}\n"))
  (br))
