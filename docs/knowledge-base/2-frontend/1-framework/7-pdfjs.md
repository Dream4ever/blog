---
sidebar_position: 7
title: PDF.js 相关
---

## 版本兼容性

在用 PDF.js 最新版（v3.3.122）开发页面时，发现在 iOS QQ 和 TIM 中，无法显示 PDF.js 所渲染的内容。

改用 v2.16.105 版本时，则显示报错信息：

```
载入PDF时发生错误
信息：undefined is not an object(evaluating 'response.body.getReader')
```

搜索上面问题，也没找到解决方案。

然后用 `iOS+QQ+pdf.js` 搜索，发现在微信开发者社区有用户反映同样的问题：[使用pdfjs插件预览文件显示空白？](https://developers.weixin.qq.com/community/develop/doc/000cc8990307780f4d9bf2a3b51000)，并且将 PDF.js 版本降低至 v2.x（x 为个位数）时问题解决。

于是下载了 PDF.js v2.x各个版本，发现等于或低于 v2.9.359 版本的 PDF.js 都不会有上面所说的问题。
