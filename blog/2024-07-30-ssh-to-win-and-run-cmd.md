---
slug: ssh-to-win-and-run-cmd
title: SSH 连接 Windows 服务器并执行命令
authors: HeWei
tags: [ssh, windows, cmd, powershell, bash]
---

## 无效命令

1. rm + Windows 格式的路径
`ssh -t ecs1 "'rm -r e:\upcweb\uppbook\yd\_nuxt\*'"`

## 有效命令

1. rm + Linux 格式的路径
`ssh -t ecs1 "'rm -r /e/upcweb/uppbook/yd/_nuxt/*'"`

注意：按照 [这里](https://stackoverflow.com/a/70698765/2667665) 的说明，需要执行的命令先用双引号包裹，然后再用单引号包裹，这样才能成功执行。
