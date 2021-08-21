---
title: LCT maintains subtrees
date: 2020-10-20 20:59:28
tags: 
	- LCT
	- Ds
---

# Use Link-cut-tree to maintain information on subtrees

<!--more-->

## What can traditional `LCT` do

+ link
+ cut
+ modify on a chain
+ query on a chain

But what if the problem questions something on a particular subtree?

## Improve `LCT` to maintain information on a subtree

### Variables to maintain

It is really important to make it clear that what do we need to maintain on each node of the Link-cut-tree, this can help you to save lots of time.

Originally we have:

+ `val`: the value on this node
+ `tot`: the total value on this **SPLAY** subtree

But now things have been totally changed.

We have:

+ `vtot`: the sum of `atot`(defined below) of its **VIRTUAL** sons(on the real tree), and the original `val`
+ `atot`: the sum of `vtot` and original `tot`

It looks pretty strange, but later we will know that these variables are enough.

### What's the answer

Before we consider of how to maintain these values, let's think about an easier problem: how can we get the answer through these values?

Here are what we need to do on querying subtree `u`:

+ `u->access()` Remember this action will turn all of it's sons into virtual sons, and pushdown tags along the way from `u` to the top.
+ `return u->vt` Is this correct? Notice that all the sons of `u` are included, and `u->val` also do. Obviously there is no other nodes included.

### How to maintain the variables

Here comes the most important part.

Originally we just need to update these variables in function `pushUp`, and of course we still need to do this here.

#### `pushUp`

```cpp
void pushUp() { 
	at = vt;
    if (s[0] != NULL) at += s[0]->at;
    if (s[1] != NULL) at += s[1]->at;
}
```

Just follow the definition to maintain `at`

We do not now the information about its virtual sons, so it's not a good idea to update `vt` here.

This is not enough. Things about virtual sons also changes in the function `access` and `link`. (in function `cut` it's guaranteed that we will only cut **preferred** edges, so we do not need to care about it.)

#### `access`

Original access:

```cpp
void access() {
    Node *u = this, *s = NULL;
    while (u != NULL) { 
    	u->splay(); 
        u->s[1] = s; 
        u->pushUp(); 
        s = u; u = u->f; 
    } 
}
```

So we can find that in each operation, original `u->s[1]` becomes a virtual son, and `s` becomes a preferred son.

So we just need add two more lines to update this, as follow:

```cpp
void access() {
    Node *u = this, *s = NULL;
    while (u != NULL) { 
    	u->splay(); 
        if (u->s[1] != NULL) { u->vt += u->s[1]->at; }
        if (s != NULL) { u->vt -= s->at; }
        u->s[1] = s; 
        u->pushUp(); 
        s = u; u = u->f; 
    } 
}
```

`pushUp` will help us to update `at`.

#### `link`

Original link:

```cpp
void link(Node* u, Node* v) {
    u->makeRoot(); v->makeRoot();
    p[u].f = v;
}
```

This will append `u` as a virtual son of node `v`.

So we need to update `v`, as follow:

```cpp
void link(Node* u, Node* v) {
	u->makeRoo(); v->makeRoot();
  p[u].f = v; v->vt += u->at; v->pushUp();
}
```

Great, everything is done.

## Example

### [UOJ207](https://uoj.ac/problem/207)

#### Brief Solution

rand a value for each pair, and we can use `XOR` to check whether **exactly one** node of each pair appears in a subtree .

