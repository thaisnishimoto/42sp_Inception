FROM debian:oldstable

RUN apt update && \
    apt install -y php7.4 php7.4-fpm php7.4-mysql wget mariadb-client && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod 755 /var/www/html && \
    mkdir -p /run/php && \
    chown -R www-data:www-data /run/php && \
    wget -O /usr/local/bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp-cli.phar && \
    ln -s /usr/local/bin/wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh 

CMD ["/usr/local/bin/init.sh"]