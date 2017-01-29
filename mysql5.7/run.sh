#!/bin/bash
#
# 此脚本用于配置MySQL,并且启动supervisor,由supervisor管理ssh和mysql服务
#
export PATH=$PATH:/usr/local/mysql/bin

MYSQL_DATA="/var/lib/mysql/data"
CONF_FILE="/etc/my.cnf"
LOG="/var/lib/mysql/log/error.log"

StartMySQL () {
    echo "=> 启动MySQL ..."
    mysqld_safe --defaults-file=/etc/my.cnf --user=mysql > /dev/null 2>&1 &

    # 判断是否启动
    LOOP_LIMIT=13
    for (( i=0 ; ; i++ )); do
        if [ ${i} -eq ${LOOP_LIMIT} ]; then
            echo "超时.错误日志如下:"
            tail -n 100 ${LOG}
            exit 1
        fi
        echo "=> 等待确认MySQL是否启动, ${i}/${LOOP_LIMIT} ..."
        sleep 5
        mysql -uroot -e "status" > /dev/null 2>&1 && break
    done
}

CreateMySQLUser()
{
	StartMySQL
	if [ "$MYSQL_PASS" = "**Random**" ]; then
	    unset MYSQL_PASS
	fi
	PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
	echo "=> 创建MySQL用户${MYSQL_USER}"
    mysql -uroot -e "FLUSH PRIVILEGES"
	mysql -uroot -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${PASS}'"
	mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION"
	mysql -uroot -e "FLUSH PRIVILEGES"

	echo "=> 完成!"
	echo "========================================================================"
	echo "现在可以使用如下的账户远程连接MySQL:"
	echo ""
	echo "    mysql -u${MYSQL_USER} -p${PASS} -h<host> -P<port>"
	echo ""
	echo "该账户具有超级权限,请尽快修改密码!"
	echo "========================================================================"

	mysqladmin -uroot shutdown
}

# Init MySQL
if [[ ! -d ${MYSQL_DATA}/mysql ]]; then
    echo "=> 初始化MySQL ..."
    mysqld --initialize-insecure --user=mysql --basedir=/usr/local/mysql/ --datadir=${MYSQL_DATA}
    echo "=> 完成!"
    echo "========================================================================"
	echo "MySQL初始化完成,并创建了一个空密码的超级账户:"
	echo ""
	echo "    mysql -hlocalhost -uroot"
	echo ""
	echo "该超级账户只能在本地登录,请尽快修改密码!"
	echo "========================================================================"
    echo "=> 创建${MYSQL_USER}用户 ..."
    CreateMySQLUser
else
    echo "=> 失败: ${MYSQL_DATA}已经存在数据,无法初始化"
fi

exec supervisord -c /etc/supervisord.conf