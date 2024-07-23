---
sidebar_position: 2
title: JavaScript
---

## 前端获取后端返回的自定义 header

搜索关键词：`axios get custom response header`。
参考链接：https://github.com/axios/axios/issues/1946#issuecomment-958790245 和 https://stackoverflow.com/a/37931084/2667665 。
要让前端能够获取到自定义 header，需要在服务端配置响应 header: `Access-Control-Expose-Headers: CUSTOMIZED-HEADER`。

## 安卓 WebView 中 writeText 方法不能复制文本

Google 搜索 `writetext write permission denied not allowed error`，在 StackOverflow 的讨论 [Clipboard API call throws NotAllowedError without invoking onPermissionRequest()](https://stackoverflow.com/questions/61243646/clipboard-api-call-throws-notallowederror-without-invoking-onpermissionrequest) 中，看到下面的答案说 `writeText` 需要 `Permissions` 相关的 API 来获取 `clipboard-write` 权限。但是安卓的 WebView 没有 `navigator.permissions` 这个 API。

下面另一个回答也提到了 VueUse 这个库也是对这种情况进行了兼容处理，没有权限的安卓 WebView 就用 `execCommand('copy')` 的方式实现复制文本的操作。

## 以组件化的方式使用 SVG 图标

参考资料：[(Next.js) How can I change the color of SVG in next/image?](https://stackoverflow.com/a/65685418/2667665)

具体方案：

在网站 [transform.tools](https://transform.tools/) 中，将 SVG 内容粘贴进去，网站会自动转换成 JSX 组件。

比如有以下的 SVG 文件：

```html
<svg
  style="flex:1;"
  xmlns="http://www.w3.org/2000/svg"
  xmlns:xlink="http://www.w3.org/1999/xlink"
>
  <rect
    x="10"
    y="10"
    height="100"
    width="100"
    style="stroke:#ff0000; fill: #0000ff"
  />
</svg>
```

网站会输出下面的组件：

```js
import * as React from "react";

function SvgComponent(props) {
  return (
    <svg
      style={{
        flex: 1,
      }}
      xmlns="http://www.w3.org/2000/svg"
      {...props}
    >
      <path stroke="red" fill="#00f" d="M10 10H110V110H10z" />
    </svg>
  );
}

export default SvgComponent;
```

再将 JSX 组件中 `path` 属性里的 `fill` 字段的值改为 `currentColor`，就可以配合 tailwind.css，实现自定义 SVG 图标的颜色及其他样式了。

## 用 FileSaver 库保存 DOCX 库生成的 Word 文档

关键词：`docx+file-saver`。

参考方案：[Create dynamic word documents using DOCX Js, file-saver and data from an EXCEL or JSON](https://medium.com/geekculture/create-dynamic-word-documents-using-docx-js-file-saver-and-data-from-an-excel-or-json-dbd5e4ec823f)。

关键代码：

```js
// 创建文档并添加内容
let doc = new Document();
doc.createParagraph("This paragraph will be in my new document");

//  设置相关参数
const packer = new Packer();
const mimeType =
  "application/vnd.openxmlformats-officedocument.wordprocessingml.document";

// 保存文件
const fileName = "example.docx";
packer.toBlob(doc).then((blob) => {
  const docblob = blob.slice(0, blob.size, mimeType);
  saveAs(docblob, fileName);
});
```

## 用 axios 下载后端传来的文件

关键词：`axios download file`。

参考方案：[How to download files using axios](https://stackoverflow.com/a/53230807/2667665)。

关键代码：

```js
axios({
  url: "http://api.dev/file-download", //your url
  method: "GET",
  responseType: "blob", // important
}).then((response) => {
  // create file link in browser's memory
  const href = URL.createObjectURL(response.data);

  // create "a" HTML element with href to file & click
  const link = document.createElement("a");
  link.href = href;
  link.setAttribute("download", "file.pdf"); //or any other extension
  document.body.appendChild(link);
  link.click();

  // clean up "a" element & remove ObjectURL
  document.body.removeChild(link);
  URL.revokeObjectURL(href);
});
```

## 点击 button 元素上传文件（不用 input 控件）

关键词：`html5 button file upload`。

参考方案：[Is it Possible to make a button as File upload Button?](https://stackoverflow.com/a/56607553/2667665)。

关键代码：

```html
<img src="" id="out" />
<button onClick="onClickHandler(event)">select an IMAGE</button>
```

```js
function onClickHandler(ev) {
  var el = (window._protected_reference = document.createElement("INPUT"));
  el.type = "file";
  el.accept = "image/*";
  el.multiple = "multiple"; // remove to have a single file selection

  // (cancel will not trigger 'change')
  el.addEventListener("change", function (ev2) {
    // access el.files[] to do something with it (test its length!)

    // add first image, if available
    if (el.files.length) {
      document.getElementById("out").src = URL.createObjectURL(el.files[0]);
    }

    // test some async handling
    new Promise(function (resolve) {
      setTimeout(function () {
        console.log(el.files);
        resolve();
      }, 1000);
    }).then(function () {
      // clear / free reference
      el = window._protected_reference = undefined;
    });
  });

  el.click(); // open
}
```

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
- 示例代码中的坐标需要改成目标地点的经纬度，通过百度地图的“[拾取坐标系统](http://api.map.baidu.com/lbsapi/getpoint/index.html)”，用关键字进行搜索，得到搜索结果之后，点击地图中标记的点 A，在页面右上方会显示当前坐标点 `xxx.xxxxxx, xx.xxxxxx`，将坐标复制下来之后，粘贴到示例代码中，按照示例代码中数字的格式，精确到小数点后三位即可 `xxx.xxx, xx.xxx`。
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
