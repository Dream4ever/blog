---
sidebar_position: 3
title: 解决 MySQL 占用 CPU 过高的问题
---

## 问题描述

一项业务最近有不少用户打电话，说部分功能反应很慢，甚至慢到无法使用。

登录阿里云，在云监控功能的主机监控部分，查看 1 小时内的 CPU 使用率，发现时不时地就会飙到 100%，切换指标后，发现主要是被 cpu_user 占用了，也就是被非系统进程所占用。

同时查看内存占用，发现没有明显变化。

再查看磁盘指标，发现读写字节数持续在 40MB/s 左右，平时这个指标则不到 20。读写请求数持续在 3000 左右，平时这个指标则不到 1000，说明磁盘读写频繁。

再查看网络指标，发现在 CPU 占用高的时间段，各项网络指标也正常。

然后查看进程监控部分，查看最近 7 天的数据，依次点击各个进程查看资源占用，发现 MySQL 占用 CPU 很高，它的 CPU 使用率和打开文件数如下所示。

![image](https://user-images.githubusercontent.com/2596367/119521756-032a6000-bdae-11eb-8db1-ac6cb958bf3b.png)

![image](https://user-images.githubusercontent.com/2596367/119521810-0f162200-bdae-11eb-91ca-bfc72bb628fe.png)

然后远程桌面登录阿里云服务器，对任务管理器中的进程按 CPU 使用率从高到低排列，持续观察一段时间之后，进一步确定是 mysqld.exe 这个进程占用了大量的 CPU。

## 解决过程

### 尝试限制 CPU 占用

最开始想的是能不能先限制 MySQL 的 CPU 占用，然后再慢慢解决问题。

Google 了 `limit mysql cpu usage`，参照着搜索结果中的第一个链接 [Mysql process goes over 400% of CPU usage](https://stackoverflow.com/questions/43443807/mysql-process-goes-over-400-of-cpu-usage) 的最高票回答，检查了一下 MySQL 的配置文件，发现配置是没有问题的，那就说明是使用 MySQL 的方法不正确。

除此之外，没有看到有什么方法可以从系统或软件层面直接限制 MySQL 的 CPU 占用，这条路走不通，那就换个思路。

### 列出 MySQL 当前查询

再 Google `mysql high cpu usage`，几篇文章都提到了可以执行 `show processlist` 来查看 MySQL 当前正在执行的查询，从而找出是哪些查询大量占用 CPU。

进入 MySQL 安装目录下的 bin 子文件夹，执行：

`.\mysqladmin.exe -uroot -p**** processlist`，就可以看到 MySQL 中当前正在执行的 SQL 语句及语句用时。

因为不知道 MySQL 中各个用户的密码，所以参考 [查看Navicat已保存数据库密码](https://blog.yinaun.com/posts/29259.html) 中的方法，先拿到了 root 用户的密码。

`show processlist` 命令的说明见文章 [MySQL CPU占用超过100%](https://blog.51cto.com/vickyzhang/1913054) 及 [MySQL high CPU usage](https://stackoverflow.com/questions/1282232/mysql-high-cpu-usage)。

多次执行该命令，发现语句都显著超过了 1 秒钟（输出结果中的 Time 列的单位为秒），普遍十几秒到几十秒，有的还达到了几分钟之久，难怪用户纷纷打电话投诉。

### 查看数据库设计

查看了业务相关的数据库，用下面两行代码来查看每张表的行数和索引情况。

```
SELECT COUNT(*) FROM db.table;
SHOW INDEX FROM db.table;
```

查询之后，确认有 5 张表的数据是十万级的，还有 5 张表的数据是万级的，剩下几张表，最多的也就是一两千行数据，更少的像是临时表，只有几条或十来条数据。

以上这些表，都是只给主键添加了索引，但是业务中绝大多数查询并不是查主键，所以导致查询效率低。

经过对业务代码进行梳理，并测试了各部分 SQL 语句的用时之后，确定了其中几张最常用也是数据量最大的表，是必须加索引的，而且对各类 SQL 语句的执行结果用时进行了截图保存，以便对比。

然后给这些数据表加上了索引，再执行之前那些比较耗时的 SQL 语句，果然飞快！基本上都是 0.0X 秒，更快的则是 0.00 秒。体验了一下相关的业务，的确也快多了，很棒啊！

### （后续）开启慢查询

按照文章 [MySQL慢查询&分析SQL执行效率浅谈](https://www.jianshu.com/p/43091bfa8aa7) 中的方法，在阿里云服务器上通过 Navicat 运行 MySQL 的命令行界面（可以窗口最大化，比 MySQL 自带的好用），然后依次输入如下命令，开启并设置 MySQL 的慢查询日志功能。

```
set long_query_time=1;
set global slow_query_log='ON';
set global log_queries_not_using_indexes=’ON’;
```

第一行的命令将慢查询的标准设置为 1 秒，超过该时长的查询都视为慢查询进行记录。
第二行的命令很简单，全局开启 MySQL 的慢查询日志功能。
第三行命令则对于未使用索引的查询也进行记录，至于是记录所有查询，还是只记录时长超过 long_query_time 的查询，还需要进一步确认。

而下面两行命令，则可以查询更新后的慢查询相关设置，包括日志文件的物理位置。

```
show variables like 'long%';
show variables like 'slow%';
```

重启服务器之后，发现以上设置又恢复到了默认状态，看来需要把这些设置写入 MySQL 的配置文件 my.ini 中才行。

TODO: 具体的操作，参考官方文档的 [5.4.5 The Slow Query Log](https://dev.mysql.com/doc/refman/5.7/en/slow-query-log.html) 这一节来做就行。后续需要继续优化业务的话，开启慢查询日志即可。
