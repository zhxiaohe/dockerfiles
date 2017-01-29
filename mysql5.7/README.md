### 下载MySQL-5.7
```
$wget -c http://mirrors.sohu.com/mysql/MySQL-5.7/mysql-5.7.17-linux-glibc2.5-x86_64.tar.gz -O mysql-5.7.tar.gz
```
> 注意：一定要是mysql-5.7.tar.gz

### 准备SSH登录用的公钥
```bash
$cp ~/.ssh/id_rsa.pub ./authorized_keys
```

### 构建mysql镜像
```bash
# 当前目录下的内容
$tree ./
./
├── Dockerfile
├── README.md
├── authorized_keys
├── my.cnf
├── mysql-5.7.tar.gz
├── run.sh
└── supervisord.conf

# 开始构建
$docker build -t nick/mysql:5.7.17 .

# 查看构建好的容器
$docker images
或者
$docker image ls

# 查看镜像的详细信息
$docker inspect nick/mysql:5.7.17
```

### 启动容器
```bash
$docker run -d --name mysql -h db -P nick/mysql:5.7.17  # -d表示后台运行,--name表示容器名,-h表示容器主机名,-P表示端口映射

# 查看容器
$docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                            NAMES
fa0e585191de        nick/mysql:5.7.17   "/run.sh"           5 seconds ago       Up 4 seconds        0.0.0.0:32771->22/tcp, 0.0.0.0:32770->3306/tcp   mysql


# 查看容器启动日志
$docker logs mysql
=> 初始化MySQL ...
=> 完成!
========================================================================
MySQL初始化完成,并创建了一个空密码的超级账户:

    mysql -hlocalhost -uroot

该超级账户只能在本地登录,请尽快修改密码!
========================================================================
=> 创建root用户 ...
=> 启动MySQL ...
=> 等待确认MySQL是否启动, 0/13 ...
=> 创建MySQL用户root
=> 完成!
========================================================================
现在可以使用如下的账户远程连接MySQL:

    mysql -uroot -p7J9hnOmA8p8I -h<host> -P<port>

该账户具有超级权限,请尽快修改密码!
========================================================================
2017-01-29 18:07:49,959 CRIT Supervisor running as root (no user in config file)
2017-01-29 18:07:49,962 INFO supervisord started with pid 1
2017-01-29 18:07:50,969 INFO spawned: 'sshd' with pid 1048
2017-01-29 18:07:50,971 INFO spawned: 'mysqld' with pid 1049
2017-01-29 18:07:56,478 INFO success: sshd entered RUNNING state, process has stayed up for > than 5 seconds (startsecs)
2017-01-29 18:07:56,479 INFO success: mysqld entered RUNNING state, process has stayed up for > than 5 seconds (startsecs)


# 连接MySQL
$mycli -P32770 -uroot -p7J9hnOmA8p8I
Version: 1.8.1
Chat: https://gitter.im/dbcli/mycli
Mail: https://groups.google.com/forum/#!forum/mycli-users
Home: http://mycli.net
Thanks to the contributor - Sudaraka Wijesinghe
mysql root@localhost:(none)> select version();
+-------------+
| version()   |
|-------------|
| 5.7.17-log  |
+-------------+
1 row in set
Time: 0.001s
mysql root@localhost:(none)>


# 连接SSH
$ssh root@localhost -p32771
The authenticity of host '[localhost]:32771 ([::1]:32771)' can't be established.
ECDSA key fingerprint is SHA256:jYsI/LSuTVWxj9xOviAf70pzUjyI/gknXIPXFO5p4CQ.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[localhost]:32771' (ECDSA) to the list of known hosts.

[root@db ~]# /usr/local/mysql/bin/mysql -hlocalhost -uroot
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 5
Server version: 5.7.17-log MySQL Community Server (GPL)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

### 启动容器并指定用户名和密码
```bash
$docker run -d --name mysql1 -h db1 -P -e MYSQL_USER="admin" -e MYSQL_PASS="admin123" nick/mysql:5.7.17  #-e表示指定环境变量

$docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                            NAMES
1332e782f033        nick/mysql:5.7.17   "/run.sh"           4 seconds ago       Up 3 seconds        0.0.0.0:32773->22/tcp, 0.0.0.0:32772->3306/tcp   mysql1
fa0e585191de        nick/mysql:5.7.17   "/run.sh"           16 minutes ago      Up 16 minutes       0.0.0.0:32771->22/tcp, 0.0.0.0:32770->3306/tcp   mysql

$mycli -P32772 -uadmin -padmin123
Version: 1.8.1
Chat: https://gitter.im/dbcli/mycli
Mail: https://groups.google.com/forum/#!forum/mycli-users
Home: http://mycli.net
Thanks to the contributor - Anonymous
mysql admin@localhost:(none)> exit
Goodbye!
```

### 启动容器并且挂载本地目录到容器中
```bash
$docker run -d --name mysql2 -P -v /opt/supervisor:/var/log/supervisor -v /opt/mysql/data:/var/lib/mysql/data nick/mysql:5.7.17 #宿主机目录不需要创建,会自动生成
```
