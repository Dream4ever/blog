---
sidebar_position: 7
title: 配置容器化的 Strapi
---

## 配置数据库 Postgres

`docker-compose.yml` 文件如下：

> 参考了官方示例 https://hub.docker.com/_/postgres

```yml
# Use postgres/example user/password credentials
version: '3.1'

services:

  db:
    # 官方文档 https://docs.strapi.io/dev-docs/installation/docker 用的是 v12 版本
    # 这里用的就是 v12 的最新版（2023-06-11）
    image: postgres:12.15
    restart: always
    environment:
      # 明确设置默认用户名
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ****
      # 明确设置数据库，Strapi 项目要用到
      POSTGRES_DB: db-name
    ports:
      - 5432:5432
```

创建该文件之后，在目录下执行 `docker-compose up -d`，Docker 就会自动下载镜像，并按照上面的配置创建容器。

## 容器化 Strpi

参考资料：

- 关键词：`install strapi docker`
- 文章：[A Comprehensive Tutorial: Setting Up Strapi, Next.js, and Docker for Seamless Web Development](https://blog.devgenius.io/a-comprehensive-tutorial-setting-up-strapi-next-js-and-docker-for-seamless-web-development-48a145db06fb)
