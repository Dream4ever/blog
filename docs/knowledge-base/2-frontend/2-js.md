---
sidebar_position: 2
title: JavaScript
---

## Web 端嵌入百度地图

### 调研过程

按顺序讲一下自己的实现过程，中间踩了好几个坑，感谢 Google，感谢 SegmentFault，让我成功出坑。

- 百度地图这么大的一个平台，应该会给开发者提供 API。去哪里找呢？不知道，那就先打开百度地图页面：[https://map.baidu.com/](https://map.baidu.com/)，看到页面下方有[百度地图开放平台](http://lbsyun.baidu.com/)，应该就是它了，点进去看看。
- 看到开放平台最上方导航栏有“开发文档”，文档里面有“Web 开发中的 [JavaScript API](http://lbsyun.baidu.com/index.php?title=jspopular)”，嗯，点击进去看看都有啥。
- 进入 JavaScript API 页面之后，查看各个示例的预览图，确定“[POI 详情展示](http://lbsyun.baidu.com/jsdemo.htm#i1_6)”就是所需的功能。
- 进入该功能的 [DEMO 页面](http://lbsyun.baidu.com/jsdemo.htm#i1_6)，左侧有示例代码，更新代码后点击上方的“运行”按钮，在右侧就会显示代码的执行结果。

### 入选方案

- [POI 详情展示](http://lbsyun.baidu.com/jsdemo.htm#i1_6)

### 应用过程

- 要使用开放平台的各项功能功能，需要先申请调用百度地图 API 的 key：进入开放平台的[控制台](http://lbsyun.baidu.com/apiconsole/key)，选择“创建应用”，应用类型选择“浏览器端”，启用服务默认全选，应用名称和 Referer 白名单可按需设置，设置完成后点击提交。
- 示例代码中的坐标需要改成目标地点的经纬度，通过百度地图的“[拾取坐标系统](http://api.map.baidu.com/lbsapi/getpoint/index.html)”，用关键字进行搜索，得到搜索结果之后，点击地图中标记的点A，在页面右上方会显示当前坐标点 `xxx.xxxxxx, xx.xxxxxx`，将坐标复制下来之后，粘贴到示例代码中，按照示例代码中数字的格式，精确到小数点后三位即可 `xxx.xxx, xx.xxx`。
- 将示例代码复制到项目中之后，ESLint 会报错（用的 `vue-cli`，通过 `vue init webpack project` 指令初始化项目）。上网搜索一番，在[百度地图开发实例番外篇--实用方法（持续更新）](https://segmentfault.com/a/1190000012889136#articleHeader6)中找到了解决方法，原来是需要针对 ESLint 进行单独配置：

```js
// .eslintrc OR .eslintrc.js
module.exports = {
  ...
  "globals": {
    //为百度地图设置规则
    "BMap": true,
    "BMAP_NORMAL_MAP": true,
    "BMAP_HYBRID_MAP":true,
    "BMAP_ANCHOR_TOP_LEFT":true,
    "BMAP_ANCHOR_TOP_RIGHT":true,
    ...
  }
}
```

- 配置完成之后 ESLint 不报错了，但是在浏览器中查看控制台输出，会发现依然报错：`Cannot read property 'gc' of undefined`。搜索一番后找到了[解决方法](https://segmentfault.com/q/1010000010117527)，原来是要把示例代码放到 Vue 的 `mounted` 这个生命周期钩子函数中才行。如果还不行，可以在示例代码外面加上一段代码：

```js
mounted () {
  this.$nextTick(() => {
    // 示例代码
  })
}
```

好了，到这里就大功告成了，哈哈。
