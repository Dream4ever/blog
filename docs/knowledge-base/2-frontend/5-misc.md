---
sidebar_position: 5
title: 其他
---

## 优选移动端 UI 框架

### 需求描述

需要做电子书，只面向移动端，因此需要先优选出一款移动端的 UI 框架。

电子书已实现下列功能，自己需要用新的架构重新编写的话，所选择的 UI 就需要考虑这些功能：

- 显示/关闭都很方便的**侧栏**
  - 章节目录
  - 书签
  - 笔记
- 提供多种操作的**底栏**
  - 添加书签
  - 添加笔记
  - **搜索**

### 方案调研

在 GitHub 上用关键字 `mobile ui` 搜索移动端 UI 框架，不筛选语言，按照 Star 数排名，看了一下前两页的项目，第二页的质量显然不如第一页，那就只在第一页里面选。

### 入选方案

- [ElemeFE/mint-ui](https://github.com/ElemeFE/mint-ui)：也是基于 Vue 的组件库，组件也很丰富，UI 设计比 vux 好看一些，不过也不能说是上乘。侧栏 ×，底栏 √，搜索 √

### 排除方案

- [Tencent/weui](https://github.com/Tencent/weui)：微信原生风格，UI 很精美，不过是纯粹的 UI 库，只引入 CSS，功能过于简单，不符合需求。侧栏 ×，底栏 √，搜索 √
- [alibaba/weex](https://github.com/alibaba/weex)：目标跨平台，野心太大了，不适合当前项目。
- [airyland/vux](https://github.com/airyland/vux)：基于 Vue 和 WeUI 的组件库，个人项目，组件很丰富，但是相似性也比较多，UI 设计稍逊一筹。侧栏 ×，底栏 √，搜索 √
- [amazeui/amazeui](https://github.com/amazeui/amazeui)：Web 版本以 jQuery 为基础库，部分兼容 IE，使用 gulp 构建项目。Touch 版本以 React 为基础库，专用于移动端，对手机兼容性很好。官网导航做得不好，找示例找了半天才找到，而且 UI 设计也不好看。侧栏 ×，底栏 √
- [OnsenUI/OnsenUI](https://github.com/OnsenUI/OnsenUI)：主打 PWA 和混合开发。感觉官网做得不够好，看示例也是找了半天才找到，不要它。侧栏 ×，底栏 √，搜索 √
- [sdc-alibaba/SUI-Mobile](https://github.com/sdc-alibaba/SUI-Mobile)：有点小众，基于 Zepto/jQuery 风格的 API 开发，不能用 Vue 做组件化开发，不用。侧栏 ×，底栏 √，搜索 √

## 将上传至页面中的图片显示出来

> 前提：假设图片已通过 `type=file` 的 `input` 控件上传至页面中。

关键词：`show uploaded image in html`。

可用方案：[HTML - Display image after selecting filename [duplicate]](https://stackoverflow.com/questions/12368910/html-display-image-after-selecting-filename)。

核心代码：

```html
<input type="file" onchange="readURL(this);" />
```

```js
function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $('#blah').attr('src', e.target.result).width(150).height(200);
    };

    reader.readAsDataURL(input.files[0]);
  }
}
```

## 实现虚拟展厅

### 搜索方向

- 前端 VR
- 前端 展厅
- three.js Gyroscope(陀螺仪)

搜索引擎：Google、掘金

### 参考资料

- [2天赚了4个W，手把手教你用Threejs搭建一个Web3D汽车展厅！](https://juejin.cn/post/6981249521258856456)
- [三种前端实现VR全景看房的方案！说不定哪天就用得上！](https://juejin.cn/post/6973865268426571784)

### 技术方案

- [babylonjs](https://www.babylonjs.com/)
- [krpano](https://krpano.com/home/)
- [Photo Sphere Viewer](https://photo-sphere-viewer.js.org/)
- [720 云](https://720yun.com/find)
- [Perspective tracking using gyroscope data](https://discourse.threejs.org/t/perspective-tracking-using-gyroscope-data/17101)
- [CSS3DRenderer](https://threejs.org/docs/#examples/en/renderers/CSS3DRenderer)

## Skeleton Screen Loading

应用骨架屏技术，提升页面加载时的用户体验。

### 方案调研

在 SegmentFault 上看到了这篇文章：[Vue页面骨架屏注入实践](https://segmentfault.com/a/1190000014832185)，了解到了现在普遍使用的一项技术：Skeleton Screen Loading。

以 `skeleton screen vue` 作为关键字 Google，能在网上看到不少文章，后面需要的时候继续深入。
