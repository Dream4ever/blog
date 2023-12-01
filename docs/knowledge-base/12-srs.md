---
sidebar_position: 12
title: SRS 相关
---

## 安装及配置

> 参考了官方文档：https://ossrs.net/lts/zh-cn/docs/v5/doc/getting-started

先启动 SRS，因为 FFmpeg 推流要成功，需要 SRS 服务的 1935 端口开启。

```sh
docker run --rm -it -p 1935:1935 -p 1985:1985 -p 8080:8080 registry.cn-hangzhou.aliyuncs.com/ossrs/srs:5
```

然后用 FFmpeg 开始推流。

```sh
ffmpeg -re -i source.flv  -c copy -f flv rtmp://localhost/live/livestream
```

## 拉流

用 PotPlayer 访问推流服务器的 8080 端口，即可看到推流的视频。

假设前一步的推流服务器 IP 为 1.2.3.4，则在 PotPlayer 中打开连接 http://1.2.3.4:8080/live/livestream.m3u8 即可查看推流地址的视频。
