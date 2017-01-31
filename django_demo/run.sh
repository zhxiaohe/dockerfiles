#!/usr/bin/env bash
# 脚本用于初始化Django环境,并启动Django开发环境
export PATH=$PATH

StartProject() {
    if [[ ! -f "/opt/demo/manage.py" ]];then
        echo "=> /opt/demo 目录下为空, 将创建一个新的项目 demo "
        django-admin startproject demo /opt/demo
        mkdir /opt/demo/templates
        echo "=> demo 项目创建完毕, 启动demo项目, 用浏览器访问 http://127.0.0.1:8080"
        python /opt/demo/manage.py makemigrations
        python /opt/demo/manage.py migrate
        python /opt/demo/manage.py runserver 0.0.0.0:8080
    elif [[ -f "/opt/demo/manage.py" ]];then
        echo "=> /opt/demo 目录下已经存在项目, 将启动已存在的项目, 用浏览器访问 http://127.0.0.1:8080"
        python /opt/demo/manage.py makemigrations
        python /opt/demo/manage.py migrate
        python /opt/demo/manage.py runserver 0.0.0.0:8080
    fi
}

if [ "$DEMO" == "inside" ];then
    StartProject
elif [ "$DEMO" == "outside" ];then
    StartProject
else
    echo "环境变量 'DEMO' 必须设置为 'inside' 或者 'outside' !"
fi
