---
sidebar_position: 5
title: 服务端
---

## fail2ban 解禁 IP

有一天在用 SSH 方式连接服务器的时候，突然发现连不上去了。

执行 `ssh -vvvv`，显示报错信息：`finish_connect - ERROR: async io completed with error: 10060`。

Google 了一下，说有可能是服务器阻止了连接。

想起来以前配置过 fail2ban，于是用另一台服务器 SSH 连过去，发现可以正常连，再查看 fail2ban 已屏蔽的 IP，发现本机 IP 赫然在列。

于是执行了 `sudo fail2ban-client set <jailname> unbanip x.x.x.x` 把本机 IP 解禁了，但是不敢把这个 IP 加入白名单，因为这个 IP 是随机分配的，别人也有可能分配到。

## 访问 IIS URL 重写的 URL 偶尔报错

访问 IIS URL 重写模块重写后的 URL，有时会报错“Server error in '/' application. Runtime Error.”。

Google 了一下，发现在系统的 `事件查看器` 的 `应用程序` 分类下，会看到下面这类错误。

```
日志名称:          Application
来源:            ASP.NET 4.0.30319.0
日期:            2023/8/1 21:29:45
事件 ID:         1309
任务类别:          Web Event
级别:            警告
关键字:           经典
用户:            暂缺
计算机:           ~
描述:
Event code: 3005 
Event message: 发生了未经处理的异常。 
Event time: 2023/8/1 21:29:45 
Event time (UTC): 2023/8/1 13:29:45 
Event ID: ~ 
Event sequence: 1690 
Event occurrence: 9 
Event detail code: 0 

Application information: 
    Application domain: /LM/W3SVC/9/ROOT-1-~ 
    Trust level: Full 
    Application Virtual Path: / 
    Application Path: ~
    Machine name: ~ 

Process information: 
    Process ID: 2096 
    Process name: w3wp.exe 
    Account name: IIS APPPOOL\~ 

Exception information: 
    Exception type: HttpException 
    Exception message: 从客户端(:)中检测到有潜在危险的 Request.Path 值。
   在 System.Web.HttpRequest.ValidateInputIfRequiredByConfig()
   在 System.Web.HttpApplication.PipelineStepManager.ValidateHelper(HttpContext context)


Request information: 
    Request URL: https://~/admin/content-manager/collectionType/api::xxx.xxx/1 
    Request path: /admin/content-manager/collectionType/api::xxx.xxx/1 
    User host address: 118.178.15.107 
    User:  
    Is authenticated: False 
    Authentication Type:  
    Thread account name: IIS APPPOOL\~ 
 
Thread information: 
    Thread ID: 44 
    Thread account name: IIS APPPOOL\~ 
    Is impersonating: False 
    Stack trace:    在 System.Web.HttpRequest.ValidateInputIfRequiredByConfig()
   在 System.Web.HttpApplication.PipelineStepManager.ValidateHelper(HttpContext context)
```

再 Google `detect request.path from client`，发现微软官方给出了解决方案：[A potentially dangerous Request.Path value was detected from the client (<) asp.net 4.8](https://learn.microsoft.com/en-us/answers/questions/661968/a-potentially-dangerous-request-path-value-was-det)，也就是在 `web.config` 文件中添加下面这么一段即可：

```
<system.web>
    <httpRuntime requestValidationMode="2.0" />
</system.web>
```

按照上面说的进行操作了，过了两天发现还是会报这样的错误。
