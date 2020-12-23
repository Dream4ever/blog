---
title: "React 小书学习笔记：使用 JSX 描述 UI 信息"
date: 2020-12-23T12:22:29+08:00
tags: ['Note 学习笔记']
draft: false
---

原文链接：[使用 JSX 描述 UI 信息](http://huziketang.mangojuice.top/books/react/lesson6)

<!--more-->

用 `create-react-app` 创建本地的 React 环境之后，将 `src/index.js` 中代码关键的部分修改成下面的样子：

```js
import React, { Component } from 'react'
import ReactDOM from 'react-dom'

class Header extends Component {
  render() {
    return <div>
      <h1>React 小书</h1>
    </div>
  }
}

ReactDOM.render(
  <Header />,
  document.getElementById('root')
)
```

上面的代码整体上和前几节中的类似，一个继承了 `Component` 类的组件，里面有一个 `render` 方法返回 HTML 结构，不过这里直接返回了 HTML，而不是字符串，这种语法就叫 JSX。

## JSX 原理

```html
<div class='box' id='content'>
  <div class='title'>Hello</div>
  <button>Click</button>
</div>
```

如果用 JavaScript 的对象来表示 DOM 元素的话，每个 DOM 元素其实只包含三个信息：标签名，属性，子元素。

对于上面的 DOM 结构，可以用下面的 JavaScript 对象来表示：

```js
{
  tag: 'div',
  attrs: { className: 'box', id: 'content'},
  children: [
    {
      tag: 'div',
      arrts: { className: 'title' },
      children: ['Hello']
    },
    {
      tag: 'button',
      attrs: null,
      children: ['Click']
    }
  ]
}
```

可以看出来，HTML 和 JavaScript 可以表示同样的内容，只是方式不一样，而 JavaScript 写起来太长，又不够直观。于是 React 就把 JavaScript 的语法进行了扩展，让 JavaScript 语言能够支持这种直接在 JavaScript 里面写 HTML 结构的语法，这样就方便多了。而之后 React 则会自己把类似 HTML 的 JSX 结构转换成 JavaScript 的对象结构。

前面的 React 代码经过编译之后，发生改变的部分会变成下面这样：

```js
...
render() {
  return React.createElement(
    'div',
    null,
    React.createElement(
      'h1',
      { className: 'title' },
      'React 小书',
    )
  )
}
...

ReactDOM.render(
  React.createElement(Header, null),
  document.getElementById('root')
)
```

这里的 `React.createElement` 会创建 JavaScript 对象来描述 HTML 结构和信息，这样的代码就是合法的 JavaScript 代码了。所以使用 React 和 JSX 时一定会有编译的过程。

这里再重复一遍： **所谓的 JSX 其实就是 JavaScript 对象** 。每当在 JavaScript 代码中看到这种 JSX 结构的时候，脑袋里面可以自动转化一下，这样对于理解 React 的组件写法很有好处。

有了这个表示 HTML 结构和信息的对象后，就可以拿来构造真正的 DOM 元素，然后把 DOM 元素插入到页面上了。这也是最后的 `ReactDOM.render` 所做的事情：

```js
ReactDOM.render(
  <Header />,
  document.getElementById('root')
)
```

它其实就是渲染组件、构造 DOM 树，然后插入到页面上某个指定的元素上。

那么为什么要先把 JSX 编译成 JavaScript 对象，然后再进一步渲染成 DOM 树，而不是直接把 JSX 渲染成 DOM 树呢？

一方面是因为，这个 JSX 不一定是要渲染到常规的 HTML 页面上，有可能是渲染到 canvas 上，也有可能是渲染到手机 APP 上。所以前面才会有 `react-dom` ，类比一下，可能也会有 `react-canvas` ，而 `ReactNative` 恰好就是用来编写 APP 的。

另一方面，是因为数据变化，需要更新组件的时候，可以用比较快的算法操作 JavaScript 对象，而不用直接操作页面上的 DOM，尽量减少浏览器的重排，从而尽量优化性能。

## 总结

这一节要记住这几个点：

1. JSX 是 JavaScript 语言的一种语法扩展，长得和 HTML 一样，但并不是 HTML。
2. React 可以用 JSX 来描述组件的 HTML 结构和信息。
3. React 在编译的时候把 JSX 变成相应的 JavaScript 对象。
4. `react-dom` 接着把描述 UI 信息的 JavaScript 对象变成 DOM 元素，并渲染到页面上。
