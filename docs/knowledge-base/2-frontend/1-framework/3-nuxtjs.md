---
sidebar_position: 3
title: Nuxt.js 相关
---

## 定义全局可用的 TypeScript Interface

关键词：`how to define interface type in nuxt`。

参考链接：[How to add global interfaces to Nuxt project](https://stackoverflow.com/a/73237686/2667665)。

示例代码：

```ts
// ~/types/index.ts

export { };

declare global {
  type SomeType = [boolean, string, number]; 

  interface MyFancyInterface {
    ...
  }

  const enum GlobalConstEnum {
    ...
  }

  ....
}
```

## 环境配置

### 配置运行时环境变量（Nuxt v3）

> 参考资料：[useRuntimeConfig](https://nuxt.com/docs/api/composables/use-runtime-config)

先在 `.env` 文件中定义环境变量，比如 `API_SECRET`。

然后在 `nuxt.config.ts` 文件中，添加下面的内容：

```ts
export default defineNuxtConfig({
  // ...
  runtimeConfig: {
    REG_TOKEN: process.env.REG_TOKEN,
  },
})
```

在其他文件中，就可以用下面的方式，访问到上面定义的环境变量了。

```js
const config = useRuntimeConfig()
console.log(config.REG_TOKEN)
```

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

### 配置接口请求代理

> 参考资料：[Nuxt.js — How to handle CORS error](https://mookypoo.medium.com/nuxt-js-how-to-handle-cors-error-a4c5022611d0)
> 接口文档：[routeRules | Config - Nitro](https://nitro.unjs.io/config#routerules)

```ts
// nuxt.config.ts
export default defineNuxtConfig((){
  routeRules: {
      '/web/v1/**': {
          proxy: { to: "httpw://api.abc.com/web/v1/**", },
      }
    }
})
```

## 错误排查

### 项目 dev 时 build 报错 EPERM: operation not permitted, mkdir '**\.nuxt\components'

解决方案：['EPERM: operation not permitted' error when building Nuxt app](https://stackoverflow.com/questions/56448815/eperm-operation-not-permitted-error-when-building-nuxt-app)。

具体操作：先停止 dev 状态，然后再 build，就不会报错了。

### 项目初始化后运行报错 TypeError: Cannot destructure property 'nuxt' of 'this' as it is undefined

报错信息为：`Nuxt Fatal Error TypeError: Cannot destructure property 'nuxt' of 'this' as it is undefined.`。

Google 之后看到项目官方仓库就有人提了 issue：https://github.com/nuxt/nuxt/issues/10840 ，自己的报错信息正如提问者截图所示，原来是 Nuxt.js 默认关于 tailwindcss 的配置有问题。

解决方法也很简单，按照回帖中很多人所说的方法，去 tailwindcss 官网，按照 [Install Tailwind CSS with Nuxt.js](https://tailwindcss.com/docs/guides/nuxtjs) 一文所说的方法，对 Nuxt.js 进行重新配置即可。

## 用 pinia 实现状态管理

> 参考项目：https://github.dev/piniajs/example-nuxt-2

### 状态定义

```js
// /stores/audio.ts
import { defineStore } from 'pinia'

export const useAudioStore = defineStore({
  id: 'audio',

  state: () => ({
    show: false,
  }),

  actions: {
    showAudioControl () {
      this.$patch({
        show: true,
      })
    },
  },
})
```

### 状态使用

```js
import { storeToRefs } from 'pinia'
import { useAudioStore } from '~/stores/audio'

// 1. 初始化
const audioStore = useAudioStore()

// 2. 使用值
const { doPause } = storeToRefs(audioStore)

// 3. 调用方法
audioStore.showAudioControl()
```

### 状态监听

> 参考资料：[How to Watch Pinia State Inside Vue 3 Components](https://runthatline.com/pinia-watch-state-getters-inside-vue-components/)

```js
import { storeToRefs } from 'pinia'
import { useAudioStore } from '~/stores/audio'

const audioStore = useAudioStore()

const { doPause } = storeToRefs(audioStore)

watch(doPause, () => {
  if (doPause.value) {
    // do something
  } else {
    // do something
  }
})
```
