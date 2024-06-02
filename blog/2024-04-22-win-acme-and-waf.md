---
slug: win-acme-and-waf
title: win-acme 自动续期 SSL 证书及上传 WAF
authors: HeWei
tags: [acme, win-acme, powershell, waf, aliyun]
---

## 前情提要

之前在 V2EX 咨询过 [阿里云免费 SSL 证书的替代方案](https://v2ex.com/t/999627)，考虑到阿里云服务器目前的操作系统是 Windows Server 2012，所以基于 Linux 或者 Docker 的方案就都 pass 了。

再考虑到自动化更新 SSL 证书的需求，所以在经过一番调研之后，最终确定使用 [win-acme](https://www.win-acme.com/) 来完成这一工作。因为虽然 Caddy 也能完成这项工作，但是还需要把在 IIS 中配置好的网站再重新配置一遍，还不知道会有什么新问题。本着尽量不要增加复杂度的理念，所以就没有采用 Caddy。

由于网站前面还有一层阿里云 WAF（Web 应用防火墙），各网站的流量都是先由 WAF 检查一遍，过滤掉非法请求之后，才能最终到达服务器。而要使用 WAF 的话，各域名的 DNS 都是解析到 WAF 的地址上的，这也给后面的工作和问题排查带来了一些问题，不过这是后话了。

## 基本流程测试

把 win-acme 下载并解压到服务器上之后，运行程序，按照网上的教程一步步操作。为了不影响现有各域名上的业务，在阿里云服务器的 IIS 上配置了一个新的域名，并且在阿里云 WAF 里面接入了这个二级域名。

按照教程的操作步骤，成功用 win-acme 申请到了这个二级域名的 SSL 证书，但是默认步骤只会生成一个 Windows IIS 所需的 pfx 格式的证书。如果要让阿里云 WAF 能够正常过滤 HTTPS 流量，还需要上传证书和对应的私钥到阿里云的数字证书管理服务中，然后在阿里云 WAF 的网站接入设置中选择所上传的证书才行。这样一来，还需要让 win-acme 生成 PEM 格式的证书和私钥。

所以基础流程就是：申请证书 → 保存 PFX 格式证书 → 保存 PEM 格式证书。

## 配置阿里云 WAF

在用 win-acme 给各个域名申请证书的时候，在验证域名所有权的那一步，有的域名能够验证成功，有的域名就总会失败。考虑到 IIS 上各个域名的配置是一样的，又看了一下 DNS 解析也是一样的格式，那应该就是阿里云 WAF 的问题了。

对比之后发现，有的域名在阿里云 WAF 的配置中同时勾选了 HTTP 和 HTTPS 协议，但是有的只勾选了 HTTPS 协议。对于只勾选了 HTTPS 协议的域名，有的还没有开启 HTTP 到 HTTPS 的强制跳转。

加上域名的 DNS 解析是指向阿里云 WAF 的，于是猜测是 WAF 这里的设置导致了域名所有权的验证失败。于是给全部域名的 WAF 配置都同时勾选了 HTTP 和 HTTPS 协议，并且禁止了 HTTP 到 HTTPS 的强制跳转，这个时候，各个域名的所有权验证终于都能通过了。

## Debug 阿里云 Cli

有了 win-acme，SSL 证书的自动续期就搞定了。但是证书每次续期之后，还需要再把新的证书上传到阿里云的数字证书管理服务中，然后在阿里云 WAF 的网站接入设置中更新证书。既然是 Windows 系统，那就用 PowerShell 写个脚本来实现这个操作好了。

而上面的需求需要调用阿里云的 API，如果想要用脚本来实现这一功能，就还要用到阿里云 Cli。在配置阿里云 Cli 的用户凭证时，AccessKey 凭证和 EcsRamRole 凭证方式一开始都有问题，最后把之前的配置信息都删了，新建了一个具有 `管理云盾应用防火墙（WAF）的权限` 的用户，然后用该用户的 AccessKey 才终于成功调用了阿里云的 API。

## Debug PowerShell

在测试阿里云 API 的调用时，还遇到了一个有些隐蔽的问题，就是在阿里云的 OpenAPI 平台上测试接口调用的时候是没问题的，但是在 PowerShell 脚本中调用就是有问题。到了最后把两种方式的完整命令复制出来对比，才发现 PowerShell 的 `Get-Content` 命令读取到的 SSL 证书和私钥的文本，换行符都没了，这尼玛！

解决了这个问题后，续期后的新证书和私钥自动上传至阿里云并在 WAF 中更新的功能也就实现了，以后这项工作就不需要自己再手动操作了。

## 总结

最后再说一下完整的流程和注意事项吧。

1. 用 win-acme 申请 SSL 证书并实现自动续期。这个程序能够自动把从 IIS 中读取网站信息，申请新证书关联到对应的网站，很省心。
2. 如果用到了阿里云 WAF 之类的服务，要想防护 HTTPS 流量，就需要上传 SSL 证书和私钥，这样的话需要配置 win-acme 再额外保存一份 PEM 格式的证书和私钥。其中 `-chain.pem` 后缀的文件是需要导入 WAF 的网站证书及中间证书，`-key.pem` 后缀的文件则是需要导入 WAF 的私钥文件。
3. 如果用到了阿里云 WAF 之类的服务，并且各业务域名的 DNS 都解析到了 WAF 上，那么就要在 WAF 配置中同时启用 HTTP 和 HTTPS，并且禁止 HTTP 到 HTTPS 的强制跳转，不然有可能在域名所有权验证那一步失败。
4. 配置阿里云 Cli 的时候，如果配置的各种凭证方式都不管用，可以尝试把旧的配置都删除，包括 Cli 里的配置和阿里云网页端控制台的配置，然后重新来一遍。
5. PowerShell `Get-Content` 命令拿到的证书和私钥的文本会丢失换行符，可以参考 https://stackoverflow.com/a/15041925/2667665 这里的方法来解决。
6. 上传证书和私钥调用的是 WAF 中的 `CreateCertificate` 这个 API，将证书关联至 WAF 中接入域名是 `CreateCertificateByCertificateId` API。

## 背景知识

- [证书、证书链、CA 的那些事](https://xie.infoq.cn/article/48ee67170b9bfb0b4a6039b68)：介绍了根证书、中间证书之类的概念。
- [What is the purpose of chain.pem files?](https://superuser.com/questions/1642520/what-is-the-purpose-of-chain-pem-files)：也讲了有关证书链的知识。
- [SSL Server Test](https://www.ssllabs.com/ssltest/)：检查域名的 SSL 证书是否配置正确的工具。上传到阿里云的证书如果没有中间证书，域名用这个工具扫描后会报告缺少中间证书。
