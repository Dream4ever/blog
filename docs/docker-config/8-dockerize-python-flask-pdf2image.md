---
sidebar_position: 8
title: 配置容器化的 Python Flask pdf2image 项目
---

## 配置 Debian apt 使用国内源

查看 Docker Hub 上每个具体版本的 [Python 镜像](https://hub.docker.com/layers/library/python/3.12.2/images/sha256-eae24db48035197c7c6a521d5263e125cfba1d59b2d03bdc63ce11655af1695b?context=explore)的话，会发现 Python 是基于 Debian 的镜像来构建的。

要在国内环境使用，就需要修改 Debian apt 的源和 pip 的源。

而对于不同版本的 Debian 来说，用于配置 apt 源的文件也是不一样的，一定要根据 Debian 的版本来确定要修改哪个文件。

如果不确定的话，可以先只是用指定版本的 Python 镜像启动一个容器，然后进入容器的 `/etc/apt` 目录。在 Debian 12 上，配置 apt 源的文件在该目录下的 `sources.list.d/debian.sources` 文件中，而在低版本的 Debian 中，则是该目录下的 `sources.list` 文件，这一点要注意。

## 配置 pip 使用国内源

配置 pip 的源就很简单了，`RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple` 一条命令足矣。

## 最终代码

最终的项目代码前往 https://github.com/Dream4ever/flask-pdf2image 查看即可，包含容器化运行所需的完整文件。
