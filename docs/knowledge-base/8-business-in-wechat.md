---
sidebar_position: 8
title: 微信内业务开发
---

## 微信内网页

### 自定义微信和QQ分享链接的卡片样式

#### 代码

在 HTML 中引入微信和 QQ 的 JS-SDK。

```html
<script src="//res.wx.qq.com/open/js/jweixin-1.6.0.js"></script>
<script src="//qzonestyle.gtimg.cn/qzone/qzact/common/share/share.js"></script>
```

然后执行下面两个函数，就可以自定义 QQ 和微信的分享卡片的样式了。

注意，下面的 `wxApi` 是后端用于对微信 API 进行签名的接口，相关信息见 [附录1-JS-SDK使用权限签名算法](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/JS-SDK.html#62)。

```js
// 自定义 QQ 分享卡片样式
function setQQShareCard(shareData) {
  setShareInfo({
    title: shareData.msgShareTitle,
    summary: shareData.desc,
    pic: shareData.imgUrl,
    url: window.location.href.split('#')[0],
  })
}

// 自定义微信分享卡片样式
function setWXShareCard(shareData) {
  var wxApi = 'https://generate.wechat.jssdk.signature'

  axios.post(wxApi, {
    headers: {
      'content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json'
    },
    data: {
      url: encodeURIComponent(window.location.href),
    },
  })
    .then(function (res) {
      // 注入权限验证配置
      wx.config({
        debug: false,
        appId: res.data.appId,
        timestamp: res.data.timestamp,
        nonceStr: res.data.nonceStr,
        signature: res.data.signature,
        jsApiList: [
          'updateAppMessageShareData',
          'updateTimelineShareData',
        ],
      })
      wx.ready(function () {
        // 自定义分享给微信/QQ 好友的卡片样式
        // 但是 QQ 好友卡片样式好像不受此设置影响
        wx.updateAppMessageShareData({
          title: shareData.msgShareTitle,
          desc: shareData.desc,
          link: shareData.link,
          imgUrl: shareData.imgUrl,
        })
        // 自定义分享到朋友圈/QQ 空间的卡片样式
        // 但是 QQ 空间卡片样式好像不受此设置影响
        wx.updateTimelineShareData({
          title: shareData.tlShareTitle,
          link: shareData.link,
          imgUrl: shareData.imgUrl,
        })
      })
      wx.error(function (res) {})
    })
    .catch(function (error) {})
}
```

#### 参考链接

- [微信网页开发 /JS-SDK说明文档](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/JS-SDK.html)：介绍微信中分享给朋友/朋友圈所需的 JS-SDK 的引入、权限验证配置及分享卡片的自定义
- [自定义QQ和微信分享卡片](https://juejin.cn/post/6905961701514936334)：微信分享在官方文档中已解决，这篇文章所说的自定义 QQ 分享的方法只有部分字段起作用
- [setShareInfo | 手机 QQ 接口文档](https://open.mobile.qq.com/api/mqq/index#api:setShareInfo)：腾讯官方文档，从自己在石墨文档中一篇比较老的笔记里翻出来的，也是只有部分字段起作用
- [对外分享组件接口文档 | 手机 QQ](https://open.mobile.qq.com/api/component/share)：这篇文档是可以完全起作用的

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

#### 参考资料

- [移动端字体放大问题的研究](https://juejin.cn/post/6844903507061932040)：介绍了 iOS 系统、Android 系统和 Android 微信分别是如何修改默认字号的，以及该如何解决。
- [关于微信安卓端网页字体适配的通知](https://developers.weixin.qq.com/community/develop/doc/000a26b86948f8743cb9a6da951409)：微信官方通知，给出了用户该如何设置网页为默认字号的示例代码。
- [Wechat Dev Notes #30](https://github.com/leoyoung07/blog/issues/30)：介绍了 Android 设置 Webview 默认字号时可能出现的问题。

## 微信公众号

### 微信内网页静默获取 OpenID

在将公司业务接入微信支付，调用微信支付 API 的统一下单接口时，需要用户的 OpenID 来生成预支付订单信息。而只是获取 OpenID 的话，不需要用户主动授权，直接静默授权就可以，具体流程如下。

#### 流程梳理

官方文档：[微信网页开发 - 网页授权](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/Wechat_webpage_authorization.html)

关键流程如下：

#### 访问微信 URL

公众号内的**前端**页面将用户定向至微信 URL：
`https://open.weixin.qq.com/connect/oauth2/authorize?appid=${APPID}&redirect_uri=${encodedURIComponent(REDIRECT_URI)}&response_type=code&scope=snsapi_base&state=${CUSTOM_STATE}#wechat_redirect`

注意，是直接让用户 **在浏览器的前端页面中** 访问该 URL，不要用 axios 之类的库将该 URL 作为 API 调用，不管是在前端还是在后端调用都不行，会出错。

然后微信会将用户定向至开发者所指定的重定向 URL：
`${REDIRECT_URI}/?code=${CODE}&state=${CUSTOM_STATE}`

#### 用 code 换 openid、access_token

**后端**根据重定向 URL 中的 code，调用下面的 API，换取 openid、网页授权 access_token 及其他信息：

`https://api.weixin.qq.com/sns/oauth2/access_token?appid=${APPID}&secret=${SECRET}&code=${CODE}&grant_type=authorization_code`

该 API 不能在前端调用，不然会泄露 `secret`。

请求成功时，响应结果如下：

```json
{
  "access_token":"ACCESS_TOKEN",
  "expires_in":7200,
  "refresh_token":"REFRESH_TOKEN",
  "openid":"OPENID",
  "scope":"snsapi_base"
}
```

#### 调用脚手架实现

TNWX 文档链接：[授权获取用户信息](https://javen205.gitee.io/tnwx/guide/wxmp/oauth.html)

需要用户发起支付请求的前端页面，调用脚手架 API `toAuth`，会将用户定向至 API `auth`，该 API 会返回 `access_token`、`openid` 等信息。

但是在实际操作中，调用脚手架未成功，查看后台报错信息，似乎跟代码逻辑不完善有关，于是手动通过 axios 来获取 OpenID，代码也很简单。

#### 已关注用户 vs 未关注用户

用自己的微信账号测试，未关注公众号时，按照上面流程所获取到的 OpenID，和关注公众号之后，按照同样流程获取到的 OpenID 是相同的。

如果这是微信默认的行为的话，那就先不用管用户是否关注公众号了，因为是同一个 OpenID。

#### 类似功能

[微信内网页授权获取用户信息](https://github.com/Dream4ever/Knowledge-Base/issues/157)

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
