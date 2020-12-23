---
title: "React 小书学习笔记：事件监听"
date: 2020-12-23T22:12:35+08:00
tags: ['Note 学习笔记']
draft: false
---

原文链接：[事件监听](http://huziketang.mangojuice.top/books/react/lesson9)

<!--more-->

React 中要监听事件的话，给对应的元素加上 `onClick` 、`onKeyDown` 之类的属性和对应的回调函数即可：

```js
class Header extends React.Component {
  handleClick() {
    console.log('clicked header')
  }
  render() {
    return <h2 onClick={this.handleClick}>This is Header</h2>;
  }
}
```

因为 React 已经封装了一系列的 `on*` 属性，需要让某个元素监听某种事件的时候，像上面那样添加对应属性和回调函数就行，也不需要考虑浏览器兼容问题。

在 [SyntheticEvent - React](https://reactjs.org/docs/events.html) 这个页面中，列出了 React 所支持的各类监听事件的名称。

有一点要注意，在没有做特殊处理时，**这些 `on*` 监听事件只能用在普通的 HTML 标签上，不能用在组件上** 。

## event 对象

React 将事件监听函数中的 `event` 这个浏览器原生对象也进行了封装，以便对外提供统一的 API 和属性。这个 `event` 对象是符合 W3C 标准的，具有类似 `event.preventDefault` 这种常用的方法。

这次来尝试当用户点击 HTML 元素的时候，把它的 `innerHTML` 打印出来：

```js
class Main extends React.Component {
  printInnerHTML(e) {
    console.log(e.target.innerHTML)
  }
  render() {
    return <h2 onClick={this.printInnerHTML}>This is main content</h2>;
  }
}
```

## 事件中的 this

一般来说，类的实例方法里的 `this` 指的是这个实例本身。但是如果在 React 组件里定义的方法中打印 `this` 的话，得到的却是 `null` 或者 `undefined` 。

```js
...
  printInnerHTML(e) {
    console.log(this) // => null or undefined
  }
...
```

这是因为虽然在组件里调用组件内定义的方法时，写的是 `this.printInnerHTML` 这种形式，但 React 其实是直接通过函数调用，而不是通过对象方法的方式来调用的，所以在事件监听函数内，默认是不能通过 `this` 获取到实例的。

如果想要在时间监听函数内获取到当前实例，就需要手动将实例方法 `bind` 到当前实例上，再传给 React。

```js
class Main extends React.Component {
  printInnerHTML(e) {
    console.log(this)
  }
  render() {
    return <h2 onClick={this.printInnerHTML.bind(this)}>This is main content</h2>;
  }
}
```

这里的 `bind` 会把实例方法绑定到当前实例上，然后再把绑定后的函数传给 React 的 `onClick` 事件监听。

此外，`bind` 不只是可以传入 `this` ，还可以传入别的参数：

```js
class Main extends React.Component {
  printInnerHTML(e) {
    console.log(this)
  }
  render() {
    return <h2 onClick={this.printInnerHTML.bind(this, 'hello world!')}>This is main content</h2>;
  }
}
```

这种 `bind` 模式在 React 的事件监听中非常常见，它不仅可以把事件监听方法中的 `this` 绑定到当前组件实例上，还可以在渲染列表元素的时候，帮我们把列表元素传入事件监听函数里面，这个在后面会讲到。

如果对于 JavaScript 的 `this` 模式或者 `bind` 函数的使用方法不熟悉，可以去 MDN 上补充学习相关知识：[this | MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/this)，[bind | MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_objects/Function/bind)。

## 总结

1. React 为我们包装好了 `on*` 监听事件，但默认只能用在 HTML 标签上。
2. React 支持监听函数的 `event` 对象。
3. 可通过 `bind` 将组件实例与 `this` 相绑定。
