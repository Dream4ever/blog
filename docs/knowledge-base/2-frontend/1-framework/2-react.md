---
sidebar_position: 2
title: React.js 相关
---

## 声明式 vs 命令式

声明式的前端框架（React.js/Vue.js/Angular），都是在描述开发者期待的视图状态，开发者只需关心最终的渲染结果，不用管中间的具体执行过程。

而命令式的如 jQuery，则是直接调用浏览器的 API（或者加上一层封装）来实现最具体的功能。

## JSX

### 语法糖的本质

在 React 中，JSX 是 `React.createElement(type, props, ...children)` 的语法糖。

比如对于代码 `<div className="card-title">{title}</div>`，`div` 就是 `type`，`className="card-title"` 就是一组 prop 的名称和值，`div` 元素里的所有内容都是 `children`。

### 组件 JSX 最外层加分号

当组件的 return 语句返回 JSX 时，要在 JSX 的最外层加上圆括号 `()`，这样能够避免换行的 JSX 被编译器自动加分号从而导致短路问题。

### 命名规则

自定义组件的变量名/函数名首字母必须大写。如果首字母小写，React 会将其识别成不规范的 HTML 标签并交给浏览器处理。

HTML 元素全部小写，以便和自定义组件区分。

## 组件化开发

### 原则

组件拆分没有一个绝对的标准，需要根据实际的业务和交互来设计组件的层次结构，实现关注点分离：在开发哪个层次的组件，就只需要关注这个层次，无需关注上一层或下一层。

有的经验认为，对于中小型应用，从上向下拆分组件比较合适，先定义最大粒度的组件，然后逐渐缩小粒度；大型应用则相反。但是自己目前只写过小型应用，这一点还有待以后的经验来证明。

### props

props 是 React 组件对外的数据接口，可以传入多种数据类型，包括函数。

props 属性命名建议用驼峰规则（camelCase），并且区分大小写。比如 `filename` 和 `fileName` 就是两个不同的 props。

如果要给 props 传入复杂的 JSX，记得传入的 JSX 只能有一个根元素，如果在语义层面不想加上一个实际的 HTML 元素或 React 组件，可以用 Fragment 元素 `<></>` 代替。

### 一般格式

像下面这样编写组件，在调用的时候，就可以在 `children` 的位置放入任意子元素，效果类似于 Vue.js 的 `slot`。

```js
const KanbanBoard = ({ children }) => {
  return (
    <main className="kanban-board">{children}</main>
  )
}
```

### 向被调用组件传值

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

### 子组件调动父组件

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

## 虚拟 DOM

### 子组件

