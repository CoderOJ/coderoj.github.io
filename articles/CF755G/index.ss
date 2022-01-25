($article
  ((tag Tutorial Math Poly)
   (title . "Codeforces 755G")
   (date . "")
   (mathjax . #t))
  ((h2 (id . "description")) "Description")
  (p
   "$n$ balls stand a row. You can select exactly $m$ groups of them,\n"
   "each consisting either a single ball or two neighbouring balls.\n"
   "Each ball can only be in one group.")
  (p
   "for all $m$ in $[1,k]$\n"
   "you need to output the number of such divisions.")
  ((h2 (id . "tutorial")) "Tutorial")
  (p "let $f(n,m)$ to be the answer of selecting $m$ groups in $n$ balls.")
  (p "let")
  ((script (type . "math/tex; mode=display"))
   "F_n(x) = \\sum_{k \\geq 0}^{\\infty} f(n,k) x^k")
  (p "Because")
  ((script (type . "math/tex; mode=display"))
   "f(n,k) = f(n-1,k) + f(n-1,k-1) + f(n-2,k-1)")
  (p "We have")
  ((script (type . "math/tex; mode=display")) "F_n = (1+x)F_{n-1} + xF_{n-2}")
  (p "It can be proved that there exist a $Z$ that for all $n$")
  ((script (type . "math/tex; mode=display")) "F_n = Z * F_{n-1}")
  (p "Then we have")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "Z^2 F_{n-2} &= Z (1+x)F_{n-2} + F_{n-2} \\\\\n"
   "Z^2 - (1+x) Z - 1 &= 0 \\\\\n"
   "Z &= \\frac{1+x\\pm\\sqrt{1+6x+x^2}}{2} \\\\\n"
   "Z_1 &= \\frac{1+x+\\sqrt{1+6x+x^2}}{2}, \\\\\n"
   "Z_2 &= \\frac{1+x-\\sqrt{1+6x+x^2}}{2} \\\\\n"
   "\\end{aligned}")
  (p "Therefore")
  ((script (type . "math/tex; mode=display")) "F_n = C_1Z_1^{n} + C_2Z_2^{n}")
  (p "As is obviously that")
  ((script (type . "math/tex; mode=display")) "F_0(x) = 1,\n" "F_1(x) = 1 + x")
  (p "So we can solve $C_1, C_2$")
  ((script (type . "math/tex; mode=display"))
   "C_1 = \\frac{Z_1}{\\sqrt{1+6x+x^2}},\n"
   "C_2 = \\frac{-Z_2}{\\sqrt{1+6x+x^2}}")
  (p "Then $F_n$ shoud be")
  ((script (type . "math/tex; mode=display"))
   "F_n = \\frac{Z_1^{n+1} - Z_2^{n+1}}{\\sqrt{1+6x+x^2}}")
  (p "Obviously")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}[]\n"
   "[x^0] Z_2 &= 0 \\\\\n"
   "Z_2^{n+1}(x) &\\equiv 0 \\pmod{x^{n+1}}\n"
   "\\end{aligned}")
  (p "So there is no need to calculate $Z_2$")
  ((script (type . "math/tex; mode=display"))
   "F_n = \\frac{1}{\\sqrt{1+6x+x^2}} (\\frac{1+x+\\sqrt{1+6x+x^2}}{2})^{n+1}")
  (p "And this can be solved in $O(k \\log k)$")
  ((h2 (id . "code")) "Code:")
  (p
   ((a (href . "https://gitee.com/coderoj/code/blob/master/creats/Scanner.h"))
    "include1")
   ((a (href . "https://gitee.com/coderoj/code/blob/master/Math/Poly/main.h"))
    "include2"))
  (pre
   ((code (class . "lang-cpp"))
    "int main() {\n"
    " using namespace Polys;\n"
    " int _n = sc.n();\n"
    " int _k = sc.n();\n"
    " int k = std::max(3, _k+1);\n"
    " Poly Delta(k);\n"
    " Delta[0] = 1;\n"
    " Delta[1] = 6;\n"
    " Delta[2] = 1;\n"
    " Delta = Delta.sqrt();\n"
    " Poly Z = Delta;\n"
    " Z[0] += Int(1);\n"
    " Z[1] += Int(1);\n"
    " Z *= Int(1) / Int(2);\n"
    " int n = (_n+1) % MOD;\n"
    " Z = Z.pow(n,n);\n"
    " Z *= Delta.inv();\n"
    " for (int i = 1; i <= _k; ++ i) {\n"
    "   printf(\"%u \", i <= _n ? static_cast<unsigned>(Z[i]) : 0);\n"
    " }\n"
    " return 0;\n"
    "}\n"))
  (br))
