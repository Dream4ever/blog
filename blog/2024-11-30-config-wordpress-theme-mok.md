---
slug: config-wordpress-theme-mok
title: 配置 WordPress 主题 MOK
authors: HeWei
tags: [WordPress,Theme,MOK]
---

## 安装 MOK 主题

将 MOK 主题压缩包上传到服务器的 `~` 目录下，因为如果尝试直接上传到 `/var/www/powertidal.com` 目录下，会因为权限不够导致上传失败。

```bash
scp -i C:\Users\${Username}\.ssh\key.pem .\mok.zip ecs-user@1.2.3.4:~/
```

然后再用 `sudo mv mok.zip /var/www/powertidal.com/wp-content/themes` 命令将 MOK 主题压缩包移动到网站目录下。

执行 `cd /var/www/powertidal.com/wp-content/themes && sudo unzip mok.zip`，将 MOK 主题文件解压。

如果点击上传按钮后，显示报错信息 `Unable to create directory wp-content/uploads/2024/06. Is its parent directory writable by the server?`，可以通过以下命令解决：

```bash
sudo mkdir -p /var/www/powertidal.com/wp-content/uploads
sudo chown -R www-data:www-data /var/www/powertidal.com/wp-content/uploads
```

## 启用 MOK 主题

访问 `https://www.powertidal.com/wp-admin/themes.php`，启用 MOK 主题即可。

对于英文版网站做同样操作。

## 配置网站 Logo

访问 `https://www.powertidal.com/wp-admin/themes.php?page=tbos_setting`，在默认显示的第一个页面中，上传网站所需的 PC 端和移动端的 Logo 图片，图片尺寸按照网页上所说的建议尺寸调整即可。

中文版网站配置好 Logo 之后，英文版网站使用相同的 Logo URL 即可。

## 配置多语言

管理后台 - Appearance - MOK 主题设置 - 多语言
- 前台语言：中文站选择`中文`，英文站选择`英文`
- 语言切换
  - 打开 `开启`、`手机端显示`、`语言切换自动跳转`
  - 中文网址：`https://www.powertidal.com`
  - 英文网址：`https://www.powertidal.com/en`

## 多语言网站的文章切换

对于多语言网站，不同语言的文章在 Edit 页面中的 ID 应当是相同的，这样点击页面右上方的语言切换按钮的时候，才能正常切换到对应语言的文章。

## 多语言网站的文章分类

在管理后台 - Posts - Categories 页面中管理文章分类。

`Name` 为显示在页面中的分类名称，`Slug` 为分类的别名。

对于多语言网站，不同语言同一个分类的 ID 应当相同，这样切换语言后才能正常显示另一种语言下该分类的内容。

## 列表页小图与正文大图

在编辑文章时，`Featured Image` 是只在列表页显示的小图，如果要在正文中也显示，需要在正文中也插入图片。

## 设置顶部导航栏

管理后台 - Appearance - Menus

1. Menu Settings - Display Location，选中 `顶部导航`。
2. 输入 Menu Name。
3. 点击 `Create Menu` 创建菜单。

## 设置联系我们页面

1. 在中英文后台新建相同 ID 的页面，页面模板选择 `联系我们`。
2. 为中英文网站分别填写对应语言的页面标题。
3. 在中英文后台的 Appearance - Menus 页面中，将新建的联系我们页面添加到顶部导航栏中。
4. 在中英文后台的 Appearance - MOK 主题设置 - 联系方式页面中，填写所需的联系方式即可。

## 开启在线留言功能

1. 新建一个 Page，模板选 `合作`。
2. 管理后台 - Appearance - MOK 主题设置 - 页面中，开启 `合作页面`，并按照需求填写或开启所需功能。
3. 管理后台 - Appearance - MOK 主题设置 - 联系方式中，创建一个 `自定义` 类型的`联系方式`，链接填第一步新建的 Page 的链接，`账号/号码/地址` 填 `点击留言`。

## 其他配置

MOK 主题设置
- 基本 - 其他：开启 `关闭评论功能`。
- 外观
  - 建站年份：填写当年年份
  - 关闭 `主题由themebetter提供`
- 文章
  - 统计：关闭 `点赞`
  - 版权提示：关闭 `产品详情页版权` 和 `其他详情页版权`
- 分享
  - 网页分享：全部取消选中
- 联系方式
  - 关闭 `顶部-仅显示1个联系方式`
  - 关闭：`联系方式-微信公众号`、`联系方式-客服微信`、`联系方式-客服QQ`、`联系方式-专属客服`、`联系方式-24小时服务热线`
