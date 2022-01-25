($article
  ((tag Math Poly Tutorial) (title . "Codeforces 438E") (date . ""))
  ((h2 (id . "description")) "Description")
  (p
   "We define a tree valid if and only if on each node there is a number in $S$, and the value of this true is define as the sum of these numbers.")
  (p
   "Given $n,m,S$, for each $k$ in $[1,m]$ find out the number of valid"
   (strong "binary")
   "trees with $n$ nodes and value $k$.")
  ((h2 (id . "tutorial")) "Tutorial")
  (p
   "Define the OGF to the answer as $F$, and $G(x) = \\sum_{k=0}^\\infty [k \\in S]x^k$.")
  (p "We know that a binary tree is defined as follow:")
  (ul
   (li "An empty tree is a binary tree")
   (li "The combination of a root and two son binary trees(with order)"))
  (p "The there is clear that")
  ((script (type . "math/tex; mode=display")) "F(x) = 1 + G(x)F^2(x)")
  (p "So")
  ((script (type . "math/tex; mode=display"))
   "F(x) = \\frac{2}{1 \\pm \\sqrt{1-4G(x)}}")
  (p "As is obviously that")
  ((script (type . "math/tex; mode=display")) "[x^0]F(x) = 1")
  (p "We know the $\\pm$ should be $+$")
  ((h2 (id . "code")) "Code")
  (p
   "ref:"
   ((a
     (href . "https://gitee.com/coderoj/cts/blob/master/tmp/CF438E/main.cpp"))
    "local")
   ","
   ((a (href . "https://codeforces.com/contest/438/submission/99882580"))
    "complete"))
  (pre
   ((code (class . "lang-cpp"))
    "#include \"~/code/Math/Poly/main.h\"\n"
    "void solve()\n"
    "{\n"
    " using namespace Polys;\n"
    " int n = sc.n(), m = sc.n();\n"
    " Poly A(m+1);\n"
    " rep (i,n) { \n"
    "   int u = sc.n();\n"
    "   if (u <= m) A[u] -= 4; }\n"
    " A[0] = 1;\n"
    " A = A.sqrt();\n"
    " A[0] = 2;\n"
    " A = A.inv();\n"
    " A *= Int(2);\n"
    " repa (i,m) printf(\"%u\\n\", static_cast<unsigned>(A[i]));\n"
    "}\n"))
  (br))
