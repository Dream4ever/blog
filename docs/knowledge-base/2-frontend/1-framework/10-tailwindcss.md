---
sidebar_position: 10
title: Tailwind.css 相关
---

## 部分样式在 React 中不生效

像 `rotate-*` 这样的样式在 React 中不生效，上网查了查，有的建议直接写到 style 里面：[How to rotate an element 180 in react?](https://stackoverflow.com/questions/67085701/how-to-rotate-an-element-180-in-react)。

示例代码如下：

```js
const style = {
 transform: 'rotate(180deg)',
}

<div style={style}><div>
```

## 让 tailwindcss 的任意值在 React 中生效

在 React 中用 tailwindcss 的时候，发现任意值的写法不管用了。比如 `ml-[11px]` 这样的写法不会被正常解析。

Google `tailwind arbitrary value not working react`，看到 [Problem with arbitrary values on Tailwind with React](https://stackoverflow.com/a/71063391/2667665) 这篇讨论中有人说要把样式从 className 移到 style 里面，那还不够麻烦的。

于是把任意值都写到 `tailwind.config.js` 里了，不同的属性要写到不同的位置，写错了会不生效，别的就没什么要注意的了。

## 使用 CSS 让正方形绕中心旋转 45 度

如果单纯用 `transform` 的 `rotate` 属性让正方形旋转 45 度，就会发现正方形相对原来的位置在 X 轴和 Y 轴方向上都有偏移。

解决方案就是设置一个起到容器作用的父元素，父元素用 flexbox 让作为子元素的正方形在水平和垂直方向上都居中。

基于 tailwindcss 的伪代码如下所示：

```html
<div
  class="wrapper shrink-0 flex justify-center items-center w-[100px] h-[100px]"
>
  <div
    class="cube shrink-0 w-[calc(100%_/_1.414)] h-[calc(100%_/_1.414)]"
  ></div>
</div>
```

这样正方形不仅在父元素（也是正方形）中在水平和垂直方向上都居中，并且子元素在水平和垂直方向上的长度刚好和父元素相等。

另外等腰直角三角形的斜边和直角边之比为 1.414，用这个值结合 CSS 的 `calc` 来设置子元素正方形的边长，就能让子元素在水平和垂直方向上的长度刚好和父元素相等。

## gap 属性在旧手机上不生效

Google 关键词 `tailwind gap polyfill`，在 https://stackoverflow.com/a/64636818/2667665 中提到，说是这个属性只在新的浏览器上才支持，可以用 `space-*` 来代替，测试之后的确管用。
