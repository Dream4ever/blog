---
slug: install-wordpress-on-ubuntu-2404
title: 在 Ubuntu 24.04 上安装配置 WordPress
authors: HeWei
tags: [WordPress,Ubuntu,PHP,MySQL]
---

## 配置 ECS

系统选择 Ubuntu 24.04，密码则在实例管理控制台页面，通过重置密码方式进行设置。

## 更新已有软件包

```bash
# 更新软件包列表
sudo apt update

# 升级所有软件包
sudo apt upgrade
```

## 安装 Nginx 并设置为开机启动

```bash
# 安装 Nginx
sudo apt install nginx

# 启动 Nginx
sudo systemctl start nginx

# 设置 Nginx 开机启动
sudo systemctl enable nginx

# 查看 Nginx 状态
sudo systemctl status nginx
```

## 配置 UFW 并设置为开机启动

```bash
# 查看 UFW 应用列表
sudo ufw app list

# 允许 Nginx HTTP 访问
sudo ufw allow 'Nginx HTTP'

# 允许 OpenSSH 访问
sudo ufw allow 'OpenSSH'

# 启用 UFW
sudo ufw enable

# 查看 UFW 状态
sudo ufw status

# 查看公网 IP
curl -4 icanhazip.com
```

## 安装 MySQL 并设置为开机启动

```bash
# 安装 MySQL
sudo apt install mysql-server -y

# 启动 MySQL
sudo systemctl start mysql

# 设置 MySQL 开机启动
sudo systemctl enable mysql

# 查看 MySQL 状态
sudo systemctl status mysql
```

## 加强 MySQL 安全设置

```bash
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
```

## 安装 PHP 及相关依赖并设置为开机启动

```bash
# 安装 PHP 和 PHP-FPM
sudo apt install php php-fpm -y

# 安装 MySQL 及 WordPress 和 MOK 主题所需扩展
sudo apt install php-mysql php-cli php-xml -y

# 查看 PHP 版本
php -v

# 启动 PHP-FPM，PHP 版本基于前面查看的版本
sudo systemctl start php8.3-fpm

# 设置 PHP-FPM 开机启动，PHP 版本基于前面查看的版本
sudo systemctl enable php8.3-fpm

# 查看 PHP-FPM 状态，PHP 版本基于前面查看的版本
sudo systemctl status php8.3-fpm
```

## 配置 PHP-FPM

```bash
# 查看 PHP-FPM 进程
ss -pl | grep php

# 进入 PHP-FPM 配置目录
cd /etc/php/8.3/fpm/pool.d/

# 查看配置
cat www.conf
# 验证 PHP-FPM pool 名称为 www
[www]
# 验证 user 和 group 为 www-data
user = www-data
group = www-data
```

## 配置 Nginx

```bash
# 创建 Nginx 配置文件
# 这里只配置了 80 端口的 HTTP 请求
# 是因为用了 Cloudflare 的域名，Cloudflare 会自动配置好 HTTPS，所以服务端无需额外配置
sudo nano /etc/nginx/sites-available/your.domain
```

```nginx
server {
    listen 80;
    server_name your.domain www.your.domain;
    root /var/www/your.domain;

    index index.html index.htm index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
     }

    location ~ /\.ht {
        deny all;
    }

}
```

```bash
# 创建配置文件的软链接
sudo ln -s /etc/nginx/sites-available/your.domain /etc/nginx/sites-enabled/

# 删除默认配置文件的软链接
sudo unlink /etc/nginx/sites-enabled/default

# 测试配置文件
sudo nginx -t

# 重新加载 Nginx
sudo systemctl reload nginx

# 创建网站文件夹
sudo mkdir /var/www/your.domain

# 创建测试文件
sudo nano /var/www/your.domain/index.html
```

```html
<html>
  <head>
    <title>your.domain website</title>
  </head>
  <body>
    <h1>Hello World!</h1>

    <p>This is the landing page of <strong>your.domain</strong>.</p>
  </body>
</html>
```

访问 http://www.your.domain，如果看到页面，说明 Nginx 配置成功，删除刚才创建的测试文件。

## 测试 PHP 解析

```bash
sudo nano /var/www/your.domain/info.php
```

```php
<?php
phpinfo();
```

访问 http://www.your.domain/info.php，如果看到页面，说明 PHP 解析成功。

```bash
# 删除测试文件
sudo rm /var/www/your.domain/info.php
```

## 测试 PHP 连接 MySQL

```bash
sudo mysql
```

```sql
CREATE DATABASE example_database;

CREATE USER 'example_user'@'%' IDENTIFIED WITH mysql_native_password BY 'ABcd1234!@#$';

GRANT ALL ON example_database.* TO 'example_user'@'%';

exit
```

```bash
mysql -u example_user -p
```

```sql
SHOW DATABASES;

CREATE TABLE example_database.todo_list (
	item_id INT AUTO_INCREMENT,
	content VARCHAR(255),
	PRIMARY KEY(item_id)
);

INSERT INTO example_database.todo_list (content) VALUES ("My first important item");

SELECT * FROM example_database.todo_list;

exit
```

