---
title: "MDN JavaScript 教程 - 学习笔记"
date: 2020-10-26T19:41:57+08:00
tags: ['JavaScript', 'Note 学习笔记']
draft: false
---

最近工作不太忙了，于是打算从头开始，系统地把 JavaScript 学习一遍。

这篇笔记所记录的是 MDN 上的 JavaScript 教程的学习记录和心得。

教程首页：[JavaScript | MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript)

<!--more-->

## JavaScript first steps

[点我查看页面](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps)

### What is JavaScript?

[点我查看页面](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/What_is_JavaScript)

#### 浏览器安全

每个浏览器标签页都有自己专属的执行环境 (execution environment)，大部分情况下，各标签页的代码是无法影响其他标签页的。

#### 脚本加载策略

浏览器的 `DOMContentLoaded` 事件，可以保证在 HTML body 加载并解析 (load and parse) 完成后，才执行事件中绑定的代码。

`async` 和 `defer` 属性都可以实现脚本的非阻塞式加载，如果不用这两个属性，HTML 页面在遇到脚本的时候，就必须等待脚本加载完毕，才执行它后面的代码。

不过 `async` 属性不保证多个脚本会按照其在页面中出现的顺序执行。

而 `defer` 则可以保证脚本的按顺序执行，并且在 HTML body 加载并解析完成后执行，效果和 `DOMContentLoaded` 相同。

### A first splash into JavaScript

[点我查看页面](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/A_first_splash)

核心内容：如何将一个需求分解成具体的编程任务。

教程中介绍的“猜大小”游戏，规则如下：

1. 用户有 10 次机会，猜一个 1~100 之间的数字。
2. 如果猜中，或者用完了 10 次机会都没猜中，则游戏结束，用户可选择重新开始。
3. 如果没猜中，且 10 次机会没有用完，游戏会提示用户猜的数字偏大还是偏小。

在自己尝试着编写这个游戏的时候，一开始想直接写代码，后来发现自己并没有把流程想清楚，于是试着整理思路理清流程。

在整理思路时，发现自己即使看了源代码，也看了教程中给出的流程，真到自己做的时候，依然会有各种考虑不周全的情况。这也很正常，知易行难，没必要要求自己第一次就能做到尽善尽美，也不现实。

之后花了两个小时的时间把这个小游戏写出来了，虽然已经做了好几年 Web 开发了，但是能够实现这个小游戏还是蛮有成就感的。

这种先写出思路，然后再写出具体代码的习惯，应当一直坚持，想清楚了再去做，能够将效率提升很多。

PS：在阅读 MDN 上的源码时，看到了一个新的 API [Node.textContent](https://developer.mozilla.org/en-US/docs/Web/API/Node/textContent)。

### What went wrong? Troubleshooting JavaScript

[点我查看页面](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/What_went_wrong)

核心内容：如何解决 JavaScript 代码中的错误。

错误主要有两类：

第一类是语法错误，用现代编辑器及相关的插件，这种错误基本上都可以避免。

另一类则是逻辑错误，比如业务的边界条件考虑不周全。要解决这种错误，一方面需要有充分的经验和成熟的方法，另一方面也需要有认真的态度，犯错不可怕，但是总在同一个地方跌倒就太愚蠢了。

参考资料：[JavaScript error reference](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Errors)，这里列出了 JavaScript 会抛出的各种错误。

### Storing the information you need — Variables

[点我查看页面](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/Variables)

核心内容：变量的基础知识。

变量是**值的容器**，容器里的东西是可以改变的，变量的值也是可以改变的。

一个变量要先声明 (declare) 然后才能初始化/赋值 (initialize)。

用 `var` 声明的变量，会有作用域提升 (hoisting) 的问题，`let` 和 `const` 则没有这个问题。

`var` 可以多次声明一个变量，`let` 和 `const` 则只能声明一次，否则会报错。

给变量取名的一些规范：

- 变量名只包含英文字母、阿拉伯数字和下划线，并且不能用数字开头，且建议不要用下划线开头，这样的变量通常被系统占用。
- 变量名建议用 `lower camel case` 格式命名，也就是变量名中首个单词全部小写，之后的单词全部首字母大写，其余字母全小写。
- 变量名的英文字母区分大小写。

### Basic math in JavaScript — numbers and operators

[点我查看页面](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/Math)

核心内容：数学的基础知识。

JavaScript 中数的类型：Number 和 BigInt。

JavaScript 中十进制数 (decimal number) 的种类：整数，浮点数，双精度浮点数。

JavaScript 中各种进制的数：二进制 (binary)，八进制 (octal)，十进制 (decimal)，十六进制 (hexadecimal)。

将字符串转换为数字的方法：`Number()` 构造函数。

### Handling text — strings in JavaScript

[点我查看页面](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/Strings)

教程建议尽量使用模板字符串（template string），效率更高，也更易读。

模板字符串不只是可以显示变量的值，还可以计算表达式，换行也会原样保存。

做了教程中的几道题之后，觉得如果需要处理复杂字符串的话，模板字符串的确非常方便，不过如果只是简单字符串，不用模板字符串也是 OK 的。

### Arrays

[点我查看页面](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/First_steps/Arrays)

对数组使用 `toString()` 方法，等于使用 `.join(',')` 方法，即通过逗号将数组元素拼接成字符串。