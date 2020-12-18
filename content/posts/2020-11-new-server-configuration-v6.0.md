---
title: "云服务器配置笔记 v6.0"
date: 2020-11-18T22:06:23+08:00
tags: ['Server 服务器', 'Ops 运维', 'Note 学习笔记']
draft: false
---

为了之后将业务从 Windows 迁移到 Linux，现在就买了一台阿里云服务器，安装了 CentOS 系统，然后开始配置各方面的功能，以便之后迅速迁移。

<!--more-->

# 零、通用操作规范

1. 备份文件时，统一用 `cp file_name file_name.bak` 这样的命令，为文件添加后缀 `.bak` 。

# 一、系统安装

## 1.1 安装系统

选择安装 CentOS 7 的最新版，并选择“安全加固”，同时在安装时创建密钥对或选择已有的密钥对。这样安装完成的系统，默认只能用密钥对进行 SSH 连接，无法使用密码连接，提高了安全性。

## 1.2 格式化并挂载数据盘

随系统盘一起购买的数据盘，虽然已经被挂载到 ECS 实例上了，但还需要创建分区、创建文件系统、挂载文件系统，以及在开机后自动挂载这个新分区，才能让数据盘正常使用。

具体操作流程参考 [Linux格式化数据盘](https://help.aliyun.com/document_detail/25426.html) 中的操作即可，文章讲解得十分详细，完全照做就行，其中文件系统选择 `ext4` ，系统分区使用的也是这个文件系统。

# 二、系统监控

## 2.1 安装云监控插件

参考 [安装和卸载插件](https://help.aliyun.com/document_detail/183482.html)，在 CentOS 7 上安装云监控查看，并在 [网页端](https://cloudmonitor.console.aliyun.com/) 查看云监控插件是否正常运行。

## 2.2 启用 CPU 监控

参考 ECS 最佳实践中的 [设置报警阈值和报警规则](https://help.aliyun.com/document_detail/52047.html#title-ri6-gxw-2an)，为云服务器添加 CPU 告警规则，连续 3 个 5 分钟 CPU 使用率都大于等于 70% 的话，就发短信报警。

# 三、 账号加固

## 3.1 建立新用户并赋予 root 权限

参考 [Initial Server Setup with CentOS 7](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-centos-7) 中的建议，建立新用户并赋予 root 权限，以后只用该用户远程登录服务器。

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
# 测试用户 www 是否能执行 sudo 命令，需要输入用户 www 的密码
$ sudo ls -la /root
```

## 3.2 提升密码安全性（可选）

参考 [Password Policies](https://wiki.centos.org/HowTos/OS_Protection#Password_Policies) 和 [Enable password aging on Linux systems](https://www.techrepublic.com/article/enable-password-aging-on-linux-systems/) 中的方法，设置修改密码的最小时间间隔（7 天），和密码失效时间（180 天）。

```shell
# 备份密码配置文件
$ cp /etc/login.defs /etc/login.defs.bak

# 修改密码配置文件
$ vi /etc/login.defs

# 将修改密码的最大时间间隔 PASS_MAX_DAYS 的值改为 180
# 将修改密码的最小时间间隔 PASS_MIN_DAYS 的值改为 7
# 将最小密码长度 PASS_MIN_LEN 的值改为 16
# 将密码到期前开始提醒的时间 PASS_WARN_AGE 的值设置为 14
# 然后保存并关闭文件

# 上面的配置只对之后新建的用户生效
# 这里还要为已存在的 root/www 用户启用同样的设置
$ chage --maxdays 180 root
$ chage --mindays 7 root
$ chage --warndays 14 root
```

[Enable password aging on Linux systems](https://www.techrepublic.com/article/enable-password-aging-on-linux-systems/) 还提到了可以设置用户的 `inactive` 和 `expire` 时间，这里先不设置。

然后根据阿里云的加固建议，编辑 `/etc/security/pwquality.conf`，把 `minlen` （密码最小长度）设置为 16，把 `minclass` （至少包含小写字母、大写字母、数字、特殊字符等4类字符中等3类或4类）设置为 4。

```shell
# 备份密码质量文件
$ cp /etc/security/pwquality.conf /etc/security/pwquality.conf.bak

# 修改密码质量文件
$ vi /etc/security/pwquality.conf

# 将 minlen 的值改为 16
# 将 minclass 的值改为 4
# 然后保存并退出
```

再根据阿里云的加固建议，强制用户最近用过的 24 个密码不能有重复的，降低密码猜测攻击风险：

修改 `/etc/pam.d/password-auth` 和 `/etc/pam.d/system-auth` 这两个文件，在 `password sufficient pam_unix.so` 这行的末尾配置 `remember` 参数为 24。原来的内容不用更改，只在行尾添加 ` remember=24` 即可。

# 四、 SSH 加固

## 4.1 修改 SSH 默认端口

参考 [修改Linux系统实例默认远程端口](https://help.aliyun.com/document_detail/51644.html#title-0qk-cyo-ljc) 进行修改。

```shell
# 备份 sshd 服务配置文件
$ cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# 编辑 sshd_config 配置文件
$ vim /etc/ssh/sshd_config

# 将 Port 改为 30000 以上的值
# 然后保存并关闭文件

# 重启 sshd 服务
$ systemctl restart sshd

# 重新在本机通过 SSH 连接服务器，测试端口修改是否生效
# 如该服务器在阿里云中配置了安全组
# 还需修改安全组中对应 SSH 端口号
```

## 4.2 使用 SSH 配置文件连接 CentOS

按照文档 [在支持SSH命令的环境中使用密钥对（通过config文件配置信息）](https://help.aliyun.com/document_detail/51798.html?#title-ii4-zmw-zxi) 中的流程，使用 SSH 密钥对，以 root 用户的身份连接至 Linux 实例。

记得先按前一小节 [通过命令配置](https://help.aliyun.com/document_detail/51798.html#title-7je-5ba-sm2) 的流程做一遍，这样才能够确保私钥文件的权限符合密钥登录的要求，否则将无法登录。

## 4.3 配置新用户的 SSH 公钥

配置新用户的 SSH 公钥。

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

## 4.4 测试新用户的 SSH 连接

在本机执行以下命令。

```shell
$ vi ~/.ssh/config
# 将 User 字段后面的值由 root 改为 www
# 正常情况下，严格按照前面的流程操作的话，这里就能够以 www 用户的身份连接至服务器
$ ssh ecs
```

## 4.5 为 SSH 创立专门用户组

按照 [Create SSH Group For AllowGroups](https://github.com/imthenachoman/How-To-Secure-A-Linux-Server/blob/master/README.md) 中给出的方法，为允许通过 SSH 连接至服务器的用户，创立专门的用户组。

```shell
# 创立用户组
$ sudo groupadd sshusers
# 添加用户至用户组
$ sudo usermod -a -G sshusers www
```

## 4.6 加固 SSH 服务端配置

参考 [How-To-Secure-A-Linux-Server#the-ssh-server](https://github.com/imthenachoman/How-To-Secure-A-Linux-Server#the-ssh-server) 一节中的内容，以非 root 用户的身份，通过 SSH 连接至 Linux 实例后，手动修改 SSH 服务端配置文件，改成如下内容：

```
ListenAddress 0.0.0.0
Port 33333

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

可以分别用 root 和 www 两个用户，以密钥对方式登录，测试配置是否成功。如果 root 无法登录而 www 可以登录，就说明配置成功了。

## 4.7 删除短的 Diffie-Hellman 密钥

```shell
# 备份 SSH 的 moduli 文件 /etc/ssh/moduli
$ sudo cp /etc/ssh/moduli /etc/ssh/moduli.bak
# 删除短的 Diffie-Hellman 密钥
$ sudo awk '$5 >= 3071' /etc/ssh/moduli | sudo tee /etc/ssh/moduli.tmp
$ sudo mv /etc/ssh/moduli.tmp /etc/ssh/moduli
```

# 五、 网络加固

## 5.1 配置安全组

在云服务器的安全组中，采用白名单策略，只开放个人电脑 IP 的 SSH 权限。

## 5.2 配置 FirewallD

### 5.2.1 尝试启动

先彻底禁用 iptables：

```shell
$ sudo systemctl stop iptables
$ sudo systemctl mask iptables
```

然后执行下面的命令启动 FirewallD

```shell
$ sudo systemctl start firewalld
```

结果终端连接立刻无响应了，猜测是 FirewallD 中没有 SSH 相关规则导致的。

于是在浏览器中登录阿里云控制台，通过云助手发送命令 `sudo systemctl stop firewalld` 至服务器，先暂时停止 FirewallD。

### 5.2.2 关闭不安全配置

然后查看 FirewallD 的运行状态：

```shell
$ sudo systemctl status firewalld
...
Dec 09 11:37:03 ecs02 firewalld[11787]: WARNING: AllowZoneDrifting is enabled. This is considered an insecure configuration option. It will be removed in a future release. Please consider disabling it now.
...
```

上面的 `WARNING` 那一行建议用户关闭 `AllowZoneDrifting` 这个不全安的配置，上网搜索之后，按照 [AllowZoneDrifting - Firewalld: What is it and should I disable it?](https://stackoverflow.com/questions/61402334/allowzonedrifting-firewalld-what-is-it-and-should-i-disable-it) 中所说的，将 `/etc/firewalld/firewalld.conf` 文件中 `AllowZoneDrifting` 的值由 `yes` 改为 `no`。

### 5.2.3 升级至最新版

另外，上面的提示文字说这个不安全的配置在未来的某个版本中可能删除，于是将 FirewallD 升级到最新版：

```shell
$ sudo yum update firewalld
```

### 5.2.4 了解 FirewallD

然后按照 DigitalOcean 的教程 [How To Set Up a Firewall Using FirewallD on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7) 来配置 FirewallD。

### 5.2.5 Zones

教程先介绍了 FirewallD 中预定义的“zones”，信任级别由低到高依次为：

- **drop**: 最低信任级别，入方向连接全部 drop，没有 reply，只允许出方向连接。
- **block**: 与上面相似，只是入方向连接不是 drop 而是 reject，同时附带消息 `icmp-host-prohibited` 或 `icmp6-adm-prohibited`。
- **public**: 公开、不受信的网络，不信任其他计算机，只允许特定情况的入方向连接。
- **external**: 使用防火墙作为网关时的外部网络部分，配置用来实现 NAT masquerading，使内网依然 private 同时又可触达（reachable）。
- **internal**: 使用防火墙作为网关时的内部网络部分，其他计算机是非常可信的，同时允许更多的服务所产生的请求。
- **dmz**: 用于 DMZ 中的计算机，只允许特定的入方向连接。
- **work**: 用于工作环境，信任网络中的大部分计算机，在前面的基础上，还允许另外少数服务所产生的请求。
- **home**: 用于家庭环境，信任网络中的大部分计算机，在前面的基础上，还允许另外少数服务所产生的请求。
- **trusted**: 信任网络中的所有计算机，开放程度最高，需谨慎使用。

### 5.2.6 配置规则

因为 FirewallD 中目前没有预定义任何配置，所以从本地通过 SSH 连接到服务器的话，一开启 FirewallD 就会导致 SSH 断开连接，所以先通过阿里云 ECS 实例页面的 **发送命令** 功能来配置 FirewallD。

另外该功能用的是具有 `sudo` 权限的账号执行命令的，所有命令都无需在前面添加 `sudo`，更不需要输入密码。

先让 FirewallD 开机自动启动 `systemctl enable firewalld`。

然后启动 FirewallD `systemctl start firewalld`，并查看运行状态 `firewall-cmd --state`，输出 `running`，说明启动成功。

接着查看 FirewallD 默认的 zone `firewall-cmd --get-default-zone`，输出 `public`，一切正常。

再查看当前被激活的 zone `firewall-cmd --get-active-zones`，结果发现没有任何输出，和上面 DigitalOcean 的教程中的结果不符，就说明目前没有任何 zone 被激活。

然后执行 `firewall-cmd --list-all`，发现输出结果中，`interfaces` 这一项值为空，意味着 `publi` 这个 zone 没有和网卡相关联，那先解决这个问题。

执行 `ifconfig`，可以看到有 3 个 interfaces：docker0、eth0 和 lo。查看各自的 `inet` 属性值，也就是 IP 地址，可知 `eth0` 是连接外网的网卡，那么把 `public` 这个 zone 绑定到 `eth0` 上即可。

Google `firewalld interfaces empty`，在第一个链接 DigitalOcean 的问答贴 [No Network Interfaces Bound to Firewalld Zone](https://www.digitalocean.com/community/questions/no-network-interfaces-bound-to-firewalld-zone)，给出了命令 `sudo firewall-cmd --zone=public --change-interface=eth0`，执行该命令后返回 `success`。

然后再执行 `firewall-cmd --get-active-zones`，输出结果如下，说明操作的确成功了。

```
public
  interfaces: eth0
```

再执行 `firewall-cmd --list-all`，第一行的 `public` 后面只有 `active`，没有 `default`，那么就把 `public` 这个 zone 设为默认：

```shell
$ firewall-cmd --set-default-zone=public
Warning: ZONE_ALREADY_SET: public
success
```

由于 SSH 用的不是默认端口，所以需要在 FirewallD 中进行对应设置：

```shell
$ firewall-cmd --zone=public --add-service=ssh
Warning: ALREADY_ENABLED: 'ssh' already in 'public'
success
$ firewall-cmd --zone=public --permanent --service=ssh --add-port=37962/tcp
$ reboot
```

执行了上面的命令之后，就可以从任意电脑上通过 SSH 连接服务器了。

## 六、 配置 fail2ban

### 6.0 fail2ban 的意义

即使在前面的步骤中，启用了 SSH 密钥登录，禁用了 SSH 密码登录，fail2ban 也非常有用。

因为合理配置的 fail2ban，不只是可以屏蔽非法的 SSH 登录请求。对于很多网上的自动扫描的机器人，被 fail2ban 屏蔽之后，有可能在一段时间之内就不会再尝试扫描这台服务器。

fail2ban 功能极其丰富，它本质上是通过监控各种日志文件，找出符合规则的记录，然后将记录中的 IP 加以屏蔽。这样一来，不只是 SSH，像 Nginx、Wordpress 之类的应用，也是可以屏蔽的，比如屏蔽掉那些尝试暴力登录网站的请求等等。

### 6.1 安装 fail2ban

```shell
$ sudo yum update && sudo yum install epel-release
$ sudo yum install fail2ban
```

### 6.2 启动 fail2ban

```shell
$ sudo systemctl start fail2ban
# 设置 fail2ban 开机启动
$ sudo systemctl enable fail2ban
```

### 6.3 fail2ban 基础配置

`fail2ban.conf` 包含了 fail2ban 的默认配置，并且每次升级时会覆盖该文件。如果需要修改该文件中的配置，合理的方式是将该文件复制一份，并重命名为 `fail2ban.local`，这样就不会被升级影响了。

不过在后面的配置中，不需要修改这个文件，所以这一步操作不做也可以。

然后再将 Jail 配置文件 `jail.conf` 也复制一份并重命名为 `jail.local`，避免在软件升级时被覆盖。

```shell
$ sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
```

然后将配置文件中对应字段修改如下：

```
# 不屏蔽本机 IP
ignoreip = 127.0.0.1/8 ::1
# 屏蔽持续 14 天
bantime  = 14d
# 登录失败一次就屏蔽
maxretry = 1
# CentOS 7 系统，需要改成这个值
backend = systemd
# CentOS 7 使用 FirewallD 作为防火墙，需要改成这两个值
banaction = firewallcmd-ipset
banaction_allports = firewallcmd-ipset
```

上面的字段 `bantime` 原本设置为 `10y`，也就是 10 年。结果在查看 fail2ban 的日志 `/var/log/fail2ban.log` 时，发现每次在屏蔽登录失败的 IP 时，都会报 `stderr: "ipset v7.1: Syntax error: '315576000' is out of range 0-2147483"` 这么一个错误，原来是给这个字段设置的值超出了它允许的最大值。

将最大值 `2147483` 换算成天，差不多是 24 天，为了保险期间，就把 `bantime` 的值设置为 `14d`，也就是登录失败一次，就屏蔽两个星期，这已经够久了。

### 6.4 fail2ban 具体服务配置

新建 `/etc/fail2ban/jail.d/sshd.local` 文件，用于配置 SSH 服务的屏蔽设置，具体配置如下：

```
[sshd]

# To use more aggressive sshd modes set filter parameter "mode" in jail.local:
# normal (default), ddos, extra or aggressive (combines all).
# See "tests/files/logs/sshd" or "filter.d/sshd.conf" for usage example and details.
#mode   = normal
enabled = true
port    = 66666
logpath = /var/log/secure
```

因为 `jail.local` 这个通用配置文件中的 `enabled` 字段值为 `false`，所以需要在这里将该字段值设置为 `true`，来启用 SSHD 服务的安全防护。

`port` 字段则设置为 SSHD 服务的自定义端口。

`logpath` 字段设置为 `/var/log/secure`，这是 CentOS 下的登录日志文件所在位置。

### 6.5 参考资料

- [Using Fail2ban to Secure Your Server - A Tutorial](https://www.linode.com/docs/guides/using-fail2ban-to-secure-your-server-a-tutorial/)
- [Add a jail file to protect SSH](https://www.howtoforge.com/tutorial/how-to-install-fail2ban-on-centos/#add-a-jail-file-to-protect-ssh)
- [where-to-find-ssh-login-log-files-on-centos](https://superuser.com/questions/1224688/)
