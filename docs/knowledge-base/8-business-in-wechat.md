---
sidebar_position: 8
title: 微信/QQ内业务开发
---

## 公司接入微信支付功能

### 需求描述

公司最近规划中的一项付费业务，需要在公众号里的网页中使用微信支付功能，也就是 JSAPI 支付。

### 商户号申请

入口：[公众号接入支付](https://pay.weixin.qq.com/static/applyment_guide/applyment_detail_public.shtml)

用**财务同事的微信号**作为商户的**超级管理员**，来申请开通商户号，因为超管账号有**操作资金的权限**，这个账号不能由开发部门来负责，得由财务部门来负责。

会用到微信支付功能的网页，所属公众号是用子公司资料注册的，而微信支付的申请，财务的同事强烈建议用母公司的资料来做。这样就导致微信支付和公众号所关联的主体公司不同，在申请开通微信支付时，是没办法将公众号关联到商户号上的。只有在微信支付开通成功之后，用超管账号登录管理后台，手动关联才行。

#### 商户号查看

在“微信支付商家助手”小程序中，点击首页顶部的公司名称，在打开的页面中，最上方的公司名称下面，就有商户号的编号。

### 商户号配置

#### 【需超管】授权开发人员账号

对于开发人员，超级管理员还需为其账号授予下面三项权限，以便其顺利接入微信支付功能：

- API 证书查看
- API 证书续期
- 密钥修改

### 【需超管】绑定公众号 AppID

由于商户号是用母公司身份申请的，而需要关联的公众号 AppID 是用子公司身份申请的，为官方文档 [商户申请接入时，如何确认绑定关系？](https://kf.qq.com/faq/180910QZzmaE180910vQJfIB.html) 中所说的情况三：申请绑定主体不一致的 AppID。

先登录 [微信支付后台](https://pay.weixin.qq.com/)，依次进入 产品中心 → AppID 账号管理，点击按钮“关联 AppID”，填写公众号的 AppID 和 AppID 认证主体这两项信息，并提交操作。

然后登录 [微信公众平台](https://mp.weixin.qq.com/)，点击左侧的“微信支付”，允许商户关联的请求。

#### 【需超管】申请 API 证书

[参考文档](https://kf.qq.com/faq/161222NneAJf161222U7fARv.html)

按照流程申请并下载证书及私钥文件，发送给开发人员，以便顺利接入微信支付功能。

TODO: 配置商户证书，是否就是“申请 API 证书”？

[参考文档](https://pay.weixin.qq.com/wiki/doc/apiv3/open/pay/chapter2_1.shtml#part-5)

##### 注意事项：证书安全

[接口规则 - 安全规范](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=4_3)

1. 证书文件不应放在 Web 服务器目录下，而应放在有访问权限控制的目录中，防止被他人下载；
2. 建议将证书文件名改为复杂且不容易猜测的文件名，提升安全性；
3. 服务器要做好病毒和木马防护工作，不被非法侵入者窃取证书文件。

#### 【需授权】配置 API 密钥

[参考文档](https://pay.weixin.qq.com/wiki/doc/apiv3/open/pay/chapter2_1.shtml#part-4)

证书用途：涉及敏感操作时，比如资金回滚、退款、撤销等，需要用商户证书来校验机构身份。

#### 【需超管】设置支付授权目录（公众号内前端页面）

[参考文档](https://pay.weixin.qq.com/wiki/doc/apiv3/open/pay/chapter2_1.shtml#part-6)

支付授权目录，就是会调用“微信支付收银台”的页面地址。

建议将其设置为带协议格式的顶级域名，比如：https://www.weixin.com/ ，这样只校验顶级域名，域名下的任何页面都可以调用微信支付功能，会比较方便。

#### 设置授权域名（公众号关联的后端服务）

开发 JSAPI 支付功能时，在下单接口中必须要传用户的 openid。

要实现这一需求，就得在公众号中设置允许获取 openid 的域名，这样该域名才能合法获取 openid。

在公司的实际业务中，使用专门提供后端 API 服务的那个域名应该就可以？到时候验证一下。

### 微信支付整体流程

看懂了 [业务流程图](https://pay.weixin.qq.com/wiki/doc/apiv3/open/pay/chapter2_3.shtml#part-5)，对于微信支付过程中，需要后端参与的部分就清楚了。其实主要就是下面几个关键步骤：

- `步骤3`：用户下单发起支付，商户通过 [统一下单 API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_1.shtml) 创建支付订单。
- `步骤8`：用户继续发起支付，商户通过 [JSAPI 调起支付API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_4.shtml) 调起微信支付，用之前创建的支付订单发起支付请求。
- `步骤15`：用户支付成功后，商户接收微信的 [支付结果通知 API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_5.shtml) 所发来的支付结果。
- `步骤20`：如果商户没有接收到微信支付结果通知（4 小时），需要主动调用 [查询订单 API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_2.shtml) 查询支付结果。

### 配置微信公众号开发环境

#### 启用公众号开发设置

启用开发者密码（AppSecret）：该信息用于验证公众号开发者身份，要记录在安全的地方，公众平台显示一次之后不再显示，如果忘记就只能重置该信息。

添加 IP 白名单：对于用来获取 OpenID 的后端服务，要将其所在服务器的 IP 添加到公众号的 开发 → 基本配置 → 公众号开发信息 → IP 白名单 中。

#### 启用公众号服务器配置

配置服务器地址（URL），该地址用于接收微信消息和事件的接口。

令牌（Token）和消息加解密密钥（EncodingAESKey）按照页面要求来配置即可。

微信会对上面所提供的服务器地址和令牌进行验证，验证流程见官方文档：[接入指南](https://developers.weixin.qq.com/doc/offiaccount/Basic_Information/Access_Overview.html)。

用了脚手架 TNWX 之后，微信验证就很简单了：

```js
// 引入公众号的配置信息
import config from '../../config'
// 引入 TNWX 库的必要功能
import {
  ApiConfig,
  ApiConfigKit,
  WeChat,
} from 'tnwx'

// 加载公众号配置信息
let devApiConfig = new ApiConfig(
  config.mpgyxq.appId,
  config.mpgyxq.appSecret,
  config.mpgyxq.token,
)

// 使用公众号配置信息
ApiConfigKit.putApiConfig(devApiConfig)
// 开启开发模式，方便调试
ApiConfigKit.devMode = true
// 设置当前应用
ApiConfigKit.setCurrentAppId(devApiConfig.getAppId)

// 按照官方文档的验证流程，返回相应信息，即可通过验证
export const checksignature = async (req, res) => {
  let appId = req.query.appId
  if (appId) {
      ApiConfigKit.setCurrentAppId(appId)
  }

  let signature = req.query.signature,
      timestamp = req.query.timestamp,
      nonce = req.query.nonce,
      echostr = req.query.echostr
  res.send(WeChat.checkSignature(signature, timestamp,nonce, echostr))
}
```

验证通过之后，即可启用服务器配置。

### 恢复公众号菜单及自动回复功能

见 [编程方式实现公众号菜单](https://www.hewei.in/knowledge-base/business-in-wechat#%E7%BC%96%E7%A8%8B%E6%96%B9%E5%BC%8F%E5%AE%9E%E7%8E%B0%E5%85%AC%E4%BC%97%E5%8F%B7%E8%8F%9C%E5%8D%95) 及 [编程方式实现自动回复功能](https://www.hewei.in/knowledge-base/business-in-wechat#%E7%BC%96%E7%A8%8B%E6%96%B9%E5%BC%8F%E5%AE%9E%E7%8E%B0%E8%87%AA%E5%8A%A8%E5%9B%9E%E5%A4%8D%E5%8A%9F%E8%83%BD)。

### 静默获取 OpenID

调用微信支付 API 的统一下单接口时，需要用户的 OpenID 来生成预支付订单信息，而只是获取 OpenID 的话，不需要用户主动授权，直接静默授权就可以，那就不打扰用户了，采用静默授权获取即可。

完整流程见 [微信内网页静默获取 OpenID](https://github.com/Dream4ever/Knowledge-Base/issues/156)。

### 微信支付 API v3

[官方文档](https://pay.weixin.qq.com/wiki/doc/apiv3/wechatpay/wechatpay-1.shtml)

[JSAPI 支付 v2 旧版文档](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=7_1)：有些内容在新版的 v3 文档中没有写，可以来旧版文档中找资料，比如下面统一下单的订单号的生成建议。

#### 【服务端】统一下单

官方文档：[统一下单 API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_1.shtml)

在实际项目中，直接使用了 TNWX 的 [示例代码](https://gitee.com/javen205/TNWX/blob/master/sample/egg/app/controller/wxpay.ts)。

其中的 case 13，就是后端根据用户传来的 OpenID，调用 JSAPI 支付方式的统一下单接口获取预支付订单号：`{ "prepay_id": "wx201410272009395522657a690389285100" }`。

然后根据预支付订单号再构造签名串、计算签名值，将这些信息返回给前端，因为这都是最终支付时所需要的，所以 case 13 中一次性将这些步骤都完成了，自己在实际项目中的代码也是如此操作的。

##### 注意事项

**订单号** ：应按什么规则生成？[旧版文档](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_2) 中对于订单号的生成给出了建议：根据当前系统时间加随机序列来生成订单号。

**交易结束时间** ：API 调用成功的话，返回的预支付交易会话标识有效期为 2 小时。所以调用该接口时，请求中的交易结束时间也设置为 2 小时？

**通知地址** ：用于接收支付结果的接口地址，**必须为 https，且应当能直接访问，不能携带查询字符串**。

**错误码** ：根据对应的错误码，在前端页面中给用户以相应提示。

#### 【客户端】JSAPI 调起支付

官方文档：[JSAPI 调起支付 API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_4.shtml)

后端生成支付所需签名串和签名的过程，也在 TNWX 的 [示例代码](https://gitee.com/javen205/TNWX/blob/master/sample/egg/app/controller/wxpay.ts) 的 case 13 中。

前端拿到支付所需的各种数据之后，执行下面的代码，即可完成最终支付：

```js
function onBridgeReady() {
  WeixinJSBridge.invoke('getBrandWCPayRequest', {
    //公众号名称，由商户传入
    "appId": "wx2421b1c4370ec43b",
    //时间戳，自1970年以来的秒数
    "timeStamp": "1395712654",
    //随机串
    "nonceStr": "e61463f8efa94090b1f366cccfbbb444",
    "package": "prepay_id=up_wx21201855730335ac86f8c43d1889123400",
    //微信签名方式：
    "signType": "RSA",
    //微信签名
    "paySign": "oR9d8PuhnIc+YZ8cBHFCwfgpaK9gd7vaRvkYD7rthRAZ\/X+QBhcCYL21N7cHCTUxbQ+EAt6Uy+lwSN22f5YZvI45MLko8Pfso0jm46v5hqcVwrk6uddkGuT+Cdvu4WBqDzaDjnNa5UK3GfE1Wfl2gHxIIY5lLdUgWFts17D4WuolLLkiFZV+JSHMvH7eaLdT9N5GBovBwu5yYKUR7skR8Fu+LozcSqQixnlEZUfyE55feLOQTUYzLmR9pNtPbPsu6WVhbNHMS3Ss2+AehHvz+n64GDmXxbX++IOBvm2olHu3PsOUGRwhudhVf7UcGcunXt8cqNjKNqZLhLw4jq\/xDg=="
  },
  function(res) {
    if (res.err_msg == "get_brand_wcpay_request:ok") {
      // 使用以上方式判断前端返回,微信团队郑重提示：
      //res.err_msg将在用户支付成功后返回ok，但并不保证它绝对可靠。
    }
  });
}
if (typeof WeixinJSBridge == "undefined") {
  if (document.addEventListener) {
    document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
  } else if (document.attachEvent) {
    document.attachEvent('WeixinJSBridgeReady', onBridgeReady);
    document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
  }
} else {
  onBridgeReady();
}
```

##### 注意事项

JSAPI 是微信 APP 内的功能，调起支付 API 不需要请求外部接口。

另外，在上面的示例代码中，用的是 `WeixinJSBridge.invoke('getBrandWCPayRequest', {})` 这个 API 发起支付。和 `wx.chooseWXPay` 相比，前者不需要引入 `jweixin` 这个文件，也不需要调用 `wx.config` 接口，来注入权限验证配置，更方便一些。

不过如果公众号还有其它需要调用微信 JS-SDK 的需求，那么还是需要引入 `jweixin`，也还是需要调用 `wx.config` 接口，来注入权限验证配置，这个就根据自己实际业务需求来判断吧。

参考资料：

- [微信支付js接口chooseWXPay与WeixinJSBridge有什么不同](https://developers.weixin.qq.com/community/pay/doc/000ca28374cb20f6ff483ced651400)
- [微信支付getBrandWCPayRequest和wx.chooseWXPay有何区别？](https://segmentfault.com/q/1010000002949321)

#### 【服务端】接收支付结果通知

官方文档：[支付通知API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_5.shtml)

##### 注意事项

**回调 URL**：这里用于接收支付结果通知的回调 URL，就是在前面统一下单接口中，传给微信的“通知地址”字段。

**通知规则**：用户支付完成后，微信会把支付结果和用户信息发给该回调 URL，服务端保存该支付通知，并返回应答信息，以告知微信已成功接收到支付通知。

返回的应答如果不符合微信规范或返回超时，微信会以一定的频率重新发起通知： 15s/15s/30s/3m/10m/20m/30m/30m/30m/60m/3h/3h/3h/6h/6h - 总计 24h4m。

##### 签名验证

微信会对发给商户的通知进行签名，签名数据在 HTTP header 的 `Wechatpay-Signature` 字段中，缺失该字段或者字段值验签不通过，均视为不可信的回调请求。

具体的签名验证过程，见官方文档 [签名验证](https://pay.weixin.qq.com/wiki/doc/apiv3/wechatpay/wechatpay4_1.shtml)。

要验证收到的通知信息，首先需要 **微信支付平台证书** 中的公钥，注意，这个和前面提到过的商户 API 证书是不同的。

微信支付平台证书的获取方法见文档 [获取平台证书列表](https://pay.weixin.qq.com/wiki/doc/apiv3/wechatpay/wechatpay5_1.shtml)，其中 HTTP 请求头 `Authorization` 字段的值，按照文档 [签名生成](https://pay.weixin.qq.com/wiki/doc/apiv3/wechatpay/wechatpay4_0.shtml) 中的方法生成即可。

在脚手架 TNWX 中，如果单纯设置 HTTP 请求头 `Authorization` 字段的值，调用 `PayKit.buildAuthorization` 方法即可。如果要获取平台证书列表，调用 `PayKit.exeGet` 方法即可。

如果调用“获取平台证书列表”接口成功，则响应头和响应体的数据如下：

```
// 响应头
{
  'wechatpay-nonce': '****',
  'wechatpay-signature': '****',
  'wechatpay-timestamp': '1612346036',
  'wechatpay-serial': '5157F09EFDC096DE15EBE81A47057A7232F1B8E1'
}

// 响应体
{
  "data": [
      {
          "serial_no": "5157F09EFDC096DE15EBE81A47057A7232F1B8E1",
          "effective_time ": "2018-06-08T10:34:56+08:00",
          "expire_time ": "2018-12-08T10:34:56+08:00",
          "encrypt_certificate": {
              "algorithm": "AEAD_AES_256_GCM",
              "nonce": "61f9c719728a",
              "associated_data": "certificate",
              "ciphertext": "sRvt… "
          }
      },
      {
          "serial_no": "50062CE505775F070CAB06E697F1BBD1AD4F4D87",
          "effective_time ": "2018-12-07T10:34:56+08:00",
          "expire_time ": "2020-12-07T10:34:56+08:00",
          "encrypt_certificate": {
              "algorithm": "AEAD_AES_256_GCM",
              "nonce": "35f9c719727b",
              "associated_data": "certificate",
              "ciphertext": "aBvt… "
          }
      }
  ]
}
```

TODO: 那么是否要根据文档 [证书和回调报文解密](https://pay.weixin.qq.com/wiki/doc/apiv3/wechatpay/wechatpay4_2.shtml#part-1) 中所说的步骤，对证书进行解密？但是响应体会返回多个证书，对哪个证书进行解密？是只解密响应头 `wechatpay-serial` 中所记录的那个证书就行？

##### 报文解密

对于验签通过的回调，再对 HTTP body 进行解密。

- 商户平台上设置的 API v3 密钥为 key
- 回调 HTTP body 中的 resource.algorithm 中为算法（目前为AEAD_AES_256_GCM）
- 用上面的 key 和 HTTP body 中的 resource.nonce 和 resource.associated_data 作为算法的参数，对 HTTP body 中的密文 resource.ciphertext 进行解密，就得到了 JSON 格式的原始通知内容

拿到了通知的原始内容后，主要看交易状态字段 `trade_state` 的值，根据该值的内容，进行对应的处理。最简单的当然是支付成功了，但是其他情况也要处理。

##### 通知应答

如果回调处理异常，服务端返回给微信的 HTTP 状态码应当是 4XX 或者 500。

只有返回 200 或 204，微信才认为服务端正常接收到了支付结果的通知。

商户后台应答失败（商户失败？微信失败？）时，微信支付会记录应答的报文（HTTP body），建议商户用下面的格式返回。

```
{   
    "code": "ERROR_NAME",
    "message": "ERROR_DESCRIPTION",
}
```

##### 处理重复通知

from 官方文档：

> 同样的通知可能会多次发送给商户系统。商户系统必须能够正确处理重复的通知。 推荐的做法是，当商户系统收到通知进行处理时，先检查对应业务数据的状态，并判断该通知是否已经处理。如果未处理，则再进行处理；如果已处理，则直接返回结果成功。在对业务数据进行状态检查和处理之前，要采用数据锁进行并发控制，以避免函数重入造成的数据混乱。

相关参考资料：

- 关键词：node.js 支付 数据锁
- [nodejs 高并发下请求同一资源](https://segmentfault.com/q/1010000004328578)
- 关键词：mongodb 加锁
- [MongoDB 的锁事](https://generalthink.github.io/2019/07/05/mongodb-locks/)
- [mongo锁机制简介](https://zhuanlan.zhihu.com/p/70895268)
- 关键词：微信 支付 通知 多次 锁
- [为了避免出现订单重复支付的现象，产品的支付逻辑该怎么设计？](https://wen.woshipm.com/question/detail/8l1jf.html)
- [YClimb的专栏 - 浅析微信支付系列](https://segmentfault.com/blog/yclimb)

**4 小时内无通知**：如果在 4 小时内都没有收到微信的支付结果通知，就需要主动调用查询订单接口，来确认订单状态。

#### Postman 脚本

[微信支付API v3 Postman脚本](https://github.com/wechatpay-apiv3/wechatpay-postman-script)

### 参考资料

在 V2EX、掘金、思否等社区查找有价值的文档。

GitHub 上的一个用 TypeScript 写的微信平台开发脚手架：[Javen205 / TNWX](https://github.com/javen205/TNWX) 挺不错，提供了微信平台开发的各方面功能，在项目中用上了。

未使用：

- GitHub 上有个用 TS 写的项目：[klover2 / wechatpay-node-v3-ts](https://github.com/klover2/wechatpay-node-v3-ts)，是用于微信支付 API v3 版本的，看看代码，可以的话就直接应用到项目里。
- Gitee 上有个两年没更新的项目，也是用 TS 写的，同时支持微信支付和支付宝支付，也可以借鉴：[Notadd / nt-addon-pay](https://gitee.com/notadd/nt-addon-pay)。

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

### 禁止 X5 浏览器（手Q/微信）播放完视频后推荐相关内容

#### 解决方法

在 video 标签中加上这么一条参数即可：

```
mtt-playsinline="true"
```

#### 信息来源

《[复杂帧动画之移动端video采坑实现](https://juejin.im/post/5d513623e51d453b72147600)》提到了解决方法：

> 这个 video 我是设置了循环播放的，硬生生 QQ 浏览器就在视频播放完毕后展示推荐视频，并且停止了我的循环播放，这让我的页面显的有点 low， 这明显是不仁道的，尝试无果之后，于是我咨询 QQ 浏览器的同事帮忙这个问题， 他让我在 video 标签上加上这个属性，即可使用系统播放器，而拒绝被拦截植入推荐视屏， 感谢@eddiecmchen 提供的意见
> mtt-playsinline="true"

## 微信公众号

### 微信内网页授权获取用户信息

#### 注意

> 对于已关注公众号的用户，如果用户从公众号的会话或者自定义菜单进入本公众号的网页授权页，即使是 scope 为 snsapi_userinfo，也是静默授权，用户无感知。

经过实际测试，对于已关注公众号的用户，通过公众号会话或自定义菜单，进入该公众号的网页授权页时，会短暂显示一个“正在登录中”的 toast，然后就能获取到下面所列出的用户基本信息了。

#### 功能说明

官方文档：[网页授权 | 微信网页开发](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/Wechat_webpage_authorization.html)。

该功能用于获取微信用户的昵称、性别、国家、省份、城市、头像 URL 等信息。

#### 整体流程

##### 前端获取用户授权

公众号内的前端页面将用户定向至微信 URL：

`https://open.weixin.qq.com/connect/oauth2/authorize?appid=${APPID}&redirect_uri=${encodedURIComponent(REDIRECT_URI)}&response_type=code&scope=snsapi_userinfo&state=${CUSTOM_STATE}#wechat_redirect`

注意，是直接让用户 **在浏览器的前端页面中** 访问该 URL，不要用 axios 之类的库将该 URL 作为 API 调用，不管是在前端还是在后端调用都不行，会出错。

然后微信会给用户展示如下内容，告知用户当前网页申请获取用户基本信息。

![image](https://user-images.githubusercontent.com/2596367/123397349-e6fc2780-d5d4-11eb-9eeb-7a9c09886068.png)

如用户允许获取，微信就会将用户定向至开发者所指定的重定向 URL：

`${REDIRECT_URI}/?code=${CODE}&state=${CUSTOM_STATE}`

##### 后端用 code 换 openid、access_token

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

##### 获取用户基本信息

上一步拿到用户的 openid 和 access_token 之后，**后端**就可以用它们来获取用户基本信息了：

`https://api.weixin.qq.com/sns/userinfo?access_token=${ACCESS_TOKEN}&openid=${OPENID}&lang=zh_CN`

请求成功时，响应结果格式如下：

```json
{   
  "openid": "OPENID",
  "nickname": "NICKNAME",
  "sex": 1,
  "province":"PROVINCE",
  "city":"CITY",
  "country":"COUNTRY",
  "headimgurl":"https://thirdwx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/46",
  "privilege":[ "PRIVILEGE1" "PRIVILEGE2"     ],
  "unionid": "o6_bmasdasdsad6_2sgVt7hMZOPfL"
}
```

拿到用户基本信息之后，就可以将必要的信息保存在数据库中，同时返回给前端，以便使用。

#### 类似功能

[微信内网页静默获取 OpenID](https://github.com/Dream4ever/Knowledge-Base/issues/156)：两者整体流程相同，主要区别有下面几点：

1. 调用微信服务时所传的参数不同。微信内网页静默获取 OpenID 时，`scope` 字段的值为 `snsapi_base`。而在获取用户基本信息时，`scope` 字段的值则为 `snsapi_userinfo`。
2. 用 `code` 拿到用户的 OpenID 之后，如果需要获取用户信息，则还需要再调用微信的一个 API。不需要的话，就可以结束了。

#### 可能要踩的坑

- [微信网页授权+分享踩过的坑](https://segmentfault.com/a/1190000019031655)
- [网页授权，当用户进入一个已经授权过的页面如何能不提示“近期已授权“直接进入回调](https://developers.weixin.qq.com/community/develop/doc/00024277d8c04888aa583bba256c00)


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
