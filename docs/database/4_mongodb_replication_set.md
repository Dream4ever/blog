---
sidebar_position: 4
title: 配置 MongoDB 复制集
---

## 配置 MongoDB 复制集

1. 停止默认的 MongoDB 服务，并将其设置为手动启动。

2. 执行下面的命令，用指定的配置文件将 mongod 安装为服务。

```sh
mongod --config "e:\upcweb\MongoDB\Server\4.2\conf\mongod.conf" --serviceName "MongoDB1" --serviceDisplayName "MongoDB1" --install
```

配置文件内容如下：

```conf
storage:
  dbPath: e:\upcweb\MongoDB\Server\4.2\data
  journal:
    enabled: true

systemLog:
  destination: file
  logAppend: true
  path:  e:\upcweb\MongoDB\Server\4.2\log\mongod.log

net:
  bindIp: 0.0.0.0
  port: 27017

replication:
  replSetName: rs0
```

3. 启动前一步所创建的服务。

> MongoDB 要实现高可用复制集的话，需要至少有三个实例，并且需要有奇数个实例。
>
> 所以如果有多台电脑需要配置 MongoDB，就需要在各个电脑上均按照上述的方式进行配置。
>
> 如果一台电脑上要运行两个 MongoDB 实例，则要为不同的实例分配不同的端口号，以保证实例之间不冲突。

4. 添加复制集。

```sh
# 进入 mongo shell
mongo
# 由于按前面的步骤操作之后，第一个实例默认会自动成为主节点
# 因此直接添加其他的实例即可
rs.add({ _id: 1, host: "192.168.8.27:27017" })
rs.add({ _id: 2, host: "192.168.8.27:27018" })
# 查看复制集配置结果
rs.status()
```

5. 设置固定主节点

如需保证主节点始终为某个节点，则需进行如下配置。

```sh
var conf = rs.conf()
// 将0号节点的优先级调整为10
conf.members[0].priority = 10
// 应用调整
rs.reconfig(conf)
```

5. 访问复制集

按如下流程操作，即可访问复制集中的从节点。

```sh
# 进入从节点的 mongo shell
mongo
# 临时启用从节点的读权限
rs.secondaryOk()
# 访问从节点的库和表
……
```
