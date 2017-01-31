### 下载基础镜像
```bash
$docker pull ubuntu:latest

# 查看镜像
$docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              latest              f49eec89601e        10 days ago         129 MB
```
### 构建Django镜像
```bash
# 进入目录
$cd django_demo/

# 当前目录下的内容
$tree . -L 1
.
├── Dockerfile
├── README.md
├── demo
├── requirements.txt
└── run.sh

1 directory, 4 files

# 开始构建镜像
$docker build -t nick/django_demo:0.1 .  #-t表示镜像名(格式为  用户名/镜像名:tag)，   . 表示当前目录
……省略……
Successfully built a7d6ba421436

# 查看镜像
$docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nick/django_demo         0.1              a7d6ba421436        44 seconds ago      447 MB
ubuntu              latest              f49eec89601e        10 days ago         129 MB

# 查看镜像的详细信息
$docker inspect nick/django_demo:0.1
```

### 启动容器
```bash
$docker run -d --name django_demo -P nick/django_demo:0.1 #run表示运行，-d表示后台运行, --name django_demo表示指定容器名称为django_demo, -P 表示端口映射,  nick/django_demo:0.1 是镜像名称

# 查看容器
$docker ps -a
CONTAINER ID        IMAGE                  COMMAND             CREATED             STATUS              PORTS                     NAMES
90de47c17758        nick/django_demo:0.1   "/run.sh"           9 seconds ago       Up 8 seconds        0.0.0.0:32768->8080/tcp   django_demo  #注意端口映射

# 查看容器启动日志
$docker logs -f django_demo  # 指定容器名称，查看启动日志
=> /opt/demo 目录下为空, 将创建一个新的项目 demo
=> demo 项目创建完毕, 启动demo项目, 用浏览器访问 http://127.0.0.1:8080

# 使用Ctrl + C 可中断日志的输出
```

> 现在可以在浏览器通过 http://127.0.0.1:32768 (docker ps -a可以看到具体映射到哪个端口)访问容器内部的8080端口了

### 将外部的程序挂载进容器，并启动
```bash
# 启动容器
$docker run -d --name django_demo -v /Users/nick/mycode/dockerfiles/django_demo/demo:/opt/demo -e DEMO=outside -P nick/django_demo:0.1
解释： run -d 表示后台运行容器, --name django_demo表示指定容器名称为django_demo(注意要避免名字冲突), -v xxx:zzz 表示将本地目录xxx挂载到容器内部的zzz目录
      -e xxx=zzz 表示指定环境变量xxx的值为zzz, -P 表示端口映射, 最后的nick/django_demo:0.1 表示镜像名称

# 查看容器
$docker ps -a
CONTAINER ID        IMAGE                  COMMAND             CREATED             STATUS              PORTS                     NAMES
8bf7eeafe412        nick/django_demo:0.1   "/run.sh"           3 minutes ago       Up 3 minutes        0.0.0.0:32769->8080/tcp   django_demo

# 查看容器启动日志
$docker logs -f django_demo
=> /opt/demo 目录下已经存在项目, 将启动已存在的项目, 用浏览器访问 http://127.0.0.1:8080
Not Found: /
[31/Jan/2017 18:10:56] "GET / HTTP/1.1" 404 1900
Not Found: /favicon.ico
[31/Jan/2017 18:10:56] "GET /favicon.ico HTTP/1.1" 404 1933
[31/Jan/2017 18:11:00] "GET /api HTTP/1.1" 301 0
[31/Jan/2017 18:11:00] "GET /api/ HTTP/1.1" 200 51

# 使用Ctrl + C 可中断日志的输出
```
> 现在可以在浏览器通过 http://127.0.0.1:32769 (docker ps -a可以看到具体映射到哪个端口)访问容器内部的8080端口了

### 删除容器
```bash
# 删除已经退出的容器
$docker rm django_demo

# 强制删除正在运行的容器
$docker rm -f django_demo
```

### 删除镜像
```bash
$docker rmi nick/django_demo:0.1
```
