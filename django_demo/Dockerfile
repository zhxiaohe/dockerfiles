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
RUN apt-get install vim curl wget python2.7 python-dev iproute2 util-linux git iputils-ping lsof tree -y
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python2.7
ADD requirements.txt /opt/requirements.txt
RUN pip install -r /opt/requirements.txt
RUN mkdir /opt/demo
VOLUME /opt/demo
ENV DEMO inside

# clean apt
RUN rm -rf /var/lib/apt/lists/*

# set timezone
RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo 'Asia/Shanghai' >/etc/timezone

# set port
EXPOSE 8080

# start service command
ADD run.sh /run.sh
RUN chmod 755 /run.sh
CMD ["/run.sh"]