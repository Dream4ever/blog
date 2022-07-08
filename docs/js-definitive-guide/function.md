---
sidebar_position: 7
---

# 函数

函数的形参叫 `parameter`，实参叫 `argument`。

函数调用时除了实参，还会有本次调用的上下文（`context`），也就是 `this` 关键字的值。

如果函数作为属性挂载在对象上，那这样的函数就叫做对象的方法（`method`）。通过对象调用这个函数时，对象就是这次调用的上下文，也就是函数中 `this` 的值。（TODO: 非函数类型的对象，是否有 `this` 呢？）

用于初始化新建对象的函数叫做构造函数（比如 `new Array()`）。

在 JavaScript 中，一切皆对象，函数自然也不例外。可以把函数赋值给变量，也可以作为参数传递给其它函数。因为函数就是对象，所以可以给他们设置属性，甚至可以调用他们的方法（函数的方法）。（TODO: Promises 中的 then 是不是就是如此？）

嵌套在其它函数定义内的函数，可以访问被定义时所处的作用域中的任何变量，这就构成了一个闭包。

## 函数定义

定义函数的标准格式：`function funcName() {}`，其中 `funcName` 是函数名称标识符。

```js
// 函数定义表达式可以包含名称，从而可以定义递归调用的函数
var f = function fact(x) { if (x <= 1) return 1; return x * fact(x - 1); };
```

函数声明语句和函数定义表达式的区别：

- 对函数声明语句来说，其实是声明了一个变量，然后把函数对象赋值给它。但是对函数定义表达式来说，并没有声明一个变量。倒是可以像上面的阶乘函数一样给函数命名，这样的话，函数的局部作用域会包含一个绑定到函数对象的名称，其实函数的名称就成了函数内的局部变量了。不过一般来说，用表达式方式定义函数时不需要名称，能让代码更紧凑，很适合用来定义只用到一次的函数。
- 函数声明语句中的函数名是一个变量名，变量指向函数对象。和通过 `var` 声明的变量一样，函数声明语句所定义的函数被显式地“提前”到了脚本或函数的顶部，因此它们在整个脚本或函数里都是可见的。
- 用 `var` 声明的函数定义表达式，只有变量声明被提前了，变量赋值并没有提前。因此用这种方式定义的函数，在定义之前是无法调用的。

函数声明语句并不是真正的语句，只是 ECMAScript 规范允许它们作为顶级语句。它们可以出现在全局代码里，或内嵌在其它函数中，但是不能出现在循环、条件判断，或者 `try/catch/finally` 以及 `with` 语句中。但是函数定义表达式无此限制，可以出现在代码的任何地方。

## 函数调用

函数体中的代码在定义时并不会执行，只有在调用该函数的时候才会执行，下面是四种调用函数的方式：

- 作为函数
- 作为方法
- 作为构造函数
- 通过函数的 `call()` 和 `apply()` 方法间接调用

### 函数调用

对普通的函数调用来说，`return` 语句的返回值就是函数的返回值，如果没值或者没有 `return`，则返回值就是 `undefined`。

在非严格模式中，调用上下文（`this` 的值）是全局对象，严格模式下则是 `undefined`。

虽然函数形式的调用一般不会用到 `this` 关键字，但是可以用它来判断当前是否为严格模式。

```js
var strict = (function() { return !this; })();
```

### 方法调用

方法调用和函数调用的一个重要区别就是调用上下文：方法调用的调用上下文是主调对象，比如 `o.m(x, y)` 中的 `o` 就是方法 `m` 的调用上下文。

```js
var calculator = {
    operand1: 1,
    operand2: 1,
    add: function () {
        this.result = this.operand1 + this.operand2; // TODO: 这算是隐式地新增了一个属性 result？
    }
};
calculator.add();
calculator.result // => 2
```

方法调用也可以用方括号来访问属性：

```js
o["m"](x, y); // => 等价于 o.m(x, y)
a[0](z) // => a[0] 是一个函数
```

方法调用还可以包含更复杂的属性访问表达式：

```js
f().m() // => f() 调用结束后，再调用返回值中的方法 m()
```

**方法和 `this` 关键字是面向对象编程的核心**。作为方法调用的函数都会传入一个隐式的实参——也就是调用这个方法的对象。

方法链：方法的返回值是对象时，这个对象可以再次调用它的方法，在这样的方法链中，每次的调用结果都是另一个表达式的组成部分，比如 `$("#id").map(() => this.id).get().sort()`。方法不需要返回值的时候，尽量直接返回 `this`。

**注意**：方法的链式调用和构造函数的链式调用是不同的。TODO: 后面可以就这两个概念进行区分。

`this` 是关键字，只能读取，不能赋值。

关键字 `this` 和变量不一样，它没有作用域：嵌套在内部的函数不会继承外部函数的 `this`。如果嵌套函数作为方法被调用，`this` 依然是调用它的对象；如果作为函数被调用，`this` 要么是全局对象（非严格模式）要么是 `undefined`。嵌套在内部的函数如果想访问外部函数的 `this`，外部函数就需要事先保存其 `this` 的值。

