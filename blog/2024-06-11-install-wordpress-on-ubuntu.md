---
slug: install-wordpress-on-ubuntu
title: 在 Ubuntu 上安装配置 WordPress
authors: HeWei
tags: [WordPress,Ubuntu,PHP,MySQL]
---

## 配置 ECS

系统选择 Ubuntu 22.04，密码则在实例管理控制台页面，通过重置密码方式进行设置。

但是设置密码之后，依然无法远程 SSH 登录，猜测可能是系统防火墙的问题，先不管了，先把整体环境配置好。

## 安装 Nginx

sudo apt update

sudo apt install nginx

## 配置防火墙

sudo ufw app list

sudo ufw allow 'Nginx HTTP'

sudo ufw allow 'OpenSSH'

sudo ufw enable

sudo ufw status

curl -4 icanhazip.com

## 安装配置 MySQL

sudo apt install mysql-server

sudo mysql_secure_installation

VALIDATE PASSWORD COMPONENT can be used to test passwords
and improve security. It checks the strength of password
and allows the users to set only those passwords which are
secure enough. Would you like to setup VALIDATE PASSWORD component?

Press y|Y for Yes, any other key for No: y

MEDIUM Length >= 8, numeric, mixed case, and special characters

Remove anonymous users? (Press y|Y for Yes, any other key for No) : y

Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y

Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y

## 安装 PHP

sudo apt install php8.1-fpm php-mysql php-simplexml

## 配置 Nginx

sudo nano /etc/nginx/sites-available/your_domain

```
server {
    listen 80;
    server_name your_domain www.your_domain;
    root /var/www/your_domain;

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }

}
```

sudo ln -s /etc/nginx/sites-available/your_domain /etc/nginx/sites-enabled/

sudo unlink /etc/nginx/sites-enabled/default

sudo nginx -t

sudo systemctl reload nginx

sudo mkdir /var/www/your_domain

sudo nano /var/www/your_domain/index.html

```html
<html>
  <head>
    <title>your_domain website</title>
  </head>
  <body>
    <h1>Hello World!</h1>

    <p>This is the landing page of <strong>your_domain</strong>.</p>
  </body>
</html>
```

http://server_domain_or_IP

## 测试 PHP 解析

sudo nano /var/www/your_domain/info.php

```php
<?php
phpinfo();
```

access http://server_domain_or_IP/info.php

sudo rm /var/www/your_domain/info.php

## 测试 PHP 连接 MySQL

sudo mysql

CREATE DATABASE example_database;

CREATE USER 'example_user'@'%' IDENTIFIED WITH mysql_native_password BY 'xxxx';

GRANT ALL ON example_database.* TO 'example_user'@'%';

exit

mysql -u example_user -p

SHOW DATABASES;

```
CREATE TABLE example_database.todo_list (
	item_id INT AUTO_INCREMENT,
	content VARCHAR(255),
	PRIMARY KEY(item_id)
);
```

INSERT INTO example_database.todo_list (content) VALUES ("My first important item");

SELECT * FROM example_database.todo_list;

exit

sudo nano /var/www/your_domain/todo_list.php

```
<?php
$user = "example_user";
$password = "xxxx";
$database = "example_database";
$table = "todo_list";

try {
  $db = new PDO("mysql:host=localhost;dbname=$database", $user, $password);
  echo "<h2>TODO</h2><ol>"; 
  foreach($db->query("SELECT content FROM $table") as $row) {
    echo "<li>" . $row['content'] . "</li>";
  }
  echo "</ol>";
} catch (PDOException $e) {
    print "Error!: " . $e->getMessage() . "<br/>";
    die();
}
```

http://server_domain_or_IP/todo_list.php

sudo rm /var/www/your_domain/todo_list.php

## 安装配置 WordPress

先在 MySQL 中创建数据库和用户。

```
# 如果需要多语言，则创建两个数据库
CREATE DATABASE wordpress;
CREATE DATABASE wordpress_en;

CREATE USER 'wordpress_admin'@'%' IDENTIFIED WITH mysql_native_password BY 'xxxx';

# 用同一个 DB ADMIN 账户管理两个数据库
GRANT ALL ON wordpress.* TO 'wordpress_admin'@'%';
GRANT ALL ON wordpress_en.* TO 'wordpress_admin'@'%';
```

