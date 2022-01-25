($article
  ((tag Tutorial Math Poly) (title . "「清华集训2016」如何优雅地求和"))
  ((h2 (id . "description")) "Description")
  (p "给定 $n,x$ 和 $m$ 次多项式 $f$ （给出 $0 \\cdots m$ 的点值） ，求")
  ((script (type . "math/tex; mode=display"))
   "\\sum_{k=0}^n f(k) \\binom{n}{k} x^k (1-x)^{n-k}")
  ((h2 (id . "tutorial")) "Tutorial")
  (p "设 $f$ 转化为下降幂多项式时的系数为 $b_0 \\cdots b_m$")
  (p "使用类似于联合省选组合数问题的技巧，我们有")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "\\sum_{k=0}^n f(k)\\binom{n}{k} x^k (1-x)^{n-k}\n"
   "&= \\sum_{k=0}^n \\sum_{i=0}^{m} b_i k^{\\underline i} \\binom{n}{k} x^k (1-x) ^{n-k} \\\\\n"
   "&= \\sum_{k=0}^n \\sum_{i=0}^{m} b_i n^{\\underline i} \\binom{n-i}{k-i} x^k (1-x) ^{n-k} \\\\\n"
   "&= \\sum_{i=0}^{m} b_i n^{\\underline i} \\sum_{k=i}^n \\binom{n-i}{k-i} x^k (1-x) ^{n-k} \\\\\n"
   "&= \\sum_{i=0}^{m} b_i n^{\\underline i} x^i \\sum_{k=0}^{n-i} \\binom{n-i}{k} x^{k} (1-x) ^{n-i-k} \\\\\n"
   "&= \\sum_{i=0}^{m} b_i x^i n^{\\underline i} &(1)\n"
   "\\end{aligned}")
  (p
   "接下来考虑如何求 $b_i$，当然可以先插值再转为下降幂，但出题人给点值"
   (del "显然")
   "不是用来恶心人的，考虑直接通过点值求 $b_i$")
  (p "因为")
  ((script (type . "math/tex; mode=display"))
   "x^n = \\sum_k \\begin{Bmatrix} n\\\\k \\end{Bmatrix} x^{\\underline k}")
  (p "设 $f$ 的普通幂系数为 $a_0 \\cdots a_m$，我们有")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "b_i &= \\sum_j \\begin{Bmatrix} j\\\\i \\end{Bmatrix} a_j &(2)\n"
   "\\end{aligned}")
  (p "然后考虑一个恒等式")
  ((script (type . "math/tex; mode=display"))
   "\\sum_{m} \\binom{k}{m} \\begin{Bmatrix} n\\\\m \\end{Bmatrix} m! = k^n")
  (p "这很容易用组合意义证明")
  (p "二项式反演得到")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "m! \\begin{Bmatrix} n\\\\m \\end{Bmatrix} &= \\sum_k \\binom{m}{k} k^n(-1)^{m-k} \\\\\n"
   "  \\begin{Bmatrix} n\\\\m \\end{Bmatrix} &= \\frac1{m!}\\sum_k \\binom{m}{k} k^n(-1)^{m-k} \\\\ \n"
   "\\end{aligned}")
  (p (del "我怎么把第二类斯特林数·行的式子推了一遍"))
  (p "带入 $(2)$，得到")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "b_i &= \\sum_j \\begin{Bmatrix} j\\\\i \\end{Bmatrix} a_j \\\\\n"
   "&= \\frac1{i!} \\sum_j \\sum_k \\binom{i}{k}k^j(-1)^{i-k} a_j \\\\\n"
   "&= \\frac1{i!} \\sum_k \\binom{i}{k}(-1)^{i-k} \\sum_j a_j k^j \\\\\n"
   "&= \\frac1{i!} \\sum_k \\binom{i}{k}(-1)^{i-k} f(k) \\\\\n"
   "&= \\sum_k \\frac{f(k)}{k!} \\frac{(-1)^{i-k}}{(i-k)!} \\\\\n"
   "\\end{aligned}")
  (p "这十分的卷积，显然可以 $O(m \\log m)$ 计算")
  (p "然后把算出来的$b_i$ 带回 $(1)$ 就好了")
  ((h3 (id . "upd0")) "UPD0")
  (p "突然发现我好傻逼，转下降幂完全不用那么烦")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "f(k) &= \\sum_i b_ii! \\times \\frac{k^{\\underline i}}{i!} \\\\\n"
   "&= \\sum_i b_i i! \\binom{k}{i}\n"
   "\\end{aligned}")
  (p "直接二项式反演")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "b_k k! &= \\sum_i (-1)^{k-i} \\binom{k}{i} f(i) \\\\\n"
   "b_k &= \\sum_i \\frac{(-1)^{k-i}}{(k-i)!} \\frac{f(i)}{i!}\n"
   "\\end{aligned}")
  (p "我之前在干什么。。。")
  ((h2 (id . "code")) "Code")
  (p "一个 ntt 调了两个小时的我是屑")
  (pre
   ((code (class . "lang-cpp"))
    "// at https://gitee.com/coderoj/code/blob/master/creats/Scanner.h\n"
    "#include \"/home/jack/code/creats/Scanner.h\"\n"
    "#include <bits/stdc++.h>\n"
    "constexpr int N = 65536;\n"
    "constexpr int MOD = 998244353;\n"
    "int n, m, x;\n"
    "int a[N], b[N];\n"
    "int power(int a, int b) {\n"
    " int r = 1;\n"
    " for (;b;b>>=1) {\n"
    "   if (b & 1) { r = 1ll * r * a % MOD; }\n"
    "   a = 1ll * a * a % MOD; }\n"
    " return r; }\n"
    "inline void checkAdd(int& a) { a += a < 0 ? MOD : 0; }\n"
    "inline void checkSub(int& a) { a -= a >= MOD ? MOD : 0; }\n"
    "namespace polys {\n"
    "void dft(int *const a, int n) {\n"
    " int len = (1 << n);\n"
    " static int rev[N], w[N], last_n = -1;\n"
    " if (last_n != n) { last_n = n;\n"
    "   rev[0] = 0;\n"
    "   for (int i=1; i<len; ++i) {\n"
    "     rev[i] = (rev[i>>1] >> 1) | ((i&1) << (n-1)); }\n"
    "   for (int i=0; i<n; ++i) {\n"
    "     int p = 1 << i; int pw = power(3, (MOD-1) / p / 2); w[p] = 1;\n"
    "     for (int j=p+1; j<p+p; j++) { w[j] = 1ll * w[j-1] * pw % MOD; } } }\n"
    " for (int i=0; i<len; ++i) if (i < rev[i]) { std::swap(a[i], a[rev[i]]); }\n"
    " for (int l=1; l<len; l<<=1) {\n"
    "   for (int i=0; i<len; i+=2*l) {\n"
    "     for (int j=0; j<l; ++j) {\n"
    "       int t = 1ll * a[i + l + j] * w[l + j] % MOD;\n"
    "       checkAdd(a[i + l + j] = a[i + j] - t);\n"
    "       checkSub(a[i + j] += t); } } }\n"
    "}\n"
    "void idft(int *const a, int n) {\n"
    " int len = 1 << n;\n"
    " std::reverse(a+1, a+len);\n"
    " dft(a, n);\n"
    " int inv_len = power(len, MOD-2);\n"
    " for (int i=0; i<len; ++i) {\n"
    "   a[i] = 1ll * a[i] * inv_len % MOD; } }\n"
    "void mulp(int *const a, int *const b, int _n) {\n"
    " int l=1, n=0;\n"
    " while (l < 2*_n-1) { l *= 2; n++; }\n"
    " dft(a, n); dft(b, n);\n"
    " for (int i=0; i<l; ++i) { a[i] = 1ll * a[i] * b[i] % MOD; }\n"
    " idft(a, n);\n"
    "}\n"
    "}\n"
    "int fac[N], ifac[N];\n"
    "int main () {\n"
    " n = sc.n(); m = sc.n(); x = sc.n();\n"
    " for (int i=0; i<=m; ++i) { a[i] = sc.n(); }\n"
    " fac[0]=ifac[0]=1; for (int i=1;i<=m;++i) { fac[i] = 1ll * fac[i-1] * i % MOD; ifac[i] = power(fac[i], MOD-2); }\n"
    " for (int i=0; i<=m; ++i) { a[i] = 1ll * a[i] * ifac[i] % MOD; }\n"
    " for (int i=0; i<=m; ++i) { b[i] = ifac[i]; if (i % 2) { b[i] = MOD - b[i]; } }\n"
    " polys::mulp(a, b, m+1);\n"
    " int ans = 0;\n"
    " int x_pow = 1, n_down = 1;\n"
    " for (int i=0; i<=m; ++i) {\n"
    "   ans = (ans + 1ll * a[i] * x_pow % MOD * n_down) % MOD;\n"
    "   x_pow = 1ll * x_pow * x % MOD; n_down = 1ll * n_down * (n-i) % MOD; }\n"
    " printf(\"%d\\n\", ans);\n"
    " return 0;\n"
    "}\n"))
  (br))
