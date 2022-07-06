---
sidebar_position: 4
title: Docker 网络
---

## 网络

### 端口映射

在默认情况下，宿主机无法通过网络访问 Docker 容器。

如果指定 `-P` 参数（大写），Docker 会随机映射一个 49000~49900 的宿主机端口到容器端口。

如果用小写的 `-p` 参数，则格式为 `[IP:][HostPort]:ContainerPort`，其中容器端口必须指定，IP 和宿主机端口至少需要指定其中一个。

`docker port` 指令可以查看指定容器的端口映射情况，也可以用 `docker inspect CONTAINER_ID` 来查看容器的具体信息。

### 容器互联

查看官方文档可知，该功能未来将会从 Docker 中被移除，因此官方建议不要再使用该功能。
