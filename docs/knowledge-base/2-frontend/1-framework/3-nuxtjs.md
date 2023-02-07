---
sidebar_position: 3
title: Nuxt.js 相关
---

## 环境配置

### 配置环境变量

> 参考资料：[The env property](https://nuxtjs.org/docs/configuration-glossary/configuration-env#the-env-property)

如果需要添加一些项目中通用的环境变量，比如 CDN 文件的通用基础 URL，按照如下方式进行配置即可：

```js
// nuxt.config.js

export default {
  env: {
    baseUrl: process.env.BASE_URL || 'http://localhost:3000'
  }
}
```

### 配置项目基础路径

> 参考资料：[base - The router property](https://nuxtjs.org/docs/configuration-glossary/configuration-router#base)

在默认配置下，Nuxt.js 的基础路由路径是 `/`，假设其部署在 `www.abc.com` 域名下，则 URL 就是 `www.abc.com/`。

如果要设置为子路径，比如 `app2`，则按照下面的方式配置，就可以用 URL `www.abc.com/app2` 来访问。

```js
// nuxt.config.js

export default {
  router: {
    base: '/app/'
  }
}
```

## 错误排查

### 项目 dev 时 build 报错 EPERM: operation not permitted, mkdir '**\.nuxt\components'

解决方案：['EPERM: operation not permitted' error when building Nuxt app](https://stackoverflow.com/questions/56448815/eperm-operation-not-permitted-error-when-building-nuxt-app)。

具体操作：先停止 dev 状态，然后再 build，就不会报错了。

### 项目初始化后运行报错 TypeError: Cannot destructure property 'nuxt' of 'this' as it is undefined

报错信息为：`Nuxt Fatal Error TypeError: Cannot destructure property 'nuxt' of 'this' as it is undefined.`。

Google 之后看到项目官方仓库就有人提了 issue：https://github.com/nuxt/nuxt/issues/10840 ，自己的报错信息正如提问者截图所示，原来是 Nuxt.js 默认关于 tailwindcss 的配置有问题。

解决方法也很简单，按照回帖中很多人所说的方法，去 tailwindcss 官网，按照 [Install Tailwind CSS with Nuxt.js](https://tailwindcss.com/docs/guides/nuxtjs) 一文所说的方法，对 Nuxt.js 进行重新配置即可。
