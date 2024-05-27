---
sidebar_position: 7
title: 配置容器化的 Strapi
---

## 更新项目依赖

将 `package.json` 中 strapi 相关的依赖更新到最新版本或次新版本。如果最新版本是安全更新，那就用最新版，如果是功能更新，为了避免出问题，就用次新版本。

因为之前在某版本发布之后，出现了一个影响程序运行的问题，所以为了避免最新版有问题，在没有安全更新的情况下，优先使用次新版本。

## 构建 Docker 镜像

### 构建基础镜像

由于 Strapi 所需的 Node.js 环境平时并不变化，所以将不变的部分编译成基础镜像，这样可以显著提升最终镜像的构建速度。

基础镜像的 Dockerfile 如下。

```Dockerfile
FROM node:18-alpine as strapi.node-base

# 设置时区为东八区，这样在查看日志时才能显示正确的时间
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Installing libvips-dev for sharp Compatibility
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
  && apk update \
  && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev nasm bash vips-dev git
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY package.json yarn.lock ./
```

假设这个 Dockerfile 的文件名为 `Dockerfile.node-base`，那么用下面的命令即可构建基础镜像。

注意 `-t` 参数后面的镜像名称，要和 Dockerfile 中第一行 `FROM` 语句 `as` 后面的名称相一致，不然在构建最终镜像时会找不到这个镜像。

```sh
docker build -t strapi.node-base -f ./Dockerfile.node-base .
```

### 构建最终镜像

有了上面的基础镜像，再结合下面的 Dockerfile，就可以构建出最终的 Strapi 镜像。

注意第一行 `FROM` 语句，这里使用了上面构建的基础镜像 `strapi.node-base`。

另外在执行 `yarn build` 之前，先执行了 `yarn strapi ts:generate-types`，这是为了生成 TypeScript 类型文件，以便在开发时使用，不然启动容器后就会 [报错](https://www.google.com.hk/search?q=Argument+of+type+is+not+assignable+to+parameter+of+type+%27ContentType%27&oq=Argument+of+type+is+not+assignable+to+parameter+of+type+%27ContentType%27&gs_lcrp=EgZjaHJvbWUyBggAEEUYOdIBCDU1NTVqMGo3qAIAsAIA&sourceid=chrome&ie=UTF-8)。

```Dockerfile
FROM strapi.node-base as build

RUN yarn config set network-timeout 600000 -g && yarn config set registry https://registry.npmmirror.com && yarn global add node-gyp && yarn install && yarn cache clean

ENV PATH /opt/node_modules/.bin:$PATH
WORKDIR /opt/app

COPY --chown=node:node . .
USER node

RUN ["yarn", "strapi", "ts:generate-types"]
RUN ["yarn", "build"]
EXPOSE 1337
CMD ["yarn", "develop"]
```

用下面的命令来构建最终镜像。

```sh
docker build -t strapi.final -f .\Dockerfile.final .
```

## 最终文件

```yml
// docker-compose.yml

version: '3'

services:
  strapi:
    container_name: strapi
    # 使用当前目录下的 Dockerfile.prod 文件的配置生成镜像
    build:
      context: .
      dockerfile: Dockerfile.prod
    image: strapi:latest
    restart: unless-stopped
    env_file: .env
    environment:
      DATABASE_CLIENT: ${DATABASE_CLIENT}
      DATABASE_HOST: strapiDB
      DATABASE_NAME: ${DATABASE_NAME}
      DATABASE_USERNAME: ${DATABASE_USERNAME}
      DATABASE_PORT: ${DATABASE_PORT}
      JWT_SECRET: ${JWT_SECRET}
      ADMIN_JWT_SECRET: ${ADMIN_JWT_SECRET}
      DATABASE_PASSWORD: ${DATABASE_PASSWORD}
      NODE_ENV: ${NODE_ENV}
    volumes:
      - ./config:/opt/app/config
      - ./src:/opt/app/src
      - ./package.json:/opt/package.json
      - ./yarn.lock:/opt/yarn.lock

      - ./.env:/opt/app/.env
      - ./public/uploads:/opt/app/public/uploads
    ports:
      - '1337:1337'
    networks:
      - strapi
    depends_on:
      - strapiDB

  strapiDB:
    container_name: strapiDB
    env_file: .env
    image: mysql:8.0.33 # 指定 MySQL 具体版本
    command: --default-authentication-plugin=mysql_native_password
    environment:
      MYSQL_USER: ${DATABASE_USERNAME}
      MYSQL_ROOT_PASSWORD: ${DATABASE_PASSWORD}
      MYSQL_PASSWORD: ${DATABASE_PASSWORD}
      MYSQL_DATABASE: ${DATABASE_NAME}
    volumes:
      - ./mysql_data:/var/lib/mysql # MySQL 挂载数据卷至宿主机，记得创建对应目录
    ports:
      - '3306:3306'
    networks:
      - strapi

  # 可选
  strapiAdminer:
    container_name: strapiAdminer
    image: adminer
    restart: unless-stopped
    ports:
      - '9090:8080'
    environment:
      - ADMINER_DEFAULT_SERVER=strapiDB
    networks:
      - strapi
    depends_on:
      - strapiDB

// 配置几个容器在同一个网络中，否则互相之间无法通信
networks:
  strapi:
    name: Strapi
    driver: bridge
```

## 用指定的 YML 文件启动容器

```sh
# 用 compose-dev.yml 启动容器
$ docker compose -f compose-dev.yml up -d
```

`compose-dev.yml` 文件与 `compose.yml` 文件的区别只在下面一段：

```yml
# compose-dev.yml
services:
  strapi:
    container_name: strapi
    build:
      context: .
      dockerfile: Dockerfile.prod # 生产环境执行另一个 Dockerfile 文件
```

## 参考资料

用到了开源项目 [strapi-community / strapi-tool-dockerize](https://github.com/strapi-community/strapi-tool-dockerize)，用于在已生成 strapi 项目的情况下，再生成对应的 dockerfile 和 docker-compose.yml 等相关文件，以便部署至 Docker 中。

又参考了国内文章 [快速体验 Strapi CMS（基于 docker 部署）](https://juejin.cn/post/7196869815596761144)，对 docker compose 过程中需要从国外下载的情况，配置了国内源，实现加速下载。

这篇文章 [Docker Container time & timezone (will not reflect changes)](https://serverfault.com/a/683651/551094) 介绍了怎样在 Docker 容器中设置时区，如果用默认时区，容器中的日志时间会是 UTC 时间，不方便查看。