---
sidebar_position: 1
title: 在 VSCode 中使用 Vim
---

## Preface | 前言

1. 在参考 [iggredible / Learn-Vim](https://github.com/iggredible/Learn-Vim) 这一教程学习 Vim 时，有了这篇笔记，特此说明，以表感谢。
1. 上面所说教程中的部分章节或具体内容，不适用于在 VSCode 中使用 Vim 的场景，这样的内容就未在此处列出。

## Navigation | 移动光标

### Nouns (Motions) | 基础的移动方式

```
h    向左一个字符
l    向右一个字符
j    向下一行
k    向上一行
gj   移动至软换行的下一行
gk   移动至软换行的上一行

}    移动到下一个段落（两个不连续的空行之间的所有非空行为一个段落）

H     移动到屏幕顶部（High）
M     移动到屏幕中间（Middle）
L     移动到屏幕底部（Low）
```

- [ch04_vim_grammar.md#nouns-motions](https://github.com/iggredible/Learn-Vim/blob/master/ch04_vim_grammar.md#nouns-motions)

### Word Navigation | 以单词为单位的移动

word 与 WORD 的区别：word 只包含 `a-zA-Z0-9_` 这些最常见的字符，WORD 则包含空白字符以外的所有字符。

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

- [ch05_moving_in_file.md#word-navigation](https://github.com/iggredible/Learn-Vim/blob/master/ch05_moving_in_file.md#word-navigation)

### Current Line Navigation | 行内的移动

```
0     移动到本行第一个字符处
$     移动到本行最后一个字符处
^     移动到本行第一个非空字符处
g_    移动到本行最后一个非空字符处
n|    移动到本行的第 n 列
```

```
f    在本行内，从光标处往后定位至指定字符
F    在本行内，从光标处往前定位至指定字符
t    在本行内，从光标处往后定位至指定字符的前一个字符
T    在本行内，从光标处往前定位至指定字符的前一个字符
;    以相同的方向，重复上一次定位
,    以相反的方向，重复上一次定位
```

- [ch05_moving_in_file.md#current-line-navigation](https://github.com/iggredible/Learn-Vim/blob/master/ch05_moving_in_file.md#current-line-navigation)

### Scroll Screen | 移动屏幕

```
<C-E> 屏幕向下滚动一行，即当前行向上
<C-Y> 屏幕向上滚动一行，即当前行向下
zt    将当前行滚动到屏幕顶部
zz    将当前行滚动到屏幕中部
zb    将当前行滚动到屏幕底部
```

- [更快地移动 | 03｜更多常用命令：应对稍复杂的编辑任务](https://time.geekbang.org/column/article/266754)

### Easymotion

这个插件可以快速定位到文件中任意单词的开头/结尾处，也可以快速定位到文件中指定字符的任意位置。

下面的 `<leader>` 表示 `\` 按键。

```
<leader><leader>w       单词的开头，向后查找
<leader><leader>b       单词的开头，向前查找
<leader><leader>bdw     单词的开头，全文查找，但是实际使用时该快捷键不起作用
<leader><leader>e       单词的结尾，向后查找
<leader><leader>ge      单词的结尾，向前查找
<leader><leader>bdw     单词的结尾，全文查找，但是实际使用时该快捷键不起作用
<leader><leader>j       行首，向后查找
<leader><leader>k       行首，向前查找
<leader><leader>f{char}	指定字符，向后查找
<leader><leader>F{char}	指定字符，向前查找
<leader><leader>t{char}	指定字符的前一个字符，向后查找
<leader><leader>T{char}	指定字符的前一个字符，向前查找
<leader><leader>s{char}	指定字符的前一个字符，全文查找
```

- [MOVING EVEN FASTER WITH VIM SURROUND AND EASYMOTION](https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/moving-even-faster-with-vim-sneak-and-easymotion/)

## 编辑文本

### Verbs (Operators) | 操作符

```
y    复制文字
d    删除文字，并将被删除的文字保存至 register
D    删除文字到行尾，并将被删除的文字保存至 register，相当于 d$
c    删除文字，将被删除的文字保存至 register，并进入 insert 模式
C    删除文字到行尾，将被删除的文字保存至 register，并进入 insert 模式，相当于 c$
```

单行的操作，可以通过连按两下操作符实现：yy、dd、cc 都是直接对光标所在行进行操作。

- [ch04_vim_grammar.md#verbs-operators](https://github.com/iggredible/Learn-Vim/blob/master/ch04_vim_grammar.md#verbs-operators)
- [文本修改 | 03｜更多常用命令：应对稍复杂的编辑任务](https://time.geekbang.org/column/article/266754)

### More Nouns (Text Objects) | 文本对象

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

- [ch04_vim_grammar.md#more-nouns-text-objects](https://github.com/iggredible/Learn-Vim/blob/master/ch04_vim_grammar.md#more-nouns-text-objects)

### 从/向其他程序复制文本

如果在 VSCode 扩展 Vim 中启用了 `Use System Clipboard` 这个选项，那么在 Vim 中复制的内容就会进入操作系统的剪贴板，这样在其他程序中就可以直接粘贴了；并且在其他程序中复制的内容也可以直接在 VSCode 里面粘贴了。

如果没有开启上面的选项，那么在执行操作时，需要加上 `"*` 或者 `"+` 前缀。比如在 VSCode 中复制一行内容时，执行 `"*yy` 命令，在其他程序中就可以粘贴了；而在其他程序中复制时，在 VSCode 中执行 `"*p` 命令，就可以把复制的内容粘贴过来了。

- [ch08_registers.md#the-selection-registers](https://github.com/iggredible/Learn-Vim/blob/master/ch08_registers.md#the-selection-registers)

## 其他

### 相对行号

在 VSCode 的 Vim 扩展中，可以直接在设置里启用“相对行号”的功能。

注意：在 VSCode 中首次打开某个文件时，需要先进入一次 Insert 模式再退出到普通模式，在该文件中的相对行号功能才会启用。

对于每个文件，都需要做一次这样的操作，才能开启相对行号功能。

- [ch05_moving_in_file.md#relative-numbering](https://github.com/iggredible/Learn-Vim/blob/master/ch05_moving_in_file.md#relative-numbering)
