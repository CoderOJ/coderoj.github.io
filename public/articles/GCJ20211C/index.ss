($article
  ((tag Tutorial) (title . "Code Jam 2021 Round 1C"))
  (p
   "今年 Code Jam 时间是真的阴间，1A 和省选冲，1B 在半夜，1C 在尴尬的 5 点，2 也因为一些奇怪的原因打不了"
   (del "我还要 T-Shirt"))
  (p
   "说起来这几年真越来越卷了，Qualification Round 两千多个 AK，我最后一个 MO 题没写直接 rk 3k+，"
   (del "19 年只有不到 500 个 AK")
   "。\n"
   "CF 上有个曾经 Master 的老哥去年 1A rank 600 今年直接进不了。")
  (p "想着 R1 都不过太逊了，于是决定还是打一下 R1C。\n" "没吃晚饭就开打了，" (del "靠着下午吃的蛋糕撑到了夜宵"))
  (p "题目还是一如既往的偏思维，区分度仍然很迷(?)")
  (p "最后 52 秒极限过 C，直接从 rk 1700+ 到 rk 102 就很爽")
  (p "还有谷歌怎么这么咕咕咕的啊，按 1A 和 1B 的情况来看代码查重要跑个四五天才能出终榜。")
  ((h1 (id . "a-closest-picks")) "A. Closest Picks")
  ((h2 (id . "description")) "Description")
  (p "懒得翻了，直接原题面扔上来：")
  (blockquote
   (p
    "You are entering a raffle for a lifetime supply of pancakes. $N$ tickets have already been sold. Each ticket contains a single integer between 1 and $K$, inclusive. Different tickets are allowed to contain the same integer. You know exactly which numbers are on all of the tickets already sold and would like to maximize your odds of winning by purchasing two tickets (possibly with the same integer on them). You are allowed to choose which integers between 1 and $K$, inclusive, are on the two tickets.")
   (p
    "You know you are the last customer, so after you purchase your tickets, no more tickets will be purchased. Then, an integer"
    (em "c")
    "between 1 and $K$, inclusive, is chosen uniformly at random. If one of your tickets is strictly closer to"
    (em "c")
    "than all other tickets or if both of your tickets are the same distance to"
    (em "c")
    "and strictly closer than all other tickets, then you win the raffle. Otherwise, you do not win the raffle.")
   (p
    "Given the integers on the $N$ tickets purchased so far, what is the maximum probability of winning the raffle you can achieve by choosing the integers on your two tickets optimally?")
   (p "$N \\leq 30,K \\leq 10^9$"))
  ((h2 (id . "tutorial")) "Tutorial")
  (p "$N$ 很小，所以随便来。")
  (p "考虑原先的 tickets 把 $1$ 到 $K$ 划分成很多段，然后自己选的两张要么在同一段里要么分别在两段。")
  (p "如果两张在同一段的话显然一张头一张尾可以覆盖整段。")
  (p
   "不在同一段的话假设段长为 $L$， 那么一张可以覆盖的长度为 $\\lceil \\dfrac{L}{2} \\rceil$，放在最长的两段即可，注意首尾也有可能。")
  (p "时间复杂度 $O(n \\log n)$")
  ((h2 (id . "code")) "Code")
  (p "赛时写的非常丑，赛后有重新写了一遍")
  (pre
   ((code (class . "lang-cpp"))
    "constexpr int N = 35;\n"
    "int n, k, a[N];\n"
    "int case_num = 1;\n"
    "void preInit() { } \n"
    "void init() {\n"
    " n = sc.n(); k = sc.n();\n"
    " for (int i: range(n)) a[i] = sc.n();\n"
    " std::sort(a, a+n); } \n"
    "void solve() {\n"
    " Vector<int> bars { a[0] - 1, k - a[n-1] };\n"
    " for (int i=0; i+1<n; ++i) bars.push_back((a[i+1] - a[i]) / 2);\n"
    " std::sort(bars.begin(), bars.end(), std::greater<int>());\n"
    " int ans1 = bars[0] + bars[1];\n"
    " int ans2 = std::max(a[0] - 1, k - a[n-1]);\n"
    " for (int i=0; i+1<n; ++i) checkMax(ans2, a[i + 1] - a[i] - 1);\n"
    " printf(\"Case #%d: %.12lf\\n\", case_num++, \n"
    "        1.0 * std::max(ans1, ans2) / k); }\n"))
  ((h1 (id . "b-roaring-years")) "B. Roaring Years")
  ((h2 (id . "description")) "Description")
  (p
   "定义一个数是好的，当且尽当它能被写成 $a \\# a+1 \\# a+2 \\# \\cdots \\# a+k(k\\geq 1)$，其中 $\\#$ 表示十进制表示下字符串的拼接。")
  (p "给定一个数 $n$，求最小的大于 $n$ 的好的数。")
  (p "$n \\leq 10^{18}$")
  ((h2 (id . "tutorial")) "Tutorial")
  (p "场上写了一个很阴间的做法，然后 F 了。")
  (p "一个简洁的做法是枚举 $k$，然后再二分 $a$ 的值，显然它有单调性。")
  ((h2 (id . "code")) "Code")
  (pre
   ((code (class . "lang-python"))
    "def gen(a, n):\n"
    "   res = \"\"\n"
    "   for i in range(n):\n"
    "       res = res + str(a)\n"
    "       a += 1\n"
    "   return int(res)\n"
    "def main():\n"
    "   n = int(input())\n"
    "   ans = 10 ** 100\n"
    "   for length in range(2, 18):\n"
    "       l, r = 1, 10 ** 20\n"
    "       while l < r:\n"
    "           mid = (l + r) // 2\n"
    "           if gen(mid, length) > n:\n"
    "               r = mid\n"
    "           else:\n"
    "               l = mid + 1\n"
    "       pos = gen(l, length)\n"
    "       if ans > pos:\n"
    "           ans = pos\n"
    "   return ans\n"
    "T = int(input())\n"
    "for i in range(T):\n"
    "   print(\"Case #{}: {}\".format(i + 1, main()))\n"))
  ((h1 (id . "c-double-or-noting")) "C. Double or NOTing")
  ((h2 (id . "description")) "Description")
  (p
   "给定两个二进制串 $s,t$，每次操作可以将 $s$ 二进制翻转（零变一一变零）或者乘二（后面加零），每次操作删除多余前导零，问最少多少次能把 $s$ 变成 $t$")
  (p "Test Set 1: $|s|, |t| \\leq 8$")
  (p "Test Set 2: $|s|, |t| \\leq 100$")
  ((h2 (id . "tutorial")) "Tutorial")
  (p
   "一开始先打算写的暴力，然后没注意到 \"0\" 乘二以后还是 \"0\" 不是 \"00\" 所以暴力一直没过。当时认为答案上界是 $3n$ 或者 $2n + O(1)$，以为搜的不够深，但是再深就 TLE 了。事实证明长度为 8 的时候答案最多只有 15。")
  (p
   "感觉暴力没前途以后尝试了一下正解，想出了一个感觉靠谱的做法但还是因为乘二的原因 WA 了。然后就一直拍拍不出来，最后几分钟意识到乘二的问题，改掉以后就在大约还剩 50 秒左右的时候过了。")
  (p "先考虑一个简单的性质。如果操作中有两个连续的 NOT，那么我们一定可以把这两个 NOT 一起放到操作序列的最后，显然答案不会更劣。")
  (p "然后发现我们可以控制的一定是 $t$ 的一段后缀，所以可以枚举后缀的长度，尝试构造出这个后缀，然后判断前面的部分是否符合要求。")
  (p "具体的，对于一段连续的零或一，不断乘二，然后在在零一的边界二进制翻转，最后再不断翻转去除多余的高位。")
  (p "注意第一步也可能是翻转，所以要考虑两种情况。")
  (p "时间复杂度 $O(n^3)$，实现的精细一点可以做到 $O(n^2)$，不知道有没有更优的做法。")
  ((h2 (id . "code")) "Code")
  (pre
   ((code (class . "lang-python"))
    "def trim(n):\n"
    "   while len(n) > 1 and n[0] == \"0\":\n"
    "       n = n[1:]\n"
    "   return n\n"
    "def noting(n):\n"
    "   return trim(\"\".join(map(lambda c: \"1\" if c == \"0\" else \"0\", n)))\n"
    "def doubling(n):\n"
    "   if n == \"0\":\n"
    "       return \"0\"\n"
    "   return n + \"0\"\n"
    "def doit(f, t, param):\n"
    "   pos = param[0] if len(param) >= 1 else \" \"\n"
    "   ans = 0\n"
    "   for c in param:\n"
    "       if c != pos:\n"
    "           f = noting(f)\n"
    "           ans += 1\n"
    "       f = doubling(f)\n"
    "       ans += 1\n"
    "       pos = c\n"
    "   if pos == \"1\":\n"
    "       f = noting(f)\n"
    "       ans += 1\n"
    "   while len(f) > len(t):\n"
    "       f = noting(noting(f))\n"
    "       ans += 2\n"
    "   if f == t:\n"
    "       return ans\n"
    "   return 10 ** 100\n"
    "def main():\n"
    "   a, b = input().split()\n"
    "   ans = 10 ** 100\n"
    "   lb = len(b)\n"
    "   for i in range(lb+1):\n"
    "       # 第一步是 doubling\n"
    "       ans = min(ans, doit(a, b, b[lb-i:]))\n"
    "       # 第一步是 noting\n"
    "       ans = min(ans, doit(noting(a), b, b[lb-i:]) + 1)\n"
    "   if ans >= 10 ** 100:\n"
    "       return \"IMPOSSIBLE\"\n"
    "   return ans\n"
    "T = int(input())\n"
    "for i in range(T):\n"
    "   print(\"Case #{}: {}\".format(i + 1, main()))\n"))
  (br))