```js
var o = {
    m: function () {
        var self = this; // 保存 this 的值
        console.log(this === o); // 检查 this 是否为对象 o
        f();

        function f() { // 定义嵌套函数
            console.log(this === o); // => false: this 没有继承，值是全局变量或者 undefined
            console.log(self === o); // => true: self 是外部函数的 this 的值
        }
    }
};
o.m();
```

### 构造函数调用

带关键字 `new` 调用的方法或者函数，就是构造函数调用。

如果构造函数没有形参，调用的时候是可以省略实参列表和圆括号的，所以下面两行代码等价：

```js
var o = new Object(); // => {}
var o = new Object; // => {}
```

构造函数调用会创建一个新的空对象，对象继承自构造函数的 `prototype` 属性。构造函数初始化这个新对象，并用它做调用上下文，所以构造函数可以用 `this` 引用这个新对象，也就是说，`new o.m()` 中，调用上下文并不是 `o` 而是构造函数 `m()` 所新建的对象。

构造函数的返回值永远是新建的对象：

- 构造函数一般是用来初始化新对象的，所以通常用不到 `return` 关键字，这种时候，构造函数调用表达式的返回值就是这个新对象的值。
- 如果构造函数显示地用 `return` 返回一个对象，返回值就是这个对象。如果用 `return` 但没有指定返回值，或者返回一个原始值，则原始值将被忽略，依然将对象作为返回值。

### 间接调用

JavaScript 中的函数也是对象，自然也可以包含方法。`call()` 和 `apply()` 这两个方法就可以用来间接调用函数。

这两个方法都可以显式指定调用时 `this` 的值，也就是任何函数都可以作为任何对象的方法被调用，即使这个函数不是对象的方法也没关系。

`call()` 方法使用自有的实参列表作为函数的实参，`apply()` 则需要以数组形式传入实参。

## 函数的实参和形参

JavaScript 的函数定义并不指定形参的类型，调用时也不检查实参的类型，甚至不检查传入形参的个数。

### 可选形参

函数调用时传入的实参比声明时指定的形参个数要少的时候，其余的形参的值都为 `undefined`。为了让形参有良好的适应性，应该给省略的参数赋一个合理的默认值：

```js
function getPropertyNames(o, /* optional */ a) {
    if (a === undefined) a = []; // 如果未定义，则定义新数组
    for (var property in o) a.push(property);
    return a;
}

var o = { x: 1, y: 2, z: 3 };
var a = getPropertyNames(o); // => ["x", "y", "z"]
var p = { a: 'a', b: 'b', c: 'c' };
getPropertyNames(p, a); // => ["x", "y", "z", "a", "b", "c"]
```

上面代码中的 `if` 语句，还可以改写成：`a = a || []`。在这里，由于 `a` 是作为形参传入的，相当于 `var a`，已经被声明了，所以才能这样用。

用这种可选实参来设计函数的时候，可选实参一定要放在实参列表的最后，因为 JavaScript 本身只会按实参传入的顺序依次赋值给形参。对于可选实参，可以传入 null 或者 undefined 作为占位符。

### 可变长的实参列表：实参对象

上面讲了调用函数时传入的实参数量比函数定义时的形参数量少的情况，下面再讲讲实参比形参多的情况。对于这种情况，普通的方式无法获取到多出来的实参的信息，这个时候就要用实参对象了。在函数体中，标识符 `arguments` 是指向实参对象的引用。因为实参对象是一个**类数组对象**，这样通过下标就可以访问各个实参了，而不用担心实参比形参多导致没法通过名字来得到实参了。

下面就是实参对象的示例用法：

```js
function f(x, y, z) {
  if (arguments.length !== 3) throw new Error;
  // ...
}
```

不过实际上用不着这样做，因为 JavaScript 默认会处理好各种事情：没有传入的实参都是 `undefined`，多余的实参也会自动忽略（TODO: 忽略是指什么意思？没法通过形参访问多余的实参？）。

**注意**：如果传入函数的参数为对象，在函数内直接修改对象的话，外部的对象的值也会同步更改；如果传入的是原始值，则不会有这种情况。TODO: 这个知识点值得单独拿出来进行讨论。

实参对象的一个重要用途，就是可以让函数操作任意数量的实参：

```js
function max(/* ... */) {
  var max = Number.NEGATIVE_INFINITY;
  for (var i = 0; i < arguments.length; i++)
    if (arguments[i] > max) max = arguments[i];
  return max;
}

var largest = max(1, 10, 100, 2, 3, 1000, 4, 5, 10000, 6); // => 10000
```

这种可以接收任意个实参的函数，也叫做不定实参函数 ( varargs function )。

对于不定实参函数，参数的个数最好不要是 0。`arguments[]` 对象适用的函数，是包含固定个数已命名的必需参数，且跟着不定个可选实参的函数。

一定要注意，`arguments` 并不是数组，而是实参对象。它其实就是个对象，只是碰巧可以用数字索引而已。

