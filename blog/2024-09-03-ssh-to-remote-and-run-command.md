---
slug: ssh-to-remote-and-run-command
title: SSH 连接远程服务器后执行命令
authors: HeWei
tags: [ssh, remote, command]
---

### SSH 登录后执行 zip 命令

公司阿里云 Windows 服务器上的日志需要每个月归档一下，以前都是手动操作，最近感觉太麻烦，于是研究了一下自动化的方案，因此有了这篇文章。

万事不决问 Kimi，这篇文章的主要思路和解决方案都是 Kimi 给出的，谨表谢意。

最开始给出的方案是 `ssh -t ecs '...'`，经过研究，`ssh -t` 会为命令创建一个伪终端，这样命令就可以在远程服务器上以交互模式运行。

之前给另一个前端项目写的命令是调用 `rm` 来删除文件，这个命令在 Windows 服务器上能运行，说明调用的是服务器上的 `git bash` 带的命令。

但是 `git bash` 默认不带 `zip` 命令，于是搜索 `git bash zip command pass variable` 这组关键词之后，看到了 [How to add man and zip to "git bash" installation on Windows](https://stackoverflow.com/a/55749636/2667665) 这篇文章，按照文章里的方法，给 `git bash` 安装了 `zip` 命令。

虽然 `zip` 命令安装成功了，但是执行 `ssh -t ecs 'zip ...'` 的时候，既不会报错，也不会执行命令。

经过研究，发现命令是没问题的，只不过 `-t` 参数加上之后会让命令无法执行。

于是干脆去掉这个参数，直接执行 `ssh ecs '...'`，这样命令就能正常执行了。

### 将前一个月的年份和月份作为变量传递

由于需要归档的是服务器上前一个月各网站的 IIS 日志，所以需要将前一个月的年份和月份作为变量传递给远程服务器上的命令。

结合 Kimi 和 Cursor 给出的方案，最终用下面的代码实现了需求：

```sh
# 获取上一个月的年份和月份
# 即使本月是 1 月，上一个月也会自动计算为前一年的 12 月
YYYY=$(date -d "$(date) -1 month" "+%Y")
YY=$(date -d "$(date) -1 month" "+%y")
MM=$(date -d "$(date) -1 month" "+%m")
```

拿到了年份和月份，在 bash 中就可以用 `${YYYY}`、`${YY}` 和 `${MM}` 的方式来使用了。

### 将指定目录下匹配规则的文件进行压缩

这个需求很简单，指定目录下的目标文件名符合 `u_exYYMMDD.log` 的格式，这样的文件可以用 `u_ex${YY}${MM}*` 的方式来匹配。

因为需要压缩后删除源文件，所以用 `zip -m` 参数来压缩。

另外压缩时不需要带上文件的目录结构，所以用 `-j` 参数。

这样完整的 zip 命令就是 `zip -mj ${ZIP_FILE} ${LOG_DIR}/u_ex${YY}${MM}*`。

### 将多个目录下的文件压缩到多个对应的目录中

IIS 为每个网站创建的日志目录格式是 `W3SVC1`、`W3SVC2` 这种，而自己用来存放压缩后的每个月日志的目录格式是 `W3SVC1_aaaa`、`W3SVC2_bbbb` 这种，所以需要将每个网站的日志压缩到对应的目录中。

问了一下 kimi，给出了下面的方案，很好用。

```sh
declare -A websites
websites["W3SVC2"]="aaaa"
websites["W3SVC3"]="bbbb"
......
```

然后就可以用下面的语句来遍历这个数组，执行压缩命令了。

```sh
for index in "${!websites[@]}"; do
  ZIPFILE_DIR="/path/of/archive/${index}_${websites[$index]}"
  LOG_DIR="/path/of/logs/${index}"
  ZIP_FILE="${ZIPFILE_DIR}/${YYYY}-${MM}.zip"

  # 构建压缩命令
  # -m 表示压缩后删除源文件
  # -j 表示压缩时不带目录结构
  CMD="ssh ecs1 \"zip -mj ${ZIP_FILE} ${LOG_DIR}/u_ex${YY}${MM}*\""

  # 执行压缩命令
  echo ""
  echo "正在归档网站 ${websites[$index]} $YYYY年$MM月的日志..."
  eval $CMD
done
```

### 总结

- 用 `ssh ecs '...'` 的方式执行命令，命令中需要用到变量时，需要用 `${...}` 的方式来获取。
- 用 `declare -A` 的方式来定义数组，用 `websites["W3SVC1"]="aaaa"` 的方式来给数组赋值，用 `websites[$index]` 的方式来获取数组的值。
- 用 `for index in "${!websites[@]}"; do ... done` 的方式来遍历数组。
- 用 `eval` 的方式来执行命令。
- 用 `zip -mj ${ZIP_FILE} ${LOG_DIR}/u_ex${YY}${MM}*` 的方式来压缩并删除源文件。
