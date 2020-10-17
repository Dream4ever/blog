---
title: "Hugo 博客配置教程"
date: 2020-10-17T11:31:39+08:00
draft: false
---

## 创建博客所需 repo

假设你在 GitHub 上的用户名是 `abcd`，那么在 GitHub 上创建下面两个 repo：

- 一个叫 `blog`，用于存放 Hugo 博客的源文件
- 另一个叫 `abcd.github.io`，用于存放 Hugo 编译生成的网页文件

记得在创建这两个 repo 的时候，至少选上 README、.gitignore、LICENSE 三个文件中的一个，这样创建出来的 repo 就不是空的，以免影响后续操作。

## 配置源文件 repo

依次执行以下命令：

```shell
# 将 repo clone 至本机 blog 文件夹中
$ git clone https://github.com/abcd/blog.git
# 用 blog 文件夹生成 Hugo 博客的初始内容
$ hugo new site blog --force
# 将博客主题添加为 blog 这个 repo 的子模块
# 这样两者互不影响
$ cd blog
$ git submodule add https://github.com/varkai/hugo-theme-zozo themes/zozo
echo 'theme = "zozo"' >> config.toml
```

# 配置最终网页 repo

```shell
# 将 public 文件夹与 repo abcd.github.io 相关联
$ git submodule add -b main https://github.com/abcd/dream4ever.github.io.git public
```

## 使用自动发布博客的脚本

```shell
#!/bin/sh

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

# Build the project.
# 使用指定的主题编译博客
hugo -t zozo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
# 2020-10-17：注意：现在 GitHub 的主分支已经改名为 main
git push origin main
```

然后再执行下面的命令，来测试脚本是否可用

```shell
# 首次执行，需为脚本开启对应权限
$ chmod +x deploy.sh
# 调用脚本，发布博客
$ ./deploy.sh "首次用脚本自动发布博客"
```