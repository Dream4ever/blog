---
title: "前端组件化（二）：优化 DOM 操作"
date: 2020-12-22T22:24:03+08:00
tags: ['Note 学习笔记']
draft: false
---

原文链接：[前端组件化（二）：优化 DOM 操作](http://huziketang.mangojuice.top/books/react/lesson3)

<!--more-->

在上一节的代码中， `changeLikeText` 函数既包含改变状态 `isLiked` 的操作，又包含改变状态对应 DOM 文字的操作。在实际开发中，一个组件的显示形态往往由多个状态决定，如果代码既要改变各个状态，又要去修改各个 DOM，就很容易导致代码可维护性变差、容易出错。那要如何改变这种局面呢？

## 状态改变 → 构建新的 DOM 元素更新页面

一种最简单粗暴的解决方案，就是状态一旦改变，就重新调用 `render` 方法生成新的 DOM，这样既不需要手动修改 DOM，又能够保证状态可以随时更新到 DOM 上。

```js
class LikeButton {
  constructor() {
    this.state = { isLiked: false }
  }

  setState(state) {
    this.state = state
    this.el = this.render()
  }
  
  changeLikedText() {
    this.setState({
      isLiked: !this.state.isLiked
    })
  }
  
  render() {
    this.el = createDOMFromString(`
    <button class="like-btn">
      <span class="like-text">${this.state.isLiked ? '取消' : '点赞'}</span>
      <span>👍</span>
    <button>
    `)
    this.el.addEventListener('click', this.changeLikedText.bind(this), false)
    return this.el
  }
}
```

上面的代码和之前的版本相比，改动如下：

1. `render` 里根据 `state` 的值不同，自动显示对应的文字，这里也显示出了 ES6 模板字符串的方便之处。
2. 新增了 `setState` 函数，用传入的 `state` 覆盖实例当前的 `state` ，并重新调用 `render` 方法。
3. 用户点击按钮触发事件，事件调用 `changeLikedText` 函数，该函数调用 `setState` ， `setState` 再调用 `render` ，`render` 再根据 `state` 的值重新构建 DOM 元素。

这样一来，DOM 操作就完全交给 `setState` 来自动操作，无需再手动修改了。

## 重新插入新的 DOM 元素

除了上面的修改，还需要在组件外能够知道组件发生改变，并且删除旧的 DOM 并插入新的 DOM 才行。通知改变的发生也在 `setState` 中进行：

```js
setState(state) {
  const oldEl = this.el
  this.state = state
  this.el = this.render()
  if (this.onStateChange) {
    this.onStateChange(oldEl, this.el)
  }
}
```

然后在使用该组件时，监听对应的 `onStateChange` 事件：

```js
const likeButton = new LikeButton()
wrapper.appendChild(likeButton.render()) // 首次插入 DOM 元素
likeButton.onStateChange(oldEl, newEl) {
  wrapper.insertBefore(newEl, oldEl) // 插入新的 DOM 元素
  wrapper.removeChild(oldEl) // 删除旧的 DOM 元素
}
```

这样一来，`setState` 每次都会调用 `onStateChange` 方法，而这个方法是实例化之后被设置的，所以可以根据自己的需求来设置它。在上面的代码中，每当 `setState` 构造完新的 DOM 元素之后，就会通过 `onStateChange` 告知外部插入新的 DOM 元素，然后删除旧的 DOM 元素，这样页面就更新了。

不过由于每次 `setState` 都要重新构造、新增、删除 DOM 元素，会导致浏览器进行大量的重排，严重影响性能，所以 React 和 Vue 都引入了 Virtual-DOM 策略来解决这个问题。

上面这个组件的不足之处在于，如果我要再写一个评论组件，那么 `setState` 方法我还要再重写一遍，而这些通用的部分其实都可以抽象出来进行公用的，下一节就讲讲如何将其进行抽象。
