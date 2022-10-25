---
sidebar_position: 2
title: 调整 MySQL 相关配置
---

## Windows 下修改 MySQL 数据库文件保存位置

关键词：`mysql change data directory windows`。

解决方案：[Change existing datadir path](https://dba.stackexchange.com/questions/24403/change-existing-datadir-path)。

关键流程：

1. 停止 MySQL 服务：`net stop mysql`。
2. 找到 MySQL 配置文件 `my.ini`，修改其中的 `datadir` 字段值，改成准备存放 MySQL 数据库文件的目标位置。
3. 将整个数据库文件夹从原来的位置复制到新的地方，可以使用命令 `xcopy "C:\ProgramData\MySQL\MySQL Server 5.1\data" F:\naveen\data /s` 实现。
4. 启动 MySQL 服务：`net start mysql`。
5. 在命令行中登录 MySQL，然后执行命令 `show variables like 'datadir';`，如果显示的是修改后的目标文件夹，说明数据库配置修改成功。
6. 检查各项使用 MySQL 的业务，如果没有问题，就可以把原来存放数据库的文件夹删除了。
