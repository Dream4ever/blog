---
sidebar_position: 5
---

# 对象

## 前言

对象可以看做是属性的无序集合，每个属性都是一个名/值对。

由于属性名只能是字符串，因此也可以把对象看成是从字符串到值的映射。

但是！对象不仅仅是从字符串到值的映射。对象不仅可以保持自有属性，还可以从原型对象继承属性。对象的方法一般都是继承而来的属性（不然什么方法都要自己写，还要你 JS 干嘛？）。这种“原型继承”是 JavaScript 的**核心特征**。

JavaScript 中的值，只有字符串、数字、布尔值、null 和 undefined 不是对象。而且其中的字符串、数字和布尔值的行为还和不可变对象非常类似。

对象是可变的，我们通过引用来操作对象（可以参考 [JavaScript 究竟是如何传值的？](http://xugaoyang.com/post/5a72d88c2e44aa2601bddef5) 中提到的几篇文章）。

常见的关于对象的用法，是对对象的属性进行创建（create）、设置（set）、查找（query）、删除（delete）、检测（test）、枚举（enumerate）这几项操作（之前读犀牛书的时候没看到这句话，这次看到了，还看到图书内容就是按这几种操作进行分类的，说明之前的阅读效果不够好啊）。

对象的属性由属性名和属性值（以及“属性特性——property attribute”）组成。

- 属性名可以是任意字符串，包含空字符串（如果有空字符串会怎样？）。
- 属性名不能相同（会自动用新值覆盖旧值？）。
- 属性值可以是 JavaScript 中的值，也可以是 getter 或者 setter 函数（或两者都是，如何实现两者都是？）。

对象的属性特性包括：

- 可写：设置属性的值。
- 可枚举：通过 `for/in` 循环得到该属性。
- 可配置：删除或修改该属性。

对象不仅包含属性，它还有三个相关的对象特性（object attribute）：

- 原型：指向另一个对象，本对象会继承其原型的属性（TODO: 只限于可继承属性？）。
- 类：标识对象类型的字符串。
- 扩展标记：明确了在 ES5 中是否可以向该对象添加新属性。

## 创建对象

### 对象直接量

对象的属性名可以是标识符也可以是字符串直接量（空字符串也可以），属性的值可以是任意类型的表达式，表达式的值就是属性的值。

```js
var empty = {}; // 没有任何属性的空对象
var point = { x: 1, y: 1 }; // 两个属性
var point2 = { x: point.x, y: point.y+1 }; // 更复杂的值
var book = {
    "main title": "JavaScript", // 属性名有空格，必须用字符串表示
    "sub-title": "The Definitive Guide", // 属性名有连字符，必须用字符串表示
    "for": "all audiences", // "for"是保留字，必须用引号
    "author": { // 该属性的值是一个对象
        firstname: "David", // 这里的属性名都没有引号
        surname: "Flanagan"
    }
};
```

对象直接量是表达式，这个表达式的每次运算都会创建并初始化一个新的对象。每次计算对象直接量时，也都会计算它的每个属性的值。因此，**如果在一个重复调用的函数中的循环体内使用了对象直接量，它将创建很多新对象，并且每次创建的对象的属性值也有可能不同。**

### 通过 `new` 创建新对象

关键字 `new` 的后面跟随一个函数调用，用来创建并初始化新对象。这里的函数为构造函数，语言核心中的原始类型都包含构造函数。也可以用自定义的构造函数来初始化新对象。

```js
var o = new Object(); // 创建一个空对象，和 {} 一样
var a = new Array(); // 创建一个空数组，和 [] 一样
var d = new Date(); // 创建一个表示当前时间的 Date 对象
var r = new RegExp("js"); // 创建一个可以进行模式匹配的 RegExp 对象
```

### 原型

TODO: 没太看明白……

在 JavaScript 中，每个对象（除了 null）都和另一个对象相关联——另一个对象就是原型。每个对象都从原型继承属性。

通过对象直接量创建的所有对象具有共同的原型对象，并且可以通过 `Object.prototype` 获得对原型对象的引用。通过关键字 `new` 及构造函数所创建的对象，其原型就是构造函数的 `prototype` 属性的值。所以 `new Object()` 所创建的对象也继承自 `Object.prototype`，`new Array()` 创建的对象其原型就是 `Array.prototype`。

只有少数对象没有原型，包括 `Object.prototype`，它不继承任何属性。其他的原型对象都是普通对象，普通对象都有原型。所有的内置构造函数以及大部分自定义的构造函数，都有一个继承自 `Object.prototype` 的原型，比如 `Date.prototype` 的属性就继承自 `Object.prototype`。因此，由 `new Date()` 创建的 Date 对象的属性，同时继承自 `Date.prototype` 和 `Object.prototype`，这一系列链接起来的原型对象就是所谓的“原型链”（prototype chain）。

### `Object.create()`

ES5 中定义了该方法用于创建对象。第一个参数为对象的原型，第二个可选参数用于进一步描述对象的属性。

`Object.create()` 是一个静态函数，也就是说它不能被某个对象作为方法调用：

```js
var o1 = Object.create({x:1, y:2}); // o1 继承了属性 x 和 y
```

可以传入参数 null 来创建一个没有原型的对象，这个对象不会继承任何东西，包括 `toString()` 这样的基础方法。

```js
var o2 = Object.create(null); // 不继承任何属性和方法，在浏览器中输入o2，然后再输入一个点号的话，不会有任何自动完成的提示
```

如果想创建一个普通的空对象（就像 `{}` 或者 `new Object()` 创建的对象），要传入参数 `Object.prototype`：

```js
var o3 = Object.create(Object.prototype); // 和 {} 及 new Object() 一样
```

还可以通过任意原型创建新对象（也就是可以使任意对象可继承），下面的代码就模拟了原型继承：

```js
// TODO: 为什么是让一个空构造函数的原型为p？而不是让一个空对象原型为p？这是用构造函数新建对象的方式？
function inherit(p) {
    if (p == null) throw TypeError(); // p必须是非null的对象
    if (Object.create) return Object.create(p); // 该方法存在时，则直接使用
    var t = typeof p; // 否则进一步检测
    if (t !== "object" && t !== "function") throw TypeError();
    function f() {}; // 定义空构造函数
    f.prototype = p; // 令其原型为 p
    return new f(); // 用 f() 创建 p 的继承对象
}
```

上面创建的 `inherit()` 函数，作用之一就是防止库函数无意间修改了不受控制的对象。该方法不是直接将对象作为参数传入函数，而是将目标对象的继承对象传给函数（令返回的对象的原型为传入的对象）。这样函数在读取继承对象属性的时候，读取的就是继承过来的值。在给继承对象的属性赋值的时候，就只影响继承对象自身，不会影响原始对象了：

```js
var o1 = { x: 1 };
var o2 = inherit(o1);
o2.x = 2;
o2.x // => 2
o1.x // => 1: o2 继承自 o1，修改 o2 的属性 x，没有影响 o1 中的同名属性
```

## 属性的查询和设置

在 JavaScript 中，可以通过点号（`.`）或者方括号（`[]`）来获取或者设置属性的值：

```js
var author = book.author; // 获取 book 的 "author" 属性
var title = book["main title"]; // 获取 book 的 "main title" 属性
book.edition = 6; // 设置 book 的 edition 属性
book["main title"] = "ECMAScript"; // 设置 book 的 "main title" 属性
```

使用点运算符时，右侧必须是以属性名称命名的简单标识符；对于方括号来说，方括号内必须是一个计算结果为字符串（或是一个可以转换为字符串的值）的表达式。

### 作为关联数组的对象

上面讲到的两种属性查询方法都能够查询对象属性的值，方括号的形式看起来更像数组，只是这个“数组”——对象的元素是通过字符串索引的，这种数组就叫关联数组（associative array）。

在一些强类型语言中（如C、C++、Java等），对象的属性都是提前定义好的，无法动态增删。而 JavaScript 由于是弱类型语言，因此可以在任何对象中创建任意数量的属性。通过点号 `.` 访问对象属性时，属性名称为标识符，而标识符不是数据类型，因此无法修改。

而用方括号 `[]` 来访问对象属性时，此时的属性名为字符串，字符串又是 JavaScript 的数据类型，所以在程序运行时可以修改或创建它们。假设要给 `portfolio` 这个对象动态添加新的属性——股票，就可以用 `[]` 运算符来实现：

```js
function addstock(portfolio, stockname, shares) {
    portfolio[stockname] = shares;
}
```

再结合 `for/in` 循环，就可以很方便地遍历关联数组（对象）了：

```js
function getValue(portfolio) {
    var total = 0.0;
    for (stock in portfolio) { // 遍历 portfolio 中的每只股票
        var shares = portfolio[stock]; // 获取每只股票的份额
        var price = getQuote(stock); // 查找股票价格
        total += shares * price; // 将结果累加至 total 中
    }
    return total; // 返回 total 的值
}
```

### 继承

JavaScript 中的对象，既有自有属性（own property），也有从原型对象继承来的属性。在查询对象 o 的属性 x 时，如果 o 中不存在 x，就会继续在 o 的原型对象中查询属性 x。如果原型对象也没有 x，但这个原型对象还有原型，就会继续在这个原型对象的原型中查询，直到找到 x 或者找到原型为 null 的对象为止。对象及其原型构成了一个“链条”，通过这个链条就实现了属性的继承。

```js
var o = {}; // o 通过这种形式从 Object.prototype 继承对象
o.x = 1; // 给 o 定义属性 x
var p = inherit(o); // p 继承 o 和 Object.prototype
p.y = 2; // 给 p 定义属性 y
var q = inherit(p); // q 继承 p、o 和 Object.prototype
q.x = 3; // 给 q 定义同名属性 x
var s = q.toString(); // toString 继承自 Object.prototype
q.x + q.y; // => 3: x 用的是 q 中的自有属性，y 则继承自对象 p
```

假设现在要给对象 o 的属性 x 赋值，如果 o 中已经有了自有属性 x，则赋值操作就只改变这个自有属性的值。如果 o 中不存在属性 x，则赋值操作就给 o 添加一个新属性 x 并赋值。如果 o 的原型对象中有属性 x，那么在 o 中新建的属性 x 就会覆盖原型对象中的同名属性。

给属性赋值时，首先会检查原型链，确认是否允许赋值。如果 o 继承自一个只读属性 x，则赋值操作是不允许的。如果允许赋值，也总是在原始对象上创建属性或对已有的属性赋值，并不会修改原型链——不会修改原型对象中的同名属性。因此，只有在查询属性时才能体会到继承的存在，设置属性就和继承无关了，这样可以让程序员选择性地覆盖（override）继承的属性。

```js
var unitcircle = { r: 1 }; // 用于继承的对象
var c = inherit(unitcircle); // c 继承了属性 r
c.x = 1; c.y = 1; // c 新定义两个属性
c.r = 2; // c 覆盖了继承来的属性
unitcircle.r; // => 1: 原型对象未被修改
```

给属性赋值，有几种可能的结果：要么失败，要么创建一个属性，要么在原始对象中设置属性（TODO: 是指修改原始对象现有属性的值？），只有一种例外：如果 o 继承了属性 x，而属性 x 是一个具有 `setter` 方法的 `accessor` 属性，这时将调用 `setter` 方法，而不会给 o 创建属性 x。注意：调用 `setter` 方法的将是 o，而不是定义这个属性的原型对象；因此，如果 `setter` 方法定义了属性的话，这个定义属性的操作是作用在 o 上的，而不是去修改原型链。

### 属性访问错误

本节讲讲查询或设置属性时，一些出错的情况。

先讲讲查询属性：查询不存在的属性时不会报错，在对象的原型链上查找不存在的属性时，返回 undefined。

```js
book.subtitle; // => undefined: 属性不存在
```

但是，查询一个不存在的对象的属性时，就会报错了。null 和 undefined 都没有属性，所以查询它俩的属性就会报错：

```js
var len = book.subtitle.length;
// 抛出一个类型错误异常，说 undefined 没有 length 属性
// => TypeError: Cannot read property 'length' of undefined
```

为了避免出错，可以用下面两种方法查询属性：

```js
// 第一种方法有些罗嗦，但容易看懂
var len = undefined;
if (book) {
    if ('subtitle' in book) len = book.subtitle.length;
} else {
    // Do something...
}
// ↑↑↑ 注意：book 对象不存在时，这样的代码还是会报错
// Uncaught ReferenceError: book is not defined
// 所以要用 try...catch 之类的错误处理语句进行处理

// 第二种方法则比较简练
var len = book && book.subtitle && book.subtitle.length;
//问题同上
```

再讲讲设置属性：给 null 和 undefined 设置属性肯定会报类型错误，给只读属性设置值也会报错；但还有些不允许新增属性的对象，对其设置属性时，失败了却不会报错：

```js
// 内置构造函数的原型是只读的
Object.prototype = 0; // 赋值失败，但没有报错，Object.prototype 没有被修改
```

这是个历史遗留问题，在 ES5 的严格模式中已经修复了。在严格模式中，任何失败的属性设置操作都会抛出一个类型错误异常。

给对象 o 设置属性 p 时，会失败的场景总结如下（TODO: 这些先记下来，回头用的时候再弄清楚）：

- o 中的属性 p 是只读的：不能给只读属性重新赋值（`defineProperty()` 方法中有个例外，可以对可配置的只读属性重新赋值）。
- o 中的属性 p 是继承属性，且是只读的：不能通过同名自有属性覆盖只读的继承属性。
- o 中不存在自有属性：o 没有使用 setter 方法继承属性 p，并且 o 的可扩展性（entensible attribute）为 false。如果 o 中不存在 p，并且没有 setter 方法可供调用，则 p 一定会添加至 o 中。但如果 o 是不可扩展的，在 o 中就不能定义新属性了。

## 删除属性

`delete` 运算符可以删除对象的属性，但本质上只是断开属性和所属对象的关系，其实并不是将对象的属性从内存中删除。

```js
a = { p: { x: 1 } };
b = a.p;
delete a.p;
b.x; // => 1
```

由于已经删除的属性的引用依然存在，所以如果代码写得不严谨，就容易造成内存泄漏。因此，在销毁对象的时候，要遍历属性中的属性，依次删除。

另外，`delete` 运算符只能删除自有属性，不能删除继承属性（只能从定义这个属性的原型对象上删除这个继承属性，而且这样会影响到所有继承自这个原型的对象）。

`delete` 表达式删除成功或没造成任何副作用（比如删除不存在的属性）时，就会返回 true。如果 `delete` 运算符的操作数不是属性访问表达式，依然返回 true，包装对象也是如此：

```js
o = { x: 1 }; // o 具有自有属性 x，并且继承了属性 toString
delete o.x; // 成功删除属性 x
delete o.x; // 什么都没做（属性 x 不存在了）
delete o.toString; // 什么都没做（不能删除继承属性）
delete 1; // 无意义
```

`delete` 不能删除可配置性为 false 的属性（但可以删除不可扩展对象的可配置属性）。某些内置对象的属性就是不可配置的，比如通过变量声明和函数声明创建的全局对象的属性。在严格模式中，删除一个不可配置的属性会报类型错误。在非严格模式中，这类的 `delete` 操作会返回 false：

```js
delete Object.prototype; // => false: 不能删除，属性不可配置
var x = 1; // 声明全局变量
delete this.x; // => false: 全局变量不能删除
function f() {} // 声明全局函数
delete this.f; // => false: 全局函数也不能删除
```

在非严格模式中删除全局对象的可配置属性时，可以省略对全局对象的引用：

```js
this.x = 1; // 创建了一个可配置的全局属性
delete x; // true
this.x; // undefined
```

但是在非严格模式中这样删除会报语法错误，必须显式指定对象及其属性：

```js
delete x; // => Uncaught SyntaxError: Delete of an unqualified identifier in strict mode.
delete this.x; // => true
```

## 检测属性

一句话概括：

- `in`：是属性就行（自有或继承）
- `hasOwnProperty`：必须是自有（继承就不行）
- `propertyIsEnumerable`：自有且可枚举

JavaScript 中的对象可以看作是属性的集合，检测集合中成员所属关系——也就是判断某个属性是否存在于某个对象中，是很常见的操作，可以通过 `in` 运算符、`hasOwnProperty()` 和 `propertyIsEnumerable()` 来完成这个工作，其实属性查询也可以做到这一点。

前面已经讲过，`in` 运算符用于检查左侧的属性名是否为右侧对象的自有属性或继承属性：

```js
var o = { x: 1 };
"x" in o; // => true: x 是 o 的属性
"y" in o; // => false: y 不是 o 的属性
"toString" in o; // => true: toString 是 o 继承来的属性
```

对象的 `hasOwnProperty()` 方法则更严格：它检查一个名称是否为对象的**自有**属性：

```js
var o = { x: 1 };
o.hasOwnProperty('x'); // => true: x 是 o 的自有属性
o.hasOwnProperty('y'); // => false: y 不是 o 的自有属性
o.hasOwnProperty('toString'); // => false: toString 是继承属性
```

`propertyIsEnumerable()` 则又是 `hasOwnProperty()` 的增强版：只有该属性为自有属性，且该属性的可枚举性为 true 时，该方法才返回 true。某些内置属性是不可枚举的，不过 JavaScript 代码创建的属性一般都是可枚举的（除非在 ES5 中用一个特殊方法改变了属性的可枚举性）：

```js
var o = inherit({ y: 2 });
o.x = 1; // => 1
o.propertyIsEnumerable("x"); // => true: x 是 o 的可枚举的自有属性
o.propertyIsEnumerable("y"); // => false: y 是继承属性
Object.prototype.propertyIsEnumerable("toString"); // => false: toString 不可枚举
```

要判断属性的值是否为 undefined，除了可以使用 `in` 运算符，更简便的方法是使用 `!==` 来判断：

```js
var o = { x: 1 };
o.x !== undefined; // => true: o 中有属性 x
o.y !== undefined; // => false: o 中没有属性 y
o.toString !== undefined; // => true: o 继承了属性 toString
```

但是，有一种场景只能用 `in` 运算符来判断：就是需要区分属性究竟是不存在，还是存在但是值为 undefined 的情况：

```js
var o = { x: undefined }; // 显式赋值属性 x 为 undefined
o.x !== undefined; // => false: 属性存在，但值为 undefined
o.y !== undefined; // => false: 属性不存在
"x" in o; // => true: 属性存在
"y" in o; // => false: 属性不存在
delete o.x; // => true: 删除了属性 x
"x" in o; // => false: 属性不再存在
```

注意：上面的代码用的是 `!==` 运算符，而不是 `!=`。`!==` 可以区分 null 和 undefined，但有时候不需要这种区分，可以用 `!=` 或者直接什么都不用：

```js
// 如果 o 中含有属性 x，且 x 的值不是 null 或 undefined，o.x 乘以 2
if (o.x != null) o.x *= 2;
// 如果 o 中含有属性 x，且 x 的值不能转换为 false，o.x 乘以 2
// 如果 x 为 undefined、null、false、""、0 或 NaN，则保持不变
if (o.x) o.x *= 2;
```

## 枚举属性

一句话概括：

- `for/in`：只需可枚举（自有或继承）
- `Object.keys()`：可枚举+自有
- `Object.getOwnPropertyNames()`：只需自有（包含不可枚举的）

前面提到过的 `for/in` 循环，可以遍历对象所有**可枚举的**属性（包括自有属性和继承属性），然后将**属性名称**赋值给循环变量。对象继承来的内置方法不可枚举，而在代码中给对象添加的属性都是可枚举的（也有例外）：

```js
var o = { x: 1, y: 2, z: 3 }; // 三个可枚举的自有属性
o.propertyIsEnumerable('toString'); // => false: 继承来的内置方法，不可枚举
for (p in o) console.log(p); // => x y z: 只输出可枚举的属性
```

许多实用工具库都向 `Object.prototype` 中添加了各种方法或属性，这些方法和属性可以被所有对象继承并使用。但是在 ES5 标准之前，添加的这些方法和属性无法设置为不可枚举，所以会在 `for/in` 循环中枚举出来，而用户其实不需要把这些方法或属性枚举出来。所以为了避免这种情况，就需要过滤 `for/in` 循环返回的属性，下面列出两种过滤不需要的属性的最常见的方式：

```js
for (p in o) {
    if (!o.hasOwnProperty(p)) continue; // 跳过继承的属性
}
for (p in o) {
    if (typeof o[p] === 'function') continue; // 跳过方法
}
```

下面的代码定义了一些实用的工具函数来操控对象的属性，这些函数都用到了 `for/in` 循环。其中的 `extend()` 函数其实经常出现在 JavaScript 的实用工具库中。

```js
// 把 p 中的可枚举属性复制/扩展到 o 中并返回 o
// p 会覆盖 o 中的同名属性
// 但不会处理 getter 和 setter 以及复制属性: TODO: 这里需要看了后面的相关知识才能弄明白……
function extend(o, p) {
    for (var prop in p) { // 遍历 p 中所有可枚举属性
        o[prop] = p[prop]; // 将属性添加至 o 中
    }
    return o;
}

// 把 p 中的可枚举属性复制/合并到 o 中并返回 o
// p 不会覆盖 o 中的同名属性
// 并且不会处理 getter 和 setter 以及复制属性
function merge(o, p) {
    for (var prop in p) { // 遍历 p 中所有可枚举属性
        if (o.hasOwnProperty(prop)) continue; // 过滤掉已经存在于 o 中的属性
        o[prop] = p[prop]; // 将属性添加至 o 中
    }
    return o;
}

// 删除 o 独有的属性，并返回 o
function restrict(o, p) {
    for (var prop in o) { // 遍历 p 中所有可枚举属性
        if (!(prop in p)) delete o[prop]; // 不存在于 p 中的话就删除
    }
    return o;
}

// 从 o 中删除 p 中也有的同名属性，并返回 o
function subtract(o, p) {
    for (var prop in p) { // 遍历 p 中所有可枚举属性
        delete o[prop]; // 从 o 中删除（删除不存在的属性也不会报错）
    }
    return o;
}

// 返回一个同时拥有 o 和 p 的属性的新对象
// 对于重名属性，用 p 中的属性值
function union(o, p) { return extend(extend({}, o), p); }


// 返回一个对象，拥有 o 和 p 的同名属性，采用 o 中的属性值
function intersection(o, p) { return restrict(extend({}, o), p); }

// 返回一个数组，包含 o 中可枚举的自有属性的名称
function keys(o) {
    if (typeof o !== 'object') throw TypeError(); // 参数必须是对象
    var result = []; // 保存属性名称的数组
    for (var prop in o) {
        if (o.hasOwnProperty(prop)) result.push(prop); // 只添加可枚举的自有属性
    }
    return result;
}
```

遍历属性的方法，除了 `for/in` 循环，还有 ES5 所定义的两个函数：`Object.keys()` 返回一个数组，元素为对象中**可枚举的自有属性**，工作原理和上面代码中的工具函数 `keys()` 类似。

还有一个函数是 `Object.getOwnPropertyNames()`，它和 `Object.keys()` 类似，只不过返回的是**所有的自有属性**的名称，包括那些不可枚举的属性。

## 属性 `getter` 和 `setter`

对象的属性，是由名字、值和一组特性（attribute）组成的，而在 ES5 中，属性的值可以用两个方法替代：`getter` 和 `setter`。这两个方法定义的属性称为“存取器属性”（accessor property），和前面所讲的“数据属性”（data attribute）不一样——数据属性只有一个简单的值。

程序在**查询**存取器属性的值的时候，就会不带参数地调用 `getter` 方法，其返回值就是属性存取表达式的值。程序在**设置**存取器属性的值的时候，就会调用 `setter` 方法，将赋值表达式右侧的值当作参数传入 `setter`——可以将这个方法看作是在负责“设置”属性的值。`setter` 方法的返回值可以忽略。

存取器属性和数据属性不一样，存取器属性不具有可写性（writable attribute）。同时具有 `getter` 和 `setter` 方法的属性是读/写属性，只有 `getter` 方法的是只读属性，只有 `setter` 方法的则是只写属性，读取只写属性会得到 undefined。

可以用对象直接量语法的一种扩展写法来定义存取器属性：

```js
var o = {
    data_prop: value, // 普通的数据属性

    // 存取器属性都是成对定义的函数
    get accessor_prop() { /* 函数体 */ },
    set accessor_prop(value)  { /* 函数体 */ },
};
```

`getter` 和 `setter` 函数的函数名必须相同，用关键字 `get` 及 `set` 而不是 `function` 来定义，且 `getter` 方法和 `setter` 方法之间需要用逗号分隔开。

```js
var p = {
    // x 和 y 是普通的可读写的数据属性
    x: 1.0,
    y: 1.0,

    // r 是可读写的存取器属性，同时有 getter 和 setter
    // 如果函数体之后还有别的属性定义，函数体后面要带逗号
    get r() {
        return Math.sqrt(this.x * this.x + this.y * this.y);
    },
    set r(newValue) {
        var oldValue = Math.sqrt(this.x * this.x + this.y * this.y);
        var ratio = newValue / oldValue;
        this.x *= ratio;
        this.y *= ratio;
    },

    // theta 是只读存取器属性，只有 getter 方法
    get theta() {
        return Math.atan2(this.y, this.x);
    }
};
```

注意上面代码中，`getter` 和 `setter` 里 `this` 关键字的用法：JavaScript 是把这些（存取器属性中定义的）函数当作对象的方法来调用的，所以在函数体内的 `this` 指向的是表示这个点的对象。因此，属性 `r` 的 `getter` 方法可以通过 `this.x` 这样的格式引用对象中的属性。

另外，这段代码使用存取器属性定义 API，提供了表示同一组数据的两种方法（笛卡尔座标系和极座标系表示法）。

存取器属性和数据属性一样是可继承的，因此上面代码中的对象 p 可以是另一个“点”的原型。以 p 为原型定义一个新对象的话，可以给新对象重新定义属性 x 和 y，然后继承属性 r 和 theta：

```js
var q = inherit(p); // 创建一个继承了 getter 和 setter 的新对象
q.x = 1, q.y = 1, // 给 q 添加两个自有属性，覆盖了原型中的同名属性
console.log(q.r); // 使用继承来的存取器属性中的 getter 方法
console.log(q.theta);
```

还有很多场景可以用到存取器属性，比如智能检测属性的写入值，以及在每次属性读取时返回不同的值：

```js
// 该对象产生严格自增的序列号
var serialNum = {
    // 该数据属性包含下一个序列号
    // $ 符号暗示该属性为私有属性
    $n: 0,

    // 返回当前值，然后自增
    get next() { return this.$n++; },

    // 设置 $n 的新值，但只有大于当前值时才成功
    set next(n) {
        if (n > this.$n) this.$n = n;
        else throw '序列号的值不能比当前值小';
    }
};
```

最后再看一个例子，它使用 `getter` 方法实现一种“神奇”的属性：

```js
// 该对象有一个可以返回随机数的存取器属性
// 比如表达式 random.octet 会产生一个在 0~255 之间的随机数
var random = {
    get octet() {
        return Math.floor(Math.random() * 256);
    },
    get uint16() {
        return Math.floor(Math.random() * 65536);
    },
    get int16() {
        return Math.floor(Math.random() * 65536) - 32768;
    }
}
```

## 属性的特性

| 数据属性 | 存取器属性 |
| -- | -- |
| 值 value | 读取 get |
| 可写性 writable | 写入 set |
| 可枚举性 enumerable | 可枚举性 enumerable |
| 可配置性 configurable | 可配置性 configurable |

上表中列出的是数据属性和存取器属性各自的四个特性，为了查询/设置属性的特性，ES5 中定义了“属性描述符”（property descriptor）这个对象，该对象代表那四个特性，且描述符对象的属性和它们所描述的属性特性是同名的。所以，数据属性的描述符对象，包含 `value`、`writable`、`enumerable` 和 `configurable` 这四个属性，存取器属性的描述符对象，则包含 `get`、`set`、`enumerable` 和 `configurable` 这四个属性，其中 `writable`、`enumerable` 和 `configurable` 都是布尔值，而 `get` 和 `set` 则是函数值。

`Object.getOwnPropertyDescriptor()` 可以获取某个对象特定属性的属性描述符：

```js
Object.getOwnPropertyDescriptor({ x: 1}, 'x');
// => {value: 1, writable: true, enumerable: true, configurable: true}
// 查询前面定义的 random 对象的 octet 属性
Object.getOwnPropertyDescriptor(random, 'octet');
// => {set: undefined, enumerable: true, configurable: true, get: ƒ}
// 查询继承属性或不存在的属性时返回 undefined
Object.getOwnPropertyDescriptor({}, 'x');
// => undefined
Object.getOwnPropertyDescriptor({}, 'toString');
// => undefined
```

`Object.getOwnPropertyDescriptor()` 只能得到对象自有属性的描述符，要想获取继承属性的特性，就需要遍历原型链了。

要设置属性的特性，或者想让新建属性具有某种特性，就要用 `Object.defineProperty()`：

```js
var o = {}; // 创建一个空对象
// 添加一个不可枚举的数据属性，并赋值为 1
Object.defineProperty(o, 'x', { value: 1, writable: true, enumerable: false, configurable: true});

// 属性存在，但不可枚举
o.x; // => 1
Object.keys(o); // => []

// 让属性变为只读
Object.defineProperty(o, 'x', { writable: false });
o.x = 2; // => 2
o.x; // => 1

// 虽然是只读，但是可配置，所以依然可以用 Object.defineProperty 修改属性的值
Object.defineProperty(o, 'x', { value: 3 });
o.x; // => 3

// 将 x 从数据属性更改为存取器属性
Object.defineProperty(o, 'x', { get: function() { return 0; }});
o.x; // => 0
```

传入 `Object.defineProperty()` 的属性描述符对象，不需要包含所有四个属性，就像上面的代码那样，包含至少一个属性就可以了。新创建的属性，其默认的特性值是 `false` 或 `undefined`。修改已有属性时，不会修改默认的特性值。该方法不能修改继承属性，只能修改已有属性或新建自有属性。

要同时修改或创建多个对象时，就要用该方法的复数形式——`Object.defineProperties()`——第一个参数是所要修改的对象，第二个参数是个映射表：包含所要修改/新建的属性的名称，及各属性的属性描述符：

```js
var p = Object.defineProperties({}, {
    x: { value: 1, writable: true, enumerable: true, configurable: true },
    y: { value: 1, writable: true, enumerable: true, configurable: true },
    r: {
        get: function() { return Math.sqrt(this.x * this.x + this.y * this.y)},
        enumerable: true,
        configurable: true
    }
});
```

上面这段代码给一个空对象添加了两个数据属性和一个只读存取器属性，然后将修改后的对象返回给变量 p。

对于不允许被创建或修改的属性来说，用 `Object.defineProperty()` 或其复数形式对其进行操作（新建或修改）就会抛出类型错误异常，比如给不可扩展的对象新增属性时。这些方法抛出类型错误异常的其它原因则和特性本身相关，以下是完整的规则，违反规则使用 `Object.defineProperty()` 或其复数形式都会抛出类型错误异常：

- 对于不可扩展对象，可编辑已有的自有属性，但不可新增属性。
- 对于不可配置属性，不能修改可配置性和可枚举性。
- 对于不可配置的存取器属性，不能修改其 `getter` 和 `setter` 方法，也不能将其转换为数据属性。
- 对于不可配置的数据属性，不能将其转换为存取器属性。
- 对于不可配置的数据属性，不能将其可写性从 `false` 修改为 `true`，但可以从 `true` 修改为 `false`。
- 对于不可配置且不可写的数据属性，不能修改它的值。但可配置不可写的属性的值是可以修改的（其实是先将其标记为可写的，然后修改值，再标记成不可写的）。

**枚举属性**这一节中的 `extend()` 函数，把一个对象的属性复制到另一个对象中，但只是简单地复制属性名和值，没有复制属性的特性，也没有复制存取器属性的 `getter` 和 `setter` 方法，只是简单地将其转换为静态的数据属性。下面的代码则给出了改进的 `extend()` 方法，使用 `Object.getOwnPropertyDescriptor()` 和 `Object.defineProperty()` 对属性的所有特性进行复制。改进后的方法作为不可枚举属性被添加到 `Object.prototype` 中，因此它是在 `Object` 上定义的新方法，并不是一个独立的函数。

```js
// （TODO: 没太看懂……）
// 给 Object.prototype 添加一个不可枚举的 extend() 方法
// 该方法继承自调用它的对象，将作为参数传入的对象的属性逐一进行复制
// 不仅复制值，也复制属性的所有特性，除非在目标对象中存在同名属性
// 参数对象的所有自有对象（自有属性？）（包括不可枚举的属性）也会被逐一复制
Object.defineProperty(Object.prototype, 'extend',
    {
        writable: true,
        enumerable: false,
        configurable: true,
        value: function(o) { // 值就是这个函数
            // 得到所有的自有属性，包括不可枚举属性
            var names = Object.getOwnPropertyNames(o);
            // 遍历这些属性
            for (var i = 0; i < names.length; i++) {
                // 如果属性已存在，则跳过
                if (names[i] in this) continue;
                // 获得 o 中的属性描述符
                var desc = Object.getOwnPropertyDescriptor(o, names[i]);
                // 用它给 this 创建一个属性
                Object.defineProperty(this, names[i], desc);
            }
        }
    });
// TODO: 执行这段代码之后，定义一个对象 p，然后执行 Object.extend(p)，再查看 Object.prototype 的属性，没有发现 p 中的属性；再执行 Object.prototype.extend(p)，则直接是 jQuery 的报错信息了，是在百度的首页环境下，在浏览器控制台中测试的
// TODO: 所以上面代码中的 this 究竟指的是什么？又将传入参数的对象的属性，复制到什么地方去了？
```

### getter 和 setter 的老式 API

对象直接量语法可以给新对象定义存取器属性，但无法查询属性的 `getter` 和 `setter` 方法，或给已有的对象添加新的存取器属性。ES5 中可以通过 `Object.getOwnPropertyDescriptor()` 和 `Object.defineProperty()` 来完成这些工作，但是在 ES5 发布之前，各大浏览器是如何实现这些功能的呢？其实在 ES5 标准被采纳之前，大多数的 JavaScript 的实现（IE 除外）就已经可以支持对象直接量语法中的 `get` 和 `set` 写法了，这些实现提供了非标准的老式 API 来查询和设置 `getter` 和 `setter`，这些 API 由四个方法组成，所有对象都有这些方法：`__lookupGetter__()` 和 `__lookupSetter__()` 用来返回一个命名属性的 `getter` 和 `setter` 方法，`__defineGetter__()` 和 `__defineSetter__()` 则用来定义 `getter` 和 `setter`。前后的两条下划线，用来表明它们是非标准的方法。

## 对象的三个属性

每一个对象都有与之相关的三个属性：原型（prototype）、类（class）和可扩展性（extensible attribute）。

### 原型属性

原型属性是用来从原型继承属性的，这个属性很重要，所以会常常把“o 的原型属性”直接叫做“o 的原型”。

在创建对象实例的时候，原型属性就设置好了：

- 由对象直接量创建的对象，其原型为 `Object.prototype`。
- 由 `new` 创建的对象，其原型为构造函数的 `prototype` 属性。
- 由 `Object.create()` 创建的对象，其原型为第一个参数（或者 null）。

在 ES5 中，用 `Object.getPrototypeOf()` 可以查询所传入的对象的原型。ES3 中虽然没有等价的函数，但可以用表达式 `o.constructor.prototype` 来检测对象的原型。`new` 创建的对象通常会继承 `constructor` 属性，这个属性指代创建这个对象的构造函数。而构造函数所拥有的 `prototype` 属性，定义了用该构造函数所创建出的对象的原型。后面会解释为什么这种方法（`o.constructor.prototype`）检测对象原型并不是100%可靠。通过对象直接量或者 `Object.create()` 传入对象直接量作为第一个参数所创建的对象，都有一个 `constructor` 属性，该属性就是 `Object()` 这个构造函数。因此，`constructor.prototype` 是对象直接量的原型，但不一定是 `Object.create()` 的原型（TODO: 为什么呢？）。

`isPrototypeOf()` 方法能够检测一个对象是否为另一个对象的原型，或者是否在另一个对象的原型链上：

```js
var p = { x: 1 }; // 定义原型对象
var o = Object.create(p); // 用原型创建新对象
p.isPrototypeOf(o); // => true: o 继承自 p
Object.prototype.isPrototypeOf(p); // => true: p 继承自 Object.prototype
```

书上说 `isPrototypeOf()` 实现的功能和 `instanceof` 运算符非常类似，一个是检查某对象是否为另一个对象的原型，另一个是检查某对象是否为另一个构造函数的实例，这么一看，的确是比较相似。

PS: Mozilla 实现的 JavaScript 对外暴露了一个命名为 `__proto__` 的属性，用来直接查询/设置对象的原型。虽然其它浏览器也部分支持，但不建议使用该属性。

### 类属性

对象的类属性是一个字符串，表示对象的类型信息。ES3 和 ES5 都没有提供设置该属性的方法，只能通过一种间接的方法查询它。默认的 `toString()` 方法（继承自 `Object.prototype`）返回如下格式字符串：

`[object class]`

上面字符串中的 `class` 即为所查询目标的类型名称。由于很多对象所继承的 `toString()` 方法被该对象重写了，所以必须间接调用 `function.call()` 方法，下面的例子就用这种方法来返回任意对象所属的类：

```js
function classOf(o) {
    if (o === undefined) return 'undefined';
    if (o === null) return 'null';
    return Object.prototype.toString.call(o).slice(8, -1);
}

classOf(1); // => "Number"
classOf('1'); // => "String"
classOf(true); // => "Boolean"
classOf(null); // => "null"
classOf(undefined); // => "undefined"
classOf(new Date()); // => "Date"
classOf(new Array()); // => "Array"
classOf(new Object()); // => "Object"
classOf(/./); // => "RegExp"
function f() {};
classOf(new f()); // => "Object"
classOf(() => {}); // => "Function"
```

有了这个函数，就能够查询任意值的类型了。对于字符串、数字和布尔值这三种原始数据类型，其实是通过这些类型的变量调用的 `toString()` 方法，而不是通过它们的直接量调用的，因为 JavaScript 本身不允许直接量这样调用。这个函数还处理了 null 和 undefined 这两种特殊类型。`Array` 和 `Date` 这样通过内置构造函数创建的对象，其类属性与构造函数名称相匹配（相同）。宿主对象通常也有一些有意义的类属性，不过和具体的实现有关。由对象直接量或者 `Object.create` 创建的对象，其类属性是 `Object`。由自定义构造函数所创建的对象，其类属性也是 `Object`：因此对于自定义的类而言，没有办法通过类属性来区分对象的类。

### 可扩展性

该属性表示是否可以给对象添加新属性。

在 ES3 中，所有的内置对象和自定义对象都是显示可扩展的，宿主对象则由其具体实现决定。在 ES5 中，除了被转换为不可扩展的对象，所有的内置和自定义对象都是可扩展的；宿主对象依然由其具体实现决定。

ES5 中定义了查询/设置对象可扩展性的函数：`Object.isExtensible()`。另外，`Object.preventExtensions()` 能够将参数对象转换为不可扩展。注意：转换为不可扩展的操作是不可逆的！也就是无法再转换成可扩展。不过 `preventExtensions()` 只影响对象本身的可扩展性，不会影响其原型链上其它对象的可扩展性，所以通过给对象的原型添加属性，能够变相地扩展该对象。

可扩展性的作用是将对象锁定在某种状态，避免外界的干扰。可扩展性常常与可配置性和可写性配合使用。

`Object.seal()` 和 `Object.preventExtensions()` 有些相似，但更为强大：它不仅将对象设置为不可扩展，还将对象所有自有属性设置为不可配置。也就是不能给对象添加新属性，已有的属性也不能删除或配置，不过可写属性依然可以设置（配置和设置有什么区别？前面讲过配置，就是修改，但设置又是什么？）。用 `Object.seal()` 封闭了的属性是无法解封的。`Object.isSealed()` 可以检测对象是否封闭。

`Object.freeze()` 相比 `Object.seal()` 则更加严格了：不仅将对象设置为不可扩展、自有属性不可配置，还将所有的自有数据属性设置为只读——所以函数名是 `freeze`（对象的存取器属性有 `setter` 方法的话，存取器属性则不受影响，依然可以通过给属性赋值来调用它们）。可以用 `Object.isFrozen()` 检测对象是否冻结。

`Object.preventExtensions()`、`Object.seal()` 和 `Object.freeze()` 都会将传入的对象返回，因此可以嵌套调用这些方法：

```js
// 创建了一个封闭的对象，包括一个冻结的原型和一个不可枚举的属性
var o = Object.seal(Object.create(Object.freeze({ x: 1 }), {y: { value: 2, writable: true}}));
```

### 序列化对象

序列化（serialization）：将对象的状态转换为字符串。当然了，字符串也可以还原为对象。

ES5 所提供的内置函数 `JSON.stringify()` 和 `JSON.parse()` 分别用来序列化和还原 JavaScript 对象，这两种方法都用 JSON 作为数据交换格式。

```js
o = { x: 1, y: { z: [false, null, '']}};
s = JSON.stringify(o); // => "{"x":1,"y":{"z":[false,null,""]}}"
p = JSON.parse(s); // => p 是 o 的深拷贝
```

JSON 支持对象、数组、字符串、有穷大数字、true、false 和 null，这些对象可以被序列化和还原。

日期对象会被序列化为 ISO 格式的日期字符串，但无法还原成原始的日期对象，而是依然保留字符串形态。

函数、RegExp、Error 对象和 undefined 不能被序列化和还原。

`JSON.stringify()` 只能序列化对象可枚举的自有属性，其余不能序列化的属性，在序列化后的输出字符串中会将其省略掉。

`JSON.stringify()` 和 `JSON.parse()` 都接收第二个可选参数，通过传入需要序列化或还原的属性列表，来自定义序列化或还原操作。

```js
var a = JSON.stringify({ x: 1 }); // => a: "{"x":1}"
var b = JSON.parse(a); // => b: {x: 1}
var c = JSON.stringify(new Date()); // => c: ""2017-11-04T08:25:59.683Z""
var d = JSON.parse(c); // => d: "2017-11-04T08:25:59.683Z"
```

## 对象方法

所有的 JavaScript 对象都从 `Object.prototype` 继承属性（除了那些不通过原型显式创建的对象），继承的这些属性主要是方法。前面已经讨论过 `hasOwnProperty()`、`propertyIsEnumerable()` 和 `isPrototypeOf()` 这三个方法，以及在 Object 这个构造函数里定义的静态函数 `Object.create()` 和 `Object.getPrototypeOf()` 等。本节将对定义在 `Object.prototype` 中的对象方法进行讲解，一些特定的类会重写这些方法。

### `toString()` 方法

该方法无参数，返回的是调用这个方法的对象的值的字符串。需要将对象转换为字符串的时候，JavaScript 都会调用这个方法，比如在用 `+` 运算符连接一个字符串和一个对象时，或者在希望使用字符串的方法中使用了对象时。

该方法在默认情况下的返回值，信息量非常少：

```js
var s = { x: 1, y: 1 }.toString(); // => s: "[object Object]"
```

由于默认的 `toString()` 并不会输出多少有用的信息，所以很多类都会自定义 `toString()`。比如数组转换为字符串之后，结果就是数组元素组成的列表。函数转换为字符串之后，就是函数的源代码。

```js
[1, 2, [3, 4, 5]].toString(); // => "1,2,3,4,5"
(function f() { return x + y; }).toString(); // => "function f() { return x + y; }"
```

### `toLocaleString()` 方法

所有的对象还都会包含 `toLocaleString()` 方法：返回一个表示该对象的本地化字符串。`Object` 中默认的 `toLocaleString()` 方法并不做任何额外操作，只是调用 `toString()` 方法并返回对应值。`Date` 和 `Number` 类对 `toLocaleString()` 方法做了自定义，可以对数字、日期和时间做本地化的转换。`Array` 类的 `toLocaleString()` 方法和 `toString()` 方法很像，唯一不同的是每个数组元素都会调用 `toLocaleString()` 方法转换为字符串，而不是调用各自的 `toString()` 方法。

```js
new Date().toLocaleString() // => "11/4/2017, 4:58:27 PM"
1E3.toLocaleString() // => "1,000"
[1, 2, [3, 4, 5]].toLocaleString(); // => "1,2,3,4,5"
```

### `toJSON()` 方法

实际上 `Object.prototype` 没有定义 `toJSON()` 方法，不过对于需要序列化的对象来说，`JSON.stringify()` 方法会调用 `toJSON()` 方法。如果需要序列化的对象存在这个方法，就会调用它，返回值就是序列化之后的结果，而不是原始的对象了。

```js
new Date().toJSON(); // => "2017-11-04T10:16:19.305Z"
```

### `valueOf()` 方法

该方法和 `toString()` 方法非常相似，但一般是需要将对象转换为某种非字符串的原始值时才会调用它，尤其是转换为数字的时候。在需要使用原始值的上下文中使用了对象时， JavaScript 就会调用该方法。另外有些内置类还自定义了 `valueOf()` 方法。

```js
new Date().valueOf(); // => 1509790841639
```
