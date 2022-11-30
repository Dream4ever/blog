---
sidebar_position: 2
title: React.js 相关
---

## React

### 组件化开发

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

在调用它的组件中，可通过如下方式触发 `onEvent` 事件：

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
