---
sidebar_position: 2
title: React.js 相关
---

## React

### 声明式 vs 命令式

声明式的前端框架（React.js/Vue.js/Angular），都是在描述开发者期待的视图状态，开发者只需关心最终的渲染结果，不用管中间的具体执行过程。

而命令式的如 jQuery，则是直接调用浏览器的 API（或者加上一层封装）来实现最具体的功能。

### JSX

#### 语法糖的本质

在 React 中，JSX 是 `React.createElement(component, props, ...children)` 的语法糖。

比如对于代码 `<div className="card-title">{title}</div>`，`div` 就是 `type`，`className="card-title"` 就是一组 prop 的名称和值，`div` 元素里的所有内容都是 `children`。

#### 组件 JSX 最外层加分号

当组件的 return 语句返回 JSX 时，要在 JSX 的最外层加上圆括号()，这样能够避免换行的 JSX 被编译器自动加分号从而导致短路问题。

#### 命名规则

自定义组件的变量名/函数名首字母必须大写。如果首字母小写，React 会将其识别成不规范的 HTML 标签并交给浏览器处理。

HTML 元素全部小写，以便和自定义组件区分。

### State/状态

#### state 改变与组件重新渲染

在组件内部改变 state 会让组件重新渲染。换句话说，如果不在组件内部改变 state，就无法保证组件及时渲染。

#### 拿到最新的 state

在一些特定情况下，通过 `useState` 声明的变量值不是最新的值，基于这个变量值来计算下一次的 state 值时，可能会覆盖上次的修改。

而当 state 更新函数的参数是一个函数时，React 会保证传入这个函数的 state 是最新的值，这样函数就可以基于这个最新的 state 值来计算下一次的值。

### 组件化开发

#### props

props 是 React 组件对外的数据接口，可以传入多种数据类型，包括函数。

props 属性命名建议用驼峰规则（camelCase），并且区分大小写。比如 `filename` 和 `fileName` 就是两个不同的 props。

#### 向被调用组件传值

对于如下的 React 组件：

```js
const KanbanCard = ({ title, status }) => {
  return (
    <li className="kanban-card">
      <div className="card-title">{title}</div>
      <div className="card-status">{status}</div>
    </li>
  );
};
```

可以通过下面的方式，向组件中传值：


```js
{ todoList.map(props => <KanbanCard {...props} />) }

```

PS：如果用 TypeScript 写 React 代码的话，就需要定义好传入组件的数据结构了。

#### 子组件调动父组件

对于如下定义的组件：


```js
const SomeComponent = ({ onEvent }) => {
  const doSomething = () => {
    onEvent(var1)
  }
}
```

在调用它的组件中，可通过如下方式触发 `onEvent` 事件。下面的 `handleEvent` 函数其实是回调函数。

```js
const handleEvent = (var1) => {
  // 这里可以处理子组件传来的值，或者执行特定的操作
}

<SomeComponent onEvent={handleEvent} />
```

## UmiJS

### 项目运行时报错 `AssertionError [ERR_ASSERTION]: filePath not found`

基于 UmiJS 的项目，安装完依赖后，在运行时报错：`AssertionError [ERR_ASSERTION]: filePath not found`。

删除 `node_modules` 目录后重新安装依赖再运行项目，未解决问题。

删除 `yarn.lock` 文件后重新安装依赖再运行项目，未解决问题。

Google 该错误，在 [AssertionError [ERR_ASSERTION]: filePath not found #7114](https://github.com/umijs/umi/issues/7114) 中找到了解决办法：删除 `src` 目录下的 `.umi` 文件夹，并重新安装依赖，然后再运行项目，问题果然解决了。
