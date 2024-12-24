---
sidebar_position: 1
title: Windows Server 下实现 MySQL 主从复制
---

> MySQL 5.5 主从复制官方文档：[Chapter 16. Replication](https://docs.oracle.com/cd/E19957-01/mysql-refman-5.5/replication.html)

## 概述

### 名词解释

- binlog：主库用来记录所有数据库发生的所有更改的日志文件。
- relay log：从库拿到主库 binlog 的更新后，保存在本地的 relay log 文件中，然后从该文件读取主库的变化，并在从库上同步执行。
- 主库 binlog dump 线程：主库用来向从库发送 binlog 更新的线程。
- 从库 I/O 线程：从库用来接收主库更新的 binlog 的线程，接收到的更新就保存在从库本地的 relay log 文件中。
- 从库 SQL 线程：从库用来从本地的 relay log 文件中读取 binlog 的更新并执行的线程。

### 复制方案对比

- 主从复制：单向的、异步复制
- [集群：同步复制](http://dev.mysql.com/doc/refman/5.1/en/mysql-cluster.html)
- [半同步复制](https://docs.oracle.com/cd/E19957-01/mysql-refman-5.5/replication.html#replication-semisync)

## 服务器环境说明

主数据库位于主服务器 ( 192.168.8.28 ) 上，MySQL 版本为 5.5.37 32位。

从数据库位于备用服务器 ( 192.168.8.27 ) 上，MySQL 版本与主服务器相同。

## 编辑主库配置文件

停止主库的服务。

备份主服务器上的 `my.ini` 之后，编辑该文件，在 `[mysqld]` 区块中增加以下内容。

第一行用于设置 binlog 文件的路径，第二行用于设置主库的 ID。主库和所有从库的 ID 应当互不相同。

```
log-bin="D:/Logs/MySQL/BinLogs/main-bin.log"
server-id=1
```

For the greatest possible durability and consistency in a replication setup using InnoDB with transactions，建议再添加以下两行配置。

```
innodb_flush_log_at_trx_commit=1
sync_binlog=1
```

确保 `my.ini` 文件中没有启用 `skip-networking` 字段。

启动主库的服务。

## 编辑从库配置文件

停止从库的服务。

备份备用服务器上的 `my.ini` 之后，编辑该文件，在 `[mysqld]` 区块中增加以下内容。

```
server-id=2

# 添加以下两行之后，可以利用 binlog
# 实现从库上的数据备份和崩溃恢复功能
# 如果从库之后被提升为主库，下面两行
# 也可以让其他从库基于新的主库来创建
innodb_flush_log_at_trx_commit=1
sync-binlog=1

# 设置从库为只读，按需开启
# 如果被提升为主库，这一条一定要删掉
read-only=1

# 从库启动时，不自动开始主从复制
# 只有手动执行 start slave 才行
# 配置完主从复制后禁用该项即可
skip-slave-start
```

确保 `my.ini` 文件中没有启用 `skip-networking` 字段。

## 主库创建专门用于主从复制的用户

进入主库的 MySQL 命令行，输入如下命令，每行命令输入完成后按回车。

命令中的 `srv-repl` 为专门用于主从复制的 MySQL 用户，`slavepass` 为密码（尽量用字母 + 数字格式的简单密码，以免出问题）。

语句中的 `%` 表示所有服务器都可以使用这个用户（建议用此模式），如果想限定只能由从库所在服务器的 IP 使用该用户，则将其改为从库所在服务器的 IP 即可（可能出问题）。

```
mysql > CREATE USER 'srv-repl'@'%' IDENTIFIED BY 'slavepass';
mysql > GRANT REPLICATION SLAVE ON *.* TO 'srv-repl'@'%';
```

## 锁定主库

进入主数据库的 MySQL 命令行，输入如下命令，每行命令输入完成后按回车。

```
# 加一个全局读的锁，保证数据无法被更改
mysql > FLUSH TABLES WITH READ LOCK;
# 新开一个进程，再输入如下命令
mysql > SHOW MASTER STATUS;
```

记下这里 File 字段 ( main-bin.000001 ) 和 Position 字段的值 ( 1325 )，后面要用。

如果这两个字段为空，则在后面用到这两个字段的地方，前者用空字符串 ''，后者用 4。

## 从库导入主库数据

记得先停止从库的服务，然后将主库的数据库文件，包括 data 目录下以数据库为名的文件夹，以及 ibdata1 文件，复制到从库的 data 目录下。

由于主库的数据体积很大，所以没有采用从主库导出整个数据库、再导入到从库的方式。

不过为了备忘，还是在这里记录一下主库导出、从库导入的流程。

```
# 用 CMD 执行导入数据的命令（不要用 PowerShell，因为符号 `<` 是 PowerShell 的保留关键字）。
# 进入 MySQL 命令行
mysql -u root
# 创建数据库
mysql> CREATE DATABASE db1;
# 完成后退出
mysql> exit
# 向数据库导入数据，不创建数据库的话，导入时会报错
mysql -u root db1 < db1.sql
```

## 从库配置到主库的连接

执行如下命令进行配置。

```
# 登录 MySQL Shell
mysql -uroot -p
# 输入 root 用户的密码
……
# 配置主从复制相关参数
mysql> CHANGE MASTER TO MASTER_HOST='192.168.8.28', MASTER_USER='srv-repl', MASTER_PASSWORD='slavepass', MASTER_LOG_FILE='main-bin.000001', MASTER_LOG_POS=1325;
# 启动从库
mysql> START SLAVE;
# 查看主从复制状态
mysql> SHOW SLAVE STATUS\G
```

如果 `Slave_IO_Running` 和 `Slave_SQL_Running` 这两个字段的值是 `YES`，则说明主从复制已经配置成功。

如果还不放心，可以手动执行命令查询主库和从库上，各库各表的行数。

## 相关关键词及文章

- `mysql replication`
- `mysql master slave replication`
- `mysql master slave replication step by step windows`
- [MySQL 5.6 Reference Manual / Chapter 17 Replication](https://dev.mysql.com/doc/refman/5.6/en/replication.html)：MySQL 5.6 版本关于主从复制的官方文档，其实这个最权威。
- [Configuring MySQL Master/Slave Replication in Windows](https://www.rmurph.com/post/configuring-mysql-master-slave-replication-in-windows)：主要参考这篇文章的整体流程。
- [7.4.2 Reloading SQL-Format Backups](https://dev.mysql.com/doc/refman/5.6/en/reloading-sql-format-dumps.html)：这里专门说了在 Windows 下用 PowerShell 执行 MySQL 恢复数据命令时的注意事项，刚好在这里卡住过。
- [MySQL主从复制《主库已经有数据的解决方案》《几种复制模式》](https://segmentfault.com/a/1190000022440263)：配置参数给出了一些有用的建议。
- [Mysql主从复制原理及搭建](https://juejin.cn/post/6844903921677238285)：文章最后有一些故障排查相关的内容，可以参考。
- [MySQL主从配置，原来这么简单？](https://www.modb.pro/db/55483)：文章最后有一些故障排查相关的内容，可以参考。
- [24 | MySQL是怎么保证主备一致的？ | MySQL 实战 45 讲](https://time.geekbang.org/column/article/76446)：前后几篇文章都讲到了有关 MySQL 主从复制的，要仔细看看。
- [21 | 数据备份：异常情况下，如何确保数据安全？ | MySQL 必知必会](https://time.geekbang.org/column/article/366307)：这篇文章讲的是用其他方式实现 MySQL 数据的备份/恢复，也可以了解一下。
- [MySQL生产环境复制故障修复](https://www.dounaite.com/article/62a403e6b80f116a578cb8a8.html)：讲了遇到问题时的排查思路。
