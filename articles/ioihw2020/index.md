---
title: 集训队作业 2020 做题记录
tags: Tutorial
---

# 集训队作业 2020 做题记录

有些题可能会写得很简略，毕竟这不是什么正经的题解，不过基本思路都有。

完成进度: <span id="fill-tot-solved"></span> / 150

<script>
  function toggleAllDetails() {
    for (let element of document.getElementsByTagName("details")) {
      element.open ^= 1;
    }
  }
</script>

<button onclick="toggleAllDetails()" style="border-style: solid; cursor: pointer"> toggle all </button>

## Atcoder 部分

### AGC020D
<!-- {{{ -->
[{MDEXPAND Description
多组询问。每个询问给定四个整数，$A, B, C, D$，求一个满足这个条件的字符串：

+ 长度为 $A + B$，由 $A$ 个字符A和 $B$ 个字符 B 构成  
+ 在此基础上，连续的相同字符个数的最大值最小  
+ 在此基础上，字典序最小  

输出这个字符串的第 $C$ 位到第 $D$ 位。
}]
[{MDEXPAND Tutorial

考虑构造出来的串一定是 $A \cdots ABA \cdots ABA \cdots | B \cdots BAB \cdots BA \cdots$

然后直接二分分界点即可。

code:

```scheme
(define (solve a b c d)
  (define k (quotient (+ a b) (+ 1 (min a b))))
  (define (get_ab p)
    (cons
      (- a (* (quotient p (+ k 1)) k) (modulo p (+ k 1)))
      (- b (quotient p (+ k 1)))))
  (define sep
    (let search ((l 0) (r (+ a b)))
      (if (= l r) l
        (let* ((mid (quotient (+ l r) 2))
               (g_r (get_ab mid))
               (pa (car g_r))
               (pb (cdr g_r)))
          (if (<= pb (* pa k))
            (search (+ mid 1) r)
            (search l mid))))))
  (define pos
    (let* ((g_r (get_ab sep))
           (pa (car g_r))
           (pb (cdr g_r)))
      (+ 1 sep pb (- (* pa k)))))

  (let loop ((i c))
    (display
      (if (<= i sep)
        (if (= (modulo i (+ k 1)) 0) #\B #\A)
        (if (= (modulo (- i pos) (+ k 1)) 0) #\A #\B)))
    (when (< i d) (loop (+ i 1))))
  (newline))


(let loop ((n (read)))
  (when (> n 0)
    (let* ((a (read))
           (b (read))
           (c (read))
           (d (read)))
    (solve a b c d) (loop (- n 1)))))
```

}]

<!-- }}} -->
### AGC020E
<!-- {{{ -->
[{MDEXPAND Description
我们定义一个 01 串的压缩是满足如下方式的字符串变化过程：

+ $0\to 0, 1\to 1$
+ 如果 $A\to P, B\to Q$ 合法，那么 $A+B \to P+Q$ 也合法（其中 + 代表字符串拼接）
+ 如果 $S = A^n (n \geq 2)$，那么 $S\to (A\times n)$ 也合法（其中 (, ), $\times$ 为字符，$n$ 为数字，算作一个字符，即使其中有 0/1）

现在给你一个 01 串 S，问它所有的**子集**的合法变化结果数的总和为多少。

答案对 $998244353$ 取模。
}]
[{MDEXPAND Tutorial

先考虑一个固定的 01 串压缩方案数是多少。显然有一个 $O(n^3)$ 的区间 dp

然后考虑所有子集的和。此时要取若干个区间的交，而这个交不一定是一个子串，所以要改成 `std::map` 记忆化搜索。

~~复杂度毛估估能过~~

}]
<!-- }}} -->
### AGC020F
<!-- {{{ -->
[{MDEXPAND Description
你有一个长度为 $C$ 的圆，你在上面画了 $N$ 个弧。弧 $i$ 有长度 $l\_i$

每一条弧 $i$ 随机均匀地放置在圆上：选择圆上的一个随机实点，然后出现一条以该点为中心的长度为l $l\_i$ 的弧。弧是独立放置的。例如，它们可以相互交叉或包含。

现在问你圆的每一个实点被至少一个弧覆盖的概率是多少？注意一条弧覆盖了它的两个端点。
}]
[{MDEXPAND Tutorial

经典套路。

首先从最长的弧的一个断环为链，转化为链上问题。

然后发现所有弧长都为整数，此时有一个很常见的套路就是 $O(N!)$ 枚举这些弧左端点**小数部分**的偏序关系。

然后就转化为了整点上的问题，直接状压 dp 即可，复杂度 $O(n! 2^n \operatorname{poly}(n))$ 

}]
<!-- }}} -->
### AGC021E
<!-- {{{ -->
[{MDEXPAND Description
有 $n$ 只变色龙，一开始都是蓝色。现在你喂了 $k$ 次球，每次指定一只变色龙吃下你指定颜色的球。  

一只变色龙从蓝色变成红色当且仅当它吃的红球比蓝球多， 一只变色龙从红色变成蓝色当且仅当它吃的蓝球比红球多。  

求最后能使所有变色龙都变成红色的方案数。  

两个方案不同当且仅当至少一次喂的球颜色不同（而不是喂的变色龙不同）。  

注意：存在一次喂的变色龙不同的两个方案可能是相同的方案。  
}]
[{MDEXPAND Tutorial

考虑枚举最终序列中红球的个数，设红球有 $r$ 个，蓝球有 $b$ 个。

1. 如果 $r < b$，显然一定不可行。
1. 如果 $r - b \geq n$，那么对于每一条变色龙，我们一定可以让分给它的红球比蓝球多，所以任意方案都合法。
1. 剩下的情况，发现一定存在一种最优方案满足：$r-b$ 条龙分到的红球比蓝球恰好多 1，剩下的龙都分到两个球，先红后蓝。结论不难证明，如果一条龙分到的红球颜色比蓝球多 2，那么可以把多出来的红球分给一个相等的。如果一个分到两种颜色数量相等的龙分到了大于等于 4 个球，就一定能拿出若干对红蓝求分给红球比蓝球多的龙。这样我们说明了任意方案都可以调整到这种局面， 也就证明了这个结论。这样的序列数量可以直接通过组合数求出，类似卡特兰数的求法。

code：

```scheme
(define mod 998244353)
(define max-n 500005)
(define fac
  (let loop ((result (make-vector max-n 1)) (i 1))
    (cond
      ((>= i max-n) result)
      (#t (vector-set! result i (modulo (* i (vector-ref result (- i 1))) mod)) 
          (loop result (+ i 1))))))
(define inv
  (let loop ((result (make-vector max-n 1)) (i 2))
    (cond
      ((>= i max-n) result)
      (#t (vector-set! result i (modulo (* (- mod (quotient mod i)) 
                                           (vector-ref result (modulo mod i))) mod))
          (loop result (+ i 1))))))
(define ifac
  (let loop ((result (make-vector max-n 1)) (i 1))
    (cond
      ((>= i max-n) result)
      (#t (vector-set! result i (modulo (* (vector-ref result (- i 1))
                                           (vector-ref inv i)) mod))
          (loop result (+ i 1))))))

(define (ncr n r)
  (cond 
    ((> r n) 0)
    ((< r 0) 0)
    (#t (modulo (* (vector-ref fac n) (vector-ref ifac r) (vector-ref ifac (- n r))) mod))))

(define n (read))
(define k (read))

(define (solve r b)
  (cond
    ((< r b) 0)
    ((< r n) 0)
    ((>= (- r b) n) (ncr k r))
    (#t 
      (when (= r b) (set! b (- b 1)))
      (- (ncr (+ r b) r) (ncr (+ r b) (+ r r (- n) 1))))))

(let loop ((ans 0) (i 0))
  (cond
    ((> i k) (write (modulo ans mod)) (newline))
    (#t (loop (+ ans (solve i (- k i))) (+ i 1)))))
```
}]
<!-- }}} -->
### AGC021F
<!-- {{{ -->
[{MDEXPAND Description
现有一个 N 行 M 列的、仅包含黑白格的表格，左上为 (1,1)(1, 1)(1,1)，右下为 (N,M)(N, M)(N,M)。

对于一个表格，设长度为 N 的数列 A，长度为 M 的数列 B、C 分别表示：

+ $A\_i$ 表示第 i 行第一个黑格的列号。若不存在则为 $M + 1$
+ $B\_i$ 表示第 i 列第一个黑格的行号。若不存在则为 $N + 1$
+ $C\_i$ 表示第 i 列最后一个黑格的行号。若不存在则为 0

现请你求出所有的 $2^{NM}$ 种表格中，不同的数列三元组 $(A,B,C)$ 的个数对 998244353 取模的结果。

$1 \leq N \leq 8 \times 10^3, 1 \leq M \leq 200$
}]
[{MDEXPAND Tutorial

令 $f(i,j)$ 表示强制**每行**都有黑格子的 $i$ 行 $j$ 列矩阵的方案数，显然答案是 $\sum_{i=1}^n \binom ni f(i,m)$

然后列出转移：

$$
f(i, j) = (1 + i + \binom i 2)f(i, j-1) + \sum_{k < i} \binom {i+2}{k} f(k, j-1)
$$

然后右半边 fft 优化即可

时间复杂度 $O(nm \log n)$

}]
<!-- }}} -->
### AGC022D
<!-- {{{ -->
[{MDEXPAND Description
有 $n$ 个商场, 第 $i$ 个商场在数轴上的 $x\_i$ 处, 你需要在第 $i$ 个商场花费连续的 $t\_i$ 单位时间购物

现在有一趟火车会在 0 到 L 处往返, 行驶一单位距离要花费一单位时间.

你从 0 时刻起在 0 处上车, 只有在商场, 0 处或 L 处才能下车, 问最少花费多少单位时间能在每一个商场都购完物后回到 0 处.

$n \leq 3 \times 10^5, 0 < x, L \leq 10^9$
}]
[{MDEXPAND Tutorial
先把所有的 $t\_i$ 对 $2L$ 取模，把商加到答案里，显然答案不变。

对于取模以后为 0 的，直接删掉。

考虑剩下的部分，答案的上界是 $N+1$，直接从小到大访问即可。

对于每一轮（即时长为 $2L$ 的一段），最多只能访问两家商店。因此我们缩小答案的方法只有将商店两两配对。

对于每个商店，定义 $l\_i = [2(L - x\_i) \geq t\_i], r\_i = [2x\_i \geq t\_i]$

对于一组 $i < j, r\_i = 1, l\_i = 1$，我们可以将其配对，将答案减小一轮。

$i < j, l\_i = 0, r\_j = 1$ 这样的点对不可能存在。

直接贪心匹配即可。
}]
<!-- }}} -->
### AGC022E
<!-- {{{ -->
[{MDEXPAND Description
有个奇数长度的 01 串 s 其中有若干位置是 ?

每次可将 3 个连续的字符替换成这三个数的中位数

求有多少方案将 ? 替换成 0/1 使得能对其进行若干次操作后得到一个 1
}]
[{MDEXPAND Tutorial
先考虑怎么判断。

“把若干个连续的数替换为新的数”这类题目的一个常见套路是维护一个栈，依次把数加入。

这道题中，我们的策略是先删 000， 然后把相邻的 01 删除（因为 01? 的中位数为 ?，所以相邻的 01 可以直接视为不存在）。

转换为栈的操作。我们维护一个栈顶到栈底为先一段 0 后一段 1 的栈。新加元素后，如果栈顶出现 000，那么替换为 0，如果出现 10，那么这个 1 与 0 抵消是一种不劣的做法，因此将其消去。这样也就保证了先 0 后 1 的性质。最后只要 1 的个数多余 0，就是合法的解。

然后要统计个数。常见的套路是 dp 套 dp。上述做法中，栈中 1 的个数可能会很大，但我们发现，由于 0 的个数最多为 2，如果 1 的个数大于 2，多出来的 1 并没有用，所以直接忽略即可。这样栈中最多 2 个 1, 2 个 0, 一共 9 种状态，dp 套 dp 转移即可。
}]
<!-- }}} -->
### AGC022F
<!-- {{{ -->
[{MDEXPAND Description
令 $x=10^{100}$, 数轴上有 $n$ 个点, 第 $i$ 个点的坐标为 $x^i$

进行 $n-1$ 次操作, 每次操作选择两点 $A$ 和 $B$, 将 $A$ 移动到 $A$ 关于 $B$ 的对称的位置并删去 $B$

求最后剩下的一个数有多少种可能的取值.

$n \leq 50$
}]
[{MDEXPAND Tutorial
考虑每次操作把 $B$ 向 $A$ 连边，形成一棵儿子有顺序的树。

对于点 $u$，它的贡献为 $2^{d(u)} s(u) x^u$，其中 $d(u)$ 是 u 的深度， $s(u)$ 是 -1 或 1

然后由于 $x$ 非常大，我们可以认为只要两个系数序列不同，最终的位置也不同。

$d(u),s(u)$ 的值都通过树的形态确定，dp 即可。（好吧我还不是很会，不过大致思路就是这样）
}]
<!-- }}} -->
### AGC023D
<!-- {{{ -->
[{MDEXPAND Description
一条街上有 $n$ 栋楼，位置从小到大分别在 $x\_1, x\_2, \cdots , x\_n$

在位置 $s$ 有一座公司，员工下班时乘坐公司的员工班车回家。

这些员工住在 $n$ 栋楼内，具体地说，第 $i$ 栋楼内住着 $P\_i$ 个员工。

班车是自动驾驶的，每一个时刻，还在车内的每个员工都会进行投票，只能投正方向或者负方向，不能弃权。

班车会自动统计两个方向的票数，并且往票多的方向行驶一个单位长度，如果票一样多，那就往负方向行驶。

员工们也有投票策略，每一个员工都会投能让他回家时间尽量早的方向，如果两个方向一样早，那就投负方向。

如果班车到达了某一个楼，那么住在那栋楼中的所有员工都会下车。

可以证明，在上述条件下，每个员工投票的方向是能够唯一确定的，班车的运行路线也能够唯一确定。

最终询问最后一名员工回到家，经过了多少个单位时间。

$1 \le n \le 10^5$
}]
[{MDEXPAND Tutorial
反过来考虑。假设现在的区间是 $[l,r]$

+ 如果 $s \not \in [l,r]$，那么显然只会向一个方向。
+ 否则，当 $p\_l \geq p\_r$ 时，不难证明最后到达的是 $r$，否则是 $l$。假设最后到达的是 $r$，那么在此之前 $r$ 的所有决策都会 $l$ 一致，那么可以让他们暂时归为 $l$。然后递归处理即可。


code（代码里用了 `sort`，建议用 Gauche 执行）:

```scheme

(define n (read))
(define s (read))

(define p 
  (let loop ((p '()) (i 0))
    (if (= i n) 
      (sort (list->vector p) (lambda (a b) (< (car a) (car b))))
      (loop (cons (cons (read) (read)) p) (+ i 1)))))

(define (pos index) (car (vector-ref p index)))
(define (pop index) (cdr (vector-ref p index)))
(define (set-pop index value) (set-cdr! (vector-ref p index) value))

(write 
  (let solve ((ans 0) (l 0) (r (- n 1)) 
              (goal (if (< (pop 0) (pop (- n 1))) 0 (- n 1))))
    (cond 
      ((< s (pos l)) (+ ans (- (pos r) s)))
      ((< (pos r) s) (+ ans (- s (pos l))))
      ((>= (pop l) (pop r)) 
        (set-pop l (+ (pop l) (pop r))) 
        (solve (+ ans (if (= goal r) (- (pos r) (pos l)) 0)) l (- r 1) l))
      (#t
        (set-pop r (+ (pop l) (pop r)))
        (solve (+ ans (if (= goal l) (- (pos r) (pos l)) 0)) (+ l 1) r r)))))
```
}]
<!-- }}} -->
### AGC023E
<!-- {{{ -->
[{MDEXPAND Description
给定一个长度为 $n$ 的序列 $a$，问所有满足$\forall i,P\_i\le A\_i$ 的 $1\sim n$ 的排列的逆序数的和为多少

答案对 $10^9+7$ 取模。
}]
[{MDEXPAND Tutorial
令 $b\_i$ 为 $a\_i$ 的排名，$c\_i$ 为 $a\_i$ 排序过后的结果。

总方案数 $f(n) = \prod\_{i=1}^{n} (a\_i - b\_i + 1) = \prod\_{i=1}^{n} (c\_i - i + 1)$

考虑插入位置 $i$ 时它前面的一个位置 $j$ 和它产生逆序对的方案数。

假设 $a\_i \geq a\_j$，若令 $a\_i \leftarrow a\_j$，则此时的所有方案中满足逆序的数量为总数的一半。对于 $a\_i < a\_j$ 的情况，用总方案数减去顺序的即可。

所以 $i,j$ 的贡献 

$$
f(i,j) = \frac 12 f(n) \frac{a_j - b_j}{a_i - b_i + 1} \prod_{k = b_j + 1}^{b_i - 1} \frac{c_k - k}{c_k - k + 1}
$$

然后考虑把 $f(i,j)$ 分为和 $i,j$ 分别有关的两部分，有：

$$
f(i,j) = \frac 12 \frac{f(n)}{a_i - b_i + 1} \times (a_j - b_j) \prod_{k = b_j + 1}^{b_i - 1} \frac{c_k - k}{c_k - k + 1}
$$

左半边与 $i$ 有关，右半边可以用线段树维护。

具体的，按从小到大的顺序依次插入，假设当前插入的是第 $k$ 个，那么全局乘上 $\frac{c\_k - k}{c\_k - k + 1}$，然后再把位置 $k$ 赋为 $(a\_k - b\_k)$ 即可。
}]
<!-- }}} -->
### AGC023F
<!-- {{{ -->
[{MDEXPAND Description
给出一棵 $n$ 个节点的树，以及一个空序列。

每个节点上有一个取值在 $\{0, 1\}$ 中的数。

每次你可以选择没有父亲节点的点删除，并且将这个节点上的数字放在当前数列末尾。

请你求出这个数列可能得到的最小逆序对数。

$n \leq 2 \times 10 ^5$
}]
[{MDEXPAND Tutorial
经典套路，根据一个顺序丢进 set 里每次去最小的和父亲合并。

考虑这题中关键字是什么。

假设是有两段 01 序列，0 和 1 的个数分别是 $a0, a1, b0, b1$

那么合起来的新增逆序对数量是 $a1 \times b0$ 或 $b1 \times a0$

不难看出按照子树中 1 的个数和 0 的个数的比值为关键字排序即可。
}]
<!-- }}} -->
AGC024D
AGC024E
AGC024F
AGC025D
AGC025E
AGC025F
AGC026D
AGC026E
AGC026F
AGC027D
AGC027E
AGC027F
AGC028C
AGC028D
AGC028E
AGC028F
AGC029C
AGC029E
AGC029F
AGC030C
AGC030D
AGC030E
AGC030F
AGC031D
AGC031E
AGC031F
AGC032C
AGC032D
AGC032E
AGC032F
AGC033D
AGC033E
AGC033F
AGC034D
AGC034E
AGC034F
AGC035C
AGC035D
AGC035E
AGC035F
AGC036D
AGC036E
AGC036F
AGC037D
AGC037E
AGC037F
AGC038E
AGC038F
AGC039D
AGC039E
AGC039F
ARC089F
ARC091F
ARC092F
ARC093E
ARC093F
ARC095F
ARC096E
ARC096F
ARC097F
ARC098F
ARC099F
ARC100F
ARC101E
ARC101F
ARC102F
ARC103D
ARC103F

