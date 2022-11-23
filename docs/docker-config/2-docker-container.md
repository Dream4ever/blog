---
sidebar_position: 2
title: Docker 容器
---

## 创建容器

`docker create` 命令用于创建容器，在创建成功后容器是停止状态，而不是启动状态。

## 命名容器

`--name` 参数可以为容器名字，这样即使容器重启，其名称也不会变化。

PS：容器名称不可重复，如果已经有一个名为 `nginx` 的容器，则不能再创建第二个同名容器。

## 启动容器

`docker start` 命令用来启动已创建好的容器。

`docker run` 命令则用于创建并启动容器，相当于 `docker create + docker start`。

**注意**：启动的容器在执行完命令之后，默认会自动退出。所以需要 `-d` 这样的命令让容器保持运行。

如果 `docker run` 因为命令无法正常执行，容器会在出错后直接退出，并返回错误代码。常见错误代码含义如下：

- 125：Docker daemon 执行出错，比如指定了不支持的 Docker 命令参数。
- 126：命令正确但无法执行，比如没有权限。
- 127：容器内命令无法找到。

## 守护态运行

`-d` 参数可以让容器在后台以守护态（Daemonized）运行。

## 重启容器

`docker restart` 命令会将运行中的容器停止，然后重新启动。

## 查看容器日志

`docker logs` 命令可以查看容器内输出的日志。

## 进入容器

`docker exec` 用于在容器内执行命令。

`-t` 命令让 Docker 分配一个伪终端，并绑定到容器的标准输入上。

`-i` 命令则让容器的标准输入保持打开。

比如 `docker exec -it 243c /bin/bash` 命令就会进入指定容器，并启动 bash。

## 退出容器

在容器内的时候，按 `Ctrl+D` 或者输入 `exit` 都可以退出容器，回到宿主环境。

## 停止容器

`docker stop` 命令会先向容器发送 `SIGTERM` 信号，等待超时时间到达后（默认为 10 秒），再发送 `SIGKILL` 信号来停止容器。

`docker kill` 命令则直接向容器发送 `SIGKILL` 信号来强行停止容器。

## 清除容器

`docker container prune` 命令会清除所有停止状态的容器，慎用。

## 查看容器

- `docker inspect`：查看容器详情。
- `docker top`：查看容器内进程。
- `docker stats`：查看统计信息。

## 容器复制文件

`docker cp` 命令用于在宿主机和容器之间复制文件。

`docker cp CONTAINER:SRC_PATH DEST_PATH` 是从容器内把文件复制到宿主机中，`docker cp SRC_PATH CONTAINER:DEST_PATH` 则刚好相反，是把文件从宿主机复制到容器内。

总的来说，`docker cp SRC_PATH DEST_PATH` 命令是从前面的环境把文件复制到后面的环境，宿主机不需要在目录前加前缀，只有容器需要加。

## 查看端口映射

`docker container port **` 命令用于查看容器的端口映射情况。

## 更新资源限额

`docker update` 命令主要用于更新容器的资源限额，包括 CPU、内存、IO 等。
