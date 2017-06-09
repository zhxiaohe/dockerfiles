### 下载Redis-3.2
```
$ wget http://download.redis.io/releases/redis-3.2.9.tar.gz -O redis.tar.gz
```
> 注意：一定要是redis.tar.gz

### 准备SSH登录用的公钥
```bash
$ cp ~/.ssh/id_rsa.pub ./authorized_keys
```

### 构建redis镜像
```bash
# 当前目录下的内容
$ tree ./
./
├── Dockerfile
├── README.md
├── authorized_keys
├── redis.conf
├── redis.tar.gz
├── run.sh
├── sentinel.conf
└── supervisord.conf

0 directories, 8 files

# 开始构建
$ docker build -t nick/redis:3.2 .

# 查看构建好的容器
$ docker images
或者
$ docker image ls

# 查看镜像的详细信息
$docker inspect nick/redis:3.2
```

### 启动容器
```bash
$ docker run -d --name redis -h redis-master -P nick/redis:3.2 # -d表示后台运行,--name表示容器名,-h表示容器主机名,-P表示端口映射

# 查看容器
$ docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                            NAMES
392d37cbd94e        nick/redis:3.2      "/run.sh"           30 seconds ago      Up 32 seconds       0.0.0.0:32771->22/tcp, 0.0.0.0:32770->6379/tcp   redis


# 查看容器启动日志
$ docker logs redis
2017-06-09 15:25:11,089 CRIT Supervisor running as root (no user in config file)
2017-06-09 15:25:11,091 INFO supervisord started with pid 1
2017-06-09 15:25:12,096 INFO spawned: 'sshd' with pid 9
2017-06-09 15:25:12,098 INFO spawned: 'redis' with pid 10
2017-06-09 15:25:17,119 INFO success: sshd entered RUNNING state, process has stayed up for > than 5 seconds (startsecs)
2017-06-09 15:25:17,119 INFO success: redis entered RUNNING state, process has stayed up for > than 5 seconds (startsecs)

# 连接Redis
$ redis-cli -p 32770


# 连接SSH
$ ssh root@127.0.0.1 -p 32771
The authenticity of host '[127.0.0.1]:32771 ([127.0.0.1]:32771)' can't be established.
ECDSA key fingerprint is SHA256:klp+JF+LQzbz1AyajKT+SKWJjB9a6lQ/Wc4FHOEyt4Y.
Are you sure you want to continue connecting (yes/no)? yes
……省略……
```
