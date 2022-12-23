---
sidebar_position: 5
title: 微信小程序开发
---

## CSS 样式

### flexbox 子元素边距失效

父元素需要像下面这样设置属性，才能让子元素的边距正常生效。

```css
flex-grow: 1;
flex-shrink: 0;
```

简写形式 `flex: 1 0;` 无法代替上面的两行代码，因为不能生效。