实参对象还有一个特殊的性质：在非严格模式中，如果函数定义了形参，那么这个 **类数组** 的实参对象中的各个元素就是形参所对应实参的别名。形参的名称，和实参对象的数组元素，就是相当于同一个变量的两个名称而已。通过形参名称和 `arguments` 都可以改变参数的值：

```js
function f(x) {
  console.log(x); // 输出实参的初始值
  arguments[0] = null; // 修改实参数组的元素也会修改 x 的值
  console.log(x); // => null
}
```

如果实参对象只是个普通数组的话，上面第二次输出的结果就不会是 `null` 了。在上面的例子中，`arguments[0]` 和 `x` 指向的是同一个值，修改其中一个就会影响另一个。

在 ES5 的严格模式中，实参对象的这种特性被移除了。而且，在严格模式中，`arguments` 是关键字，是和 `if`、`var` 一样的关键字了。

#### 实参对象的 `callee` 和 `caller` 属性

在 ES5 严格模式中没法使用这两个属性，在非严格模式中，`callee` 指的是当前正在执行的函数，`caller` 指的则是调用当前正在执行函数的函数。通过 `caller` 可以访问调用栈，而 `callee` 则可以在匿名函数中递归地调用自身。

```js
var factorial = function (x) {
  if (x <= 1) return 1;
  return x * arguments.callee(x - 1);
}
```

### 将对象属性用作实参

如果函数的参数多了，又要记住每个参数的含义，又要记住各个参数的顺序，岂不是很麻烦？这个时候，就可以把函数改进一下，把参数包裹在一个对象里面，传参的时候只传一个对象，岂不皆大欢喜？

```js
function sepeParams(name, email, tel, mobile, wechat) { ... }
function packParams(contact) { ... }
```

上面两个函数，哪个用起来更方便，一看便知吧？

### 实参类型

JavaScript 没法限制形参的类型，传入实参时，语言本身也没有类型检查机制。变通的方法，或者是采用语义化的单词来给参数命名，或者给参数补充注释。

由于 JavaScript 在一些情况下会执行类型转换，比如函数接收一个字符串参数，如果传入的实参不是字符串，那么 JavaScript 会自动转换成字符串，并且这个过程一般不会报错。可如果函数需要一个数组，却传入一个原始值呢？

一种方法，就是对传入的参数执行严格的类型检查，并且对于所有非预期的参数类型给予准确的提示（报错）。在传参阶段的报错远比执行阶段的报错容易处理。

```js
function sum(a) {
  if (isArrayLike(a)) {
    var total = 0;
    for (var i = 0; i < a.length; i++) {
      var element = a[i];
      if (element == null) continue; // 跳过 null 和 undefined
      if (isFinite(element)) total += element;
      else throw new Error("sum(): elements must be finite numbers");
    }
    return total;
  }
  else throw new Error("sum() : argument must be array-like");
}
```

另一种方法，则是先尽量对传入的参数进行可能的转换，所有尝试都失败之后，再报错给用户，这样函数的灵活性就更强了。

```js
function flexisum(a) {
  var total = 0;
  for(var i = 0; i < arguments.length; i++) {
    var element = arguments[i], n;
    if (element == null) continue; // 忽略 null 和 undefined 实参
    if (isArray(element)) // 实参是数组的话
      n = flexisum.apply(this, element); // 就递归累加
    else if (typeof element === 'function') // 否则如果是函数
      n = Number(element()); // 执行函数并对结果做类型转换
    else
      n = Number(element); // 否则直接类型转换
    if (isNaN(n)) // 转换失败就报错
      throw Error("flexisum(): can't convert " + element + " to number");
    total += n; // 否则就累加
  }
}
```

## 作为值的函数

函数最重要的特性，是它可以被定义，还可以被调用。在 JavaScript 中，函数不仅是语法，它也是值。这样一来，就可以把函数赋值给变量，可以把它保存在对象属性或者数组元素中，还可以作为参数传入到别的函数中。

为了理解上面所说的“函数不仅是语法，它也是值”，先来看看下面这个函数定义：

```js
function square(x) { return x * x; }
```

上面的函数定义创建了一个函数对象，并把它赋给变量 `square`。函数的名称其实无关紧要，它只不过是指向函数对象的一个变量名而已。这个函数对象也可以赋给另一个变量，这两个变量用起来是一样的：

```js
var s = square; // square 和 s 指向同一个函数对象
square(4); // => 16
s(4); // => 16
```

函数对象不仅可以赋给变量，还可以赋给对象属性。前面讲过，作为对象属性的函数就叫方法。

```js
var o = {square: function(x) { return x*x; }}; // 对象的属性值是函数
var y = o.square(4); // => 16
```

函数没有名字也完全 OK：

```js
var a = [function(x) { return x*x; }, 20]; // 数组元素是没有名字的函数
a[0](a[1]); // => 400
```

最后这种函数的格式可能看着还挺怪，但它也是完全合法的函数调用表达式。

