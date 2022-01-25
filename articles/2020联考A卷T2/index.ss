($article
  ((tag Math Tutorial)
   (title . "2020 联考 A 卷 D1T2")
   (date . "")
   (mathjax . #t))
  ((h2 (id . "description")) "Description")
  (p "给定 $n,x,p$ 和一个 $m$ 度多项式，求：")
  ((script (type . "math/tex; mode=display"))
   "\\sum_{k=0}^{n} \u200Bf(k) x^k \\binom{n}{k}")
  (p "在模 $p$ 意义下的值。")
  ((h2 (id . "tutorial")) "Tutorial")
  (p "考虑把 $f$ 转为下降幂多项式，设")
  ((script (type . "math/tex; mode=display"))
   "f(x) = \\sum_{i=0}^m b_ix^{\\underline i}")
  (p "所求即为：")
  ((script (type . "math/tex; mode=display"))
   "\\sum_{k=0}^n \\sum_{i=0}^{m} b_i k^{\\underline i}x^k \\binom{n}{k}")
  (p "我们有：")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "\\binom{n}{k} k^{\\underline i} &= \\frac{n!}{k!(n-k)!} \\frac{k!}{(k-i)!}  \\\\\n"
   "&= \\frac{(n-i)!n^{\\underline i}}{(n-k)!(k-i)!} \\\\\n"
   "&= \\binom{n-i}{k-i}n^{\\underline i}\n"
   "\\end{aligned}")
  (p "所以：")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "\\sum_{k=0}^n \\sum_{i=0}^{m} b_i k^{\\underline i}x^k \\binom{n}{k} \n"
   "&= \\sum_{k=0}^n\\sum_{i=0}^{m} \\binom{n}{k} k^{\\underline{i}} b_i x^k \\\\\n"
   "&= \\sum_{k=0}^n\\sum_{i=0}^{m} \\binom{n-i}{k-i} n^{\\underline{i}} b_i x^k \\\\\n"
   "&= \\sum_{i=0}^{m} n^{\\underline{i}} b_i \\sum_{k=i}^n \\binom{n-i}{k-i} x^k \\\\\n"
   "&= \\sum_{i=0}^{m} n^{\\underline{i}} b_i x^i \\sum_{k=0}^{n-i} \\binom{n-i}{k} x^k \\\\\n"
   "&= \\sum_{i=0}^{m} n^{\\underline{i}} b_i x^i (x+1)^{n-i} \\\\\n"
   "\\end{aligned}")
  (p "直接 $O(m)$ 计算。转下降幂直接暴力即可，总复杂度 $O(m^2)$")
  ((h2 (id . "code")) "Code")
  (pre
   ((code (class . "lang-cpp"))
    "constexpr int N = 1005;\n"
    "int n, x, p, m;\n"
    "int a[N], b[N];\n"
    "int stir[N][N];\n"
    "void initStir() {\n"
    " stir[0][0] = 1;\n"
    " for (int i = 1; i <= m; ++i) {\n"
    "   for (int j = 1; j <= i; ++j) {\n"
    "     stir[i][j] = (stir[i - 1][j - 1] + 1ll * j * stir[i - 1][j]) % p; } } }\n"
    "void pow_to_down() {\n"
    " for (int i = 0; i <= m; ++i) {\n"
    "   for (int j = 0; j <= i; ++j) {\n"
    "     b[j] = (b[j] + 1ll * stir[i][j] * a[i]) % p; } } }\n"
    "int power(int a, int b) {\n"
    " int r = 1;\n"
    " for (; b; b >>= 1) {\n"
    "   if (b & 1) {\n"
    "     r = 1ll * r * a % p; }\n"
    "   a = 1ll * a * a % p; }\n"
    " return r; }\n"
    "void preInit() { } void init() {\n"
    " n = sc.n(); x = sc.n(); p = sc.n(); m = sc.n();\n"
    " for (int i : range(m + 1)) {\n"
    "   a[i] = sc.n(); } }\n"
    "void solve() {\n"
    " initStir();\n"
    " pow_to_down();\n"
    " logArray(b, b + n + 1);\n"
    " int n_down = 1, x_pow = 1;\n"
    " int ans = 0;\n"
    " for (int i = 0; i <= m; ++i) {\n"
    "   ans = (ans + 1ll * n_down * b[i] % p * x_pow % p * power(x + 1, n - i)) % p;\n"
    "   n_down = 1ll * n_down * (n - i) % p; x_pow = 1ll * x_pow * x % p; }\n"
    " printf(\"%d\\n\", ans); }\n"))
  (br))
