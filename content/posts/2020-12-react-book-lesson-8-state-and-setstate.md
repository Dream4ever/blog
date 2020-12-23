---
title: "React 小书学习笔记：组件的 state 和 setState"
date: 2020-12-23T22:43:51+08:00
tags: ['Note 学习笔记']
draft: false
---

原文链接：[组件的 state 和 setState](http://huziketang.mangojuice.top/books/react/lesson10)

<!--more-->

## state

前面讲过的点赞按钮的例子，用了一个属性来保存按钮是否被点赞，React 中的 `state` 就是专门用来存储这种可变化的状态的，代码如下：

```js
class Main extends React.Component {
  constructor() {
    super()
    this.state = { isLiked: false }
  }
  
  changeState(e) {
    this.setState({
      isLiked: !this.state.isLiked
    })
  }
  render() {
    return <h2 onClick={this.changeState.bind(this)}>
    {this.state.isLiked ? '取消' : '点赞'}
    </h2>;
  }
}
```

组件中的 `state` 对象在构造函数中初始化，里面保存了 `isLiked` 属性。而 `render` 函数会根据 `isLiked` 属性值的不同，分别显示“取消”或者“点赞”。

## setState 接受对象参数

上面事件监听函数的回调，调用了 `setState` 方法，在用户每次点击 DOM 元素的时候，更改 `isLiked` 属性的值。

`setState` 方法是由父类提供的， **事件监听函数的回调内调用该函数时，React 会更新组件的状态 `state` ，然后 自动 重新调用 `render` 方法，并把渲染的最新内容显示在页面上。**

如果不调用 `setState` 方法，而是直接用 `this.state = xxx` 的方式来修改，React 是没法知道你修改了组件的状态的，也就没办法更新。所以一定要用 React 提供的 `setState` 方法， **它接受一个对象或者函数作为参数** 。

给 `setState` 传入对象的话，只需要传入更改的那部分就行，不用传入整个对象。

```js
  constructor() {
    super()
    this.state = {
      name: 'Jimmy',
      isLiked: false,
    }
  }
```

比如对于上面的状态，如果只修改 `isLiked` 属性的话，是不需要把 `name` 一起传入的。

## setState 接受函数参数

调用 `setState` 的时候， **React 并不会立刻修改 `state`** ，而是把这个对象放到一个更新队列里面，之后才会从队列中吧新的状态提取出来再合并到 `state` 里，然后才触发组件更新。比如下面的代码：

```js
  changeState(e) {
    console.log(this.state.isLiked)
    this.setState({
      isLiked: !this.state.isLiked
    })
    console.log(this.state.isLiked)
  }
```

上面的代码在实际执行的过程中，会发现 `setState` 前后输出的值是相同的，就是因为 React 的 `setState` 先把传进来的状态缓存起来，之后才会更新到 `state` 上，所以这里才会在执行完 `setState` 之后，获取到的还是旧的 `isLiked` 的值。

那么如果需要立刻获取到最新的 `state` 对象，就需要把函数传入 `setState` 了：

```js
  changeState(e) {
    this.setState((state) => {
      return { isLiked: 1 }
    })
    this.setState((state) => {
      console.log(this.state.isLiked) // => 3
      return { isLiked: state.isLiked + 1 }
    })
    this.setState((state) => {
      console.log(this.state.isLiked) // => 3
      return { isLiked: state.isLiked + 1 }
    })
  }
```

上面的代码，在每一次的 `setState` 中，都会用前一次的、也是最新的 `state` 进行运算。只不过如果像上面的代码那样，尝试输出每一步的 `isLiked` 的值，会发现输出的还是最后的值，很有意思，以后有空了可以研究研究。

## setState 合并

上面虽然执行了三次 `setState` ，但组件却只会渲染一次，因为在 React 内部会把 JavaScript 事件循环消息队列的同一个消息中的 `setState` 进行合并之后，再重新渲染组件。

深层的原理目前无需过多纠结，只需要记住，在使用 React 的时候，不需要担心多次使用 `setState` 会带来性能问题。