下面的示例就演示了作为值的函数可以怎么用：

```js
// 定义四个简单的函数
function add(x, y) { return x + y; }
function subtract(x, y) { return x - y; }
function multiply(x, y) { return x * y; }
function divide(x, y) { return x / y; }

// 下面的函数接受函数作为参数，并且在函数内部将两个实参函数作为操作数传入另一个实参函数并执行
function operate(operator, operand1, operand2) {
  return operator(operand1, operand2);
}

// 下面的函数调用，计算的就是 (2 + 3) + (4 * 5) = 25
var i = operate(add, operate(add, 2, 3), operate(multiply, 4, 5));

// 这次把函数定义为对象的属性
var operators = {
  add: function (x, y) { return x + y; },
  subtract: function (x, y) { return x - y; },
  multiply: function (x, y) { return x * y; },
  divide: function (x, y) { return x / y; },
  pow: Math.pow // 预定义的函数也可以作为对象的属性值
};

// 在对象中查找第一个参数所对应的属性名，找到之后将后两个参数传入属性名所对应的函数并执行
function operate2(operation, operand1, operand2) {
  if (typeof operators[operation] === 'function')
    return operators[operation](operand1, operand2);
  else throw 'unknown operator';
}

// 计算的就是 ('hello' + ' ' + 'world')
var j = operate2('add', 'hello', operate2('add', '', 'world'));
// 用预定义函数计算
var k = operate2('pow', 10, 2);
```

`Array.sort()` 这个方法也是函数作为值的一个很好的例子。因为可以用各种方式来对数组进行排序，所以 `sort()` 方法接受一个可选函数作为参数，用来决定应该如何排序。这个可选函数接受两个参数，并且返回一个值，这个值决定了哪个参数排在前面哪个排在后面。这样一来，`sort()` 方法的扩展性就非常强了，可以根据任何需求来进行排序。

### 自定义函数属性

在 JavaScript 中，函数是一种特殊的对象，也就意味着函数也可以有自己的属性。如果函数要用到一个每次调用时都保持不变的“静态”变量，给函数定义一个属性肯定比定义一个全局变量要好多了。比如说要让函数每次被调用时返回一个唯一的整数，同时函数每次调用时返回的值还不能相同，那么函数就需要记录它之前每次所返回的值，并且这些值应当在每次函数调用中都保存下来/持久化（persist）。虽然可以把这个值保存在一个全局变量中，但是这个值只有函数才会用到，所以还是保存为函数对象的属性更合适。下面的示例，就演示了一个每次调用时返回不同值的函数：

```js
// 因为函数声明语句的作用域会被提升至文件顶部
// 所以可以在函数声明之前就为函数对象的属性赋值
uniqueInteger.counter = 0;

function uniqueInteger() {
  return uniqueInteger.counter++;
}

uniqueInteger(); // => 0
uniqueInteger(); // => 1
uniqueInteger(); // => 2
uniqueInteger(); // => 3...
```

再来看个例子：下面这个函数 `factorial()` 把自己看成是个数组，利用自身的属性来缓存前一次的计算结果。

```js
function factorial(n) {
  // 有限大的正整数
  if (isFinite(n) && n > 0 && n === Math.round(n)) {
    // 如果没有缓存结果则进行计算，用数组索引是否存在来判断
    if (!(n in factorial)) {
      // 计算并缓存结果
      factorial[n] = n * factorial(n - 1);
    }
    return factorial[n];
  } else {
    // 输入参数不合法，直接返回 NaN
    return NaN;
  }
}
// 初始化阶乘的初值，用于更大阶乘的计算
factorial[1] = 1;
```

## 作为命名空间的函数

在前面的章节讲过函数作用域：在函数体内定义的变量，只能在函数体内（及嵌套在该函数内部的函数体内）课件，在函数之外是不可见的。在所有函数之外定义的变量则是全局变量，在整个 JavaScript 程序中都是可见的。在不是函数的普通代码块内声明的变量，是没办法让它只在这段代码块内可见的，所以可以通过定义函数来创建一个临时的命名空间，这样在其内部定义的变量就不会污染全局命名空间了。

比如想要写一个 JS 模块，这个模块会用在各种地方，在这个模块中需要定义一个变量，来保存计算时的中间结果。如果不把模块定义在函数中的话，就没法确保所定义的这个变量不会和用到这个模块的代码相冲突。这样一来，把这个模块定义成函数自然就可以解决这个问题了。

```js
function module() {
  // do something
}
module();

(function() {
  // do something
}());
```

在上面的代码中，第一种函数声明语句通过定义函数的方式来实现模块。第二种方式更为轻巧，定义一个匿名函数然后立刻调用它，这种方式用得也很普遍。`function` 关键字左边的圆括号，会让 JavaScript 认为括号里面的是 **函数定义表达式** 而不是 **函数声明语句**，这样就会立刻执行表达式并且返回计算结果。

下面的示例定义了一个匿名函数并将执行结果赋给变量 `extend`。执行结果 `extend` 也是一个函数，用于处理传入该函数的参数，将第二个及之后的参数的属性全都复制到第一个参数中。

