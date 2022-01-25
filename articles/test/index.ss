($article
  ((title . 测试文章)
   (tag test))
  (h1 测试文章)
  (p 段落)
  ,($code c 
```
// test for special characters:
// <a> & </a> 
#include <stdio.h>

int main()
{
  puts("hello world!");
  return 0;
}
```)

  <a> not a html tag & </a>

  (p inline math ,($math "(E = mc^2)"))
  ,($math-block `(x + y)^n = \sum_{k} \binom{n}{k} x^k y^{n-k}`))
