---
sidebar_position: 1
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

## TailwindCSS

### 部分样式在 React 中不生效

像 `rotate-*` 这样的样式在 React 中不生效，上网查了查，有的建议直接写到 style 里面：[How to rotate an element 180 in react?](https://stackoverflow.com/questions/67085701/how-to-rotate-an-element-180-in-react)。

示例代码如下：

```js
const style = {
 transform: 'rotate(180deg)', 
}

<div style={style}><div>
```

### 让 tailwindcss 的任意值在 React 中生效

在 React 中用 tailwindcss 的时候，发现任意值的写法不管用了。比如 `ml-[11px]` 这样的写法不会被正常解析。

Google `tailwind arbitrary value not working react`，看到 [Problem with arbitrary values on Tailwind with React](https://stackoverflow.com/a/71063391/2667665) 这篇讨论中有人说要把样式从 className 移到 style 里面，那还不够麻烦的。

于是把任意值都写到 `tailwind.config.js` 里了，不同的属性要写到不同的位置，写错了会不生效，别的就没什么要注意的了。
