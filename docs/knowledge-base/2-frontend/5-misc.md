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

## 移动端点击表单元素后弹出输入法遮盖界面

### 需求描述

在手机中打开网页，点击页面中的表单元素之后，弹出的输入法有时会遮盖住表单元素。

### 方案调研

#### 调研过程

Google `js 点击 输入框 输入法 盖住`，在 [移动web页面，input获取焦点弹出系统虚拟键盘时，挡住input，求解决方案？](https://www.zhihu.com/question/32746176) 这个链接中，提到了可以用 `scrollIntoView` 或 `scrollIntoViewIfNeeded` 来让页面自动往上滚动到刚好露出刚才点击的表单元素。

但是！`scrollIntoView(true)` 在 iOS 下有效，Android 下无效。

而且！在微信中点击输入框，虽然页面位置会滚动到能够完整显示输入框的位置，可微信自己又增加了功能，点击输入控件之后会在页面顶部（导航栏下方）显示提示对话框，时长两秒左右，这样就会盖住输入框，这样的话，还是不要用 `scrollIntoView()` 这个方法了，还是手写 JS 实现滚动吧。

此外，微信中点击输入框，似乎自己就会执行 `scrollIntoView()` 这个方法，所以还需要用 `scrollIntoView(false)` 禁用掉，让页面完全按照自己的需求往上滚动。

于是研究手写 JS 实现页面往上滚动指定距离的方法。基本思想是：如果所点击表单元素位于页面高度一半的位置之下，很可能会被输入法的软键盘盖住，因此要将页面上移一定距离。在 SegmentFault 上搜索 `移动端 键盘`，在 [如何用 js 获取虚拟键盘高度？（适用所有平台）](https://segmentfault.com/a/1190000010693229) 这篇文章中讲了具体的实现方法。

在实现这个功能的过程中，意识到自己分不清 `clientheight/offsetheight/scrollheight` 这三个概念，用这三个关键字 Google，[What is offsetHeight, clientHeight, scrollHeight?](https://stackoverflow.com/questions/22675126/what-is-offsetheight-clientheight-scrollheight) 这篇文章讲得就很到位。

三个概念的区别：

- scrollHeight：元素的实际高度
- clientHeight：元素在可视区域内的高度，不含滚动条
- offsetHeight：元素在可视区域内的高度，含滚动条

在这个过程中又了解到另外两个相关的概念：`window innerHeight/outerHeight`，区别如下：

- innerHeight：页面可视区域的高度
- outerHeight：浏览器窗口包含各种标题栏菜单栏状态栏的总高度

但是在手写 JS 实现页面滚动的过程中，发现安卓上怎么都不执行，最后拿真机连到电脑上调试了一番，才发现安卓手机上的微信并不支持 `scrollBy()` 这个方法，只好用 `scrollTop()` 这个最原始的方法了。

为了计算元素和页面顶端的距离，Google `element distance from top of window`，[How to get the distance from the top for an element?](https://stackoverflow.com/a/33840267/2667665) 这个链接里讲得就很到位。关键是其中的 `getBoundingClientRect()` 方法，不论元素如何定位的，都可正常获取到元素距离页面顶端的高度。

#### 入选方案

- [移动web页面，input获取焦点弹出系统虚拟键盘时，挡住input，求解决方案？](https://www.zhihu.com/question/32746176)
- [如何用 js 获取虚拟键盘高度？（适用所有平台）](https://segmentfault.com/a/1190000010693229)
- [How to get the distance from the top for an element?](https://stackoverflow.com/a/33840267/2667665)

### 应用过程

```js
let clickedElement = document.querySelector('#' + id);
let title = document.querySelector('#message>.title');
let app = document.querySelector('#app');

// 禁用 iOS 微信中的自动滚动
clickedElement.scrollIntoView(false);
if (clickedElement.getBoundingClientRect().top - (window.innerHeight / 2) > -40) {
  app.scrollBy(0, title.getBoundingClientRect().top)
}
```

### 要点总结

随之而来的问题：[Web移动端Fixed布局的解决方案](http://efe.baidu.com/blog/mobile-fixed-layout/)。

### 参考资料

2019年4月25日又在 SegmentFault 上看到了这么一篇文章，可以参考：[可能这些是你想要的H5软键盘兼容方案](https://segmentfault.com/a/1190000018959389)。

## 网页/微信小程序中显示数学公式

需求：要将 Word 文档中的公式显示在网页端。

关键词：

- `show formula web page`
- `microsoft word to latex converter`
- `微信小程序显示数学公式`

整体流程：

1. 先将 Word 中的公式转换成 LaTeX 格式的公式。
2. 用 [MathJax](http://docs.mathjax.org/en/latest/) 这个库在前端页面中渲染公式。

参考资料：

- [Is there a way to have math formulas look nice on a web page (as in LateX, for instance)](https://stackoverflow.com/questions/2324718/is-there-a-way-to-have-math-formulas-look-nice-on-a-web-page-as-in-latex-for-i)
- [How to display maths formulas and equations in a webpage](https://codingislove.com/display-maths-formulas-webpage/)
- [How can I convert from Microsoft Word to a LaTeX document](https://tex.stackexchange.com/questions/27731/how-can-i-convert-from-microsoft-word-to-a-latex-document)
- [在掘金搜索 MathJax](https://juejin.cn/search?query=MathJax)
- [使用MathJax 3 渲染数学公式及在Vue中的使用](https://juejin.cn/post/6986646914440085512)
