FROM debian:oldstable

RUN apt update && \
    apt install -y mariadb-server && \
    chown -R mysql:mysql /var/lib/mysql && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

COPY ./conf/my.cnf /etc/mysql/my.cnf

COPY ./tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh && \
    /usr/local/bin/init.sh

USER mysql

CMD [ "mysqld" ]