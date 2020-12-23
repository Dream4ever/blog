---
title: "React 小书学习笔记：组件的 render 方法"
date: 2020-12-23T21:28:17+08:00
tags: ['Note 学习笔记']
draft: false
---

原文链接：[组件的 render 方法](http://huziketang.mangojuice.top/books/react/lesson7)

<!--more-->

**React 中一切皆组件** 。在编写组件的时候，一般都需要继承 `Component` 这个类。而每个组件类都必须要实现一个返回 JSX 元素的 `render` 方法。这里需要注意的是，JSX 元素最外层只能有一个，也就是只能有一个根元素，这一点和 Vue 里面的组件要求是一样的。

比如下面就是错误的写法：

```js
render() {
  return <div>
    第一个</div>
    <div>第二个</div>
}
```

得写成下面这样，React 编译才能通过：

```js
render() {
  return <div>
      <div>第一个</div>
      <div>第二个</div>
    </div>
}
```

## 插入表达式

在 JSX 中合适的位置上，都可以插入用 `{}` 包裹的表达式，`render` 会把计算后的内容渲染到页面上：

```js
render() {
  const word = 'is good'
  return <div>
      <h1>React 小书 {word}</h1>
    </div>
}
```

既然说了是可以插入表达式，那么插入函数也是可以的：

```js
render() {
  return <div>
      <h1>React 小书 {(function() { return 'is good' })()}</h1>
    </div>
}
```

表达式不只是可以用来在标签内显示文本，还可以用在标签属性上：

```js
render() {
  const className='header'
  return <div className={className}>
      <h1>React 小书</h1>
    </div>
}
```

这里设置类名用的是 `className` 而不是 `class` ，是因为 `class` 是 JavaScript 关键字。另外一个相同的场景是 `for` 属性，因为也是 JavaScript 关键字，所以在 JSX 中要用 `htmlFor` 替代，即 `<label htmlFor='male'>Male</label>` 。其他的 HTML 属性就没有这个问题，可以放心使用。


## 条件返回

既然 JSX 中可以写任意表达式，当然也可以根据不同条件返回不同的 JSX：

```js
render() {
  const isGoodWord = true
  return <div>
    <h1>
      React 小书
      { isGoodWord
          ? <strong>is good</strong>
          : <span>is not good</span>
      }
    </h1>
  </div>
}
```

如果在表达式里写了 `null` ，那么 React 会什么都不显示，结合条件返回的话，可以用来隐藏元素。

## JSX 元素变量

如果真正理解了 JSX 就是 JavaScript 对象的话，那么就可以把 JSX 元素像 JavaScript 对象那样赋值给变量，或者作为函数的参数或返回值进行使用。

```js
render() {
  const isGoodWord = true
  const goodWord = <strong> is good</strong>
  const badWord = <span> is not good</span>

  return <div>
    <h1>
      React 小书
      { isGoodWord ? goodWord : badWord }
    </h1>
  </div>
}
```
