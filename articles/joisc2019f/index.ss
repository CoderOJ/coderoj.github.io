($article
  ((title . "JOISC 2019 Two Transportations")
   (tag Tutorial cps))

  (h1 JOISC 2019 Two Transportations)

  LOJ 上没有的通信题，可以在 ,($link "https://atcoder.jp/contests/joisc2019/tasks/joisc2019_f" AT) 上找到。

  (h2 Description)
  (p 给定一张 n 个点 m 条边的无向图，每条边有边权和种类（两种）。Alice 知道所有第一种边，Bob 知道所有第二种边。求单源最短路。任意通信。)
  (p `$n \leq 2000, m \leq 10^6$` ，总发送的比特数不超过 58000。)

  (h2 Tutorial)
  (p 使用 dijkstra 算法。)
  (p 朴素的做法是直接维护 dis，每次更新的时候把所有要更新的都互相传一下。由于更新次数是 `$O(m)$` 级别的，不能获得什么分数。)
  (p 考虑只在每次 pop 出最小的未增广点时，在两个人之间同步这个点的距离信息。不难归纳证明这样的正确性。)
  (p 具体的，每轮前两个人分别向对方发 9 个比特表示当前 pop 出来的点的距离比上一次增广大多少（这样可以把这个信息的值域压缩到边权最大值而非边权最大值乘点数）。
     接下来小的那个人发送给对方 11 个比特表示那个点的标号。
     一轮一共发送 29 个比特，正好 58000。)

  (hr)
  (p 然而这些不是重点。)
  (p 如果这是一道两个进程同时运行的 io 通信题，那么一切都做完了。)
  (p 但是打开这道题的 grader 一看，它需要你实现两个这样的函数 (code `void Receive(bool b)`)。)
  (p 如果你对此感到奇怪，那么可以看看这么实现以后交互库只需要干什么：)

  ,($code cpp 
```
while (true) {
  if (!qx.empty()) {
    ReceiveA(qx.front());
    qx.pop();
  } else if (!qy.empty()) {
    ReceiveB(qy.front());
    qy.pop();
  } else {
    break;
  }
}
```)

  (p (del 是不是觉得合理起来了。))
  (p 这相当于要我们实现同一个进程里的异步通信。)
  (p 一个直接的做法是在 (code Receive) 函数里维护一个状态机，但这非常丑陋。)
  (p 这时一个叫 (strong continuation) 的东西就很有用。)

  (p 具体来说，本来我们希望这样：)
  ,($code cpp
```
bool receive()
{
  bool b = ...;
  return b;
}

bool b = receive();
// ...
```)

  (p 把他转换为 continuation 的形式后：)
  ,($code cpp
```
[[noreturn]] void receive(std::function<void(bool)> &&k)
{
  bool b = ...;
  k(b);
}

receive([](bool b) {
  // ...
})
```)

  (p 乍一看觉得这样没什么用，但是第二种写法的好处在于，(code k) 这个函数它不一定要被立即调用，它可以被存下来到合适的时候调用。)
  (p 这相当于一个函数可以执行到一半停下来，类似 generator 的感觉。)
  (p 借助 continuation，一个漂亮的 (code receiver) 可以长这样：)

  ,($code cpp
```
template <class T>
struct receiver
{
  using rec_k = std::function<void(T)>;
  std::queue<rec_k, std::list<rec_k>> rec_que;

  void send(T v)
  {
    auto f = std::move(rec_que.front());
    rec_que.pop();
    f(std::move(v));
  }

  template <class K>
  void get(K &&k)
  {
    rec_que.emplace(std::forward<K>(k));
  }
};

receiver<bool> ra, rb;
void ReceiveA(bool b)
{
  ra.send(b);
}
void ReceiveB(bool b)
{
  rb.send(b);
}
```)

  (p 虽然在这题中，(code rec_que) 中最多只有一个函数，但是在一般场景下，这个队列是有意义的。)

  (p 同样使用 continuation 的方式，接收多个比特可以这么写：)
  ,($code cpp
```
template <class K>
void receive_bits(receiver<bool> &r, int c, K &&k, int x = 0)
{
  if (c == 0)
    k(x);
  else
  {
    r.get([=, &r, k = std::forward<K>(k)](bool b) mutable {
      receive_bits(r, c - 1, std::forward<K>(k), x * 2 + static_cast<int>(b));
    });
  }
}
```)

  (p 注意在一般定义下，continuation 只会被调用一次，而 continuation 本身有可能有一个很大的闭包 （那里存着相当于整个调用栈的信息）。
     所以需要谨慎地用移动语义处理好 continuation 传递的问题。)

  (p 接下来要做的就是把整个 dijkstra 的过程用 continuation style 写出来就行了。
     循环在 continuation style 下是一个不直观的东西，需要写成 (code receive_bits) 一样的函数调用。)

  ,($code cpp
```
template <class Sender, class Cmp, class K>
void solve(graph_t g, receiver<bool> &r, Sender s, Cmp c, K &&k, int round = 0)
{
  if (round == g.n)
  {
    k(std::move(g.dis));
  }
  else
  {
    const auto t = g.top();
    int ud = t.first - g.last_dis, u = t.second;
    send_bits(s, ud, 9);
    receive_bits(r, 9, [=, g = std::move(g), k = std::forward<K>(k), &r](int vd) mutable {
      if (c(ud, vd))
      {
        send_bits(s, u, 11);
        g.extend(u, g.last_dis + ud);
        solve(std::move(g), r, s, c, std::forward<K>(k), round + 1);
      }
      else
      {
        receive_bits(r, 11, [=, g = std::move(g), k = std::forward<K>(k), &r](int v) mutable {
          g.extend(v, g.last_dis + vd);
          solve(std::move(g), r, s, c, std::forward<K>(k), round + 1);
        });
      }
    });
  }
}
```)

  (details
    (summary 完整代码)
    ,($code cpp
; {{{
```
#include "transportations.h"
#include <algorithm>
#include <functional>
#include <limits>
#include <list>
#include <queue>
#include <string>
#include <vector>

template <class T>
struct receiver
{
  using rec_k = std::function<void(T)>;
  std::queue<rec_k, std::list<rec_k>> rec_que;

  void send(T v)
  {
    auto f = std::move(rec_que.front());
    rec_que.pop();
    f(std::move(v));
  }

  template <class K>
  void get(K &&k)
  {
    rec_que.emplace(std::forward<K>(k));
  }
};

receiver<bool> ra, rb;

void ReceiveA(bool b)
{
  ra.send(b);
}
void ReceiveB(bool b)
{
  rb.send(b);
}

struct graph_t
{
  struct edge_t
  {
    int v, w;
  };

  int n, m;

  std::vector<std::basic_string<edge_t>> e;

  std::vector<bool> vis;
  std::vector<int>  dis;
  std::priority_queue<std::pair<int, int>,
                      std::vector<std::pair<int, int>>,
                      std::greater<std::pair<int, int>>>
      que;
  int last_dis;

  graph_t(int n, int m) :
      n(n), m(m), e(n), vis(n, false), dis(n, std::numeric_limits<int>::max())
  {
    dis[0] = 0;
    que.emplace(0, 0);
    last_dis = 0;
  }

  graph_t(const graph_t &)
  {
    abort();
  }
  graph_t(graph_t &&) = default;

  void extend(int u, int d)
  {
    vis[u]   = true;
    dis[u]   = d;
    last_dis = d;
    for (const auto &[v, w] : e[u])
      if (d + w < dis[v])
      {
        dis[v] = d + w;
        que.emplace(dis[v], v);
      }
  }

  std::pair<int, int> top()
  {
    while (!que.empty())
    {
      auto u = que.top();
      if (u.first == dis[u.second] && !vis[u.second])
        return u;
      que.pop();
    }
    return {last_dis + 501, -1};
  }

  void add_edge(int u, int v, int w)
  {
    e[u] += {v, w};
    e[v] += {u, w};
  }
};

template <class K>
void receive_bits(receiver<bool> &r, int c, K &&k, int x = 0)
{
  if (c == 0)
    k(x);
  else
  {
    r.get([=, &r, k = std::forward<K>(k)](bool b) mutable {
      receive_bits(r, c - 1, std::forward<K>(k), x * 2 + static_cast<int>(b));
    });
  }
}

template <class F>
void send_bits(F f, int v, int c)
{
  for (int i = c - 1; i >= 0; i--)
  {
    bool b = static_cast<bool>(v & (1 << i));
    f(b);
  }
}

template <class Sender, class Cmp, class K>
void solve(graph_t g, receiver<bool> &r, Sender s, Cmp c, K &&k, int round = 0)
{
  if (round == g.n)
  {
    k(std::move(g.dis));
  }
  else
  {
    // clang-format off
    const auto t = g.top();
    int ud = t.first - g.last_dis, u = t.second;
    send_bits(s, ud, 9);
    receive_bits(r, 9, [=, g = std::move(g), k = std::forward<K>(k), &r](int vd) mutable {
      if (c(ud, vd))
      {
        send_bits(s, u, 11);
        g.extend(u, g.last_dis + ud);
        solve(std::move(g), r, s, c, std::forward<K>(k), round + 1);
      }
      else
      {
        receive_bits(r, 11, [=, g = std::move(g), k = std::forward<K>(k), &r](int v) mutable {
          g.extend(v, g.last_dis + vd);
          solve(std::move(g), r, s, c, std::forward<K>(k), round + 1);
        });
      }
    });
    // clang-format on
  }
}

std::vector<int> answer;
std::vector<int> Answer()
{
  return std::move(answer);
}

void InitA(
    int N, int A, std::vector<int> U, std::vector<int> V, std::vector<int> C)
{
  graph_t g(N, A);
  for (int i = 0; i < A; i++)
    g.add_edge(U[i], V[i], C[i]);

  solve(
      std::move(g),
      ra,
      [](bool b) { SendA(b); },
      std::less_equal<int>(),
      [](std::vector<int> ans) { answer = std::move(ans); });
}

void InitB(
    int N, int B, std::vector<int> S, std::vector<int> T, std::vector<int> D)
{
  graph_t g(N, B);
  for (int i = 0; i < B; i++)
    g.add_edge(S[i], T[i], D[i]);

  solve(
      std::move(g),
      rb,
      [](bool b) { SendB(b); },
      std::less<int>(),
      [](const std::vector<int> &) {});
}
```
; }}}
    ))

  (hr)

  (p 上述的 (code receive_bits) 函数必须写成尾递归的形式，而不能（看上去更好看地）写成这样：)

  ,($code cpp
```
template <class K>
void receive_bits(receiver<bool> &r, int c, K &&k)
{
  if (c == 0)
    k(0);
  else
  {
    receive_bits(r, c - 1, [=, &r, k = std::forward<K>(k)](int x) mutable {
      r.get([=, &r, k = std::forward<K>(k)](bool b) mutable {
        k(x * 2 + static_cast<int>(b));
      });
    });
  }
}
```)

  (p 原因是虽然 (code k) 一直是一个 (code `void(int)`) 的函数，
     但对于任意类型 (code K)，递归时新的 continuation 是一个闭包类型与 (code K) 不同的函数，
     而这个新的类型又会触发 (code receive_bits) 的特化，导致模板特化死递归。)
  (p 一种解决方法是用多态的 (code std::function<void(int)>) 代替模板，但这样会导致效率降低。)
  (p 还有一种解决方法是把 (code c) 变为模板参数并使用 (code if constexpr)，这样特化 c 次以后就会终止。
     但这样不适用于 c 很大或者 c 编译时未知的情况。)

)
