FROM ubuntu:latest

MAINTAINER from ibash.cc by Nick

# ubunut 16.04
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse" > /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse" >> /etc/apt/sources.list
RUN apt-get update

# install basic software
RUN apt-get install vim dmidecode curl wget python2.7 python-dev iproute2 util-linux pciutils sysstat git iputils-ping telnet strace ltrace lsof openssl libssl-dev libpcre3 libpcre3-dev zlib1g-dev tree -y
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python2.7

# install ssh daemon
RUN apt-get install -y openssh-server openssh-client
RUN mkdir -p /var/run/sshd
RUN mkdir -p /root/.ssh
RUN sed -ri 's/session    required     pam_loginuid.so/#session    required     pam_loginuid.so/g' /etc/pam.d/sshd

# copy publish key & chmod execute permission
ADD authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys
RUN echo "#!/usr/bin/env bash" > /run.sh
RUN echo "/usr/sbin/sshd -D" >> /run.sh
RUN chmod 755 /run.sh

# clean apt
RUN rm -rf /var/lib/apt/lists/*

# set timezone
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

# set port
EXPOSE 22

# start service command
CMD ["/run.sh"]
