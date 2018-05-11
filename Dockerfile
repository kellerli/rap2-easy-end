FROM sayhub/node:8.9.3

ENV \
MYSQL_MAJOR="5.7" \
MYSQL_VERSION="5.7.21"

ARG MYSQL_RPM_URL="https://nexus.sayhub.cn/repository/mysql/mysql-${MYSQL_MAJOR}-community/docker/x86_64/mysql-community-server-minimal-${MYSQL_VERSION}-1.el7.x86_64.rpm"

RUN set -e \

&& groupadd --gid 50 --system nginx \
&& useradd nginx --uid 1001 --gid 50 --base-dir /home/nginx --home-dir /home/nginx \
--shell /bin/bash --groups nginx --system --create-home --no-user-group --no-log-init \

&& groupadd --gid 1002 --system mysql \
&& useradd mysql --uid 1002 --gid 1002 --base-dir /home/mysql --home-dir /home/mysql \
--shell /bin/bash --groups mysql --system --create-home --no-user-group --no-log-init \

&& groupadd --gid 1003 --system redis \
&& useradd redis --uid 1003 --gid 1003 --base-dir /home/redis --home-dir /home/redis \
--shell /bin/bash --groups redis --system --create-home --no-user-group --no-log-init \

&& yum -y --noplugins --nogpgcheck install \
libaio \
numactl-libs \
redis \
nginx \

&& curl -k -L -N -o /tmp/mysql.rpm ${MYSQL_RPM_URL} \

&& yum -y --noplugins --nogpgcheck localinstall \
/tmp/mysql.rpm \

&& mkdir -p /etc/mysql/ \
&& mkdir -p /var/lib/mysql/ \
&& mkdir -p /var/lib/mysql-files/ \
&& mkdir -p /var/lib/mysql-keyring/ \
&& mkdir -p /var/log/mysql/ \
&& mkdir -p /var/run/mysql/ \

&& chown -hR mysql:mysql /etc/mysql/ \
&& chown -hR mysql:mysql /var/lib/mysql/ \
&& chown -hR mysql:mysql /var/lib/mysql-files/ \
&& chown -hR mysql:mysql /var/lib/mysql-keyring/ \
&& chown -hR mysql:mysql /var/log/mysql/ \
&& chown -hR mysql:mysql /var/run/mysql/ \

&& rm -rf /etc/my.cnf \
&& rm -rf /etc/my.cnf.d/ \
&& rm -rf /var/log/mysqld.log \
&& rm -rf /var/run/mysqld/ \

&& ln -sf /dev/stderr /var/log/nginx/error.log \
&& ln -sf /dev/stdout /var/log/nginx/access.log \

&& yum -y clean all \
&& rm -rf /var/cache/ldconfig/* /var/cache/man/* /var/cache/yum/* /tmp/*

COPY --chown=root:root ./source/rap2-delos/ /opt/app/rap2-delos/

COPY --chown=mysql:mysql ./config/mysql/my.cnf /etc/my.cnf

COPY --chown=redis:redis ./config/redis/redis.conf /etc/redis.conf

COPY --chown=nginx:nginx ./config/nginx/nginx.conf /etc/nginx/nginx.conf

COPY --chown=nginx:nginx ./source/rap2-dolores/build/ /usr/share/nginx/html/

COPY --chown=root:root ./docker-entrypoint.sh /docker-entrypoint.sh

COPY --chown=root:root ./docker-cmd.sh /docker-cmd.sh

VOLUME ["/var/lib/mysql/","/var/lib/mysql-files/","/var/lib/redis/"]

EXPOSE 3306 6379 80

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/docker-cmd.sh"]
