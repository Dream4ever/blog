---
title: "云服务器配置笔记 v6.0"
date: 2020-11-18T22:06:23+08:00
tags: ['Server 服务器', 'Ops 运维', 'Note 学习笔记']
draft: false
---

为了之后将业务从 Windows 迁移到 Linux，现在就买了一台阿里云服务器，安装了 Linux 系统，然后开始配置各方面的功能，以便之后迅速迁移。

<!--more-->

## 通用操作规范

1. 备份文件时，统一用 `cp file_name file_name_bak` 这样的命令，为文件添加后缀 `_bak`

## 系统安装

### 安装系统

选择安装 CentOS 7 的最新版，安装时创建密钥对，这样必须通过密钥对才能远程登录系统，提高安全性。

### 格式化数据盘

随系统盘一起购买的数据盘，虽然已经被挂载到 ECS 实例上了，但还需要创建分区、创建文件系统、挂载文件系统，以及在开机后自动挂载这个新分区，才能让数据盘正常使用。

具体操作流程参考 [Linux格式化数据盘](https://help.aliyun.com/document_detail/25426.html) 中的操作即可，文章讲解得十分详细，完全照做就行，其中文件系统选择 `ext4` ，系统分区使用的也是这个文件系统。

## 系统监控

### 安装云监控插件

参考 [安装和卸载插件](https://help.aliyun.com/document_detail/183482.html)，在 CentOS 7 上安装云监控查看，并在 [网页端](https://cloudmonitor.console.aliyun.com/) 查看云监控插件是否正常运行。

### 启用 CPU 监控

参考 ECS 最佳实践中的 [设置报警阈值和报警规则](https://help.aliyun.com/document_detail/52047.html#title-ri6-gxw-2an)，为云服务器添加 CPU 告警规则，连续 3 个 5 分钟 CPU 使用率都大于等于 70% 的话，就发短信报警。

## 系统加固

### SSH 加固

#### 修改 SSH 默认端口

参考 [修改Linux系统实例默认远程端口](https://help.aliyun.com/document_detail/51644.html#title-0qk-cyo-ljc) 进行修改。

```shell
# 备份 sshd 服务配置文件
$ cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bak

# 编辑 sshd_config 配置文件
$ vim /etc/ssh/sshd_config

# 将 Port 改为 30000 以上的值
# 然后保存并关闭文件

# 重启 sshd 服务
$ systemctl restart sshd

# 在自己的电脑上测试端口修改是否生效
# 如已为该服务器在阿里云启用了安全组
# 还需修改安全组中 SSH 对应端口号
```

CentOS 7 默认安装了 Firewalld，但默认没有启动，也没有开机启动，所以需要启动之后，依然按照这篇文章中的方法，将新的 sshd 服务端口号永久放行。

#### 设置 SSH 空闲超时退出时间

根据阿里云的加固建议，设置SSH空闲超时退出时间。

```shell
# 编辑 sshd 服务配置文件
$ vi /etc/ssh/sshd_config

# 修改 ClientAliveInterval 的值为 600
# 修改 ClientAliveCountMax 的值为 2
# 然后保存并关闭文件

# 重启 sshd 服务
$ systemctl restart sshd
```

### 网络加固

#### 配置安全组

此外，还需要在云服务器的安全组中，放行对应端口的入方向请求。

### 账号加固

#### 提升账号所用密码的各项安全指标

参考 [Password Policies](https://wiki.centos.org/HowTos/OS_Protection#Password_Policies) 和 [Enable password aging on Linux systems](https://www.techrepublic.com/article/enable-password-aging-on-linux-systems/) 中的方法，为当前已存在的账号（root）和之后新创建的账号，设置修改密码的最小时间间隔（7 天），和密码失效时间（180 天）。

```shell
# 备份密码配置文件
$ cp /etc/login.defs /etc/login.defs_bak

# 修改密码设置
$ vi /etc/login.defs
# 将 PASS_MAX_DAYS 的值改为 180
# 将 PASS_MIN_DAYS 的值改为 7
# 将最小密码长度 PASS_MIN_LEN 的值改为 16
# 将密码到期前开始提醒的时间 PASS_WARN_AGE 的值设置为 14
# 然后保存并关闭文件

# 为已存在的 root 账号启用同样的设置
$ chage --maxdays 180 root
$ chage --mindays 7 root
$ chage --warndays 14 root
```

[Enable password aging on Linux systems](https://www.techrepublic.com/article/enable-password-aging-on-linux-systems/) 还提到了可以设置账号的 `inactive` 和 `expire` 时间，这里先不设置了。

然后根据阿里云的加固建议，编辑 `/etc/security/pwquality.conf`，把 `minlen` （密码最小长度）设置为 16，把 `minclass` （至少包含小写字母、大写字母、数字、特殊字符等4类字符中等3类或4类）设置为 4。

```shell
# 备份密码安全文件
$ cp /etc/security/pwquality.conf /etc/security/pwquality.conf_bak

# 修改密码设置
$ vi /etc/security/pwquality.conf
# 将 minlen 的值改为 16
# 将 minclass 的值改为 4
# 然后保存并退出
```

 再根据阿里云的加固建议，强制用户不重用最近使用的密码，降低密码猜测攻击风险。

 在 `/etc/pam.d/password-auth` 和 `/etc/pam.d/system-auth` 这两个文件中，均在 `password sufficient pam_unix.so` 这行的末尾配置 `remember` 参数为 24。原来的内容不用更改，只在行尾添加 `remember=24` 即可。
