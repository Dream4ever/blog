---
sidebar_position: 6
title: 微信小程序开发
---

## [ WXSS 文件编译错误] ./app.wxss unexpected token "*"

用标题的报错信息，和 `微信小程序 tailwind unexpected token "*"` 这样的报错信息搜索，发现是微信小程序的 CSS 不支持 `*` 这个选择器。

### 参考资料

- [WeAppTailwind / 使用](https://github.com/mrleidesen/WeAppTailwind?tab=readme-ov-file#%E4%BD%BF%E7%94%A8)
- [编译报错 ./app.wxss(1:1): unexpected token `*`？](https://developers.weixin.qq.com/community/develop/doc/000a4c7bd34368f74c40698b463400)

## 小程序更新

- 官方文档：[UpdateManager 对象](https://developers.weixin.qq.com/miniprogram/dev/api/base/update/UpdateManager.html)用来管理小程序的更新。
- 掘金文章 [小程序版本更新管理器wx.getUpdateManager()](https://juejin.cn/post/6994358193312759821) 给出了具体的示例代码。
- 知乎文章 [微信小程序发布新版本时自动提示用户更新的方法](https://zhuanlan.zhihu.com/p/556249196) 则有更全面的代码，也可以参考。
- [开放接口 /账号信息 /wx.getAccountInfoSync](https://developers.weixin.qq.com/miniprogram/dev/api/open-api/account-info/wx.getAccountInfoSync.html) 可在正式版环境中获取小程序版本号。
- [小程序运行时 /更新机制](https://developers.weixin.qq.com/miniprogram/dev/framework/runtime/update-mechanism.html) 可用来排查小程序更新相关问题。

注意：

1. 微信开发者工具上可以通过「编译模式」下的「下次编译模拟更新」开关来调试小程序的更新功能。
2. 小程序开发版/体验版没有「版本」概念，所以无法在开发版/体验版上测试版本更新情况。

### 社区相关讨论

- [你们UpdateManager 都是放在onLaunch去执行吗？](https://developers.weixin.qq.com/community/develop/doc/000008d99c060825e2cd9d79251c00)
- [updateManager.onUpdateReady在正式环境无反应，怎么解决？](https://developers.weixin.qq.com/community/develop/doc/00022eb71b0e10df264a7cd6d50000)

## 小程序基础库

- [基础库 /版本分布](https://developers.weixin.qq.com/miniprogram/dev/framework/client-lib/version.html)：列出了微信统计的目前小程序基础库的版本分布情况。
- [设置最低基础库版本](https://developers.weixin.qq.com/miniprogram/dev/framework/compatibility.html#%E8%AE%BE%E7%BD%AE%E6%9C%80%E4%BD%8E%E5%9F%BA%E7%A1%80%E5%BA%93%E7%89%88%E6%9C%AC)：可查看近 30 天内访问当前小程序的用户所使用的基础库版本占比。2023-09-01 查看版本占比情况，低于 2.25.0 版本的基础库 UV 占比为 0，可以不考虑这类用户的兼容需求了，因此设置最低基础库版本为 2.25.0。

## reachBottom 事件无法触发

只有页面根元素高度大于屏幕高度（100vh）时，才能触发 reachBottom 事件。否则页面和屏幕一样高，是无法触发该事件的。

## 拦截物理返回

参考链接：[如何实现小程序物理返回拦截？](https://developers.weixin.qq.com/community/develop/doc/0006ec3db6cc98e9367a4f67751800)。

假设从 A 页面进入 B 页面之后，需要对 B 页面返回 A 页面的行为进行拦截。

解决方案：

1. 点击头部 navigator 返回键可通过重写 navigator bar 自定义返回键 handler 进行拦截。
2. 侧滑、安卓机底部物理返回键可以在 B 页 onUnload 生命周期通过事件或其他方法通知前置 A 页当前发生回退行为，在 A 页 onShow 生命周期触发拦截如再次返回 B 页，虽然逻辑层发生了回退但从交互、视觉角度当前仍停留在 B 页。

## CSS 样式

### flexbox 子元素边距失效

父元素需要像下面这样设置属性，才能让子元素的边距正常生效。

```css
flex-grow: 1;
flex-shrink: 0;
```

简写形式 `flex: 1 0;` 无法代替上面的两行代码，因为不能生效。
