---
sidebar_position: 7
title: 网络
---

## VPN

### 【未解决】VPN 创建成功，连接时报错“不能建立到远程计算机的连接 你可能需要更改此连接的网络设置”

先 Google `l2tp vpn 不能建立到远程计算机的连接 你可能需要更改此连接的网络设置`，参考 [解决Win10 vpn连接报错 "不能建立到远程计算机的连接。你可能需要更改此连接的网络设置](https://me.jinchuang.org/archives/369.html) 和 [vpn错误720：不能建立到远程计算机的连接。你可能需要更改此连接的网络设置](https://answers.microsoft.com/zh-hans/windows/forum/all/vpn%E9%94%99%E8%AF%AF720%E4%B8%8D%E8%83%BD/2b6b4edd-8d31-459b-b474-96ad4e3c57b0) 这两个链接，都未能解决问题。

在 Windows 的事件查看器中，可以看到该错误的错误代码为 720，于是又用关键词 `l2tp vpn error 720` 搜索，参考 ["Error 720: Can't connect to a VPN Connection" when you try to establish a VPN connection](https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/troubleshoot-error-720-when-establishing-a-vpn-connection)、[Error Message: Error 720: No PPP Control Protocols Configured](https://support.microsoft.com/en-us/topic/error-message-error-720-no-ppp-control-protocols-configured-aa71f6df-1765-82dd-9f70-eb00f2fe1b86) 和 [FIX: VPN error 720 on Windows 10/11 using 7 safe solutions](https://windowsreport.com/vpn-error-720-windows-10/)，也未能解决问题。