## CF 部分

### CF504E
<!-- {{{ -->
[{MDEXPAND Description
求树上两条路径的 LCP
}]
[{MDEXPAND Tutorial

直接二分哈希即可。由于是 CF 要写取模双哈希。。。

}]
<!-- }}} -->
### CF506C
<!-- {{{ -->
经典题，写过了。
<!-- }}} -->
### CF506E
<!-- {{{ -->
[{MDEXPAND Description
给定字符串 $s$，问插入 $n$ 个字符以后有多少个是回文串，对 $10^4 + 7$ 取模

$|s| \leq 200, n \leq 10^9$
}]
[{MDEXPAND Tutorial

显然有一个 $O(kn^2)$ 的 dp，然后把这个自动机拎出来发现如果之考虑转移的类型的话，本质不同路径只有 $O(n)$ 条，然后可以用一个大概 $\frac 32 n$ 个点的自动机表达，直接矩乘即可。

BM 应该也可以

}]
<!-- }}} -->
### CF512D
<!-- {{{ -->
[{MDEXPAND Description
给定一张 $n$ 个点 $m$ 条边的无向图。

一个点只有当与它直接相连的点中最多只有一个点未被选择过时才可被选择。

询问对于每个 $k \in [0,n]$，有序选择 $k$ 个点的方案数。

$n \le 100, m \le \frac{n(n-1)}2$ 
}]
[{MDEXPAND Tutorial

注意选择是依次进行的，不是一下子全选上。

不难发现选择一个点等价于删除一个叶子，然后就清晰很多了。环不可能被删，然后每棵树求出答案做背包即可。

注意一下细节。如果一棵树是接在环上的，那么我们直接钦定接在环上的那个点为根树型 dp 即可。对于一棵独立的无根树，无论钦定哪个点为根都有可能被删掉。我们可以把所有点都 dfs 一遍，然后发现一个取 $i$ 个点的方案会被算 $n-i$ 遍，直接除掉即可。

}]
<!-- }}} -->
### CF516D
<!-- {{{ -->
[{MDEXPAND Description
给定一棵 $n$ 个点的树，边有边权。

定义 $f(x) = \max_{i=1}^{n} \operatorname{dist}(x, i)$

$q$ 次询问最大的满足 $\max\_{x \in S} f(x) - \min\_{x \in S} f(x) \leq l$ 的联通块 $s$ 包含的点数。

$n \leq 10^5, q \leq 50$
}]
[{MDEXPAND Tutorail

注意到 $f(x)$ 是全局的与 $s$ 无关，所以可以先求出来。

然后变成区间联通块大小最大值，可以双指针 + LCT 随便搞搞。

还有一种更简单的做法，考虑以直径的中点为根，所有根到叶子的路径上 $f(x)$ 都是递增的。

然后我们发现加点的时候只可能 join 若干个儿子，删点的时候一定没有儿子在 $s$ 集合中。

用并查集维护即可。

}]
<!-- }}} -->
### CF516E
<!-- {{{ -->
[{MDEXPAND Description
有 $n$ 个男生 $m$ 个女生，编号分别为 $0 \sim n$ 和 $0 \sim m$

有 $b$ 个男生和 $g$ 个女生是快乐的，其他人是不快乐的。

在第 $i$ 天，编号为 $i \bmod n$ 的男生和编号为 $i \bmod m$ 的女生会一起玩（从第 0 天开始数起）

如果他们俩中有一个人是快乐的，则另一个人也会变快乐。

求至少要多少天所有人都会变快乐，或者判断不可能所有人都变快乐。

$n,m \leq 10^9, b,g  \leq 10^5$
}]
[{MDEXPAND Tutorial

令 $g = \gcd(n, m)$

若 $g \neq 1$，显然可以按模 $g$ 的余数分为 $g$ 组分别求答案。

下面假设 $n \geq m$

先把答案小于等于 $m$ 的情况判掉。

然后我们发现，只要所有男生都开心了，所有女生也都会开心。

考虑第 $k$ 个男生如何做出贡献，他会在 $k+m, k+2m, \cdots$ 的时候将 $k+m, k+2m, \cdots$ 变得开心。这样的关系构成了一个环，其中初始状态下一些点是开心的，然后会沿着边把它的后继结点变得开心。一个点变开心的时间就是最短路。

这个环的大小是 $10^9$ 级别的，但发现有用的点只有 $2n$ 个，于是直接跑多源最短路即可。
}]
<!-- }}} -->
### CF521D
<!-- {{{ -->
[{MDEXPAND Description
2800 greedy 两个 tag 让人看着脊背发凉

有 $k$ 个正整数 $a\_1 \cdots a\_k$ 

有 $n$ 个操作，每个操作给定正整数 $t, i, b$，有三种可能：

+ 如果 $t = 1$，这个操作是将 $a\_i$ 赋值为 $b$；
+ 如果 $t = 2$，这个操作是将 $a\_i$ 加上 $b$；
+ 如果 $t = 3$，这个操作是将 $a\_i$ 乘以 $b$。

你可以从 $n$ 个操作中选择最多 $m$ 个操作，并按照一定顺序执行。

你的目标是最大化它们的乘积。

$1 \leq k,n,m \leq 10^5, 1 \leq a\_i, b \leq 10^6$
}]
[{MDEXPAND Tutorial

首先对于每个位置，操作序列肯定是 0/1 个 1 操作，若干个 2 操作，若干个 3 操作。

如果只有 3 操作，显然直接贪心选前 $m$ 大即可。

对于 2 操作，由于我们可以确定在操作它之前那个数的值，所以也可以把他转化为乘法。

对于 1 操作，由于只进行一次，所以可以看成加法，再转为乘法。

注意如果写分数类的话比较的时候要么用 `double` 要么用 `__int128_t` 
}]
<!-- }}} -->
### CF521E
<!-- {{{ -->
[{MDEXPAND Description
给定一张 $n$ 个点 $m$ 条边的无向简单图。

问图中能否找到两个点，满足这两个点之间有至少三条完全不相交的简单路径。

$n,m \leq 2 \times 10^5$，图不保证连通。
}]
[{MDEXPAND Tutorial
先搜出一棵 dfs 树。

然后如果一条树边被两条非树边覆盖，那么就一定有答案，不难构造。

容易证明如果只是仙人掌的话一定没有答案。

做完了。
}]
<!-- }}} -->
### CF526F
<!-- {{{ -->
[{MDEXPAND Description
给定一个 $n \times n$ 的棋盘，其中有 $n$ 个棋子，每行每列恰好有一个棋子。

求有多少个 $k \times k$ 的子棋盘中恰好有 $k$ 个棋子。

$n \le 3 \times 10^5$
}]
[{MDEXPAND Tutorial
每行每列恰好有一个棋子这个性质比较关键。

对于一个 $k \times k$ 的矩形，它合法当且仅当它里面每行每列都有棋子。

我们对行跑扫描线，对于行的一个区间 $l,r$，只有在这个区间的棋子所在的列是连续的一段时才会对答案有 1 的贡献，否则没有贡献。

这就是一个很经典的问题了，线段树维护区间（联通块）数量即可。
}]
<!-- }}} -->
### CF526G
<!-- {{{ -->
[{MDEXPAND Description
给定一棵 $n$ 个节点的无根树，每条边有边权。

有 $q$ 次询问，每次询问给出 $x,y$，你需要选择 $y$ 条树上的路径，使这些路径形成一个包含 $x$ 的连通块，且连通块中包含的边权和最大。

$n, q \le 10^5$，强制在线。
}]
[{MDEXPAND Tutorial
选 $y$ 条路径等同与选 $2y$ 个叶子挖出他们的虚树。

发现直径的端点一定在答案中，所以一直径某个端点为根，进行长链剖分。在不考虑 $x$ 的情况下，不难证明长剖以后贪心选择就是对的。

考虑如何把 $x$ 放到答案中。此时我们要删掉一条路径，并把 $x$ 的长链以及 $x$ 往上的路径加入到答案中。一种情况是删掉当前最短链，还有一种情况是由于删掉以后还会把 $x$ 的长链接上，所以 $x$ 上方的第一条路径也有可能被删。
}]
<!-- }}} -->
### CF528C
<!-- {{{ -->
[{MDEXPAND Description
给定一张 $n$ 个点 $m$ 条边无向图。

你需要加尽可能少的边，然后给所有边定向，使得每一个点的出入度都是偶数。

边可以是自环，也可以有重边。

$n \leq 10^5, m \leq 2 \times 10^5$
}]
[{MDEXPAND Tutorial
先考虑答案的下界。首先每个点的度数必须为偶数，其次总边数也必须为偶数。

我们发现这样的图一定存在欧拉回路，如果根据奇偶性取反，就能满足每个点的出入度都为偶数。
}]
<!-- }}} -->
### CF536D
<!-- {{{ -->
[{MDEXPAND Description
给定一张 $n$ 个点 $m$ 条边的可能有自环和重边的无向连通图，每条边都有一个非负边权。

小 X 和小 Y 在这张图上玩一个游戏，在游戏中，第 $i$ 个城市有一个权值 $p\_i$。

一开始，小 X 在城市 $s$ 中，小 Y 在城市 $t$ 中，两人各有一个得分，初始为 0，小 X 为先手，然后轮流进行操作。

当轮到某一个人时，他必须选择一个非负整数 $x$，以选定所有与他所在的城市的最短距离不超过 $x$ 的还未被选定过的城市，他的得分将会加上这些城市的权值。

另外，每个人每次必须能够至少选定一个城市。

当没有人可以选择时，游戏结束，得分高者获胜。

现在请你计算出，在两人都使用最佳策略的情况下，谁会获胜（或者判断为平局）。

$n \le 2 \times 10^3, m \le 10^5, |p\_i| \le 10^9$
}]
[{MDEXPAND Tutorial
根据 dij 贪心的证明，我们可以先求出所有点到 $s$ 和 $t$ 的距离并排序，每次操作就等价于在这个序列上选择一个前缀并占领。

注意到 $n$ 不大，所以离散化以后可以直接 dp，后缀 min 优化以后可以做到 $O(n^2)$
}]
<!-- }}} -->
### CF538G
<!-- {{{ -->
[{MDEXPAND Description
有一个机器人，第 $0$ 秒时在 $(0,0)$ 位置。

机器人会循环执行一个长度为 $l$ 的指令序列，每秒执行一个指令。

指令有 ULDR 四种，分别代表向上/左/下/右移动一格。

你不知道这个指令序列具体是什么，但是你知道 $n$ 条信息，第 $i$ 条信息为「第 $t\_i$ 秒时机器人在 $(x\_i,y\_i)$」，保证 $t$ 递增。

你需要构造一个满足这些信息的指令序列，或判断不存在。

$n \leq 2 \times 10^5, l \leq 2 \times 10^6$
}]
[{MDEXPAND Tutorial
考虑曼哈顿转切比雪夫的那个 trick，将所有点旋转 45 度然后乘上 $\sqrt{2}$，也就是 $(x,y)$ 变成 $(x + y, x - y)$。这样指令变成了 $\{ (1,1), (1,-1), (-1,1), (-1,-1) \}$，两维就可以独立计算。

对于一维的情况，设一轮以后往右走了 $k$，那么所有信息按照 $t\_i \mod l$ 排序以后相邻的两个之间会对 $k$ 有一个限制。这些限制取交即可。
}]
<!-- }}} -->
### CF538H
<!-- {{{ -->
[{MDEXPAND Description
有 $T$ 名学生，你要从中选出至少 $t$ 人，并将选出的人分成两组，可以有某一组是空的。

有 $n$ 名老师，每名老师要被分配到两个小组之一，对于第 $i$ 名老师，要求所在的小组中的学生人数 $\in [l\_i, r\_i]$

此外，有 $m$ 对老师不能在同一个小组中。

你需要判断能否满足所有要求，如果可以，请给出一种方案。

$n,m \leq 10^5, T \leq 10^9$
}]
[{MDEXPAND Tutorial

把所有的互斥关系建成一张图，对于每个联通块，如果可以黑白染色，那么显然可以将同色的点取交以后缩成一个点，把联通块缩成两个点。如果不能黑白染色，显然无解。

然后我们枚举第一组的人数，并且钦定第二组人数大于第一组。

对于一对互斥的区间（老师），如果他们都能放在第一组，那么我们把右端点小的那个放在第一组，大的放在第二组。在上面的假设下，这么选一定不劣。

先离散化然后拿个 set 动态维护就好了。

}]
<!-- }}} -->
### CF547D
<!-- {{{ -->
[{MDEXPAND Description
给定 $n$ 个整点。

你要给每个点染成红色或蓝色。

要求同一水平线或垂直线上两种颜色的数量最多相差 1。

$n \leq 2 \times 10^5$
}]
[{MDEXPAND Tutorial
做法 1：行列建点，所有奇度点向一个超级点连边，然后跑欧拉回路即可。

做法 2：每行每列两两匹配连边（奇数就扔掉一个点），这样连出来的必然是二分图，黑白染色即可。
}]
<!-- }}} -->
### CF547E
<!-- {{{ -->
[{MDEXPAND Description
给定 $n$ 个字符串 $s_{1 \dots n}$

$q$ 次询问 $s\_k$ 在 $s_{l \dots r}$ 中出现了多少次。

$n, \sum |s| \le 2 \times 10^5, q \le 5 \times 10^5$
}]
[{MDEXPAND Tutorial
经典题，AC 自动机或者广义 SAM 线段树合并即可
}]
<!-- }}} -->
### CF549E

