---
sidebar_position: 5
title: UmiJS 相关
---

### 项目运行时报错 `AssertionError [ERR_ASSERTION]: filePath not found`

基于 UmiJS 的项目，安装完依赖后，在运行时报错：`AssertionError [ERR_ASSERTION]: filePath not found`。

删除 `node_modules` 目录后重新安装依赖再运行项目，未解决问题。

删除 `yarn.lock` 文件后重新安装依赖再运行项目，未解决问题。

Google 该错误，在 [AssertionError [ERR_ASSERTION]: filePath not found #7114](https://github.com/umijs/umi/issues/7114) 中找到了解决办法：删除 `src` 目录下的 `.umi` 文件夹，并重新安装依赖，然后再运行项目，问题果然解决了。
