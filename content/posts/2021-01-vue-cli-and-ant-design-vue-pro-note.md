---
title: "Vue-Cli 及 Ant Design Vue Pro 开发笔记"
date: 2021-01-20T22:57:27+08:00
tags: ['Note 学习笔记']
draft: false
---

## 在各个 commit 之间切换

可以将当前分支 checkout 到另一个分支上，然后在另一个分支中，在各个 commit 之间切换，这样不会影响当前分支，还能够看到各个 commit 项目的状态。

看完各个 commit 之后，再将新建的分支删除即可。

- [How do I revert a Git repository to a previous commit?](https://stackoverflow.com/questions/4114095/how-do-i-revert-a-git-repository-to-a-previous-commit)

## 引用静态资源

在组件中，template 中 img 元素的 src 属性，和 style 中 CSS 的 url 属性，所引用文件的路径都是以 `~@/assets` 开头的，官方文档中的相关解释如下：

如果 URL 以 `~` 开头，其后的任何内容都会作为一个模块请求被解析。这意味着你甚至可以引用 Node 模块中的资源：`<img src="~some-npm-package/foo.png">`。

如果 URL 以 `@` 开头，它也会作为一个模块请求被解析。它的用处在于 Vue CLI 默认会设置一个指向 `<projectRoot>/src` 的别名 @。(**仅作用于模版中**)

所有编译后的 CSS 都会通过 css-loader 来解析其中的 `url()` 引用，并将这些引用作为模块请求来处理。这意味着你可以根据本地的文件结构用相对路径来引用静态资源。另外要注意的是如果你想要引用一个 npm 依赖中的文件，或是想要用 webpack alias，则需要在路径前加上 `~` 的前缀来避免歧义。

- [URL 转换规则](https://cli.vuejs.org/zh/guide/html-and-static-assets.html#url-%E8%BD%AC%E6%8D%A2%E8%A7%84%E5%88%99)
- [引用静态资源](https://cli.vuejs.org/zh/guide/css.html)

## 设置项目语言环境

修改 `src/locales/index.js` 文件，导入所需的语言文件，设置 `defaultLang`，并在 `messages` 变量中设置对应字段名及字段值。

```js
import zhCN from './lang/zh-CN'

export const defaultLang = 'zh-CN'

const messages = {
  'zh-CN': {
    ...zhCN
  }
}
```

- [Vue I18n](https://kazupon.github.io/vue-i18n/zh/started.html)

