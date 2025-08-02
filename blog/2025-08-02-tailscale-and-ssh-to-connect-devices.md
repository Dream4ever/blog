---
slug: tailscale-and-ssh-to-connect-devices
title: 利用 tailscale + ssh 实现设备互连
authors: HeWei
tags: [tailscale, ssh]
---

### 核心流程

1. Windows 电脑和手机上都安装 tailscale，安装完成后运行软件并登录账号。
2. 用管理员身份运行 PowerShell，逐行执行下面的命令：

```ps
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
```

3. 检查 SSH 是否正常运行：

```ps
Test-NetConnection -ComputerName 127.0.0.1 -Port 22
```

如果显示 `TcpTestSucceeded : True`，说明 SSH 已开启。

PS：如果在 Windows 系统上安装 Tailscale 时遇到错误代码 0x80072f19（未指定的错误），通常与网络连接、系统服务或权限问题相关。

在代理软件中开启全局模式或 TUN 模式可解决此问题。

4. 允许 Windows 防火墙放行 SSH 流量
```ps
# 放行 Tailscale 接口的 SSH 流量（重要！）
New-NetFirewallRule -DisplayName "Tailscale SSH" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22 -InterfaceAlias "Tailscale*"
```

5. iOS 手机安装终端软件 Termius/iSH
6. 执行下面的命令，生成自定义名称的 SSH 密钥，以便和其他密钥区分

```bash
apk add openssh-client  # 如果未安装 SSH
ssh-keygen -t ed25519 -f ~/.ssh/iphone11
```

7. 将手机上生成的公钥 `~/.ssh/iphone11.pub`，复制到 Windows 电脑上的 `C:\Users\XXX\.ssh\authorized_keys` 文件中（文件不存在的话自己创建）。
8. 设置正确的文件权限（命令可能有误，自行修复）。

```ps
# 移除继承权限并仅允许当前用户读取
icacls C:\Users\<你的用户名>\.ssh\authorized_keys /inheritance:r /grant:r "%USERNAME%":(R)
```

10. 在手机终端尝试连接：

```bash
ssh -i ~/.ssh/iphone11 <Windows用户名>@<Tailscale IP>
```
