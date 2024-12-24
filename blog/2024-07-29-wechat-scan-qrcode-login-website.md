---
slug: wechat-scan-qrcode-login-website
title: 微信扫描 PC 端网站实现登录功能
authors: HeWei
tags: [wechat, qrcode, login]
---

## 前情提要

有一个业务，在 PC 端以网站的形式呈现，在手机端以小程序的形式提供服务。

为了统一使用一套用户身份，需要在 PC 端网站上实现微信扫码登录功能，将用户在微信小程序中的 openId 传给网页端。

最开始调研的方案，是在后端生成小程序码并发送给前端。后来在 V2EX 咨询了一下，发现这种方案有每分钟的调用频率显示，并且对服务端消耗比较大，对方建议采用普通二维码跳转小程序的方式。

官方文档：[扫普通链接二维码打开小程序](https://developers.weixin.qq.com/miniprogram/introduction/qrcode.html)。

参考文章：[微信小程序踩坑系列之扫普通链接二维码打开小程序](https://www.yilingsj.com/xwzj/2022-09-01/scan-the-QRcode-to-open-the-applet.html) 和 [扫描普通二维码进入小程序](https://juejin.cn/post/7008798114219982879)。

官方文档说得还是不够清楚，又看了几篇个人分享的心得，结合自己的实际操作，总结了一下。

## 整体流程

以下仅列出关键步骤。

1. 在服务端随机生成一个 UUID，返回给 PC Web 端。
2. PC Web 端生成一个普通二维码，内容为 `https://www.abc.com/biz/?q=${uuid}`。
3. 手机微信扫描二维码，跳转到所配置的小程序页面，并传入上面二维码对应的 URL，其中包含 UUID。小程序将用户 openId 和 UUID 传给服务端。
4. 服务端将 UUID 和 openId 关联为 key-value，以便后续使用。
5. PC Web 端轮询服务端，获取 UUID 关联的 openId，如果获取成功，则登录。

## 配置二维码跳转小程序

在小程序管理后台的 `开发设置` 页面，可配置 `扫普通链接二维码打开小程序` 的功能。

先配置 `二维码规则`，填写 `https://www.abc.com/biz/`。

然后配置 `前缀占用规则`，如果选择是，则对于前一步配置的二维码 URL，当前规则将独占所有匹配的子规则，即 `https://www.abc.com/biz/*`，其他跳转规则将不能再使用满足条件的子规则。

再配置要跳转到的 `小程序功能页面`，扫码后会跳转到这个页面。

接着配置 `测试范围`，这个选项在规则发布之后也可以修改。

最后配置 `测试链接`。注意，在跳转规则未发布的情况下，测试链接也是有效的。这样方便进行功能测试，以免发布无效的规则，浪费每月额度。