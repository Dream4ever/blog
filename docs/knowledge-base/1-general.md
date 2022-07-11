---
sidebar_position: 1
title: 通用部分
---

## 方法论

### 寻找 XXX 的最佳实践

**需求描述**

最近在做的这个项目，前端用的 Vue，后端用的 Express + MongoDB。因为之前写前端项目还算多一点，后端没怎么写过，所以这次的后端代码总感觉还有很大的提升空间，那么怎样能找到优质的代码，来学习借鉴呢？

**研究过程**

要找到优质的代码，在搜索关键词里可以加上 `best practice`。当然了，即使加上这组关键词，也要对搜索结果进行手动筛选。

就比如自己在研究 Express + Mongoose 的 API 怎样写才能更好的时候，用 `node mongodb crud best practice` 作为关键词来搜索，第一页的文章里，有借鉴价值的只有一篇，其它的文章都和 `best practice` 根本不沾边，只能算是 tutorial，入门指引。

但是即使用了上面的方法，也未必能如愿以偿，自己最后找到的比较满意的资源，是 FrontendMasters 上的一套收费课程，的开源代码：[api-design-node-v3](https://github.com/FrontendMasters/api-design-node-v3)。大致看了一下它的代码，个人认为已经完全可以拿来应用到生产项目中了。

这个开源项目是怎么找到的呢？是因为试了好几个关键字都没找到满意的结果，于是又用关键字 `design node api` 在 Google 上搜索，给出的第一个链接就是这个项目，点进去看了看，果然是个宝藏，哈哈。

看来即使是搜索这种看起来很简单的事，也得多花心思、多花功夫，像自己这次花了不少时间，总算找到自己满意的资源，还是相当值得的。

### 项目脚手架

#### 需求描述

不管是 Vue 还是 React，或者是后端 API 服务，初次上手的时候，都希望能有个现成的脚手架来提升自己的开发效率。

问题的关键不在于某个具体的项目，而是在于如何在 GitHub 上找到这种仓库。

#### 关键词

- scaffold
- boilerplate
- bootstrap
- create
- starter
- template
- stack

#### 参考项目

- [scaffold-eth/scaffold-eth](https://github.com/scaffold-eth/scaffold-eth)
🏗 forkable Ethereum dev stack focused on fast product iterations
- [vuejs/create-vue](https://github.com/vuejs/create-vue)
🛠️ Quickly scaffold a Vue project with `npm init vue@3`
- [vivekascoder/vite-vue-tailwind-jit](https://github.com/vivekascoder/vite-vue-tailwind-jit)
This template allows you to quickly scaffold a Vue project with Vue Router, VueX, TailwindCss with JIT Compiler and vite

### 项目架构梳理

#### Q

对于前后端分离的项目架构，有什么好的方法、工具可以进行梳理么？

画个时序图，倒是可以梳理整体流程上的架构。但是对于细节，感觉时序图这样的工具就无能为力了。

画个流程图的话，感觉画起来又很花时间。

所以有没有什么方法，能够既看到项目的整体架构，又看到项目的每处细节？是不是还得用时序图加别的什么图，搭配起来用？

#### A

多看 GitHub 开源项目的文档，要图文结合才能把设计说清楚。

写项目设计文档，其实就是写一份教程。如何把教程写得通俗易懂，也是一门学问。