```js
var extend = (function() {
  for (var p in { toString: null }) {
    return function extend(o) {
      for (var i = 1; i < arguments.length; i++) {
        var source = arguments[i];
        for (var prop in source) o[prop] = source[prop];
      }
      return o;
    };
  }

  return function patched_extend(o) {
    for (var i = 1; i < arguments.length; i++) {
      var source = arguments[i];
      for (var prop in source) o[prop] = source[prop];

      for (var j = 0; j < protoprops.length; j++) {
        prop = protoprops[j];
        if (source.hasOwnProperty(prop)) o[prop] = source[prop];
      }
    }
    return o;
  };

  var protoprops = ['toString', 'valueOf', 'constructor',
    'hasOwnProperty', 'isPrototypeOf',
    'propertyIsEnumerable', 'toLocaleString'];
}());

```

## 函数属性、方法和构造函数

在 JavaScript 中，函数是值，对函数使用 `typeof` 操作符，返回结果是 `function` 这个字符串。但函数其实是一种特殊的对象，所以它也可以拥有自己的属性和方法。`Function()` 构造函数还可以用来创建新的函数对象。

### length 属性

在函数体中，`arguments.length` 指的是传入函数的实参的数量，但是函数本身的 `length` 属性则指的是定义函数时的形参的数量，是只读属性。

下面定义的函数 `check()`，检查函数的形参数量 `arguments.callee.length` 和实参数量 `arguments.length` 是否相等，如果不相等则抛出异常。

```js
function check(args) {
  var actual = args.length;
  var expected = args.callee.length;
  if (actual !== expected) {
    throw Error('Expected ' + expected + 'args; got ' + actual);
  }
}

function f(x, y, z) {
  check(arguments);
  return x + y + z;
}
```

### prototype 属性

每个函数都有 `prototype` 属性，这个属性指向原型对象（prototype object），每个函数的原型对象也各不相同。把函数当构造函数使用的时候，新建的对象就会继承原型对象的属性。

在前面的章节讲过原型和 `prototype` 属性，在后面的章节也会继续深入探讨。

### `call()` 和 `apply()` 方法

可以把 `call()` 和 `apply()` 看作是对象的方法，通过调用方法的形式来间接调用函数。传入这两个方法的第一个参数是被间接调用的函数的对象，也是函数的调用上下文，在函数体内用 `this` 来引用。

这两个方法的使用方式如下：

```js
f.call(o);
f.apply(o);
```

上面的代码等价于：

```js
o.m = f;    // 将函数 f 临时存储为 o 的方法 m
o.m();      // 调用这个临时方法
delete o.m; // 删除临时方法
```

在 ES5 的严格模式中，不管传入这两个方法的第一个参数是什么，它都是被间接调用的函数内的 `this` 的值。而在 ES5 的非严格模式，和 ES3 中，传入的第一个参数是 null 或者 undefined 的话，就会自动替换为全局对象，其它原始值则会被对应的包装对象所替代。

对于 `call()` 方法来说，第一个实参之后的所有参数都会被传入函数，`f.call(o, 1, 2)` 就向函数 `f` 中传入了两个数字 1 和 2。

而对于 `apply()` 来说，所传入的实参都在第二个数组实参中：`f.apply(o, [1, 2])`。这第二个参数，可以是实际的数组，也可以是类数组对象。这样一来，就可以把一个函数的实参对象 `arguments` 传入 `apply()` 来让另一个函数调用。

```js
// 把对象 o 中的方法 m 替换为另一个方法
// 在调用原来的方法之前和之后输出日志
function trace(o, m) {
  var original = o[m];  // 在闭包中保存原始的方法
  o[m] = function() {   // 定义新的方法
    console.log(new Date(), 'Entering:', m);      // 输出日志
    var result = original.apply(this, arguments); // 调用原始函数
    console.log(new Date(), 'Exiting:', m);       // 输出日志
    return result;                                // 返回结果
  }
}
```

上面的函数 `trace()` 接收两个参数：一个对象和一个方法名，将指定的方法替换为一个新方法，新方法是一个 **包裹** 了原始方法的泛函数（特指一种变换，以函数为输入，输出可以是值，也可以是另一个函数）。这种动态修改现有方法的做法，可以叫做 **monkey-patching**。

这两个方法的意义是什么？它俩可以自定义函数的调用上下文，也就是函数体内的 `this`。

相关阅读：

