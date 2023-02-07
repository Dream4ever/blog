---
sidebar_position: 6
title: Nuxt.js 相关
---

## 项目初始化后运行报错

报错信息为：`Nuxt Fatal Error TypeError: Cannot destructure property 'nuxt' of 'this' as it is undefined.`。

Google 之后看到项目官方仓库就有人提了 issue：https://github.com/nuxt/nuxt/issues/10840 ，自己的报错信息正如提问者截图所示，原来是 Nuxt.js 默认关于 tailwindcss 的配置有问题。

解决方法也很简单，按照回帖中很多人所说的方法，去 tailwindcss 官网，按照 [Install Tailwind CSS with Nuxt.js](https://tailwindcss.com/docs/guides/nuxtjs) 一文所说的方法，对 Nuxt.js 进行重新配置即可。
