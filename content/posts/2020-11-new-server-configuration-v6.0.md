---
title: "云服务器配置笔记 v6.0"
date: 2020-11-18T22:06:23+08:00
tags: ['Server 服务器', 'Ops 运维', 'Note 学习笔记']
draft: false
---

为了之后将业务从 Windows 迁移到 Linux，现在就买了一台阿里云服务器，安装了 Linux 系统，然后开始配置各方面的功能，以便之后迅速迁移。

<!--more-->

## 系统安装及安全加固

### 安装系统

选择安装 CentOS 7 的最新版，安装时创建密钥对，这样必须通过密钥对才能远程登录系统，提高安全性。

### 格式化数据盘

随系统盘一起购买的数据盘，虽然已经被挂载到 ECS 实例上了，但还需要创建分区、创建文件系统、挂载文件系统，以及在开机后自动挂载这个新分区，才能让数据盘正常使用。

具体操作流程参考 [Linux格式化数据盘](https://help.aliyun.com/document_detail/25426.html) 一文中的操作即可，文章讲解得十分详细，完全照做就行，其中文件系统选择 `ext4` 即可，系统分区使用的也是这个文件系统。

### 安装云监控插件

参考 [这篇文章](https://developer.aliyun.com/article/628229)，在 CentOS 7 上安装云监控查看，并在[网页端](https://cloudmonitor.console.aliyun.com/)查看云监控插件是否正常运行。

### 启用 CPU 监控

参考 ECS 最佳实践中的 [设置报警阈值和报警规则](https://help.aliyun.com/document_detail/52047.html#title-ri6-gxw-2an)，为云服务器添加 CPU 告警规则，连续 3 个 5 分钟 CPU 使用率都大于等于 70% 的话，就发短信报警。

### 修改 SSH 默认端口

参考 [修改Linux系统实例默认远程端口](https://help.aliyun.com/document_detail/51644.html#title-0qk-cyo-ljc) 一文中的方法，登录服务器后先备份 sshd 服务配置文件，然后修改 sshd 服务端口号为 30000 以上的端口，并重启 sshd 服务。

CentOS 7 默认安装了 Firewalld，但默认没有启动，也没有开机启动，所以需要启动之后，依然按照这篇文章中的方法，将新的 sshd 服务端口号永久放行。

### 配置安全组

此外，还需要在云服务器的安全组中，放行对应端口的入方向请求。
