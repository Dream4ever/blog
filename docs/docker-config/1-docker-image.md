---
sidebar_position: 1
title: Docker 镜像
---

## 下载指定版本

`docker pull ubuntu` 命令相当于 `docker pull ubuntu:latest`。

为了保证镜像环境的一致，建议在下载镜像时指定其版本，比如 `docker pull ubuntu:18.04`。

## 代理加速

可以在 Docker 服务的启动配置中增加 `--registry-mirror=PROXY_URL` 来指定镜像的代理地址，以便加速下载。

## 镜像层

镜像一般都由多个层（Layer）构成，如果不同的镜像包含相同的层（比如多个版本的 MySQL），那么在硬盘上只会存储一份这个层，以便节省空间。

## 镜像标签

为了方便工作，可以用 `docker tag` 命令为本地镜像添加标签。

如果一个镜像有多个标签，那么 `docker rm image:tag1` 命令只会删除标签。当镜像只有一个标签时，该命令才会删除镜像。

## 清理镜像

`docker image prune` 命令可以删除临时镜像、未使用的镜像。
