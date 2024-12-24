---
sidebar_position: 2
title: 调整 MySQL 相关配置
---

## 设置 MySQL Shell 连接时的编码设置

用 `mysql -uroot -p` 命令连接 MySQL Shell，不作任何额外设置时，部分字符集的值是 `latin1` 系列。

```sh
mysql> SHOW VARIABLES LIKE 'collation\_%';
+----------------------+--------------------+
| Variable_name        | Value              |
+----------------------+--------------------+
| collation_connection | latin1_swedish_ci  |
| collation_database   | utf8mb4_0900_ai_ci |
| collation_server     | utf8mb4_0900_ai_ci |
+----------------------+--------------------+

mysql> SHOW VARIABLES LIKE 'character\_set\_%';
+--------------------------+---------+
| Variable_name            | Value   |
+--------------------------+---------+
| character_set_client     | latin1  |
| character_set_connection | latin1  |
| character_set_database   | utf8mb4 |
| character_set_filesystem | binary  |
| character_set_results    | latin1  |
| character_set_server     | utf8mb4 |
| character_set_system     | utf8mb3 |
+--------------------------+---------+
```

如果设置连接时的字符集为 `utf8mb4`，则输出结果如下所示：

```sh
mysql> SHOW VARIABLES LIKE 'collation\_%';
+----------------------+--------------------+
| Variable_name        | Value              |
+----------------------+--------------------+
| collation_connection | utf8mb4_0900_ai_ci |
| collation_database   | utf8mb4_0900_ai_ci |
| collation_server     | utf8mb4_0900_ai_ci |
+----------------------+--------------------+

mysql> SHOW VARIABLES LIKE 'character\_set\_%';
+--------------------------+---------+
| Variable_name            | Value   |
+--------------------------+---------+
| character_set_client     | utf8mb4 |
| character_set_connection | utf8mb4 |
| character_set_database   | utf8mb4 |
| character_set_filesystem | binary  |
| character_set_results    | utf8mb4 |
| character_set_server     | utf8mb4 |
| character_set_system     | utf8mb3 |
+--------------------------+---------+
```

可以看到，`collation_connection`、`character_set_client`、`character_set_connection` 和 `character_set_results` 的值都是 `utf8mb4`，查询结果中的汉字就可以正常显示了，而不是若干个半角问号 ? 了。

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
