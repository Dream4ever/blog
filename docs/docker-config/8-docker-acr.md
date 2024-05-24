---
sidebar_position: 8
title: 利用阿里云容器镜像服务（ACR）同步镜像
---

## 整体流程

1. 设置该服务的专用密码。
2. 在本地登录 Docker registry：`docker login --username=hi*****@aliyun.com registry.cn-qingdao.aliyuncs.com`，这里的 Docker registry 是 ACR 的公网地址。
3. 给镜像打标签：`docker tag [ImageId] registry.cn-qingdao.aliyuncs.com/[命名空间]/[镜像仓库名称]:[镜像版本号]`。
4. 将镜像推送到阿里云的 Docker registry：`docker push registry.cn-qingdao.aliyuncs.com/[命名空间]/[镜像仓库名称]:[镜像版本号]`。
5. 在服务器上登录 Docker registry，步骤同第 2 步。
6. 在服务器上拉取镜像：`docker pull registry.cn-qingdao.aliyuncs.com/[命名空间]/[镜像仓库名称]:[镜像版本号]`。这里的地址用的还是 ACR 的公网地址，可以试试专有网络这种内网地址，看看速度会不会快一些。
