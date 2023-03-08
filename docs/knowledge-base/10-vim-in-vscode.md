---
sidebar_position: 10
title: 在 VSCode 中使用 Vim
---

## 关键知识

### Nouns (Motions)

```
h    向左一个字符
l    向右一个字符
j    向下一行
k    向上一行
gj   移动至软换行的下一行
gk   移动至软换行的上一行
w    移动到下一个单词的开头
}    移动到下一个段落（两个不连续的空行之间的所有非空行为一个段落）
$    移动到行末
```

### Word Navigation

```
w     移动到下一个 word 的开头
W     移动到下一个 WORD 的开头
e     移动到下一个 word 的结尾
E     移动到下一个 WORD 的结尾
b     移动到上一个 word 的开头
B     移动到上一个 WORD 的开头
ge    移动到上一个 word 的结尾
gE    移动到上一个 WORD 的结尾
```

### Verbs (Operators)

```
y    复制文字
d    删除文字，并将被删除的文字保存至 register
c    删除文字，将被删除的文字保存至 register，并进入 insert 模式
```

单行的操作，可以通过连按两下操作符实现：yy、dd、cc 都是直接对光标所在行进行操作。

### More Nouns (Text Objects)

`<operator>i<object>` 可对 Text Object 内的字符进行操作，比如 `di(` 就是**只删除一对括号 `()` 里的内容**，但不删除这一对括号。
`<operator>w<object>` 可对 Text Object 和它所包含的字符进行操作，比如 `dia` 就是**删除一对括号 `()` 和它所包含的字符**。

```
w         一个单词
p         一个段落
s         一个句子
( or )    一对小括号 ( )
{ or }    一对花括号 { }
[ or ]    一对方括号 [ ]
< or >    一对尖括号 < >
t         XML 标签
"         一对双引号 " "
'         一对单引号 ' '
`         一对 ` `
```

### 相对行号

在 VSCode 的 Vim 扩展中，可以直接在设置里启用“相对行号”的功能。

注意：在 VSCode 中首次打开某个文件时，需要先进入一次 Insert 模式再退出到普通模式，在该文件中的相对行号功能才会启用。

对于每个文件，都需要做一次这样的操作，才能开启相对行号功能。
