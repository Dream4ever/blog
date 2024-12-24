---
slug: config-google-analytics-api
title: 配置 Google Analytics API
authors: HeWei
tags: [Google Analytics, API]
---

## 参考资料

- [How to get your Google Analytics data with Google Analytics Report API](https://medium.com/@mucagriaktas/how-to-get-your-google-analytics-data-with-google-clouds-google-analytics-report-api-5131cb4661c0)：参考这个教程，完成了 GA API 的配置。
- [Method: properties.runReport](https://developers.google.com/analytics/devguides/reporting/data/v1/rest/v1beta/properties/runReport)：runReport 方法的详细说明，并且页面内带 Playground，可直接测试 API 调用结果。

## 启用 Google Analytics API

进入 [Google Cloud Console](https://console.cloud.google.com/)，在 `API & Services` → `Library` 页面中，搜索 `Google Analytics Reporting API`。

## 创建 Service Account

在 Google Cloud Console 的 `IAM & Admin` → `Service Accounts` 页面中，点击 `Create Service Account` 按钮，按照提示完成创建。只配置第一步的 `Service account name` 即可，其他的不用管。

创建完成后，记得复制 Service Account 的邮箱地址，后面会用到。

## 创建 API Key

点击创建好的 Service Account，在 `Keys` 页面中，点击 `Add Key` 按钮，选择 `Create new key` → `JSON`，创建 API Key，创建完成后，会自动下载一个 JSON 文件，这个文件就是 API Key。

## 配置指定网站的 GA API 权限

在指定网站的 Google Analytics 管理后台中，点击左下角的齿轮按钮，进入 `Property` → `Property access management` 页面，点击右上角的 + 号按钮，选择下拉菜单中的 `Add Users` 按钮，填入前面创建好的 Service Account 的邮箱，并设置其角色为 `Viewer`。

## 记录网站的 GA Property ID

在指定网站的 Google Analytics 管理后台中，点击左下角的齿轮按钮，进入 `Property` → `Property settings` 页面，找到 `Property ID`，复制这个 ID，后面会用到。

## 测试 API 调用

可用的 JS 源码见：https://github.com/Dream4ever/Utils/blob/main/google-analytics/pageview.js。
