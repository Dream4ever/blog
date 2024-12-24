---
slug: develop-email-verification-service
title: 开发邮箱验证服务
authors: HeWei
tags: [email, verification, service, strapi, nodejs]
---

## 整体流程

公司的业务需求是需要一个邮箱验证服务，用户注册后需要验证邮箱，才能继续使用服务。这个服务的基本流程如下：

1. 用户注册时，填写邮箱地址作为用户名。
2. 后端收到注册请求时，生成一个随机的验证码，发送到用户的邮箱。
3. 用户收到邮件后，在注册页面输入邮件中的验证码，并继续注册。
4. 后端接口验证验证码是否正确，以及是否与邮箱匹配。
5. 验证成功后，注册该用户。
6. 验证失败后，提示用户重新验证。
7. 验证码的有效期为 24 小时。
8. 验证码只能使用一次。
9. 验证码错误次数超过 3 次，验证码失效。
10. 验证码失效后，用户需要重新注册。

## 后端服务

后端服务使用 `Strapi` + [@strapi/provider-email-nodemailer](https://market.strapi.io/providers/@strapi-provider-email-nodemailer) 这个插件。

## 配置插件

安装好上面的插件之后，在 Strapi 项目的 `config/plugins.js` 中配置邮箱服务的信息。

```js
module.exports = ({ env }) => ({
  email: {
    config: {
      provider: 'nodemailer',
      providerOptions: {
        host: env('SMTP_HOST', 'smtp.qiye.aliyun.com'),
        port: env('SMTP_PORT', 465),
        secure: true,
        auth: {
          user: env('**@**.com'),
          pass: env('****'),
        },
      },
      settings: {
        defaultFrom: '**@**.com',
        defaultReplyTo: 'hello@example.com',
      },
    },
  },
})
```

以上配置在本地开发环境也是可以正常使用的，自己在 Chrome 中切换到了 Charles 代理模式，访问邮箱所属域名下的 URL，通过 Charles 的 `Rewrite` 功能把请求重写到了本地，这样就能在本地方便地测试邮件发送功能了。

这里有几点要注意：

1. host 那里填写的是你的邮箱服务商的 SMTP 服务器地址，由于用的是阿里云的企业邮箱，所以参考这篇文档 [阿里邮箱IMAP、POP、SMTP地址和端口信息](https://help.aliyun.com/document_detail/36576.html) 里的地址。
2. port 那里要填写对应的端口号，阿里邮箱的 SMTP 端口是 465，同时 `secure` 要设置为 `true`。
3. 在邮箱所属域名的 DNS 解析设置里，同样要把 SMTP 服务器地址填写进去，这样才能正常发送邮件。知道这一点，是因为在用阿里云企业邮箱给自己的 QQ 邮箱发邮件失败，QQ 邮箱给的错误信息里有相关文档：[什么是SPF？如何设置SPF来防止我的邮件被拒收呢？](https://service.mail.qq.com/detail/122/73?expand=9)，阿里云也搜到了相关文档：[退信提示“spf check failed”](https://help.aliyun.com/document_detail/36777.html)，按照阿里云的设置搞定了。注意 DNS 解析修改后，要等待一段时间（10 分钟）才能生效。
4. 再次发送测试邮件时，QQ 邮箱又返回了 [550 Mail content denied](https://service.mail.qq.com/detail/122/171) 这个错误信息，原来是邮件内容涉嫌大量群发。看了一下，是代码自动生成的内容，修改了之后就可以了。
