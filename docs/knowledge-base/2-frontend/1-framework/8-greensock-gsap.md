---
sidebar_position: 8
title: GreenSock(GSAP) 相关
---

## 一次滚动一屏

相关关键词：

- fullpage.js
- one page scroll

### 调研路径

1. Google 搜索：`gsap exactly scroll 100vh`
2. 翻了几个搜索结果之后，发现 [Full screen sections](https://greensock.com/forums/topic/25479-full-screen-sections/) 这篇问答符合自己的需求
3. 二楼提到了另一篇问答 [Full page site](https://greensock.com/forums/topic/24978-full-page-site/)，看了 CodePen 示例之后确认是自己需要的效果
4. 加餐：[Full page scrolling and pinning](https://greensock.com/forums/topic/30702-full-page-scrolling-and-pinning/) 这篇问答里，二楼给出了各种整屏滚动效果的代码示例

### 关键代码

```js
// 用到了 ScrollTrigger 这个插件
ScrollTrigger.create({
  trigger: '.p2',
  start: "top bottom-=1",
  end: "bottom top+=1",
  onEnter: () => goToSection('.p2'),
  onEnterBack: () => goToSection('.p2'),
})

// 用到了 ScrollToPlugin 这个插件
const goToSection = (section) => {
  gsap.to(window, {
    scrollTo: {
      y: section,
      autoKill: false,
    },
    duration: 1,
  })
}
```

## 水平滚动

实现效果：到达页面指定区域后，鼠标滚轮上下滚动时，页面内容左右滚动。

参考链接：[ScrollTrigger: Horizontal Scroll pin-spacer height issue](https://greensock.com/forums/topic/31255-scrolltrigger-horizontal-scroll-pin-spacer-height-issue/)

## 可逆动画

### 调研路径

1. Google 搜索：`gsap reversable`
2. 看到一个貌似有用的链接 [Reversing animations on ScrollTrigger](https://greensock.com/forums/topic/29433-reversing-animations-on-scrolltrigger/)
3. to do...


