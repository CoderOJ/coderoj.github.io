($article
  ((tag Tutorial Math)
   (title . "Codeforces 932E")
   (date . "")
   (mathjax . #t))
  ((h2 (id . "description")) "Description")
  (blockquote
   (p "Calculate:")
   ((script (type . "math/tex; mode=display"))
    "\\sum_{x=0}^{N}C_N^{x}\\cdot x^k")
   (ul (li "$1\\leqslant N\\leqslant 10^9,1\\leqslant k\\leqslant 5000$")))
  ((h2 (id . "prefix-knowledge")) "Prefix Knowledge")
  (ul
   (li
    (p "Sterling numbers the second kind")
    (blockquote
     (p
      "Sterling numbers the second kind, which is written in $S(n,k)$, is defined as the number of ways to put $n$ different balls into $k$ same boxes.")
     (p "It can be calculated as below:")
     ((script (type . "math/tex; mode=display"))
      "\\begin{aligned}\n"
      "S(1,1)&=1 \\\\\n"
      "S(n,k)&=S(n-1,k-1)+n\\cdot S(n-1,k)\n"
      "\\end{aligned}"))))
  ((h2 (id . "solution")) "Solution")
  (p "Use Stirling numbers the second kind to change the form of $x^k$")
  (p "We have:")
  ((script (type . "math/tex; mode=display"))
   "x^k=\\sum_{i=0}^{x}C_x^i\\cdot i!\\cdot S(k,i)")
  (blockquote
   (p "Proof:")
   (p
    "Let's consider a problem: What's the number of ways to put $k$ different balls into $x$ different boxes.")
   (p "Obviously the answer is $x^k$.")
   (p
    "In another way, we may index $i$ that represents the number of boxes that have balls in, then the ways in this case is $S(k,i)$. And because the boxes are"
    (strong "different")
    ", we should multiply $i!$")
   (p "Thus, the answer is also $\\sum_{i=0}^{x}C_x^i\\cdot i!\\cdot S(k,i)$")
   (p "So now we have $x^k=\\sum_{i=0}^{x}C_x^i\\cdot i!\\cdot S(k,i)$"))
  (p "Then we have:")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "Ans\n"
   "&=\\sum_{x=0}^{N}C_N^{x}\\cdot x^k \\\\\n"
   "&=\\sum_{x=0}^N C_N^x\\cdot \\sum_{i=0}^{x}C_x^i\\cdot i!\\cdot S(k,i) \\\\\n"
   "&=\\sum_{x=0}^N \\sum_{i=0}^{x}C_N^x\\cdot C_x^i\\cdot i!\\cdot S(k,i) \\\\\n"
   "&=\\sum_{i=0}^N \\sum_{x=i}^{N}C_N^x\\cdot C_x^i\\cdot i!\\cdot S(k,i) \\\\\n"
   "&=\\sum_{i=0}^N S(k,i) \\cdot \\sum_{x=i}^{N}C_N^x\\cdot C_x^i\\cdot i! \\\\\n"
   "\\end{aligned}")
  (p
   "Then change the form of  $\\sum_{x\\in[i,n]} C_N^x\\cdot C_x^i\\cdot i!$")
  (p "Notice that this is the answer to the problem:")
  (blockquote
   (p
    "What's the number of ways to choose $x$ objects(same) from $N$, then $i$ (different) from $k$ ?"))
  (p
   "We may first index $i$, then consist the other $N-i$. They can be either chosen or not during the first round.")
  (p
   "Thus we have $\\sum"
   (em "{x\\in[i,N]}C")
   "{N}^x\\cdot C"
   (em "x^i\\cdot i!=A")
   "{N}^i\\cdot 2^{N-i}$ ")
  (p "After,")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "Ans\n"
   "&=\\sum_{i=0}^N S(k,i) \\cdot \\sum_{x=i}^{N}C_N^x\\cdot C_x^i\\cdot i! \\\\\n"
   "&=\\sum_{i=0}^N S(k,i) \\cdot A_N^i\\cdot 2^{N-i} \\\\\n"
   "\\end{aligned}")
  (p
   "We may notice that when $i\\geqslant k, \\ \\ S(k,i)=0$, so we just need to index $i$ from $0$ to $k$, not to $N$")
  (p "Thus, the problem can be solved in $O(k^2)$")
  ((h2 (id . "code")) "Code")
  (pre
   ((code (class . "lang-cpp"))
    "const int N = 5005;\n"
    "const int MOD = 1e9+7;\n"
    "int s[N][N];\n"
    "int n, k;\n"
    "int power(int base, int exp) {\n"
    "   if (exp < 0) return 0;\n"
    "   int res=1;\n"
    "   while (exp) {\n"
    "       if (exp&1) (res*=base)%=MOD;\n"
    "       (base*=base) %= MOD; exp >>=1; }\n"
    "   return res; }\n"
    "int inv(int u) { return power(u,MOD-2); }\n"
    "int nAr(int n, int r) {\n"
    "   int res=1;\n"
    "   rep (i,r) (res*=(n-i)) %=MOD;\n"
    "   return res; }\n"
    "void initStirling() {\n"
    "   s[1][1] = 1;\n"
    "   repi (i,2,N-1) repa (j,i) s[i][j] = (s[i-1][j-1] + s[i-1][j]*j) % MOD; }\n"
    "void init() {\n"
    "   scanf(II,&n,&k); \n"
    "   initStirling();\n"
    "}\n"
    "void solve() {\n"
    "   int ans=0;\n"
    "   rep (j,k+1) { \n"
    "       (ans+= nAr(n,j) * power(2,n-j) % MOD * s[k][j] % MOD) %= MOD; }\n"
    "   printf(IN,ans);\n"
    "}\n"))
  (br))
