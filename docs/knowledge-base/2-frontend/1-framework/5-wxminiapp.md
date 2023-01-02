---
sidebar_position: 5
title: 微信小程序开发
---

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
