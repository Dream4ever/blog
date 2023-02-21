---
sidebar_position: 4
title: Docker 网络
---

## 端口映射

在默认情况下，宿主机无法通过网络访问 Docker 容器。

如果指定 `-P` 参数（大写），Docker 会随机映射一个 49000~49900 的宿主机端口到容器端口。

如果用小写的 `-p` 参数，则格式为 `[IP:][HostPort]:ContainerPort`，其中容器端口必须指定，IP 和宿主机端口至少需要指定其中一个。

`docker port` 指令可以查看指定容器的端口映射情况，也可以用 `docker inspect CONTAINER_ID` 来查看容器的具体信息。

## 容器互联

查看官方文档可知，该功能未来将会从 Docker 中被移除，因此官方建议不要再使用该功能。

## 容器中的 NGINX 将外部请求反代至其他容器

关键词：`nginx in docker proxy_pass network`。

参考链接：

- [How to NGINX Reverse Proxy outside of Docker to proxy_pass to docker containers](https://stackoverflow.com/questions/52823279/how-to-nginx-reverse-proxy-outside-of-docker-to-proxy-pass-to-docker-containers)
- [使用 nginx 反向代理多个 docker 容器](https://segmentfault.com/a/1190000019004994)

步骤：

1. 创建 docker 内的网络 nginx.docker：

```sh
docker network create --driver=bridge --subnet=192.168.100.0/24 nginx.docker
```

2. 在各个容器的 `docker-compose.yml` 文件中设置容器网络。

nginx 的 `docker-compose.yml`：

```
services:
nginx:
  ...
  networks:
    - nginx.docker

networks:
  nginx.docker:
    name: nginx.docker
    external: true
```

其他容器的 `docker-compose.yml`：

```
services:
seafile:
  ...
  networks:
    - nginx.docker

networks:
  nginx.docker:
    name: nginx.docker
    external: true
```

3. 在 nginx 的配置文件中设置反向代理：

```
server {
  listen 80;
  ...

  location /seafile {
      proxy_pass http://外网IP:服务端口;
      proxy_set_header  Host  $http_host;
      proxy_set_header  X-Real-IP  $remote_addr;
      proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```
