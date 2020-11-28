---
title: "云服务器配置笔记 v6.0"
date: 2020-11-18T22:06:23+08:00
tags: ['Server 服务器', 'Ops 运维', 'Note 学习笔记']
draft: false
---

为了之后将业务从 Windows 迁移到 Linux，现在就买了一台阿里云服务器，安装了 Linux 系统，然后开始配置各方面的功能，以便之后迅速迁移。

<!--more-->

## 零、通用操作规范

1. 备份文件时，统一用 `cp file_name file_name_bak` 这样的命令，为文件添加后缀 `.bak` 。

## 一、系统安装

### 1.1 安装系统

选择安装 CentOS 7 的最新版，安装时创建密钥对，并且后面进行设置，要求只能用密钥对远程登录系统，提高安全性。

### 1.2 格式化并挂载数据盘

随系统盘一起购买的数据盘，虽然已经被挂载到 ECS 实例上了，但还需要创建分区、创建文件系统、挂载文件系统，以及在开机后自动挂载这个新分区，才能让数据盘正常使用。

具体操作流程参考 [Linux格式化数据盘](https://help.aliyun.com/document_detail/25426.html) 中的操作即可，文章讲解得十分详细，完全照做就行，其中文件系统选择 `ext4` ，系统分区使用的也是这个文件系统。

## 二、系统监控

### 2.1 安装云监控插件

参考 [安装和卸载插件](https://help.aliyun.com/document_detail/183482.html)，在 CentOS 7 上安装云监控查看，并在 [网页端](https://cloudmonitor.console.aliyun.com/) 查看云监控插件是否正常运行。

### 2.2 启用 CPU 监控

参考 ECS 最佳实践中的 [设置报警阈值和报警规则](https://help.aliyun.com/document_detail/52047.html#title-ri6-gxw-2an)，为云服务器添加 CPU 告警规则，连续 3 个 5 分钟 CPU 使用率都大于等于 70% 的话，就发短信报警。

## 三、系统加固

### 3.1 用户加固

#### 3.1.1 提升密码安全性（删除）

参考 [Password Policies](https://wiki.centos.org/HowTos/OS_Protection#Password_Policies) 和 [Enable password aging on Linux systems](https://www.techrepublic.com/article/enable-password-aging-on-linux-systems/) 中的方法，为当前已存在的用户（root）和之后新创建的用户，设置修改密码的最小时间间隔（7 天），和密码失效时间（180 天）。

```shell
# 备份密码配置文件
$ cp /etc/login.defs /etc/login.defs_bak

# 修改密码配置文件
$ vi /etc/login.defs

# 将修改密码的最大时间间隔 PASS_MAX_DAYS 的值改为 180
# 将修改密码的最小时间间隔 PASS_MIN_DAYS 的值改为 7
# 将最小密码长度 PASS_MIN_LEN 的值改为 16
# 将密码到期前开始提醒的时间 PASS_WARN_AGE 的值设置为 14
# 然后保存并关闭文件

# 上面的配置只对之后新建的用户生效
# 这里还要为已存在的 root 用户启用同样的设置
$ chage --maxdays 180 root
$ chage --mindays 7 root
$ chage --warndays 14 root
```

[Enable password aging on Linux systems](https://www.techrepublic.com/article/enable-password-aging-on-linux-systems/) 还提到了可以设置用户的 `inactive` 和 `expire` 时间，这里先不设置。

然后根据阿里云的加固建议，编辑 `/etc/security/pwquality.conf`，把 `minlen` （密码最小长度）设置为 16，把 `minclass` （至少包含小写字母、大写字母、数字、特殊字符等4类字符中等3类或4类）设置为 4。

```shell
# 备份密码质量文件
$ cp /etc/security/pwquality.conf /etc/security/pwquality.conf_bak

# 修改密码质量文件
$ vi /etc/security/pwquality.conf

# 将 minlen 的值改为 16
# 将 minclass 的值改为 4
# 然后保存并退出
```

再根据阿里云的加固建议，强制用户最近用过的 24 个密码不能有重复的，降低密码猜测攻击风险：

修改 `/etc/pam.d/password-auth` 和 `/etc/pam.d/system-auth` 这两个文件，在 `password sufficient pam_unix.so` 这行的末尾配置 `remember` 参数为 24。原来的内容不用更改，只在行尾添加 ` remember=24` 即可。

#### 3.1.2 建立新用户并赋予 root 权限

参考 [Initial Server Setup with CentOS 7](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-centos-7) 中的建议，建立新用户并赋予 root 权限，以后只用该用户通过 SSH 登录至服务器。

```shell
# 先用 root 用户 SSH 登录至服务器

# 建立新用户
$ adduser www
# 为新用户设置高强度密码
$ passwd www
# 将用户 www 加入 wheel 用户组，可执行 sudo 命令
$ gpasswd -a www wheel
# 切换至用户 www
$ su www
# 测试用户 www 是否能执行 sudo 命令，首次执行需要输入用户 www 的密码
$ sudo ls -la /root
```

### 3.2 SSH 加固

#### 3.2.1 修改 SSH 默认端口

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

# 在本机 SSH 至服务器，测试端口修改是否生效
# 如该服务器在阿里云中启用了安全组
# 还需修改安全组中对应 SSH 端口号
```

TODO:

待确认：CentOS 7 默认安装了 Firewalld，但默认没有启动，也没有开机启动，所以需要启动之后，依然按照这篇文章中的方法，将新的 sshd 服务端口号永久放行。

#### 3.2.2 使用 SSH 配置文件用密钥对连接 Linux 实例

按照文档 [在支持SSH命令的环境中使用密钥对（通过config文件配置信息）](https://help.aliyun.com/document_detail/51798.html?#title-ii4-zmw-zxi) 中的流程，使用 SSH 密钥对，以 root 用户的身份连接至 Linux 实例。

#### 3.2.3 配置新用户的 SSH 公钥

再配置新用户的 SSH 公钥。

```shell
# 切换至用户 www
$ su www
# 切换至当前用户的用户目录
$ cd ~
# 新建 .ssh 文件夹并设置文件夹权限
$ mkdir .ssh && chmod 700 .ssh && cd .ssh
# 将 root 用户的公钥复制过来
$ sudo cat /root/.ssh/authorized_keys > ./authorized_keys
# 设置文件为只读权限
$ chmod 400 authorized_keys
```

#### 3.2.4 测试新用户的 SSH 连接

在本机执行以下命令。

```shell
# 将 User 字段后面的值由 root 改为 www
$ vi ~/.ssh/config
# 正常情况下，严格按照前面的流程操作，这里就能够以 www 用户的身份连接至服务器
$ ssh ecs
```

#### 3.2.5 为 SSH 创立专门用户组

按照 [Create SSH Group For AllowGroups](https://github.com/imthenachoman/How-To-Secure-A-Linux-Server/blob/master/README.md) 中给出的方法，为允许通过 SSH 连接至服务器的用户，创立专门的用户组。

```shell
# 创立用户组
$ sudo groupadd sshusers
# 添加用户至用户组
$ sudo usermod -a -G sshusers www
```

#### 3.2.6 加固 SSH 服务端配置

参考 [How-To-Secure-A-Linux-Server#the-ssh-server](https://github.com/imthenachoman/How-To-Secure-A-Linux-Server#the-ssh-server) 一节中的内容，以非 root 用户的身份，通过 SSH 连接至 Linux 实例后，手动修改 SSH 服务端配置文件，改成如下内容：

```
ListenAddress 0.0.0.0
Port 38964

########################################################################################################
# start settings from https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67 as of 2019-01-01
########################################################################################################

# Supported HostKey algorithms by order of preference.
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256

Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr

MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com

AuthorizedKeysFile .ssh/authorized_keys

# LogLevel VERBOSE logs user's key fingerprint on login. Needed to have a clear audit track of which key was using to log in.
LogLevel VERBOSE

# Use kernel sandbox mechanisms where possible in unprivileged processes
# Systrace on OpenBSD, Seccomp on Linux, seatbelt on MacOSX/Darwin, rlimit elsewhere.
# Note: This setting is deprecated in OpenSSH 7.5 (https://www.openssh.com/txt/release-7.5)
UsePrivilegeSeparation sandbox

########################################################################################################
# end settings from https://infosec.mozilla.org/guidelines/openssh#modern-openssh-67 as of 2019-01-01
########################################################################################################

# don't let users set environment variables
PermitUserEnvironment no

# Log sftp level file access (read/write/etc.) that would not be easily logged otherwise.
Subsystem sftp internal-sftp -f AUTHPRIV -l INFO
# Subsystem sftp /usr/libexec/openssh/sftp-server

# only use the newer, more secure protocol
# 只允许新的 SSH 协议
Protocol 2

# disable X11 forwarding as X11 is very insecure
# you really shouldn't be running X on a server anyway
# 禁用不安全的 X11 转发
X11Forwarding no

# disable port forwarding
# 禁用端口转发
AllowTcpForwarding no
AllowStreamLocalForwarding no
GatewayPorts no
PermitTunnel no

# don't allow login if the account has an empty password
# 禁止空密码的用户登陆
PermitEmptyPasswords no

# ignore .rhosts and .shosts
IgnoreRhosts yes

# verify hostname matches IP
UseDNS no

Compression no
TCPKeepAlive no
AllowAgentForwarding no

# don't allow .rhosts or /etc/hosts.equiv
HostbasedAuthentication no

# 禁止 root 用户登陆
PermitRootLogin no
# 禁止密码登录，即只允许密钥对登录
PasswordAuthentication no
# 只允许指定用户组登录
AllowGroups sshusers

ClientAliveCountMax 0
ClientAliveInterval 600

LoginGraceTime 30
MaxAuthTries 2
MaxSessions 2
MaxStartups 2

ChallengeResponseAuthentication no
GSSAPIAuthentication yes
GSSAPICleanupCredentials no
UsePAM yes
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS
AddressFamily inet
SyslogFacility AUTHPRIV
```

修改完成后，保存并关闭文件，然后重启 sshd 服务 `systemctl restart sshd` ，新的配置即可生效。

可以分别用 root 和 www 两个用户，以密钥对方式登录，测试配置是否成功。

#### 3.2.7 删除短的 Diffie-Hellman 密钥

```shell
# 备份 SSH 的 moduli 文件 /etc/ssh/moduli
$ sudo cp /etc/ssh/moduli /etc/ssh/moduli_bak
# 删除短的 Diffie-Hellman 密钥
$ sudo awk '$5 >= 3071' /etc/ssh/moduli | sudo tee /etc/ssh/moduli.tmp
$ sudo mv /etc/ssh/moduli.tmp /etc/ssh/moduli
```

### 网络加固

#### 配置安全组

此外，还需要在云服务器的安全组中，放行对应端口的入方向请求。
