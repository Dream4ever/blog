---
sidebar_position: 6
title: 在 Windows 中使用 Docker
---

## 上网咨询

自己的提问：[Windows Server 是否适合用 Docker？](https://v2ex.com/t/874832)

关键回复可总结为如下几点：

1. 如果是基于 Windows 创建的容器，那么是可以直接在 Windows Docker 中运行的。如果是基于 Linux 创建的容器，则必须在 Windows 上的 Linux 虚拟机中运行。而云服务器本身就是虚拟的，这样又嵌套一层，性能方面会受影响。
2. 对于数据库，建议直接安装到系统中，不要装到容器里，会影响性能。

## 微软官方方案

[Windows 容器文档](https://docs.microsoft.com/zh-cn/virtualization/windowscontainers/)。

在左侧导航栏中，看到了编程语言和数据库的[容器解决方案](https://docs.microsoft.com/zh-cn/virtualization/windowscontainers/samples?tabs=Application-frameworks)。

公司业务会用到的编程语言和数据库，对应的 Windows 容器实现方案分别如下所示：

- [Node.js](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/main/windows-container-samples/nodejs)：在 Dockerfile 中执行 PowerShell 脚本，PowerShell 脚本中从 Node.js 官网下载安装程序，并调用 msiexec 来安装。
- [IIS-PHP](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/main/windows-container-samples/iis-php)：用 servercore/iis 作为基础镜像，并且会用到宿主机的 PHP 和 vcredist_x86.exe 文件。前者是 PHP 的运行环境，后者是所需的系统依赖。
- [MySQL](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/main/windows-container-samples/mysql)：用 servercore:ltsc2022 作为基础镜像，从 MySQL 官网下载 MySQL 的压缩文件并解压至镜像中，最后再将 MySQL 的 bin 目录添加至系统变量 Path 中。
- [MongoDB](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/main/windows-container-samples/mongodb)：用 servercore 作为基础镜像，执行宿主机中的 MongoDB 安装程序，最后配置好数据库所需的几个目录。
