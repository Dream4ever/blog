---
sidebar_position: 3
title: 后端开发
---

## Express.js 实现文件上传功能

[Multer](http://expressjs.com/en/resources/middleware/multer.html)：方案待考察。

## Express.js 实现文件下载功能

### 搜索关键词

- `serve file`

### 参考链接

- [res.sendFile](https://expressjs.com/en/api.html#res.sendFile)：后端实现文件下载功能
- [pillarjs / send](https://github.com/pillarjs/send)：sendFile 实际调用的功能
- [expressjs](https://github.com/expressjs)：Express.js 的 ORG
- [expressjs/serve-static](https://github.com/expressjs/serve-static)：备选方案
- [paulwalker/connect-static-expiry](https://github.com/paulwalker/connect-static-expiry)：备选方案
- [如何实现付费下载功能？](https://v2ex.com/t/891301)：在 V2EX 上的求助帖

## Windows 下 PM2 实现持久化运行

新版方案：

1. 将 https://github.com/jessety/pm2-installer 这个项目的 release 压缩包下载并放到服务器上。
2. 依次执行 `yarn run configure`、`yarn run configure-policy`、`yarn run setup`，来安装并配置 PM2 服务。
3. 如果前面配置都成功了，但最后服务一直无法成功启动，可能是因为服务是用 Local Service 用户身份启动失败，改成用 `本地系统账户`（Administrator） 启动就行了。因为观察其他开机自启动的服务，很多都是用 `本地系统账户` 启动的。

旧版方案：[Windows: Auto start PM2 and node apps](https://stackoverflow.com/questions/42758985/windows-auto-start-pm2-and-node-apps)。

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
