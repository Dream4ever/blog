---
sidebar_position: 1
---

# 词法结构

## 字符集

JavaScript 是用 Unicode 字符集编写的，这个字符集支持地球上几乎所有在用的语言。

### 区分大小写

```js
var a = 0;
var A = 1;
a === A;    // => false
```

由于 JavaScript 区分大小写，而 HTML 又不区分大小写，许多客户端 JavaScript 对象和属性与它们所表示的 HTML 标签和属性同名。所以在 HTML 中，这些标签和属性可以随便用大小写，但在 JavaScript 中必须用小写。

```html
<!-- HTML，这里不管是写成 onClick 还是 onclick 都是 OK 的 -->
<a onClick="hello"></a>
```

```js
// JavaScript
node.addEventListener('onclick', function() {
  // some code
});
```

### 空格、换行符和格式控制符

JavaScript 会忽略程序中标识 ( token ) 之间的空格，并且在大多数情况下会忽略换行符。所以可以在代码中用缩进来美化代码的格式，增强可读性。

### Unicode 转义序列

在某些老旧的硬件或软件中，无法显示或输入 Unicode 中的部分字符。因此 JavaScript 定义了 Unicode 转义序列，用 6 个 ASCII 字符来代表任意的 16 位 Unicode 内码：`\uxxxx`，以 `\u` 为前缀，后跟 4 个十六进制数。

```js
"café" === "caf\u00e9" // => true: \u00e9 的含义见下面“字符串”一节中的“字符集和内码”这一小节
```

### 标准化

虽然常规的 Unicode 字符和 Unicode 转义序列这两种编码的显示结果是相同的，但它们的二进制编码是不一样的。Unicode 标准为所有字符定义了一个首选的编码格式，并且给出了一个标准化的处理方式，把文本转换为适合比较的标准格式。JavaScript 会认为它正在解析的程序代码就已经是这种标准格式，因此就不会再对其做标准化处理了。

```js
"caf\u00e9".normalize() // => "café": 返回标准化的 Unicode 字符串
```

## 注释

除了不能嵌套书写，其它方式都 OK。

```js
//  单行注释
/* 注释段 */ // 另一个注释段

/*
* 多行注释
*/
```

## 直接量

直接量，就是程序中直接使用的数据值。

```js
12 // 数字
1.2 // 小数
"hello js" // 字符串
'hi' // 也是字符串
true // 布尔值
/javascript/gi // 正则表达式直接量
null // 空
[1, 2, 3] // 数组
a = { x: 1, y: 2 }; // 对象
```

## 标识符和保留字

JavaScript 标识符必须以字母、下划线（_）或美元符号（$）开始，后续的字符可以是前面三者和数字。为什么数字不能在标识符开头？因为这样便于区分标识符和数字。

虽然一般都只用 ASCII 字母和数字来命名标识符，但标识符中完全可以出现 Unicode 字符集中的字母和数字。

```js
// 下面的都是合法的标识符
i
my_variable_name
v8
_dummy
$str
sí
π
```

### 保留字

```js
// 以下是各类保留字
break
null
/* 未来版本的 ES 中会用到 */
const
super
/* 在严格模式下是保留字 */
let
yield
arguments
eval
/* Java 的关键字 */
abstract
private
/* 全局变量和函数 */
Infinity
eval
```

## 可选的分号

JavaScript 只在缺少了分号就无法正确解析代码的时候，才会填补分号。

```js
var a
a
=
3
console.log(a)
/* JavaScript 会识别为：var a; a = 3; console.log(a); */
```

如果语句以 `(`、`[`、`/`、`+` 或 `-` 开始，那么就有很大可能会和前一条语句合在一起解析。

```js
var y = x + f
(a+b).toString()
```

上面的代码就会被解析为：`var y = x + f(a+b).toString()`。

当前语句和下一行语句无法合并解析的话，JavaScript 就会在当前语句后面填补分号。

只有两种例外，第一种例外：如果 `return`、`break` 和 `continue` 后面直接换行了，JavaScript 就会在换行处填补分号。

```js
return
true;
```

就会被解析成：`return; true;`。

第二种例外：如果 `++` 和 `--` 运算符单独在一行上，就会和下一行合在一起解析。

```js
x
++
y
```

就会被解析成：`x; ++y;`。
