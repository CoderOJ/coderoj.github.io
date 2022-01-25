($article
  ((tag LCT Ds) (title . "LCT maintains subtrees") (date . ""))
  ((h2 (id . "what-can-traditional-lct-do"))
   "What can traditional"
   (code "LCT")
   "do")
  (ul (li "link") (li "cut") (li "modify on a chain") (li "query on a chain"))
  (p "But what if the problem questions something on a particular subtree?")
  ((h2 (id . "improve-lct-to-maintain-information-on-a-subtree"))
   "Improve"
   (code "LCT")
   "to maintain information on a subtree")
  ((h3 (id . "variables-to-maintain")) "Variables to maintain")
  (p
   "It is really important to make it clear that what do we need to maintain on each node of the Link-cut-tree, this can help you to save lots of time.")
  (p "Originally we have:")
  (ul
   (li (code "val") ": the value on this node")
   (li (code "tot") ": the total value on this" (strong "SPLAY") "subtree"))
  (p "But now things have been totally changed.")
  (p "We have:")
  (ul
   (li
    (code "vtot")
    ": the sum of"
    (code "atot")
    "(defined below) of its"
    (strong "VIRTUAL")
    "sons(on the real tree), and the original"
    (code "val"))
   (li (code "atot") ": the sum of" (code "vtot") "and original" (code "tot")))
  (p
   "It looks pretty strange, but later we will know that these variables are enough.")
  ((h3 (id . "what-s-the-answer")) "What's the answer")
  (p
   "Before we consider of how to maintain these values, let's think about an easier problem: how can we get the answer through these values?")
  (p "Here are what we need to do on querying subtree" (code "u") ":")
  (ul
   (li
    (code "u->access()")
    "Remember this action will turn all of it's sons into virtual sons, and pushdown tags along the way from"
    (code "u")
    "to the top.")
   (li
    (code "return u->vt")
    "Is this correct? Notice that all the sons of"
    (code "u")
    "are included, and"
    (code "u->val")
    "also do. Obviously there is no other nodes included."))
  ((h3 (id . "how-to-maintain-the-variables")) "How to maintain the variables")
  (p "Here comes the most important part.")
  (p
   "Originally we just need to update these variables in function"
   (code "pushUp")
   ", and of course we still need to do this here.")
  ((h4 (id . "-pushup")) (code "pushUp"))
  (pre
   ((code (class . "lang-cpp"))
    "void pushUp() { \n"
    "   at = vt;\n"
    "   if (s[0] != NULL) at += s[0]->at;\n"
    "   if (s[1] != NULL) at += s[1]->at;\n"
    "}\n"))
  (p "Just follow the definition to maintain" (code "at"))
  (p
   "We do not now the information about its virtual sons, so it's not a good idea to update"
   (code "vt")
   "here.")
  (p
   "This is not enough. Things about virtual sons also changes in the function"
   (code "access")
   "and"
   (code "link")
   ". (in function"
   (code "cut")
   "it's guaranteed that we will only cut"
   (strong "preferred")
   "edges, so we do not need to care about it.)")
  ((h4 (id . "-access")) (code "access"))
  (p "Original access:")
  (pre
   ((code (class . "lang-cpp"))
    "void access() {\n"
    "   Node *u = this, *s = NULL;\n"
    "   while (u != NULL) { \n"
    "       u->splay(); \n"
    "       u->s[1] = s; \n"
    "       u->pushUp(); \n"
    "       s = u; u = u->f; \n"
    "   } \n"
    "}\n"))
  (p
   "So we can find that in each operation, original"
   (code "u->s[1]")
   "becomes a virtual son, and"
   (code "s")
   "becomes a preferred son.")
  (p "So we just need add two more lines to update this, as follow:")
  (pre
   ((code (class . "lang-cpp"))
    "void access() {\n"
    "   Node *u = this, *s = NULL;\n"
    "   while (u != NULL) { \n"
    "       u->splay(); \n"
    "       if (u->s[1] != NULL) { u->vt += u->s[1]->at; }\n"
    "       if (s != NULL) { u->vt -= s->at; }\n"
    "       u->s[1] = s; \n"
    "       u->pushUp(); \n"
    "       s = u; u = u->f; \n"
    "   } \n"
    "}\n"))
  (p (code "pushUp") "will help us to update" (code "at") ".")
  ((h4 (id . "-link")) (code "link"))
  (p "Original link:")
  (pre
   ((code (class . "lang-cpp"))
    "void link(Node* u, Node* v) {\n"
    "   u->makeRoot(); v->makeRoot();\n"
    "   p[u].f = v;\n"
    "}\n"))
  (p "This will append" (code "u") "as a virtual son of node" (code "v") ".")
  (p "So we need to update" (code "v") ", as follow:")
  (pre
   ((code (class . "lang-cpp"))
    "void link(Node* u, Node* v) {\n"
    "   u->makeRoo(); v->makeRoot();\n"
    " p[u].f = v; v->vt += u->at; v->pushUp();\n"
    "}\n"))
  (p "Great, everything is done.")
  ((h2 (id . "example")) "Example")
  ((h3 (id . "-uoj207-https-uoj-ac-problem-207"))
   ((a (href . "https://uoj.ac/problem/207")) "UOJ207"))
  ((h4 (id . "brief-solution")) "Brief Solution")
  (p
   "rand a value for each pair, and we can use"
   (code "XOR")
   "to check whether"
   (strong "exactly one")
   "node of each pair appears in a subtree .")
  (br))
