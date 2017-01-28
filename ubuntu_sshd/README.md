### 准备ubuntu基础镜像
```
$docker pull ubuntu:latest
```

### 准备SSH登录用的公钥
```
$cp ~/.ssh/id_rsa.pub ./authorized_keys
```

### 构建镜像
```
# 当前目录下的内容
$tree .
.
├── Dockerfile
├── README.md
└── authorized_keys

# 开始构建
$docker build -t nick/ubuntu_sshd . # 最后有一个 . 表示当前目录，nick/ubuntu_sshd 表示 用户名/镜像名

# 查看构建好的容器
$docker images
或者
$docker image ls

# 查看镜像的详细信息
$docker inspect nick/ubuntu_sshd
```

### 启动容器
```
$docker run -d -p 62522:22 -h ssh_host --name ssh_container nick/ubuntu_sshd #后台启动 -d，端口映射 -p, 指定主机名 -h,给容器起名字 --name xxx

$docker ps -a #查看
```

### 进入容器
```
# 使用ssh连接进入
$ssh root@localhost -p 62522

# 使用docker 自带的工具进入容器内部
$docker exec -ti ssh_container /bin/bash
```

### 补充

#### 如何删除容器
```
$docker rmi nick/ubuntu_sshd
```

#### 如何删除镜像
```
$docker rmi nick/ubuntu_sshd
```