[{MDEXPAND Description
$n+m$ 个整点。

询问是否存在一个圆将前 $n$ 个点和后 $m$ 个点严格分开。

$n,|x|,|y| \le 10^4$
}]
[{MDEXPAND Tutorial
首先一个结论是整点凸包的点数只有 $O(w^\frac 23)$，然后这个数据范围就合理了。

把所有的点投影到 $z = x^2 + y^2$ 的抛物面上，然后问题变成找一个平面把两堆点分开。

考虑在圆内的那个点集，我们要求的就是一个三维凸包的上凸壳，本质上是原先点集凸包的某个三角剖分。

假如我们求出了三角剖分上的某条边，那么可以 $O(n)$ check 如果圆和这两个点相接时是否存在答案。

然后问题就变成了如何合理地求出三角剖分。观察到每个三角型的外接圆都能包括所有的点。于是先随便选取凸包上的一条边，找到外接圆半径最大的那个点（显然这三个点的外接圆包含所有的点），check 这个三角型后分别向两边递归即可。
}]

CF553E
CF555E
CF559E
CF566C
CF566E
CF568C
CF568E
CF571D
CF571E
CF573E
CF575A
CF575E
CF575I
CF576D
CF576E
CF578E
CF578F
CF582D
CF582E
CF585E
CF585F
CF587D
CF587F
CF590E
CF594E
CF603E
CF605E
CF607E
CF611G
CF611H
CF613E
CF626G
CF627F
CF634F
CF639E
CF639F
CF666D
CF666E
CF671D
CF671E
CF674D
CF674F
CF674G
CF679E
CF685C
CF696F
CF698D
CF700E
CF704B
CF704C
CF704D
CF704E
CF708D
CF708E


<script>
  let totSolved = document.getElementsByTagName("h3").length;
  document.getElementById("fill-tot-solved").innerText = totSolved;
</script>

