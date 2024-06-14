--
slug: install-wordpress-on-ubuntu
title: 在 Ubuntu 上安装配置 WordPress
authors: HeWei
tags: [WordPress,Ubuntu,PHP,MySQL]
---

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

MEDIUM Length >= 8, numeric, mixed case, and special characters

Remove anonymous users? (Press y|Y for Yes, any other key for No) : y

Disallow root login remotely? (Press y|Y for Yes, any other key for No) : y

Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y

## 安装 PHP

sudo apt install php8.1-fpm php-mysql

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

vi /var/www/your_domain/index.html

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

vi /var/www/your_domain/info.php

```php
<?php
phpinfo();
```

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

vi /var/www/your_domain/todo_list.php

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

将 WordPress 文件解压到 /var/www/your_domain。

```
CREATE DATABASE wordpress;

CREATE USER 'wordpress_admin'@'%' IDENTIFIED WITH mysql_native_password BY 'xxxx';

GRANT ALL ON wordpress.* TO 'wordpress_admin'@'%';
```

将 wp-config-sample.php 复制为 wp-config.php。

vi /var/www/your_domain/wp-config.php，修改数据库连接信息。

访问 http://server_domain_or_IP/wp-admin/install.php，按照提示完成安装。

用户名：abcd，密码：xxxx

https://developer.wordpress.org/advanced-administration/before-install/howto-install/

## 使用 WP 主题

将主题的 zip 文件上传到服务器。

解压到 /var/www/your_domain/wp-content/themes。

在 WordPress 后台启用主题之后，刷新页面报错：

```
There has been a critical error on this website. Please check your site admin email inbox for instructions.

Learn more about troubleshooting WordPress.
```

解决方法：将主题文件夹重命名即可。但是这样的话就没法用这个主题了，这样并不能从根本上解决问题。

参考文章：https://kinsta.com/knowledgebase/there-has-been-a-critical-error-on-your-website/。