- [context to use call and apply in JavaScript?](https://stackoverflow.com/questions/8659390/context-to-use-call-and-apply-in-javascript)
- [The reason to use JS .call() method?](https://stackoverflow.com/questions/9001830/the-reason-to-use-js-call-method)

### `bind()` 方法

该方法顾名思义，主要是用来把函数绑定到对象上。将 `bind()` 以函数 f 的方法的形式调用，并且传入一个对象 o 作为参数之后，就会返回一个新的函数 g。以方法的形式调用新的函数 g，就会将原来的函数 f 作为对象 o 的方法来调用，也就是说，对象 o 是原函数 f 的调用上下文。所有传入新函数 g 的实参都会原封不动地传入原函数 f。

```js
function f(y) { return this.x + y; }  // 需要绑定的函数
var o = { x: 1 };                     // 将与之绑定的对象
var g = f.bind(o);                    // 调用 g(x) 的时候其实在调用 o.f(x)
g(3);                                 // => 4
```

前面刚讲过 `call()` 和 `apply()` 方法，那么想要实现同样的功能其实很简单：

```js
function bind(f, o) {
  if (f.bind) return f.bind(o);
  return function() {
    return f.apply(o, arguments);
  }
}
```

在 ES5 中的 `bind()` 方法实际上并不只是把函数绑定到对象上，它还把第二个及之后的实参跟 `this` 绑定在一起。这是一种常见的函数式编程的技巧，叫做柯里化。

```js
var sum = function(x, y) { return (this.x || 0) + y; };
var succ1 = sum.bind({ x: 1}, null);  // 第一个参数 { x: 1 } 作为 this 传入 sum，第二个参数 null 就是实参 x 的值
succ1(4);                             // => 5: 实参 y 的值为 4
var succ2 = sum.bind(null, { x: 1});  // 第一个参数 null 作为 this 传入 sum，第二个参数 1 就是实参 x 的值
succ2(4);                             // => 5: 实参 y 的值为 4
```

ES3 的 `bind()` 方法可以用下面的代码进行模拟，代码中把方法保存为 `Function.prototype.bind`，这样所有的函数对象就都会继承它了。

```js
if (!Function.prototype.bind) {
  Function.prototype.bind = function(o /*, args */) {
    var self = this, boundArgs = arguments;

    return function() {
      var args = [], i;
      for(i = 1; i< boundArgs.length; i++) args.push(boundArgs[i]);
      for(i = 0; i< arguments.length; i++) args.push(arguments[i]);

      return self.apply(o, args);
    }
  }
}
```

上面自定义的 `bind()` 方法返回的函数是一个闭包，用到了外部函数内定以的 `self` 和 `boundArgs` 变量。

ES5 版本 `bind()` 方法的一些特性是上面的 ES3 版本没法模拟的。

- 首先，ES5 中的方法所返回的函数对象具有 `length` 属性，这个属性的值等于所绑定函数的形参数量减去形参数量（但不会小于 0）(TODO: 没大看懂……）。
- 其次，该方法还可以用作构造函数。如果把 `bind()` 返回的函数当作构造函数来用，那么就会忽略掉传给 `bind()` 的 `this` 的值，并将原始的函数当作构造函数来调用，同时将传入的实参原样传给原始函数(TODO: 没大看懂……）。
- 另外，该方法返回的函数没有 `prototype` 属性（普通函数的这个属性是删不掉的），那么把绑定的函数当作构造函数来用的话，所创建的对象就会继承原始函数的 `prototype` 属性。
- 最后，跟 `instanceof` 运算符一起用的话，绑定的构造函数和未绑定的构造函数是一样的。

那么，`bind()` 方法的意义又是什么呢？一方面，它可以像 `call()` 和 `apply()` 一样，自定义函数的调用上下文；另一方面，它还可以把函数柯里化！这样一来，就可以实现函数式编程了，这个概念也会在后面继续展开。

相关阅读：

- [JavaScript’s Apply, Call, and Bind Methods are Essential for JavaScript Professionals | JavaScript is Sexy](http://javascriptissexy.com/javascript-apply-call-and-bind-methods-are-essential-for-javascript-professionals/)

### `toString()` 方法

函数跟别的对象一样，也有 `toString()` 方法。ES 规范规定这个方法返回一个字符串，并且字符串和函数声明语句的语法相关(TODO: 没大看懂……）。

大部分情况下，这个方法返回的都是函数完整的源代码，不过内置的函数会把 `[native code]` 之类的字符串作为函数体返回。

### `Function()` 构造函数

在前面定义函数的时候，不管是函数声明语句，还是函数定义表达式，用的都是 `function` 关键字。但是！也可以用 `Function()` 这个构造函数来定义函数。

```js
var f = new Function('x', 'y', 'return x * y;');
var f = function(x, y) { return x * y; }
```

上面两种方式所定义的函数 f 基本上差不多。`Function()` 构造函数接受任意个字符串作为实参，最后一个实参就是函数体，实参由 JavaScript 语句组成，语句之间用分号分割。之前的所有实参都是所定义函数的形参。如果需要定义一个不接受参数的函数，那就只给构造函数 `Function()` 传一个字符串就行，也就是函数体。

跟函数表达式一样，`Function()` 构造函数创建的是匿名函数，所传入的参数没有用来定义函数名的。

有几点要注意：

- 可以用 `Function()` 构造函数在运行时动态地创建和编译函数。
- 每次调用 `Function()` 构造函数的时候，都会解析函数体并创建新的函数对象。如果在循环体内频繁调用构造函数的话，那么这个循环的性能就会很差。相比而言，循环体内的嵌套函数和函数定义表达式就只会在第一次循环时被编译。
- 最重要的一点：`Function()` 构造函数所创建的函数不会使用词法作用域，而总是作为顶层的函数被编译（TODO: 也就意味着不会产生闭包？）：

```js
var scope = 'global';
function constructFunction() {
  var scope = 'local';
  return new Function('return scope');
}

constructFunction()();  // => 'global
```

可以认为 `Function()` 构造函数就是在全局作用域中的 `eval()`，在自己的私有作用域中定义新的变量和函数。在实际开发中，谨慎使用 `Function()`。

### 可调用的对象

前面讲过类数组对象，虽然不是数组，但很多时候可以当数组来用。函数也是如此，**可调用对象** 本质上是一种对象，可以在函数调用表达式中以函数的形式调用。所有的函数都是可调用的，但并不是所有的可调用对象都是函数。

在现代的 JavaScript 环境中，在两种情况下会遇到不是函数的可调用对象：

首先，在 IE8 及更早版本中，`Window.alert()` 和 `Document.getElementById()` 之类的客户端方法是通过可调用对象实现的，而不是通过原生的函数对象来实现。这些方法的表现和在其它浏览器中是一样的，但是它们并不是函数对象。IE 从 9 开始才使用真正的函数对象，所以浏览器中的函数对象会越来越少。

另一种不是函数的可调用对象比较常见一些：那就是 RegExp 对象。在很多浏览器中可以直接调用 RegExp 对象，比调用它的 `exec()` 方法要方便。开发者编写的代码尽量不要对 RegExp 对象的可调用性有依赖，这个特性将来很可能会被废弃掉。对这类对象执行 `typeof`，有些浏览器得到的结果是 `function`（新版的 Chrome、Firefox、Edge），有些浏览器则是 `object`。

要想判断一个对象是不是正儿八经的函数对象，需要检查它的 `class` 属性：

```js
function isFunction(x) {
  return Object.prototype.toString.call(x) === "[object Function]";
}
```

这里所用的判断方式和前面讲到过的 `isArray()` 是一样的。

## 函数式编程

虽然 JavaScript 并不是 Lisp 或者 Haskell 那样的函数式编程语言，但是 JavaScript 可以像操作对象那样操作函数，这就意味着也可以用 JavaScript 实现函数式编程。 ES5 中的数组方法 `map()` 和 `reduce()` 就是函数式编程风格的。

### 用函数处理数组

假设有一个数组，想要计算它的平均值和标准差，结构化编程的代码就不用写了，各种循环，各种流程控制，看着就头大。

但是，有了 `map()` 和 `reduce()`，这个世界就清新了！

```js
var sum = function(x, y) { return x + y; };
var square = function(x) { return x * x; };

var data = [1, 1, 3, 5, 5];
var mean = data.reduce(sum) / data.length;
var deviations = data.map((x) => x - mean);
var stddev = Math.sqrt(deviations.map(square).reduce(sum) / (data.length - 1));
```

怎么样？看了上面的代码，世界是不是瞬间清晰了许多？

### 高阶函数

高阶函数接受函数作为参数，并且返回值也是函数。

```js
function not(f) {
  return function() {
    var result = f.apply(this, arguments);
    return !result;
  };
}

var even = x => x % 2 === 0;  // 判断是否为偶数
var odd = not(even);          // 判断是否为奇数
[1, 1, 3, 5, 5].every(odd);   // => true
```

上面的 `not()` 函数就是一个高阶函数，它接受函数作为参数，并且返回值也是函数。下面的 `mapper()` 函数也是一个高阶函数，它接受一个函数作为参数，所返回的函数会对数组中的每个元素应用所传入的函数。这里的重点，是要理解它和 `map()` 的区别：

```js
function mapper(f) {
  return function(a) { return a.map(f); };
}

var increment = function(x) { return x + 1; };
var incrementer = mapper(increment);
incrementer([1, 2, 3]); // => [2, 3, 4]
```

下面是一个更常见的例子：接收两个函数 f 和 g，返回一个新函数，用于计算 `f(g())`：

```js
function compose(f, g) {
  return function() {
    // 只需要给 f 传一个实参，所以用 call
    // g 需要传入实参数组，所以用 apply
    return f.call(this, g.apply(this, arguments));
  };
}

var square = function(x) { return x * x; };
var sum = function(x, y) { return x + y; };
var squareOfSum = compose(square, sum);
squareOfSum(2, 3);  // => 25
```

### 不完全函数

函数 `f` 的 `bind()` 方法返回一个新函数，这个新函数用特点的上下文和实参调用 `f`。可以认为是把函数绑定到了对象上，并且传入一部分参数。`bind()` 方法把传入的参数放在参数列表的左侧，当然也可以放在右侧，下面的三个不完全调用值得好好地体会一下：

```js
function array(a, n) {
  return Array.prototype.slice.call(a, n || 0);
}

var f = function(x, y, z) { return x * (y - z); };

function partialLeft(f /*, ...*/) {
  var args = arguments;               // => {"1":2}，外部的实参数组的值
  return function() {
    var a = array(args, 1);           // => 2，外部实参数组的第一个参数是函数 f，所以从第二个实参开始截取
    a = a.concat(array(arguments));   // => 2,3,4 内部的实参数组为 {"0":3,"1":4}，将其附在外部实参数组之后
    return f.apply(this, a);
  }
}

partialLeft(f, 2)(3, 4);              // => -2: 2 * (3 - 4)

function partialRight(f /*, ...*/) {
  var args = arguments;               // => {"1":2}，外部的实参数组的值
  return function() {
    var a = array(arguments);         // => {"0":3,"1":4}，内部的实参数组的值
    a = a.concat(array(args, 1));     // => 3,4,2 将外部实参数组附在内部实参数组之后
    return f.apply(this, a);
  }
}

partialRight(f, 2)(3, 4);             // => 6: 3 * (4 - 2)

function partial(f /*, ...*/) {
  var args = arguments;
  return function() {
    var a = array(args, 1);
    var i = 0, j = 0;
    for(; i < a.length; i++)
      if (a[i] === undefined) a[i] = arguments[j++];
    a = a.concat(array(arguments, j));// => 3,2,4
    return f.apply(this, a);
  }
}

partial(f, undefined, 2)(3, 4);       // => -6: 3 * (2 - 4)
```

有了不完全函数，就可以利用现有的函数来编写新的函数，是不是很好玩？

```js
var increment = partialLeft(sum, 1);
var cuberoot = partialRight(Math.pow, 1/3);
String.prototype.first = partial(String.prototype.charAt, 0);
String.prototype.last = partial(String.prototype.slice, -1);
```

如果再把不完全函数和高阶函数合并在一起，那就更好玩了。

```js
var not = partialLeft(compose, function(x) { return !x; });
var even = function(x) { return x % 2 === 0; };
var odd = not(even);
var isNumber = not(isNaN);
```

还可以用函数的组合和不完全函数来重新编写上面求平均数和标准差的代码：

```js
var data = [1, 1, 3, 5, 5];
var sum = function(x, y) { return x + y; };
var product = function(x, y) { return x * y; };
var neg = partial(product, -1);
var square = partial(Math.pow, undefined, 2);
var sqrt = partial(Math.pow, undefined, .5);
var reciprocal = partial(Math.pow, undefined, -1);

var mean = product(reduce(data, sum), reciprocal(data.length));
var stddev = sqrt(
  product(
    reduce(
      map(
        data,
        compose(
          square,
          partial(
            sum,
            neg(mean)
          )
        ),
        sum)
    ),
    reciprocal(
      sum(
        data.length,
        -1
      )
    )
  )
);
```

前面多次用到了嵌套函数，那么嵌套函数的实参，是否就是外部函数的实参呢？看看下面两段代码：

```js
function a1(args) {
  console.log(`outer args: ${args}`);   // => outer args: 1,2,3
  return function() {
    console.log(`inner args: ${args}`); // => outer args: 1,2,3
  };
}

a1([1, 2, 3])([4, 5, 6]); // 嵌套函数内外的 args 相同

function a2(args) {
  console.log(`outer args: ${args}`);   // => outer args: 1,2,3
  return function(args) {
    console.log(`inner args: ${args}`); // => outer args: 4,5,6
  };
}

a2([1, 2, 3])([4, 5, 6]); // 嵌套函数内外的 args 不同
```

根据上面代码的执行结果，可以判定：如果嵌套函数未传入实参，则其实参为父函数的实参列表（显然如此嘛，内部不存在的变量，肯定就要去外部找了）；如果嵌套函数传入了实参，就用传入的实参。

### 记忆

在前面的章节中，定义过一个会缓存每次计算结果的阶乘函数。在函数式编程中，这种缓存的技巧叫做“记忆”。下面定义的高阶函数 `memorize()` 就接受一个函数作为实参，然后返回这个函数带有记忆功能的版本：

```js
// 返回带记忆功能的 f
// 只有 f 的实参数组中各元素的字符串形式全不相同时才起作用
function memorize(f) {
  var cache = {};       // 在闭包中缓存值

  return function() {
    // 把实参数组转换为字符串形式，用作缓存的键
    var key = arguments.length + Array.prototype.join.call(arguments, ",");
    if (key in cache) return cache[key];
    return cache[key] = f.apply(this, arguments);
  };
}

// 只会输出一次 cache 和 key 的值
function f(num) {
  return num === 1 ? 1 : (num * f(num - 1));
}

var g = memorize(f);
g(5);

// 会输出每一次的 cache 和 key 的值
var factorial = memorize(function(n) {
  return (n <= 1) ? 1 : n * factorial(n - 1);
});

factorial(5);
```

TODO: 为什么上面定义的 `f` 记忆化之后，只会输出一次 `cache` 和 `key`？而 `factorial` 按预期的那样输出五次？