```bash
sudo nano /var/www/your.domain/todo_list.php
```

```php
<?php
$user = "example_user";
$password = "ABcd1234!@#$";
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

访问 http://www.your.domain/todo_list.php，如果看到页面，说明 PHP 连接 MySQL 成功。

然后删除测试数据库和用户：

```sql
DROP DATABASE example_database;

DROP USER 'example_user'@'%';

FLUSH PRIVILEGES;

exit
```

```bash
# 删除测试文件
sudo rm /var/www/your.domain/todo_list.php
```

## 安装配置 WordPress

先在 MySQL 中创建数据库和用户。

```bash
sudo mysql
```

```sql
# 多语言需要创建两个数据库
CREATE DATABASE wordpress;
CREATE DATABASE wordpress_en;

CREATE USER 'wordpress_admin'@'%' IDENTIFIED WITH mysql_native_password BY '****';

# 用同一个 DB ADMIN 账户管理两个数据库
GRANT ALL ON wordpress.* TO 'wordpress_admin'@'%';
GRANT ALL ON wordpress_en.* TO 'wordpress_admin'@'%';

exit
```

```bash
# 安装 unzip，用于解压 WordPress 和 MOK 主题的压缩包
sudo apt install unzip
```

将 WordPress 压缩包上传到服务器的 `~` 目录下，因为如果尝试直接上传到 `/var/www/your.domain` 目录下，会因为权限不够导致上传失败。

```bash
scp -i C:\Users\${Username}\.ssh\key.pem .\wordpress.zip ecs-user@1.2.3.4:~/
```

然后再用 `sudo mv wordpress.zip /var/www/your.domain` 命令将 WordPress 安装包移动到网站目录下。

执行 `cd /var/www/your.domain && sudo unzip wordpress.zip`，将 WordPress 文件解压。

注意，要确保解压后的文件和文件夹直接位于 `/var/www/your.domain` 目录下，而不是 `/var/www/your.domain/wordpress` 子目录下。

将 `wp-config-sample.php` 复制为 `wp-config.php` 以便修改。

执行 `sudo vi /var/www/your.domain/wp-config.php`，修改数据库连接信息。

访问 `http://www.your.domain/wp-admin/install.php`，按照提示完成安装。

### 配置 HTTPS

如果在输入密码的地方显示报错信息 `password strength is unknown`，有可能是在用 https 协议访问。可以在 wp-config.php 中添加一行：

```php
$_SERVER['HTTPS'] = true;
```

> 搜索 `Password strength unknown`，在 https://wordpress.stackexchange.com/a/350453 中找到的这个解决方法。

### 配置管理后台访问权限

如果输入账号和密码登录后，显示报错信息 `Sorry, you are not allowed to access this page.`, 则需要在 `/var/www/your.domain/wp-config.php` 中添加以下两行：

```php
define( 'WP_HOME', 'https://www.your.domain' );
define( 'WP_SITEURL', 'https://www.your.domain' );
```

对于英文版网站，上面的两个 URL 需要增加 `/en` 子路径。

参考资料：https://developer.wordpress.org/advanced-administration/before-install/howto-install/

完成以上操作之后，将 `/var/www/your.domain` 目录下的所有文件复制到 `/var/www/your.domain/en` 目录下，并修改 `/var/www/your.domain/en/wp-config.php` 中的网站信息：

```php
define( 'WP_HOME', 'https://www.your.domain/en' );
define( 'WP_SITEURL', 'https://www.your.domain/en' );
```
### 配置上传文件夹权限


```bash
sudo chown -R www-data:www-data /var/www/your.domain/wp-content/uploads
sudo chown -R www-data:www-data /var/www/your.domain/en/wp-content/uploads
```

## 放宽上传文件体积限制

WordPress 本身基于 PHP，PHP 默认会限制上传文件的体积。而网站通过 Nginx 提供服务，Nginx 也会限制上传文件的体积。所以在这两处都需要进行修改。

Nginx 修改 `/etc/nginx/nginx.conf` 文件中的 `http` 块，将 `client_max_body_size` 参数改为 `1024m` 之类的值，然后执行 `sudo systemctl restart nginx`，重启 Nginx，使修改生效。

PHP 修改 `/etc/php/8.3/fpm/php.ini`，将 `upload_max_filesize` 和 `post_max_size` 的值都改为 `1024M`，然后执行 `sudo systemctl restart php8.3-fpm`，重启 PHP，使修改生效。

## 导出/导入数据库

```bash
# 导出数据库
sudo mysqldump -u wordpress_admin -p --databases wordpress > ~/wordpress.sql

# 导入数据库
sudo mysql -u wordpress_admin -p < ~/wordpress.sql
```

## 相关资料

整体流程参考以下几个链接：

-How to Install Nginx, MySQL, PHP (LEMP Stack) on Ubuntu 24.04
- https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-ubuntu。
