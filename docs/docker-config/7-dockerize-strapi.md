---
sidebar_position: 7
title: 配置容器化的 Strapi
---

## 参考资料

用到了开源项目 [strapi-community / strapi-tool-dockerize](https://github.com/strapi-community/strapi-tool-dockerize)，用于在已生成 strapi 项目的情况下，再生成对应的 dockerfile 和 docker-compose.yml 等相关文件，以便部署至 Docker 中。

又参考了国内文章 [快速体验 Strapi CMS（基于 docker 部署）](https://juejin.cn/post/7196869815596761144)，对 docker compose 过程中需要从国外下载的情况，配置了国内源，实现加速下载。

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

```dockerfile
# Dockerfile.prod

# 下面两行能保证 Docker 中输出的日志用的是东八区的时间
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Creating multi-stage build for production
FROM node:16-alpine as build
# apk add 时使用阿里源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev > /dev/null 2>&1
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY package.json yarn.lock ./
# yarn install 时使用阿里源
RUN yarn config set network-timeout 600000 -g && yarn config set registry https://registry.npmmirror.com && yarn install --production
ENV PATH /opt/node_modules/.bin:$PATH
WORKDIR /opt/app
COPY . .
RUN yarn build

# Creating final production image
FROM node:16-alpine
# apk add 时使用阿里源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk add --no-cache vips-dev
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}
WORKDIR /opt/
COPY --from=build /opt/node_modules ./node_modules
WORKDIR /opt/app
COPY --from=build /opt/app ./
ENV PATH /opt/node_modules/.bin:$PATH

RUN chown -R node:node /opt/app
USER node
EXPOSE 1337
CMD ["yarn", "start"]
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
