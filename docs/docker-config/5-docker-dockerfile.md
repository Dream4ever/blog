---
sidebar_position: 5
title: Dockerfile
---

## 配置指令

- `FROM` Dockerfile 中第一条指令必须是它。如果在一个 Dockerfile 中创建多个镜像，每个镜像都需指定一个 `FROM` 指令。
- `ARG` 和 `ENV` 都可以在创建镜像过程中设置变量，只不过前者在镜像编译成功后会消失，后者则会保留。
- `EXPOSE` 用于设置镜像内部的端口。
- `ENTRYPOINT` 指定容器执行时的根命令。
  - 和 `CMD` 命令的区别在哪里？
- `VOLUME` 用于挂载数据卷。
- `USER` 指定运行容器时的用户名或 UID。
- `WORKDIR` 为后续的 RUN、CMD、ENTRYPOINT 指令配置工作目录。多个相对路径的 `WORKDIR` 指令可互相继承，因此为了避免出错，建议只用 **绝对路径** 。
- `ONBUILD` 后所跟的命令，会在子镜像基于父镜像创建时自动执行。由于它是隐式执行的，因此建议在镜像标签中进行标注。
  - 该指令在创建专门用于自动编译、检查等操作的基础镜像时非常有用。
- `SHELL` 指定其他命令使用 shell 时的默认 shell 类型，默认值为 `["/bin/sh", "-c"]`。
  - Windows 系统的 Shell 路径中使用了 `\` 作为分隔符，建议在 Dockerfile 开头添加 `# escape='` 来指定转义符。

## 操作指令

