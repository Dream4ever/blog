---
title: "前端组件化（一）：从一个简单的例子讲起"
date: 2020-12-22T21:49:37+08:00
tags: ['Note 学习笔记']
draft: false
---

<!--more-->

原文链接：[http://huziketang.mangojuice.top/books/react/lesson2](http://huziketang.mangojuice.top/books/react/lesson2)

## 最简单的点赞功能

要实现一个最简单的点赞/取消点赞功能，代码如下：

```html
<body>
  <div class="wrapper">
    <button class="like-btn">
      <span class="like-text">点赞</span>
      <span>👍</span>
    <button>
  </div>
</body>
```

```js
const button = document.querySelector('.like-btn')
const buttonText = button.querySelector('.like-text')
let isLiked = false
button.addEventListener('click', () => {
  isLiked = !isLiked
  if (isLiked) {
    buttonText.innerHTML = '点赞'
  } else {
    buttonText.innerHTML = '取消 '
  }
}, false)
```

这段功能倒是实现出来了，但是如果同事也想用这个功能，难道就只能手动把 HTML 和 CSS 复制过去么？当然不是。

## 结构复用

可以编写一个带 `render` 方法的类，方法直接返回表示 HTML 结构的字符串：

```js
class LikeButton {
  render() {
    return `
    <button class="like-btn">
      <span class="like-text">点赞</span>
      <span>👍</span>
    <button>`
  }
}
```

然后通过调用这个类来构建点赞按钮的实例，再把这些实例插入到页面中。

```js
const wrapper = document.querySelector('.wrapper')

const likeButton1 = new LikeButton()
wrapper.innerHTML = likeButton1.render()

const likeButton2 = new LikeButton()
wrapper.innerHTML += likeButton2.render()
```

这里虽然简单粗暴地用 `innerHTML` 把两个按钮插入到了 `wrapper` ，不过至少实现了代码的复用，后面再优化。

## 实现简单的组件化

现在的按钮是死的，因为根本没有添加事件，而这又是因为 `innerHTML` 里插入的只是字符串，并不是 DOM，字符串怎么可能添加事件呢？DOM 的 API 只能给 DOM 用的。

为了能够有 DOM，现在可以编写一个函数 `createDOMFromString`，往这个函数传入 HTML 字符串，再让它返回 DOM 相应的元素就可以了。

```js
// ::String => ::Document
const createDOMFromString = (domString) => {
  const div = document.createElement('div')
  div.innerHTML = domString
  return div
}
```

`LikeButton` 类也需要改写一下，让它返回一个实际可用的 DOM，并且这个 DOM 还绑定了对应的事件。

```js
class LikeButton {
  render() {
    this.el = createDOMFromString(`
    <button class="like-btn">
      <span class="like-text">点赞</span>
      <span>👍</span>
    <button>
    `)
    this.el.addEventListener('click', () => console.log('click'), false)
    return this.el
  }
}
```

因为 `LikeButton` 类返回的是 DOM，所以在插入实例的时候，也需要用 `appendChild` 这个 DOM API，而不是用 `innerHTML` 。

```js
const wrapper = document.querySelector('.wrapper')

const likeButton1 = new LikeButton()
const likeButton2 = new LikeButton()
wrapper.appendChild(likeButton1.render())
wrapper.appendChild(likeButton2.render())
```

要想让点赞按钮上面的文字随其状态而变化，那就需要改进一下代码：

```js
class LikeButton {
  constructor() {
    this.state = { isLiked: false }
  }
  
  changeLikedText() {
    const likedText = this.el.querySelector('.like-text')
    this.state.isLiked = !this.state.isLiked
    likedText.innerHTML = this.state.isLiked ? '点赞' : '取消'
  }
  
  render() {
    this.el = createDOMFromString(`
    <button class="like-btn">
      <span class="like-text">点赞</span>
      <span>👍</span>
    <button>
    `)
    this.el.addEventListener('click', this.changeLikedText.bind(this), false)
    return this.el
  }
}
```

上面的构造函数给每个 `LikeButton` 的实例添加了一个状态属性 `state` ，里面保存了每个按钮是否被点赞的状态。同时修改了点击事件绑定的函数，现在每次点击按钮会切换状态 `state` ，同时根据状态改变按钮显示的文本。

这个时候，这个组件的复用性就已经很不错了，同事只需要把这个组件实例化之后插入到 DOM 里面就可以用了。
