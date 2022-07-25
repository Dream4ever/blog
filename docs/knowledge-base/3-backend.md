---
sidebar_position: 3
title: 后端开发
---

## 用 Vercel Serverless Function 抓取 Medium 用户文章列表

### 搜索关键词

- `meidum api get publication posts` （Google 智能提示），最终用此关键词找到解决办法
- `medium robot`
- `how to know if medium update`
- `medium api notify update`

### 参考文章

- [How to retrieve Medium stories for a user from the API?](https://stackoverflow.com/questions/36097527/how-to-retrieve-medium-stories-for-a-user-from-the-api)

### 解决方案

先用 [https://medium.com/feed/@username](https://medium.com/feed/@username) 这个 API 获取到指定用户最新 10 篇文章的概况。

再用 [rss-to-json](https://www.npmjs.com/package/rss-to-json) 这个库把拿到的 RSS 数据转换成 JSON即可。

### 关键代码

按照下面标识的路径，将后端函数放到根目录的 `api` 文件夹下，再传到 GitHub 上，与之关联的 Vercel 就能够自动部署该 Serverless Function 了。

在同一项目的前端页面中，就能够用 `/api/medium` 这样的路径调用它了。

```js title='/api/medium.js'
const { parse } = require('rss-to-json')

export default async function handler(req, res) {
  const rss = await parse('https://medium.com/feed/@username')

  const result = JSON.stringify(rss, null, 3)
  // 可在 https://vercel.com/dream4ever/abcde/{deploy_hash}/functions
  // 看console.log 语句的输出结果
  console.log(result)

  res.status(200).json(result)
}
```
