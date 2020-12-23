---
title: "React 小书学习笔记：事件监听"
date: 2020-12-23T22:12:35+08:00
tags: ['Note 学习笔记']
draft: false
---

原文链接：[事件监听](http://huziketang.mangojuice.top/books/react/lesson9)

<!--more-->

前面我们定义了 `Header` 组件，这里我们再定义一个 `Title` 组件，然后在 `Header` 组件里面使用 `Title` 组件来显示标题：

```js
class Title extends Component {
  render() {
    return <h1>React 小书</h1>;
  }
}

class Header extends Component {
  render() {
    return <div>
      <Title />
    </div>;
  }
}
```

上面的代码可以正常显示标题内容，是因为 React 支持组件的组合、嵌套，可以在一个组件的 `render` 方法中将其中所包含组件的 JSX 渲染出来。有了组件的组合、嵌套，就有了无限可能。

有一点要注意： **自定义组件名称一定要首字母大写，普通的 HTML 标签则要小写** 。

组件可以和 HTML 一样组合、嵌套，构成一个组件树。最后再经过编译、渲染，就会形成一个完整的 DOM 树，基本上就是我们最终所看到的页面了。可以通过观察下面这个实例，对组件的组合及嵌套有基本的认识：

```js
class Header extends React.Component {
  render() {
    return <h2>This is Header</h2>;
  }
}

class Main extends React.Component {
  render() {
    return <h2>This is main content</h2>;
  }
}

class Footer extends React.Component {
  render() {
    return <h2>This is footer</h2>;
  }
}

class Index extends React.Component {
  render() {
    return <div>
      <Header />
      <Main />
      <Footer />
    </div>;
  }
}

React.render(<Index />, document.getElementById('root'));
```
