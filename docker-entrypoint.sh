#!/bin/bash

set -e

MYSQL_ROOT_PASSWORD="123456"

echo -e
echo -e "init redis ..."
echo -e

# redis

mkdir -p /etc/redis/
mkdir -p /var/log/redis/
mkdir -p /var/lib/redis/
mkdir -p /var/run/redis/

chown -hR redis:redis /etc/redis.conf
chown -hR redis:redis /etc/redis/
chown -hR redis:redis /var/log/redis/
chown -hR redis:redis /var/lib/redis/
chown -hR redis:redis /var/run/redis/

echo -e
echo -e "exec redis ..."
echo -e

nohup gosu "redis" "redis-server" "/etc/redis.conf" > /var/log/redis/redis.log &

# mysql

echo -e
echo -e "init mysql ..."
echo -e

mkdir -p /etc/mysql/
mkdir -p /var/lib/mysql/
mkdir -p /var/lib/mysql-files/
mkdir -p /var/lib/mysql-keyring/
mkdir -p /var/log/mysql/
mkdir -p /var/run/mysql/

chown -hR mysql:mysql /etc/my.cnf
chown -hR mysql:mysql /etc/mysql/
chown -hR mysql:mysql /var/lib/mysql/
chown -hR mysql:mysql /var/lib/mysql-files/
chown -hR mysql:mysql /var/lib/mysql-keyring/
chown -hR mysql:mysql /var/log/mysql/
chown -hR mysql:mysql /var/run/mysql/

if test "$(ls /var/lib/mysql/ | wc -l)" == 0; then
    mysql_ssl_rsa_setup --datadir=/var/lib/mysql-files/
    chown -hR mysql:mysql /var/lib/mysql-files/
    mysqld --initialize-insecure
    chown -hR mysql:mysql /var/lib/mysql/
    if test -n "$MYSQL_ROOT_PASSWORD"; then
        mysqld &
        sleep 3
        mysql \
        --ssl-ca=/var/lib/mysql-files/ca.pem \
        --ssl-cert=/var/lib/mysql-files/client-cert.pem \
        --ssl-key=/var/lib/mysql-files/client-key.pem \
        -u root \
<<- EOSQL
    use mysql;
    update user set host='%' where user='root';
    flush privileges;
    set password for 'root'@'%'=password('$MYSQL_ROOT_PASSWORD');
    flush privileges;
    create database if not exists rap2 default charset utf8 collate utf8_general_ci;
    flush privileges;
EOSQL

        echo -e
        echo -e "exec rap2 create db ..."
        echo -e

        cd /opt/app/rap2-delos/
        npm run create-db

        echo -e
        echo -e "kill rap2 mysqld server ..."
        echo -e

        ps -e | grep mysqld | awk '{print $1}' | xargs kill -15
        sleep 3

    fi
fi

echo -e
echo -e "exec mysql ..."
echo -e

nohup gosu "mysql" "mysqld" "--defaults-file=/etc/my.cnf" > /var/log/mysql/mysql.log &

echo -e
echo -e "exec sleep 3(s) ..."
echo -e

sleep 3

echo -e
echo -e "exec delos daemon ..."
echo -e

cd /opt/app/rap2-delos/
npm run start

echo -e
echo -e "exec nginx daemon ..."
echo -e

exec gosu "root" "$@"
