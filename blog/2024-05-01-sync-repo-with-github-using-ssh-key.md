---
slug: sync-repo-with-github-using-ssh-key
title: 用 SSH Key 来同步不同 GitHub 账号下的项目
authors: HeWei
tags: [git, github, ssh, ssh-key]
---

## 需求

由于现在的项目分布在不同的 GitHub 账号下，如果在本地的 Git 全局配置中记录其中一个 GitHub 账号的信息，那么在与 GitHub 同步另一个账号下的项目时，每次都会弹出烦人的对话框，询问要选择哪个 GitHub 账号进行同步。

## 解决过程

上网搜索了一下，得知 GitHub 官方就提供这种解决方案。

简单来说就是在本地新建一个 SSH key，把私钥添加到本地的 ssh-agent，再把公钥添加到 GitHub 对应的账号下面。然后用 GitHub 项目的 SSH 链接来 fork 项目，之后在与 GitHub 同步项目的时候，就不会弹出烦人的对话框了。

## 新建 SSH key

参考 [Generating a new SSH key and adding it to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)，在 `~\.ssh` 目录下面执行命令 `ssh-keygen -t ed25519 -C "your_email@example.com"` 一路回车，按默认设置来即可。

如果不按默认设置来，手动修改了生成的 SSH key 的名称，那么在后面将私钥添加到本地的 ssh-agent 这一步时会失败。

## 将私钥添加到 ssh-agent

执行 [Adding your SSH key to the ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent) 这里的步骤即可。

## 将公钥添加到 GitHub

按 [Adding a new SSH key to your GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) 这里的流程来即可。

## 测试 SSH 配置是否有效

按 [Testing your SSH connection](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection) 这里的步骤操作即可。

如果报错，可以先在官方文档的 [Troubleshooting SSH](https://docs.github.com/en/authentication/troubleshooting-ssh) 这一节查找对应报错信息。

有时候因为众所周知的网络原因，执行测试命令失败，可以按照 [这里](https://github.com/orgs/community/discussions/55269#discussioncomment-6106315) 的方法配置一下 SSH，然后再测试，应当就 OK 了。

## 注意

有时候将一台电脑上生成的 SSH key 复制到另一台电脑上，再按照上面的流程配置，发现不能用。那就按照上面的流程重新生成新的 SSH key，再把公钥添加到 GitHub 即可。

