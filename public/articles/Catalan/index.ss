($article
  ((tag Math Poly)
   (title . "Conclusion on Catalan number")
   (date . "")
   (mathjax . #t))
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "c_0 &= 1 \\\\\n"
   "c_n &= \\sum_{k=0}^{n-1} c_kc_{n-k-1} &(x \\geq 1)\n"
   "\\end{aligned}")
  (p "Define")
  ((script (type . "math/tex; mode=display"))
   "C(x) = \\sum_{k=0}^\\infty c_k x^k")
  (p "Then")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "C^2(x) &= \\sum_{k=0}^{\\infty} \\sum_{j=0}^{k}c_jc_{k-j}x^k \\\\\n"
   "&= \\sum_{k=0}^{\\infty}c_{k+1}x^k \\\\\n"
   "xC^2(x)&= -1 + C(x)\n"
   "\\end{aligned}")
  (p "Therefore")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "xC^2-C+1 &= 0 \\\\\n"
   "C &= \\frac{1\\pm\\sqrt{1-4x}}{2x} \\\\\n"
   "\\end{aligned} \\\\")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "&\\because [x^0]C = 0 \\\\\n"
   "&\\therefore C = \\frac{1-\\sqrt{1-4x}}{2x}\n"
   "\\end{aligned}")
  (p "Then consider how to solve $\\sqrt{1-4x}$")
  (p "Because")
  ((script (type . "math/tex; mode=display"))
   "(1+x)^\\alpha = \\sum_{k=0}^{\\infty}\\binom{\\alpha}{k}x^k")
  (p "We have")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "(1-4x)^{\\frac{1}{2}}\n"
   "&= \\sum_{k=0}^{\\infty}\\binom{\\frac{1}{2}}{k}(-4x)^k \\\\\n"
   "&= \\sum_{k=0}^{\\infty}\\frac{(\\frac{1}{2})^{\\underline{k}}}{k!}(-4x)^k \\\\\n"
   "&= \\sum_{k=0}^{\\infty}\\frac{(-\\frac{1}{2})^{\\overline{k}}}{k!}(4x)^k \\\\\n"
   "&= \\sum_{k=0}^{\\infty}\\frac{(k-\\frac{3}{2})^{\\underline{k}}}{k!}(4x)^k \\\\\n"
   "&= -\\frac{1}{2}\\sum_{k=0}^{\\infty}\\frac{(k-\\frac{3}{2})^{\\underline{k-1}}}{k!}(4x)^k \\\\\n"
   "&= -\\sum_{k=0}^{\\infty}\\frac{(2k-3)!!}{k!}(2x)^k \\\\\n"
   "&= -{2}\\sum_{k=0}^{\\infty}\\frac{(2k-3)!!}{k!} \\frac{(2k-2)!!}{(k-1)!} x^k \\\\\n"
   "&= -{2}\\sum_{k=0}^{\\infty}\\frac{(2k-2)!}{k!(k-1)!} x^k \\\\\n"
   "&= -{2}\\sum_{k=0}^{\\infty}\\frac{1}{k}\\binom{2k-2}{k-1} x^k \\\\\n"
   "\\end{aligned}")
  (p
   "Here we need to define $x^\\underline{-1}$ as $\\frac{1}{x}$, otherwise there are some edge cases.")
  (p "Pay attention to where $2$ and $\\frac{1}{2}$ appear and disappear.")
  (p "Therefore")
  ((script (type . "math/tex; mode=display"))
   "\\begin{aligned}\n"
   "C(x) \n"
   "&= \\frac{1 + 2\\sum_{k=0}^{\\infty}\\frac{1}{k}\\binom{2k-2}{k-1} x^k}{2x} \\\\\n"
   "&= \\sum_{k=1}^{\\infty}\\frac{1}{k}\\binom{2k-2}{k-1} x^{k-1} \\\\ \n"
   "&= \\sum_{k=0}^{\\infty}\\frac{1}{k+1}\\binom{2k}{k} x^{k} \\\\ \n"
   "\\end{aligned}")
  (p "As is obviously we have")
  ((script (type . "math/tex; mode=display"))
   "c_n = \\frac{1}{n+1}\\binom{2n}{n}")
  (br))
