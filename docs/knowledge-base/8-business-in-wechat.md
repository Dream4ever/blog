---
sidebar_position: 8
title: 微信内业务开发
---

## 微信内网页

### 阻止微信内置浏览器（webview）缩放字体

iOS 中需要通过 CSS 实现该需求：

```css
body {
  -webkit-text-size-adjust: none !important;
  text-size-adjust: none !important;
}
```

Android 中则需要通过 JS 实现该需求：

```js
document.addEventListener("WeixinJSBridgeReady", function () {
  WeixinJSBridge.invoke("setFontSizeCallback", {
    fontSize: '2'
  })
}, false)
```

## 微信公众号

### 编程方式实现公众号菜单

#### 实现“点击菜单跳转至 URL”功能

这里使用了 TNWX 脚手架的 [读取配置文件来创建菜单](https://javen205.gitee.io/tnwx/guide/wxmp/custom_menu.html#%E8%AF%BB%E5%8F%96%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6%E6%9D%A5%E5%88%9B%E5%BB%BA%E8%8F%9C%E5%8D%95) 方式，来创建公众号的自定义菜单，代码如下：

```js
import {
  MenuApi,
} from 'tnwx'

export const createMenu = async (req, res) => {
  fs.readFile("./src/config/mpmenu.json", function (err, data) {
      if (err) {
          console.log(err)
          return
      }
      let fileData = data.toString()
      MenuApi.create(fileData).then(data => {
          res.send(data)
      })
  })
}
```

完成了上面的代码之后，将函数关联至指定的 API 路径，然后手动调用一次，公众号自定义菜单就生效了。

有一点要注意，就是 `fs.readFile()` 方法中所读取的 JSON 文件，是相对于项目根目录的路径，而不是相对于当前代码所在文件的路径。

对于 JSON 的相关要求，见官方文档 [创建接口 - 自定义菜单](https://developers.weixin.qq.com/doc/offiaccount/Custom_Menus/Creating_Custom-Defined_Menu.html)。

#### 响应菜单事件并回复消息

上面的代码，只能实现“点击菜单跳转至 URL”这类功能，如果要给用户回复文本，还需要执行下面的步骤。

用户点击公众号自定义菜单后，微信会将点击事件推送给开发者。在官方文档 [自定义菜单事件](https://developers.weixin.qq.com/doc/offiaccount/Message_Management/Receiving_event_pushes.html) 中，列出了微信推送过来的 XML 的格式。

由于 [Node.js / Express.js 默认无法解析 XML](https://www.jianshu.com/p/87d5f4987abf)，还需要安装一个中间件 [express-xml-bodyparser](https://www.npmjs.com/package/express-xml-bodyparser) 才能将 XML 解析成 JavaScript 可以使用的对象。

XML 解析出来的对象，有几个关键字段：`fromusername` 是微信用户的 ID，`tousername` 是公众号的 ID，`eventkey` 为前一小节在公众号菜单的 JSON 文件中，为指定菜单配置的 `key` 字段的值，开发者可用来区分用户点击的是公众号菜单的哪个按钮。

用户点击公众号菜单之后，公众号后台给用户回复文本的行为，属于 [被动回复用户消息 - 回复文本消息](https://developers.weixin.qq.com/doc/offiaccount/Message_Management/Passive_user_reply_message.html)，文档中列出了要返回给用户的 XML 的格式。

要想成功给用户回复消息，回复的 XML 中的 `ToUserName` 字段和 `FromUserName` 字段，应当分别为接收到的 `FromUserName` 和 `ToUserName` 字段，[这个千万不能错](https://juejin.cn/post/6844904074479927304)。其实想想也就明白了，后台收到的消息， `FromUserName` 字段是微信用户的 ID，`ToUserName` 字段是公众号的 ID。公众号要给用户回复消息，回复的 XML 中的 `ToUserName` 字段自然是微信用户的 ID，`FromUserName` 字段是公众号的 ID。

另外，Node.js / Express.js 返回的默认是 JSON，要想[让 Node.js / Express.js 返回 XML](https://stackoverflow.com/a/21398858)，就需要 `res.set('Content-Type', 'application/xml')` 这么一行代码，记得要写在 `res.send()` 之前。

还有一点要注意，就是在返回的 XML 中，除了 `<Content><![CDATA[你好]]></Content>` 里的内容可以有空格，别的地方都不能有空格，可以用下面这个函数来构造 XML 字符串。

```js
function buildOutXml(inXml, content) {
  let resultXml = "<xml><ToUserName><![CDATA[" + inXml.fromusername + "]]></ToUserName>"
  resultXml += "<FromUserName><![CDATA[" + inXml.tousername + "]]></FromUserName>"
  resultXml += "<CreateTime>" + new Date().getTime() + "</CreateTime>"
  resultXml += "<MsgType><![CDATA[text]]></MsgType>"
  resultXml += "<Content><![CDATA[" + content + "]]></Content></xml>"
  return resultXml
}
```

上面所说的各个环节都确保不出问题，点击公众号菜单自动回复文本消息的功能应该也就可以开发成功了。

### 编程方式实现自动回复功能

#### 响应用户发送的文本消息

这是为了恢复之前的“关键词回复”及“收到消息回复”两项功能。

其实弄懂了前一节的响应自定义菜单事件该如何做之后，这一节就是用同样的思路。只不过用户发送文本消息的话，收到的 XML 中 `MsgType` 字段的值为 `text` 而不是 `event`，其他方面大同小异，这里就不再赘述。

#### 公众号回复功能无效问题

在测试用的公众号上完成了自定义菜单和消息回复的功能测试之后，给之后要开通微信支付的公众号也按照前面的流程进行了相关配置，结果发现回复文本消息的自定义菜单没反应了。于是先取消关注公众号，并调用后台接口，重新生成公众号菜单，然后再重新关注公众号，一切就都正常了。
