---
title: "React 小书学习笔记：前端组件化（三）：抽象出公共组件类"
date: 2020-12-23T08:52:35+08:00
tags: ['Note 学习笔记']
draft: false
---

原文链接：[前端组件化（三）：抽象出公共组件类](http://huziketang.mangojuice.top/books/react/lesson4)

<!--more-->

为了让代码的复用性更高，我们把上一节中预计会通用的部分抽象处理，放到组件类 `Component` 中：

```js
class Component {
  setState(state) {
    const oldEl = this.el
    this.state = state
    this._rendorDOM()
    if (this.onStateChange) this.onStateChange(oldEl, this.el)
  }
  
  _rendorDOM() {
    this.el = createDOMFromString(this.render())
    if (this.onClick) {
      this.el.addEventListener('click', this.onClick.bind(this), false)
    }
    return this.el
  }
}
```

这个组件父类 `Component` 可以被所有组件继承，来构建组件的实例。它定义的两个方法除了之前提到过的 `setState` ，还包括私有方法 `_renderDOM` ，它会调用 `this.render` 来构建 DOM 元素并监听 `onClick` 事件。所以，组件子类在继承的时候，只需要实现一个返回 HTML 字符串的 `render` 方法就可以了，剩下的工作都由父类完成了。

还有个方法 `mount` 用于把组件的 DOM 元素插入页面，并且在 `setState` 的时候更新页面：

```js
const mount = (component, wrapper) => {
  wrapper.appendChild(component._renderDOM())
  component.onStateChagne(oldEl, newEl) => {
    wrapper.insertBefore(newEl, oldEl)
    wrapper.removeChild(oldEl)
  }
}
```

这个时候，点赞组件就可以像下面这样进行重写：

```js
class LikeButton extends Component {
  constructor() {
    super()
    this.state = { isLiked: false }
  }
  
  onClick() {
    this.setState({
      isLiked: !this.state.isLiked
    })
  }
  
  render() {
    return `
      <button class='like-btn'>
        <span class='like-text'>${this.state.isLiked ? '取消' : '点赞'}</span>
        <span>👍</span>
      </button>
    `
  }
}

mount(new LikeButton(), wrapper)
```

这样已经比之前的版本好多了，但是如果需要给组件传入一些自定义的配置数据，比如按钮的背景色之类的，那么可以给组件类和它的子类都传入一个参数 `props` ，作为组件的配置参数。这时候就需要修改 `Component` 的构造函数：

```js
  constructor(props = {}) {
    this.props = props
  }
```

然后在子类继承父类的时候，通过 `super(props)` 把 `props` 传给父类，这样就可以通过 `this.props` 获取到配置参数：

```js
class LikeButton extends Component {
  constructor(props) {
    super(props)
    this.state = { isLiked: false }
  }
  
  onClick() {
    this.setState({
      isLiked: !this.state.isLiked
    })
  }
  
  render() {
    return `
      <button class='like-btn' style='background-color: ${this.props.bgColor}'>
        <span class='like-text'>
          ${this.state.isLiked ? '取消' : '点赞'}
        </span>
        <span>👍</span>
      </button>
    `
  }
}

mount(new LikeButton({ bgColor: 'red' }), wrapper)
```

这里我们修改了子类 `LikeButton` 的 `render` 方法，让它可以根据传入的参数 `this.props.bgColor` 来生成对应的 `style` 属性，这样就可以自定义组件的背景色了。

现在有了父组件类 `Component` 和 `mount` 方法，加起来不足 40 行的代码就可以做到组件化了。如果需要写一个不同的组件，只需要像上面那样，简单继承一下 `Component` 类就可以了：

```js
class RedBlueButton extends Component {
  constructor(props) {
    super(props)
    this.state = {
      color: 'red'
    }
  }
  
  onClick() {
    this.setState({
      color: 'blue'
    })
  }
  
  render() {
    return `
      <div style='color: ${this.state.color};'>${this.state.color}</div>
    `
  }
}
```

## 总结

教程用了三节的时间来讲一个简单的点赞按钮的例子，并且一直在不断优化它，最后抽象出一个公共的组件类，实现了更好的组件化。

有了组件化，就可以帮助我们解决前端结构的复用性问题，整个页面都可以由各种各样的组件组合、嵌套而成。

每个组件都有自己的显示形态（HTML 和内容）及行为，而这两者又可以由数据状态（state）和配置参数（props）共同决定，数据状态和配置参数的改变都会影响到组件的显示形态及行为。

数据变化的时候，组件的显示需要更新，而组件化的模式以一种高效的方式自动化帮我们更新页面，从而大大降低了我们所编写的代码的复杂度，带来了更好的可维护性。

这三节的内容，其实就是在讲解 React.js 这个库的核心部分，接下来就开始正式学习 React.js。
