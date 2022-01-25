($article
  ((tag LCT) (title . "LCT 入门教程"))
  ((h2 (id . "%E7%AE%80%E4%BB%8B")) "简介")
  (ul
   (li
    (p
     "Link/Cut Tree 是一种数据结构，可以在单次操作均摊 $O(\\log n)$ 内解决"
     (strong "动态树问题")
     "，并在大多数题目中复杂度吊打树链剖分。"))
   (li (p "Splay 是 LCT 的基础，但是 LCT ⽤的 Splay 和普通的 Splay 在细节处不太一样（进行了一些扩展）。"))
   (li "Link/Cut Tree 的复杂度证明略有难度，建议初学时跳过复杂度证明。"))
  ((h2 (id . "%E9%97%AE%E9%A2%98%E6%A8%A1%E5%9E%8B")) "问题模型")
  (p "Link/Cut Tree 能够维护一个" (strong "森林") ", 支持一下操作")
  (ul
   (li "删除某条边，并保证操作后仍是森林")
   (li "加⼊某条边，并保证操作后仍是森林")
   (li "对于" (strong "某个结点") "或者" (strong "某条链") "进行修改")
   (li
    "查询"
    (strong "某个结点")
    "，"
    (strong "某条链")
    "或者"
    (strong "指定某个点为根时的某个子树")
    "的信息。"))
  ((h2 (id . "%E5%9F%BA%E7%A1%80-lct")) "基础 LCT")
  ((h3 (id . "%E5%AE%9E%E9%93%BE%E5%89%96%E5%88%86")) "实链剖分")
  (p "回顾一下树链剖分的过程，我们本质上进行了如下的操作：")
  (ul
   (li "对整棵树按子树⼤小进⾏剖分，并重新标号")
   (li "重新标号之后，树上形成了若干以链为单位的连续区间，于是可以用线段树等数据结构进⾏区间操作"))
  (p
   "转向动态树问题，我们发现树链剖分以子树⼤小作为划分条件，然而在动态树问题中，子树大小会动态变化，静态的划分无法保证复杂度。\n"
   "此需要重新定义一种新的链划分方式——实链剖分，要求能够根据需求自由切换。")
  (p
   "对于⼀个点连向它所有儿子的边 , 我们自行选择⼀条边为实边，其他边则为虚边。\n"
   "对于实边，我们称它所连接的儿子为实儿子。\n"
   "对于⼀条由实边组成的链，我们同样称之为实链。")
  (p "选择实链剖分的最重要的原因：它是我们选择的，灵活且可变。\n" "正是它的这种灵活可变性，我们采用 Splay Tree 来维护这些实链。")
  ((h3 (id . "%E8%BE%85%E5%8A%A9%E6%A0%91")) "辅助树")
  (p
   "我们可以简单的把 LCT 理解成用⼀些 Splay 来维护动态的树链剖分，以期实现动态树上的区间操作。\n"
   "对于每条实链，我们建⼀个 Splay 来维护整个链区间的信息。")
  (p "我们先来看⼀看辅助树的一些性质")
  (ul
   (li "原树每个节点与 Splay 的节点一一对应。")
   (li "辅助树由多棵 Splay 组成，每棵 Splay 维护原树中的一条链，且该 Splay 的中序遍历满足结点深度递。")
   (li
    "辅助树的各棵 Splay 之间并不是独立的。对于每棵 Splay 的根结点，如果该结点对应原树的根，则该结点的父亲为空，否则为该 Splay 对应实中最浅的结点在原树上的父亲，这条边对应原树的一条"
    (strong "虚边")
    "。因此，每棵树恰好有一个点的父亲节点为空。")
   (li "由于辅助树的以上性质，我们维护任何操作都不需要维护原树，辅助树在任何情况下都能唯一确定原树，我们只需要维护辅助树即可。"))
  (p (strong "注意") "：原树的根可能不是辅助树的根。")
  (p "一个辅助树的例子：")
  (p "如图，现在有⼀棵原树，加粗边是实边，虚线边是虚边。")
  (p ((img (src . "./lct9.png") (alt . ""))))
  (p "由刚刚的定义，一棵可能的辅助树结构如下")
  (p ((img (src . "./lct10.png") (alt . ""))))
  (p "辅助树有如下性质：")
  (ul
   (li "原树中的某条实链上的点，在辅助树中对应节点都在一棵 Splay 中。")
   (li "辅助树是可以在满足辅助树、Splay 的性质下任意换根的。")
   (li "虚实链变换可以轻松在辅助树上完成，这也就实现了动态维护树链剖分。"))
  ((h3 (id . "%E6%93%8D%E4%BD%9C%E5%AE%9E%E7%8E%B0")) "操作实现")
  ((h4 (id . "%E7%BB%93%E7%82%B9%E5%AE%9A%E4%B9%89")) "结点定义")
  (pre
   ((code (class . "lang-cpp"))
    "struct LCTNode {\n"
    " LCTNode *f = nullptr;\n"
    " LCTNode *s[2] = {nullptr, nullptr};\n"
    " bool rev = false;\n"
    " /* ... */\n"
    "};\n"))
  (p "具体的解释：")
  (ul
   (li (code "f") ": 其在 Spaly 上的父亲")
   (li
    (code "s")
    ":"
    (code "s[0]")
    "代表该结点在 Splay 上的左儿子，"
    (code "s[1]")
    "代表右儿子")
   (li (code "rev") ": 子树翻转标记"))
  (p "根据维护的操作种类，我们可能还需要记录一些其他信息。")
  ((h4
    (id
     .
     "%E5%92%8C%E6%99%AE%E9%80%9A-splay-%E7%9B%B8%E5%90%8C%E7%9A%84%E9%83%A8%E5%88%86"))
   "和普通 Splay 相同的部分")
  (pre
   ((code (class . "lang-cpp"))
    "struct LCTNode  {\n"
    " void update();\n"
    " void push_up();\n"
    " void push_down();\n"
    " void reverse();\n"
    " void rotate();\n"
    " void splay();\n"
    "};\n"))
  (p "一些注意点：")
  (ul
   (li
    "进行"
    (code "rotate")
    "的时候如果一个点连向父亲的便是虚边，不能更新该结点父亲的儿子信息（因为两者实际上并不在一棵 Splay 中）。")
   (li
    "在普通 Splay 中，我们需要从根往下走才能定位某个结点，在这个过程中完成了"
    (code "push_down")
    "操作。但在 LCT 中，一个结点是直接通过在原树中的编号确定的，所以在实现"
    (code "splay")
    "的时候要先将该点所有的祖先"
    (code "push_down")
    "。"))
  ((h4 (id . "%E6%96%B0%E6%93%8D%E4%BD%9C")) "新操作")
  (pre
   ((code (class . "lang-cpp"))
    "struct LCTNode {\n"
    " void access();\n"
    " void make_root();\n"
    " LCTNode *find_root();\n"
    "};\n"
    "void link(LCTNode *u, LCTNode *v);\n"
    "void split(LCTNode *u, LCTNode *v);\n"
    "void split(LCTNode *u, LCTNode *v);\n"))
  ((h5 (id . "access")) "access")
  (p (code "access") "的功能是将该结点到根上的所有边变为实边，并将这个点的所有儿子变为虚儿子 。")
  (p "假设我们有这样一棵树，实线为实边，虚线为虚边。")
  (p ((img (src . "./lct1.png") (alt . ""))))
  (p "它的辅助树可能长成这样，每个绿框里是一棵 Splay。")
  (p ((img (src . "./lct2.png") (alt . ""))))
  (p "现在我们要进行" (code "N->access()") ", 把 $A$ 到 $N$ 路径上的边都变为实边，拉成一棵 Splay。")
  (p ((img (src . "./lct3.png") (alt . ""))))
  (p "实现的方法是从下到上逐步更新 Splay。")
  (p "首先我们要把 $N$ 旋至当前 Splay 的根。")
  (p "为了保证辅助树的性质，原来 $N$ 到 $O$ 的实边要更改为虚边。")
  (p "由于认父不认子的性质，我们可以单方面的把 $N$ 的儿子改为空。")
  (p "于是原来的辅助树就从下图变成了下下图。")
  (p ((img (src . "./lct4.png") (alt . ""))))
  (p ((img (src . "./lct5.png") (alt . ""))))
  (p "下一步，我们把 $N$ 的父亲 $I$ 也旋转到根。")
  (p "原来的实边 $I \\to K$ 要去掉，这时候我们把 $I$ 的右儿子指向 $N$, 就得到了 $I$—$L$ 这样一棵 Splay。")
  (p ((img (src . "./lct8.png") (alt . ""))))
  (p
   "接下来，按照刚刚的操作步骤，由于 $I$ 的父亲为 $H$, 我们把 $H$ 旋转到他所在 Splay 的根，然后把 $H$ 的"
   (strong "右儿子")
   "设为 $I$。")
  (p "之后的树是这样的：")
  (p ((img (src . "./lct6.png") (alt . ""))))
  (p "同理我们将 A 旋转到根， 并把 $A$ 的右儿子指向 $H$。")
  (p "于是我们得到了这样一棵辅助树。并且发现 $A \\to N$ 的整个路径已经在同一棵 Splay 中了。大功告成！")
  (p ((img (src . "./lct7.png") (alt . ""))))
  (p "代码实现：")
  (pre
   ((code (class . "lang-cpp"))
    "void LCTNode::access() {\n"
    " Node *uu = this, *ss = nullptr;\n"
    " while (uu != nullptr) {\n"
    "   uu->splay();\n"
    "   uu->s[1] = ss;\n"
    "   uu->push_up();\n"
    "   ss = uu;\n"
    "   uu = uu->f;\n"
    " }\n"
    "}\n"))
  (p "总结一下，我们发现" (code "access") "有如下四步操作：")
  (ol
   (li "把当前节点转到根")
   (li "把儿子换成之前的节点")
   (li "更新当前点的信息")
   (li "把当前点换成当前点的父亲，继续操作"))
  ((h5 (id . "make-root")) "make_root")
  (p
   "我们在需要维护路径信息的时候，会出现路径深度无法严格递增的情况。根据辅助树的的性质，这种路径是不能出现在一棵 Splay 中的。因此，我们需要一种操作，将一个点变成原树的根。")
  (p
   "考虑一次换根做了什么，假设原先根为 $R$，当前结点为 $U$，我们需要将 $R \\to U$ 的路径翻转，变为 $U \\to R$。因此我们只需要将 $U$ 结点"
   (code "access")
   "，然后将这棵 Splay 翻转。")
  (p "代码实现：")
  (pre
   ((code (class . "lang-cpp"))
    "void LCTNode::make_root() {\n"
    " access();\n"
    " splay();\n"
    " reverse();\n"
    "}\n"))
  ((h5 (id . "find-root")) "find_root")
  (p (code "find_root") "返回一个森林的根，常用于判断两个点是否属于同一联通块。")
  (p
   "将该点"
   (code "access")
   "、"
   (code "splay")
   "后，该联通块的根即为 Splay 中最左侧的点，直接不断往搜索走即可。")
  (p "注意这里在大部分情况下不需要" (code "push_down") "，如果为了保险起见也可以写上。")
  (p "注意找到根以后需要将根" (code "splay") "以保证复杂度。")
  (p "代码实现：")
  (pre
   ((code (class . "lang-cpp"))
    "LCTNode *LCTNode::find_root() {\n"
    " access();\n"
    " splay();\n"
    " LCTNode *uu = this;\n"
    " uu->push_down();\n"
    " while (uu->s[0] != nullptr) {\n"
    "   uu = uu->s[0];\n"
    "   uu->push_down();\n"
    " }\n"
    " uu->splay();\n"
    " return uu;\n"
    "}\n"))
  ((h5 (id . "link")) "link")
  (p (code "link") "操作将原树上的两个点之间加边（虚边）")
  (p "做法非常显然，先将一个点变为根，然后将其的父亲设为另一个结点。")
  (p "代码实现：")
  (pre
   ((code (class . "lang-cpp"))
    "void link(LCTNode *u, LCTNode *v) {\n"
    " u->make_root();\n"
    " u->f = v;\n"
    "}\n"))
  ((h5 (id . "split")) "split")
  (p (code "split") "操作将两点之间的路径提取出来，便于查询。")
  (p
   "先将其中的一个点"
   (code "make_root")
   "，这样这条路径的深度严格递增。将另外一个点"
   (code "access")
   "再"
   (code "splay")
   "，这样这个点上的信息就是该路径的信息")
  (p "代码实现：")
  (pre
   ((code (class . "lang-cpp"))
    "void split(LCTNode *u, LCTNode *v) {\n"
    " u->make_root();\n"
    " v->access();\n"
    " v->splay();\n"
    "}\n"))
  ((h5 (id . "cut")) "cut")
  (p "断边操作有两种情况，保证合法和不一定保证合法。")
  (p "如果保证合法，那么直接将这两个点" (code "split") "出来，此时这两个点之间连的是实边，直接在 Splay 上切断即可。")
  (p "保证合法的代码实现：")
  (pre
   ((code (class . "lang-cpp"))
    "void cut(LCTNode *u, LCTNode *v) {\n"
    " split(u, v);\n"
    " v->s[0] = u->f = nullptr;\n"
    " v->push_up();\n"
    "}\n"))
  (p "如果是不保证合法，我们需要判断一下两个点之间是否有边。判断的条件为：")
  (ul (li "两个点在同一个联通块内") (li "两个点的距离为 1"))
  (p "判断距离可以直接看 Splay 的大小。")
  (p "不保证合法的代码实现：")
  (pre
   ((code (class . "lang-cpp"))
    "void cut(LCTNode *u, LCTNode *v) {\n"
    " if (u->find_root() != v->find_root())\n"
    "   throw std::invalid_argument(\"u is not directly connected with v!\");\n"
    " split(u, v);\n"
    " if (v->s[1] != nullptr ||\n"
    "     u->s[0] != nullptr ||\n"
    "     u->s[1] != nullptr)\n"
    "   throw std::invalid_argument(\"u is not directly connected with v!\");\n"
    " v->s[0] = u->f = nullptr;\n"
    " v->push_up();\n"
    "}\n"))
  ((h4
    (id
     .
     "%E5%AE%8C%E6%95%B4%E5%AE%9E%E7%8E%B0%EF%BC%88%E4%BB%A5%E7%BB%B4%E6%8A%A4%E9%93%BE%E5%BC%82%E6%88%96%E5%92%8C%E4%B8%BA%E4%BE%8B%EF%BC%89"))
   "完整实现（以维护链异或和为例）")
  (pre
   ((code (class . "lang-cpp"))
    "// Copyright (C) 2018-2020 Jacder Zhang\n"
    "// This program is free software: you can redistribute it and/or modify\n"
    "// it under the terms of the GNU General Public License as published by\n"
    "// the Free Software Foundation, either version 3 of the License, or\n"
    "// (at your option) any later version.\n"
    "// This program is distributed in the hope that it will be useful,\n"
    "// but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
    "// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
    "// GNU General Public License for more details.\n"
    "// You should have received a copy of the GNU General Public License\n"
    "// along with this program. If not, see <https://www.gnu.org/licenses/>.\n"
    "#include <bits/stdc++.h>\n"
    "struct LCTNode {\n"
    " LCTNode *f = nullptr;\n"
    " LCTNode *s[2] = {nullptr, nullptr};\n"
    " bool rev = false;\n"
    " int val = 0, sum = 0;\n"
    " bool is_root();\n"
    " bool get_son();\n"
    " void push_up();\n"
    " void reverse();\n"
    " void push_down();\n"
    " void push();\n"
    " void rotate();\n"
    " void splay();\n"
    " void access();\n"
    " void make_root();\n"
    " LCTNode *find_root();\n"
    "};\n"
    "bool LCTNode::is_root() {\n"
    " return f == nullptr || \n"
    "        (f->s[0] != this && f->s[1] != this);\n"
    "}\n"
    "bool LCTNode::get_son() {\n"
    " return this == f->s[1];\n"
    "}\n"
    "void LCTNode::push_up() {\n"
    " sum = val;\n"
    " if (s[0] != nullptr) sum ^= s[0]->sum;\n"
    " if (s[1] != nullptr) sum ^= s[1]->sum;\n"
    "}\n"
    "void LCTNode::reverse() {\n"
    " rev = !rev;\n"
    " std::swap(s[0], s[1]);\n"
    "}\n"
    "void LCTNode::push_down() {\n"
    " if (rev) {\n"
    "   if (s[0] != nullptr) s[0]->reverse();\n"
    "   if (s[1] != nullptr) s[1]->reverse();\n"
    "   rev = false;\n"
    " }\n"
    "}\n"
    "void LCTNode::push() {\n"
    " if (!is_root()) f->push();\n"
    " push_down();\n"
    "}\n"
    "void LCTNode::rotate() {\n"
    " LCTNode *const uu=this, *ff=f, *aa=ff->f;\n"
    " bool ss = uu->get_son();\n"
    " if (!ff->is_root()) aa->s[ff->get_son()] = uu;\n"
    " ff->f = uu, ff->s[ss] = uu->s[!ss];\n"
    " uu->f = aa; uu->s[!ss] = ff;\n"
    " if (ff->s[ss] != nullptr) ff->s[ss]->f = ff;\n"
    " ff->push_up(), uu->push_up(); \n"
    "}\n"
    "void LCTNode::splay() {\n"
    " push();\n"
    " while (!is_root()) {\n"
    "   if (f->is_root()) {\n"
    "     rotate();\n"
    "     return;\n"
    "   }\n"
    "   (get_son() == f->get_son() ? f : this)->rotate();\n"
    "   rotate(); \n"
    " }\n"
    "}\n"
    "void LCTNode::access() {\n"
    " LCTNode *uu = this, *ss = nullptr;\n"
    " while (uu != nullptr) {\n"
    "   uu->splay();\n"
    "   uu->s[1] = ss;\n"
    "   uu->push_up();\n"
    "   ss = uu;\n"
    "   uu = uu->f;\n"
    " }\n"
    "}\n"
    "void LCTNode::make_root() {\n"
    " access();\n"
    " splay();\n"
    " reverse();\n"
    "}\n"
    "LCTNode *LCTNode::find_root() {\n"
    " access();\n"
    " splay();\n"
    " LCTNode *uu = this;\n"
    " uu->push_down();\n"
    " while (uu->s[0] != nullptr) {\n"
    "   uu = uu->s[0];\n"
    "   uu->push_down();\n"
    " }\n"
    " uu->splay();\n"
    " return uu;\n"
    "}\n"
    "void link(LCTNode *const u, LCTNode *const v) {\n"
    " if (u->find_root() == v->find_root())\n"
    "   throw std::invalid_argument(\"u and v are already connected\");\n"
    " u->make_root();\n"
    " u->splay();\n"
    " u->f = v;\n"
    "}\n"
    "void split(LCTNode *const u, LCTNode *const v) {\n"
    " u->make_root();\n"
    " v->access();\n"
    " v->splay();\n"
    "}\n"
    "void cut(LCTNode *u, LCTNode *v) {\n"
    " if (u->find_root() != v->find_root())\n"
    "   throw std::invalid_argument(\"u is not directly connected with v!\");\n"
    " split(u, v);\n"
    " if (v->s[1] != nullptr ||\n"
    "     u->s[0] != nullptr ||\n"
    "     u->s[1] != nullptr)\n"
    "   throw std::invalid_argument(\"u is not directly connected with v!\");\n"
    " v->s[0] = u->f = nullptr;\n"
    " v->push_up();\n"
    "}\n"
    "constexpr int N = 100005;\n"
    "LCTNode p[N];\n"
    "int main() {\n"
    " int n, m;\n"
    " scanf(\"%d%d\", &n, &m);\n"
    " for (int i=1; i<=n; ++i) {\n"
    "   scanf(\"%d\", &p[i].val);\n"
    " }\n"
    " for (int i = 0; i < m; ++i) {\n"
    "   int opt, u, v;\n"
    "   scanf(\"%d%d%d\", &opt, &u, &v);\n"
    "   if (opt == 0) {\n"
    "     split(&p[u], &p[v]);\n"
    "     printf(\"%d\\n\", p[v].sum);\n"
    "   } else if (opt == 1) {\n"
    "     try {\n"
    "       link(&p[u], &p[v]);\n"
    "     } catch (...) {}\n"
    "   } else if (opt == 2) {\n"
    "     try {\n"
    "       cut(&p[u], &p[v]); \n"
    "     } catch (...) {}\n"
    "   } else {\n"
    "     p[u].splay();\n"
    "     p[u].val = v;\n"
    "     p[u].push_up();\n"
    "   }\n"
    " }\n"
    " return 0;\n"
    "}\n"))
  ((h2 (id . "lct-%E8%BF%9B%E9%98%B6")) "LCT 进阶")
  ((h3 (id . "%E7%BB%B4%E6%8A%A4%E8%BE%B9%E4%BF%A1%E6%81%AF")) "维护边信息")
  (p "LCT 的辅助树只能方便的维护点的信息，不能维护边的信息。")
  (p "如果题目要求维护边的信息，则可以采用边转点的技巧，即对于每一条边，新增一个点记录边上的信息。")
  (p "假如有如下原树：")
  (p ((img (src . "./e2v_0.png") (alt . ""))))
  (p "边转点以后得到：")
  (p ((img (src . "./e2v_1.png") (alt . ""))))
  ((h3 (id . "%E7%BB%B4%E6%8A%A4%E5%AD%90%E6%A0%91%E4%BF%A1%E6%81%AF"))
   "维护子树信息")
  (p "查询原树子树信息需要在每个结点上记录其虚儿子的信息，并在虚实链切换时维护这些信息。")
  (p "与普通 LCT 不同，维护子树信息的 LCT 需要在每个结点上维护一下信息（以子树和为例）：")
  (ul
   (li (code "vtot") "：该点所有虚儿子的" (code "atot") "之和，加上该点权值")
   (li (code "atot") "：该点的" (code "vtot") "加上 Splay 上左右儿子的" (code "atot")))
  (p "根据上述定义，我们需要修改普通 LCT 的以下函数：")
  (ul
   (li (code "push_up") "：根据" (code "atot") "的定义进行操作")
   (li (code "access") "：该过程中会进行虚实边切换，需要维护" (code "vtot"))
   (li (code "link") "：该操作新增一条虚边，需要维护" (code "vtot")))
  (p "注意" (code "cut") "操作切断的是实边，无需维护" (code "vtot"))
  (p "具体实现：")
  (pre
   ((code (class . "lang-cpp"))
    "void LCTNode::push_up() {\n"
    " atot = vtot;\n"
    " if (s[0] != nullptr) atot += s[0]->atot;\n"
    " if (s[1] != nullptr) atot += s[1]->atot;\n"
    "}\n"
    "void LCTNode::access() {\n"
    " LCTNode *uu = this, *ss = nullptr;\n"
    " while (uu != nullptr) {\n"
    "   uu->splay();\n"
    "   // uu->s[1] 从实儿子变为虚儿子\n"
    "   if (uu->s[1] != nullptr)\n"
    "     uu->vtot += uu->s[1]->atot;\n"
    "   uu->s[1] = ss;\n"
    "   // ss 从虚儿子变为实儿子\n"
    "   if (uu->s[1] != nullptr) \n"
    "     uu->vtot -= uu->s[1]->vtot;\n"
    "   uu->push_up();\n"
    "   ss = uu;\n"
    "   uu = uu->f;\n"
    " }\n"
    "}\n"
    "void link(LCTNode *u, LCTNode *v) {\n"
    " u->make_root();\n"
    " // 如果不对 v 进行 make_root 的话 v 的祖先的虚子树信息无法得到更新\n"
    " v->make_root();\n"
    " u->f = v;\n"
    " v->vtot += u->atot;\n"
    " // 因为修改了 v 的信息所以要 push_up \n"
    " v->push_up();\n"
    "}\n"))
  ((h2 (id . "%E4%BE%8B%E9%A2%98")) "例题")
  ((h3 (id . "-sdoi2008-cave")) "[SDOI2008] Cave")
  (blockquote
   (p "有 $n$ 个点，一开始没有连边。有 $m$ 次操作，操作有 3 种类型：")
   (ul (li (p "连接某两个点")) (li (p "断开某一条边")) (li (p "还有一种是询问两个点是否连通。")))
   (p "操作过程中保证整个图是森林。"))
  (p "直接用 LCT 进行连边和删边，用" (code "find_root") "判断联通性即可。")
  ((h3 (id . "-wc2006-%E6%B0%B4%E7%AE%A1%E5%B1%80%E9%95%BF")) "[WC2006] 水管局长")
  (blockquote
   (p "$n$ 个点的图，$m$ 条带权边,有 $q$ 次操作，操作有两种类型：")
   (ul
    (li "在节点 $x$ 到 $y$ 的之间所有路径中找一条路径，使得这条路径上的最大边权尽量小，输出这个最小值。")
    (li "删除某一条边"))
   (p "操作过程中保证图连通。"))
  (p "运用“时光倒流”的技巧，先假设所有边都被删掉，然后倒过来一边加边一边回答询问。")
  (p
   "加边的时候如果发现两个点已经联通，那么就找到两个点路径上权值最大的边，如果当前的边权值比这条边小，那么找到的这条边以后都不会出现在最优路径中，因此可以删掉，用新加入的这条边替换。这样可以保证我们维护的始终是一个森林。")
  (p "找到路径上权值最大的边需要用到边转点的技巧。")
  ((h3 (id . "codechef-march14-gerald07")) "Codechef MARCH14 GERALD07")
  (blockquote (p "$N$ 个点 $M$ 条边的无向图，询问保留图中编号在 $[l,r]$ 的边的时候图中的联通块个数。"))
  (p
   "首先，将边按照编号顺序依次加入图中。每当出现环时，将环中最早加入的边弹出。记第 $i$ 条边被弹出的时间为 $T_i$ ，表示在第 $T_i$ 条边加入的时候，第 i 条边被弹出了。")
  (p
   "联通块个数等于点数减生成森林的边树。对于一个时间区间 $[l,r]$，满足 $l \\leq i \\leq r <T_i $ 的边会出现在生成森林中，于是就把问题转化为二维数点，可以使用可持久化线段树或离线后用树状数组解决。")
  ((h3
    (id . "%E6%9C%80%E5%B0%8F%E5%B7%AE%E5%80%BC%E7%94%9F%E6%88%90%E6%A0%91"))
   "最小差值生成树")
  (blockquote (p "给定 $N$ 个点，$M$ 条变的图，求边权极差最小的生成树。"))
  (p "考虑确定生成树边权的最大值，求出该情况下生成树边权最小值的最大值。")
  (p "按照边权从小到大加边，如果两点已经联通则删去两点之间权值最小的边，维护树边中权值最小值即可。")
  ((h3
    (id
     .
     "-uoj207-%E5%85%B1%E4%BB%B7%E5%A4%A7%E7%88%B7%E6%B8%B8%E9%95%BF%E6%B2%99"))
   "[UOJ207] 共价大爷游长沙")
  (blockquote
   (p "给定一个 $n$ 个节点的树，有 $m$ 次操作，操作有以下 $4$ 种类型：")
   (ul
    (li
     "给定四个正整数 $x,y,u,v$，表示先删除连接点 $x$ 和点 $y$ 的无向边，保证存在这样的无向边，然后加入一条连接点 $u$ 和点 $v$ 的无向边，保证操作后的图仍然是一棵树。")
    (li "给定两个正整数 $x,y$，表示在 $S$ 中加入点对 $(x,y)$。")
    (li
     "给定一个正整数 $x$，表示删除第 $x$ 个加入 $S$ 中的点对，即在第 $x$ 个操作 2 中加入 $S$ 中的点对，保证这个点对存在且仍然在 $S$ 中。")
    (li
     "给定两个正整数 $x,y$，询问连接点 $x$ 和点 $y$ 的边是否属于 $S$ 集合中的所有路径的交集，保证存在这样的无向边且此时 $S$ 不为空。")))
  (p
   "首先，我们发现询问一条边 $(x,y)$ 是否是所有路径的交集，可以转化成将 $x$ 变成根，询问在 $S$ 集合中的每一条路径是否都有且仅有一个端点出现在 $y$ 子树中。")
  (p
   "于是，问题转化成了维护子树信息。对于每一条路径的两端点，我们随机一个值，并将两个端点的权值异或上该值，于是原问题就变成了 LCT 维护子树节点权值异或和 。")
  ((h3 (id . "-zjoi2018-%E5%8E%86%E5%8F%B2")) "[ZJOI2018] 历史")
  (blockquote
   (p
    "给一棵树，点有点权 $a_i$。第 $i$ 个点要"
    (code "access")
    "恰好 $a_i$ 次，要求构造一个"
    (code "access")
    "的顺序最大化轻重边切换次数，你还要支持增大一个点的点权。"))
  (p "首先我们得有一个多项式复杂度的玩意。")
  (p
   "钦定两次"
   (code "access")
   "在"
   (code "LCA")
   "处贡献。那么枚举"
   (code "LCA")
   "，将子树 $x$（以及自己的点权）中的所有"
   (code "access")
   "看成一种，那么我们得到的问题就是，有若干不同颜色的球 ，你要将他们排列起来，最大化相邻的异色球数量。")
  (p "这是一个经典问题，记 $S$ 为球数和，$\\textit{maxv}$ 为出现次数最多的球的出现次数，则：")
  (ul
   (li
    (p
     "若$S-\\textit{maxv}< \\textit{maxv}$，则应该用其他所有球去和最多的球拼（最多的球也还有剩余，即$2(S-\\textit{maxv})$"))
   (li (p "否则，最多的球能完全贡献（不会同色相邻），并且可以证明所有球都能完全贡献，即$S-1$")))
  (p "做一个树形dp就好了，复杂度 $O(n)$。")
  (p "接下来考虑怎么支持修改。")
  (p
   "性质1：记 $y$ 为 $x$ 出现次数严格大于一半的儿子（可能不存在，那就留空），那么当 $x$ 的子树中点权增大时，$y$ 仍为 $x$ 出现次数严格大于一半的儿子，并且 $x$ 的贡献不变。")
  (p "性质2：任意一个点到根，大部分都是从出现次数严格大于一半的儿子走到父亲，不是这样的只有$\\log \\sum a_i$ 条。")
  (p "那么就可以想到，将出现次数严格大于一半的儿子记为实儿子，用LCT维护，不存在就留空（为了避免实儿子是自己，可以新建一个点把点权放在上面）。")
  (p
   "修改的时候，我们魔改 LCT 的"
   (code "access")
   "操作（由性质1，实链上的点只有链底可能变化），判断一下是否割掉原本的实儿子，是否将现在的点作为新的实儿子即可，同时统计贡献。")
  (p
   "由性质2，一个点到根只有 $O(\\log \\sum a_i)$ 条实链，每条实链上 splay 代价 $O(\\log n)$，那么一个显然的上界是每次均摊 $O(\\log n\\log \\sum a_i)$。")
  (p "凭什么都是 LCT 魔改后要多一只 $\\log$？")
  (blockquote
   (p
    "你可以拿起笔，在草稿纸上涂涂画画，写下一堆形如 $\\phi + \\sum f'(x) − \\sum f(x)$ 的东西，然后拍案而起：“这样做复杂度是 $O(\\log n + \\log \\sum a_i)$ 的！”"))
  ((h2 (id . "%E5%90%8E%E8%AE%B0")) "后记")
  (blockquote
   (p "如果你不是熟练的 OI 选手，没有关系，百度上有本文所需的所有前置知识。")
   (p
    "本文中没有复杂度分析，因为分析的方法很多，无论你是 $\\phi + \\sum f'(x) − \\sum f(x)$ 的均摊分析选手，还是运算次数每加一规模减半的毛估估大师，都可以轻松得到正确的复杂度。")
   (p "然而这并没有什么用，因为理论复杂度与运行效率没有直接关系，LCT 只能出成交互题卡卡交互次数，树链剖分还是得学的。")
   (p "出题人一般是比较懒的，只会造菊花加链加二叉树。"))
  (p "参考文献：")
  (ul
   (li (p "[1]: 董永建，宋新波，徐先友等，《信息学奥赛一本通 (C++ 版)》，科学技术文献出版社"))
   (li (p "[2]: 张哲宇, 浅谈树上分治算法, IOI2019 中国国家候选队论文集, 2019"))
   (li
    (p
     "[3]:"
     ((a (href . "https://oi-wiki.org/ds/lct/")) "Link Cut Tree - OI wiki")))
   (li
    (p
     "[4]:"
     ((a (href . "https://www.cnblogs.com/zhouzhendong/p/LCT.html"))
      "LCT入门教程 - zzd233")))
   (li
    (p
     "[5]:"
     ((a (href . "https://www.cnblogs.com/zhouzhendong/p/JunTanFenXi.html"))
      "均摊分析 学习笔记 - zzd233"))))
  (br))
