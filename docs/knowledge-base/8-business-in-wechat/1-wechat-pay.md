---
sidebar_position: 1
title: 微信支付
---

## 微信支付接入流程

### 商户号申请

入口：[公众号接入支付](https://pay.weixin.qq.com/static/applyment_guide/applyment_detail_public.shtml)

用**财务同事的微信号**作为商户的**超级管理员**，来申请开通商户号，因为超管账号有**操作资金的权限**，这个账号不能由开发部门来负责，得由财务部门来负责。

会用到微信支付功能的网页，所属公众号是用子公司资料注册的，而微信支付的申请，财务的同事强烈建议用母公司的资料来做。这样就导致微信支付和公众号所关联的主体公司不同，在申请开通微信支付时，是没办法将公众号关联到商户号上的。只有在微信支付开通成功之后，用超管账号登录管理后台，手动关联才行。

### 商户号查看

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

[什么是商户API证书？如何获取商户API证书？](https://kf.qq.com/faq/161222NneAJf161222U7fARv.html)

按照流程申请并下载证书及私钥文件，发送给开发人员，以便顺利接入微信支付功能。

[接入前准备 - 4.下载并配置商户证书](https://pay.weixin.qq.com/wiki/doc/apiv3/open/pay/chapter2_1.shtml#part-5)

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

## 微信支付整体流程

看懂了 [业务流程图](https://pay.weixin.qq.com/wiki/doc/apiv3/open/pay/chapter2_3.shtml#part-5)，对于微信支付过程中，需要后端参与的部分就清楚了。其实主要就是下面几个关键步骤：

- `步骤3`：用户下单发起支付，商户通过 [统一下单 API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_1.shtml) 创建支付订单。
- `步骤8`：用户继续发起支付，商户通过 [JSAPI 调起支付API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_4.shtml) 调起微信支付，用之前创建的支付订单发起支付请求。
- `步骤15`：用户支付成功后，商户接收微信的 [支付结果通知 API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_5.shtml) 所发来的支付结果。
- `步骤20`：如果商户没有接收到微信支付结果通知（4 小时），需要主动调用 [查询订单 API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_2.shtml) 查询支付结果。

## 微信支付 API v3

[官方文档](https://pay.weixin.qq.com/wiki/doc/apiv3/wechatpay/wechatpay-1.shtml)

[JSAPI 支付 v2 旧版文档](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=7_1)：有些内容在新版的 v3 文档中没有写，可以来旧版文档中找资料，比如下面统一下单的订单号的生成建议。

### 【服务端】统一下单

官方文档：[统一下单 API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_1.shtml)

在实际项目中，直接使用了 TNWX 的 [示例代码](https://gitee.com/javen205/TNWX/blob/master/sample/egg/app/controller/wxpay.ts)。

其中的 case 13，就是后端根据用户传来的 OpenID，调用 JSAPI 支付方式的统一下单接口获取预支付订单号：`{ "prepay_id": "wx201410272009395522657a690389285100" }`。

然后根据预支付订单号再构造签名串、计算签名值，将这些信息返回给前端，因为这都是最终支付时所需要的，所以 case 13 中一次性将这些步骤都完成了，自己在实际项目中的代码也是如此操作的。

#### 注意事项

**订单号** ：应按什么规则生成？[旧版文档](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_2) 中对于订单号的生成给出了建议：根据当前系统时间加随机序列来生成订单号。

**交易结束时间** ：API 调用成功的话，返回的预支付交易会话标识有效期为 2 小时。所以调用该接口时，请求中的交易结束时间也设置为 2 小时？

**通知地址** ：用于接收支付结果的接口地址，**必须为 https，且应当能直接访问，不能携带查询字符串**。

**错误码** ：根据对应的错误码，在前端页面中给用户以相应提示。

### 【客户端】JSAPI 调起支付

官方文档：[JSAPI 调起支付 API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_4.shtml)

后端生成支付所需签名串和签名的过程，也在 TNWX 的 [示例代码](https://gitee.com/javen205/TNWX/blob/master/sample/egg/app/controller/wxpay.ts) 的 case 13 中。

前端拿到支付所需的各种数据之后，执行下面的代码，即可完成最终支付：

```js
function onBridgeReady() {
  WeixinJSBridge.invoke('getBrandWCPayRequest', {
    //公众号名称，由商户传入
    "appId": "xxxx",
    //时间戳，自1970年以来的秒数
    "timeStamp": "1111",
    //随机串
    "nonceStr": "1111",
    "package": "prepay_id=up_wx1111",
    //微信签名方式：
    "signType": "RSA",
    //微信签名
    "paySign": "1111"
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

#### 注意事项

JSAPI 是微信 APP 内的功能，调起支付 API 不需要请求外部接口。

另外，在上面的示例代码中，用的是 `WeixinJSBridge.invoke('getBrandWCPayRequest', {})` 这个 API 发起支付。和 `wx.chooseWXPay` 相比，前者不需要引入 `jweixin` 这个文件，也不需要调用 `wx.config` 接口，来注入权限验证配置，更方便一些。

不过如果公众号还有其它需要调用微信 JS-SDK 的需求，那么还是需要引入 `jweixin`，也还是需要调用 `wx.config` 接口，来注入权限验证配置，这个就根据自己实际业务需求来判断。

参考资料：

- [微信支付js接口chooseWXPay与WeixinJSBridge有什么不同](https://developers.weixin.qq.com/community/pay/doc/000ca28374cb20f6ff483ced651400)
- [微信支付getBrandWCPayRequest和wx.chooseWXPay有何区别？](https://segmentfault.com/q/1010000002949321)

### 金额计算/精度问题

如果用 JS 自带的方法计算金额，会出现精度丢失的问题，比如 `69.1 * 100` 计算出来的结果是 6909.999999999999。如果将这样的结果传给微信支付，就会报错：`无法将 JSON 输入源“/body/amount/total”映射到目标字段“总金额”中，此字段需要一个合法的 64 位有符号整数`。

务必要用 [decimal.js](https://github.com/MikeMcl/decimal.js) 之类的库来计算金额，以确保最终计算出来的订单金额是整数（以“分”为单位）。

### 【服务端】接收支付结果通知

官方文档：[支付通知API](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/chapter3_1_5.shtml)

#### 注意事项

**回调 URL**：这里用于接收支付结果通知的回调 URL，就是在前面统一下单接口中，传给微信的“通知地址”字段。

**通知规则**：用户支付完成后，微信会把支付结果和用户信息发给该回调 URL，服务端保存该支付通知，并返回应答信息，以告知微信已成功接收到支付通知。

返回的应答如果不符合微信规范或返回超时，微信会以一定的频率重新发起通知： 15s/15s/30s/3m/10m/20m/30m/30m/30m/60m/3h/3h/3h/6h/6h - 总计 24h4m。

#### 签名验证

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
  'wechatpay-timestamp': '1111',
  'wechatpay-serial': '1111'
}

// 响应体
{
  "data": [
      {
          "serial_no": "1111",
          "effective_time ": "2018-06-08T10:34:56+08:00",
          "expire_time ": "2018-12-08T10:34:56+08:00",
          "encrypt_certificate": {
              "algorithm": "AEAD_AES_256_GCM",
              "nonce": "1111",
              "associated_data": "certificate",
              "ciphertext": "1111"
          }
      },
      {
          "serial_no": "1111",
          "effective_time ": "2018-12-07T10:34:56+08:00",
          "expire_time ": "2020-12-07T10:34:56+08:00",
          "encrypt_certificate": {
              "algorithm": "AEAD_AES_256_GCM",
              "nonce": "1111",
              "associated_data": "certificate",
              "ciphertext": "1111"
          }
      }
  ]
}
```

TODO: 那么是否要根据文档 [证书和回调报文解密](https://pay.weixin.qq.com/wiki/doc/apiv3/wechatpay/wechatpay4_2.shtml#part-1) 中所说的步骤，对证书进行解密？但是响应体会返回多个证书，对哪个证书进行解密？是只解密响应头 `wechatpay-serial` 中所记录的那个证书就行？

#### 报文解密

对于验签通过的回调，再对 HTTP body 进行解密。

- 商户平台上设置的 API v3 密钥为 key
- 回调 HTTP body 中的 resource.algorithm 中为算法（目前为AEAD_AES_256_GCM）
- 用上面的 key 和 HTTP body 中的 resource.nonce 和 resource.associated_data 作为算法的参数，对 HTTP body 中的密文 resource.ciphertext 进行解密，就得到了 JSON 格式的原始通知内容

拿到了通知的原始内容后，主要看交易状态字段 `trade_state` 的值，根据该值的内容，进行对应的处理。最简单的当然是支付成功了，但是其他情况也要处理。

#### 金额问题

微信返回的支付结果中，`amount.total` 和 `amount.payer_total` 的值可能不一样，后者是用户使用了各种券之后的实际支付金额。

#### 通知应答

如果回调处理异常，服务端返回给微信的 HTTP 状态码应当是 4XX 或者 500。

只有返回 200 或 204，微信才认为服务端正常接收到了支付结果的通知。

商户后台应答失败（商户失败？微信失败？）时，微信支付会记录应答的报文（HTTP body），建议商户用下面的格式返回。

```
{   
    "code": "ERROR_NAME",
    "message": "ERROR_DESCRIPTION",
}
```

#### 处理重复通知

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

### Postman 脚本

[微信支付API v3 Postman脚本](https://github.com/wechatpay-apiv3/wechatpay-postman-script)

### 参考资料

在 V2EX、掘金、思否等社区查找有价值的文档。

GitHub 上的一个用 TypeScript 写的微信平台开发脚手架：[Javen205 / TNWX](https://github.com/javen205/TNWX) 挺不错，提供了微信平台开发的各方面功能，在项目中用上了。

未使用：

- GitHub 上有个用 TS 写的项目：[klover2 / wechatpay-node-v3-ts](https://github.com/klover2/wechatpay-node-v3-ts)，是用于微信支付 API v3 版本的，看看代码，可以的话就直接应用到项目里。
- Gitee 上有个两年没更新的项目，也是用 TS 写的，同时支持微信支付和支付宝支付，也可以借鉴：[Notadd / nt-addon-pay](https://gitee.com/notadd/nt-addon-pay)。

## 结算费率及入账周期

### 结算费率

费率：微信支付每笔交易收取的手续费，单位为“元”。出版社可选择的行业（符合资质要求或没有资质限制的），对应的费率为 0.6% 或 1%。

### 入账周期

入账周期：微信支付将交易款项划入商户账户的时间，单位为“天”。企业的入账周期全都是 T+1。

### 虚拟限额

虚拟限额：对于虚拟业务，微信支付有虚拟限额存在，该限额仅限制用户付款，不限制商户收款。单用户每笔付款限额 6000，每天限额 9000。有虚拟限额的业务不多，可以在小程序里把服务类目切换成其他的，就不会有虚拟限额了。

### 官方文档

- [入驻结算规则、行业属性及特殊资质](https://kf.qq.com/faq/220228IJb2UV220228uEjU3Q.html)：列出了各类主体（企业、事业单位、政府等）在开通微信支付时，可选择的行业及对应的结算费率和入账周期。
- [商户收款限额是多少？](https://kf.qq.com/touch/faq/200726QjeQFF200726Vryay6.html)

## 问题记录

### 风险异常 —— 交易停滞

财务同事有一天说公司微信支付账号出现异常情况。

登录微信支付后台，提示风险类型为“交易停滞”，处理方法为“调整收款额度（单日10000元），关闭信用卡支付权限”。

按照[官方页面](https://pay.weixin.qq.com/index.php/xphp/cviolated_mch_handle/merchant_details_do)的提示进入小程序，发现交易停滞的原因如下：

> 此商户由于近期未产生任何交易，存在经营异常情况，平台判定存在风险。如您目前有使用该商户号进行经营的诉求，请提交相关材料。平台将于7日内完成审核，审核通过后自动解除处罚

按照流程指引完成了解除处罚的申请，然后就是等待审核结果了。

## 关键名词

### 商户 API 证书

#### 用途

商户调用微信支付所有接口都需要用到该证书，比如下单接口、订单查询接口等。微信支付后台用于识别商户真实身份。

#### 证书更新

商户 API 证书有效期为 5 年，可访问 [该页面](https://myssl.com/cert_decode.html) 查看证书的有效期。

证书更新流程可查看 [该页面](https://kf.qq.com/faq/1808302quyqi180830EjANrq.html)，新证书申请并部署成功后，记得作废旧证书。

目前商户 API 证书只能通过 **网页端 + 单机软件** 更新，不支持 API 更新。

### 平台证书

#### 用途

- 微信支付验证商户的请求签名正确后，会在应答的HTTP头部中包括 **应答签名**。
- 微信支付会在回调的 HTTP 头部中带上 **回调报文的签名**。

对于微信返回的这两类签名，商户需要用 **微信支付平台证书** 中的公钥来验证签名的正确性。

#### 证书更新

平台证书有效期为 5 年，可调用 [获取平台证书](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/wechatpay5_1.shtml) 这个接口查看证书的有效期。

[获取平台证书](https://pay.weixin.qq.com/wiki/doc/apiv3/apis/wechatpay5_1.shtml) 这个接口同时也可以用来下载证书。

### 商户 API 证书 vs. 平台证书

简而言之，**商户 API 证书** 是微信用来验证商户身份的，**微信支付平台证书** 是商户用来验证微信身份的。

也可以查看 [私钥和证书](https://pay.weixin.qq.com/wiki/doc/apiv3/wechatpay/wechatpay3_1.shtml) 这篇官方文档。

## 参考资料

- [微信支付 API v3 接口文档](https://wechatpay-api.gitbook.io/wechatpay-api-v3/)