sudo apt install unzip

将 WordPress 文件解压到 /var/www/your_domain，再复制一份到 your_domain/en。

将两处的 wp-config-sample.php 复制为 wp-config.php。

vi /var/www/your_domain/wp-config.php，修改数据库连接信息，en 子目录下的相同文件也做同样操作。

访问 http://server_domain_or_IP/wp-admin/install.php，按照提示完成安装，en 子目录下的相同。

如果在输入密码的地方报错 password strength is unknown，有可能是在用 https 协议访问。可以在 wp-config.php 中添加一行：

```
$_SERVER['HTTPS'] = true; 
```

> 搜索 `Password strength unknown`，在 https://wordpress.stackexchange.com/a/350453 中找到的这个解决方法。

用户名：abc，密码：****

https://developer.wordpress.org/advanced-administration/before-install/howto-install/

## 使用 WP 主题

将主题的 zip 文件上传到服务器。

如果 Nginx 报错 `413 Request Entity Too Large`，可以修改 /etc/nginx/nginx.conf，添加或修改 client_max_body_size 为 100M。

```nginx
http {
    client_max_body_size 100M;
}
```

点击上传按钮后报错 `Unable to create directory wp-content/uploads/2024/06. Is its parent directory writable by the server?`，可以通过以下命令解决：

```bash
sudo chown -R www-data:www-data /var/www/your_domain/wp-content/uploads
```

但是这样的话，WordPress 还要求配置 FTP 用户名和密码，这不麻烦了吗，不折腾。

家里电脑没法通过 SSH 连接服务器，但是办公室可以，于是就用办公室电脑的 Termius 的 SFTP 功能上传了主题文件。

由于 ecs-user 账户权限有限，所以先上传到 /home/ecs-user，然后再用 sudo mv 命令移动到 /var/www/your_domain/wp-content/themes。

接着用 sudo unzip 解压到压缩包所在目录下。

## 导出/导入数据库

```bash
# 导出数据库
sudo mysqldump -u wordpress_admin -p --databases wordpress > ~/wordpress.sql

# 导入数据库
sudo mysql -u wordpress_admin -p < ~/wordpress.sql
```

## 问题记录

在 WordPress 后台启用主题之后，刷新页面报错：

```
There has been a critical error on this website. Please check your site admin email inbox for instructions.

Learn more about troubleshooting WordPress.
```

解决方法：将主题文件夹重命名即可。但是这样的话就没法用这个主题了，这样并不能从根本上解决问题。

参考文章：https://kinsta.com/knowledgebase/there-has-been-a-critical-error-on-your-website/。

问了一下客服，让按照 https://themebetter.com/wp-debug.html 的方法，开启 DEBUG 模式。

开启之后，报错信息如下：

```
Fata error: Uncaugnt Error: call to undefined function simplexml_load_string() in
/var/www/your_domain/wp-content/themes/mok/inc/update.php:72 Stack trace: #0
/var/www/your_domain/wp-content/themes/mok/inc/update.php(4): get_latest_theme_version() #1
/var/www/your_domain/wp-includes/class-wp-hook.php(324): update_notifier_menu() #2
/var/www/your_domain/wp-includes/class-wp-hook.php(348): WP Hook->apply_filters() #3
/var/www/your_domain/wp-includes/plugin.php(517): WP Hook->do_action() #4
/var/www/your_domain/p-admin/includes/menu.php(161): do_action() #5
/var/www/your_domain/wpadmin/menu,php(422): require_once('...') #6
/var/www/lxklsh,com/wp-admin/admin.php(158):reguire('...') #7
/var/www/your_domain/wp-admin/index.php(10): require_once('...') #8
{main} thrown in /var/www/your_domain/wp-content/themes/mok/inc/update.php on line 72
```

客服说是没有装 PHP 的 simplexml 扩展，装了之后就没问题了。

## 相关资料

整体流程参考 https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu。
