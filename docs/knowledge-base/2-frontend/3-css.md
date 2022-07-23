f---
sidebar_position: 3
title: CSS
---

## 文字渐变效果

搜索关键词：`css text background linear gradient`。

参考文章：[Gradient Text | CSS-Tricks](https://css-tricks.com/snippets/css/gradient-text/)。

关键代码

```css
background: -webkit-linear-gradient(#eee, #333);
-webkit-background-clip: text;
-webkit-text-fill-color: transparent;
```

## CSS 实现输入光标闪烁动画

Google `css cursor blink`。

参照搜索结果的第一篇 [Simple blinking cursor animation using CSS](https://www.amitmerchant.com/simple-blinking-cursor-animation-using-css/) 即可实现，思路其实也挺简单，关键的是 `animation` 属性的 `step(2)` 这个值，让光标的闪烁效果更接近于真实形态。

## 让浏览器显示小于 12px 的字体

在做页面的时候，发现浏览器对于 font-size 小于 12px 的字体，实际显示出来的是 12px。

Google `html font size than 12px`，发现在 [Font-size <12px doesn't have effect in Google Chrome](https://stackoverflow.com/questions/2295095/font-size-12px-doesnt-have-effect-in-google-chrome) 这个回答里，有人说能解决，有人说不能解决。

又换成中文搜索 `浏览器 字号 12px`，网上的解决方案其实和英语搜索结果一样，最后用 `transform: scale()` 属性解决了。

## 移除旧版 iOS Safari input/textarea 控件上方的阴影效果

在开发 Web 页面时，发现在 iOS 13 的 Safari 上，input/textarea 控件上方有阴影，如下图所示。

![image](./img/ios-safari-input-shadow-1.png)

用 `ios safari input shadow` 作为关键词进行查询，发现原来是旧版 iOS Safari 为 input/textarea 控件设置了 `appearance` 属性，把这个属性去掉就好了。

解决方案：[Remove iOS input shadow](https://stackoverflow.com/questions/23211656/remove-ios-input-shadow)。

关键代码：

```css
-webkit-appearance: none;
-moz-appearance: none;
appearance: none;
```

应用上面 CSS 后的效果如下图所示：

![image](./img/ios-safari-input-shadow-2.png)

## iOS Safari 100vh 页面高度被遮挡

写了一个移动 Web 页面，CSS 设置页面的高度为 100vh，结果发现在 iPhone 7 的 Safari 浏览器上，页面纵向高度会被浏览器本身的界面元素占据一部分，在 iPhone 11 上则没有这个问题。

用 `iOS Safari 100vh covered by` 作为关键词搜索，发现的确存在这个问题。尝试了几种方法都不管用，最后干脆把高度设置为 `100%` 了，不折腾了。

## 使元素保持长宽比

Google `css set element height same as width`。

[Height equal to dynamic width (CSS fluid layout) [duplicate]](https://stackoverflow.com/questions/5445491/height-equal-to-dynamic-width-css-fluid-layout)

只需要给元素本身设置 CSS 样式即可:

```css
.some_element {
    position: relative;
    width: 20%;
    height: 0;
    padding-bottom: 20%;
}
```

## 父元素 overflow hidden + 子元素正常滚动

在开发一个页面的时候，需要让页面中的一个元素显示为固定高度，但其子元素又需要能够正常的上下滚动（高度超出父元素时）。

在 [Overflow hidden with nested overflow scroll not working](https://stackoverflow.com/q/43539284/2667665) 这个帖子中，提问者自己就已经找到了解决方案，整体思路如下：

1. 对于设置了 `overflow: hidden;` 属性的父元素，再为其添加 `display: flex;` 和 `flex-direction:column;` 属性。
2. 父元素和子元素之间增加一个容器元素，CSS 属性设置为 `overflow: auto;` 和 `flex-grow:1;`，这样可以让容器元素和子元素的宽高相同，并且可以正常地滚动。
