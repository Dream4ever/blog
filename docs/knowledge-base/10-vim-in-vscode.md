---
sidebar_position: 10
title: 在 VSCode 中使用 Vim
---

## 关键知识

### Nouns (Motions)

移动光标的操作：

```
h    向左一个字符
j    向下一行
k    向上一行
l    向右一个字符
w    移动到下一个单词的开头
}    移动到下一个段落（两个不连续的空行之间的所有非空行为一个段落）
$    移动到行末
```

### Verbs (Operators)

操作符：

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