React 只有 **元素树**（FiberNode），没有 **组件树** （TODO：[这块儿没看懂](https://time.geekbang.org/column/article/561203)）。

### 协调

React 组件渲染出的元素树，在每次 props、state 变化的时候，会渲染出新的元素树，然后 React 会将新旧两个元素树做 diffing 对比，然后把元素的变化体现在浏览器页面的 DOM 中。

两个元素树对应节点的子元素如果都是列表，那么 React 会尝试按顺序匹配两个列表的元素。

如果列表元素没有 `key` 属性，React 就不知道哪些元素能保留哪些不能，于是就只能把整个列表推翻了重建，这样就会带来性能损耗。

当列表元素的 `key` 属性对于每个元素是唯一且稳定的，就不会产生上面的问题。

### 协调触发场景

触发协调有两个方向，拉（pull）的机制需要后台始终轮询，这样会增加资源开销，没有必要。

推（push）的方式就比较合理，结合 React 的设计哲学：`UI = f(state)`，只在数据变化的时候触发协调即可。

而在 React 中，props、state、context 都可以操作组件数据。其中 props 从组件外面把数据传进来，state 在组件内操作数据；context 的话，由组件外的 Context.provider 提供数据，然后在组件内消费 context 数据。

只要三者之一发生了变化，React 就会对 **当前组件** 触发协调过程，最终按照 diffing 结果更改页面。

### 不可变性

在 React 中，props 和 state 都是不可变的。如果尝试在组件内修改或者新增 props 的属性，React 是会报错的。

## 组件生命周期

### 类组件生命周期

一个类组件的生命周期包含挂载（mounting）、更新（updating）、卸载（unmounting）这三个阶段，以及错误处理（error handling）阶段。类组件在这四个阶段提供了不同的生命周期方法，render() 也是一个生命周期方法，也是最重要的生命周期方法。

React 的 **渲染阶段** 主要负责 **更新虚拟 DOM 树**（FiberNode），这一过程可能被 React 暂停、恢复，也会有并发处理的情况，所以这一阶段的生命周期方法必须是 **没有任何副作用的纯函数**。由于这一阶段有可能会很慢，所以 React 把这一阶段设计为一步过程（即前面说的 **协调** ）。

**提交阶段** 则是根据渲染阶段的比对结果修改真实 DOM，这个阶段一般会很快，所以被设计为同步过程。

### 函数组件生命周期

函数组件的生命周期也包含挂载、更新、卸载三个阶段。虽然也有错误处理阶段，但没有对应的生命周期 hooks，错误处理依赖于父组件或祖先组件提供的错误边界。

在函数组件的挂载阶段，React 会执行组件函数（是执行这个组件里的所有函数？），执行函数过程中遇到的 useState、useMemo 等 hooks 会依次挂载到 FiberNode 上。useEffect 虽然也会被挂载，但它的副作用（在 Fiber 引擎中称为 Effect）会保留到提交阶段（是说提交阶段才执行副作用函数？）。

组件函数的返回值一般是 JSX，React 在渲染阶段根据返回值创建 FiberNode 树，在提交阶段 React 更新真实 DOM 之前，会依次执行前面定义的 Effect。

如果组件接收到新的 props，或者 setState 更改了状态，或者 useReducer 返回的 dispatch 更改了状态，组件就会进入更新阶段。组件函数本身会被再次执行，hooks 会依次与 FiberNode 上已挂载的 hooks 一一匹配，并根据需要更新。组件函数的返回值则用来更新 FiberNode 树。

进入提交阶段后，React 会更新真实 DOM，随后 React 会先执行上一轮 Effect 的清除函数，然后再次执行 Effect，包括 useEffect 与 useLayoutEffect。useLayoutEffect 是在更新真实 DOM 后同步执行的，类似于类组件的 componentDidMount、componentDidUpdate，而 useEffect 是异步执行的，一般晚于 useLayoutEffect。

## State/状态

### state 改变与组件重新渲染

在组件内部改变 state 会让组件重新渲染。换句话说，如果不在组件内部改变 state，就无法保证组件及时渲染。

### 拿到最新的 state

在一些特定情况下，通过 `useState` 声明的变量值不是最新的值，基于这个变量值来计算下一次的 state 值时，可能会覆盖上次的修改。

而当 state 更新函数的参数是一个函数时，React 会保证传入这个函数的 state 是最新的值，这样函数就可以基于这个最新的 state 值来计算下一次的值。示例代码如下：

```js
const [var1, setVar1] = useState({...})

setVar1(oldValue => {
  return {
    ...oldValue,
    newValue,
  }
})
```

## Hooks

### 相关概念

纯函数：

1. 无论被调用多少次，只要传入参数相同，返回值就一定相同，不受外部状态或者 IO 操作的影响。
2. 被调用时不会产生副作用（side effect）：不会修改传入的引用参数，不会修改外部状态，不会触发 IO 操作，也不会调用其他会产生副作用的函数。

纯函数组件：以纯函数的方式编写的组件。虽然没有副作用，但是除了 props 和 JSX，纯函数组件无法使用 React 的任何其他特性，对它来说，其他特性全都是 **外部状态或者副作用**。

反过来说，如果要使用其他特性，只要让它显式地使用外部状态或者执行副作用就好了。

**Hooks 就是这样一套为函数组件设计的，供用户访问 React 的内部状态或执行副作用操作，以函数形式存在的 React API**。这里的“内部状态”，除了组件的 state，还包括 context、memo、ref 等。

### 函数组件

组件的 state 并不是绑定在函数组件上的，而是绑定在组件渲染产生的虚拟 DOM 节点（FiberNode）上的。所以在函数组件中调用 useState，意味着将访问组件以外、React 以内的状态，这就让函数产生了副作用，函数组件就不再是“纯函数组件”。但是这样一来，函数组件虽然不再纯粹，功能却更加强大了，可以使用 React 的绝大部分特性了。

### 纯函数组件 vs 纯组件

前者每次在渲染阶段都会执行，提交阶段如果没有变化就不会执行。而后者是一个主要用于性能优化的独立 API PureComponent：**当组件的 props 和 state 没有变化时，将跳过这次渲染，直接用上次渲染的结果**。

## useState

### 生命周期

在组件挂载阶段，组件内会为每一条 useState 函数的语句创建一个 state，并根据传入的值对其进行初始化。

而在组件每次更新的渲染阶段，useState 函数会被再次调用，但不会再重新初始化 state，而是保证返回值的第一个变量是最新的。

### 性能

每次组件更新都会调用 useState，这样就会产生性能隐患。传入 useState 的参数是简单的内容还好，如果传入复杂的表达式，比如计算斐波那契数列的函数，那么在每次组件更新时，即使表达式的值不会被 useState 使用，但表达式本身还是会被执行的。