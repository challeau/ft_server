FROM debian:buster

ENV AUTOINDEX on

RUN apt-get update -y > /dev/null && apt-get upgrade -y
RUN apt-get install -y wget nginx mariadb-server apt-utils > /dev/null \
; apt-get install -y php php-mysql php-fpm php-pdo php-gd php-cli php-mbstring > /dev/null \
; apt-get update -y > /dev/null && apt-get upgrade -y  > /dev/null

COPY ./srcs/index_setup.sh .
COPY /srcs/my_nginx.conf /etc/nginx/sites-available/localhost
COPY ./srcs/wp-config.php ./tmp/wp-config.php
RUN ln -s /etc/nginx/sites-available/localhost /etc/nginx/sites-enabled/localhost


WORKDIR /var/www/html/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz \
> /dev/null \
; tar -xf phpMyAdmin-5.0.1-english.tar.gz > /dev/null \
; rm -rf phpMyAdmin-5.0.1-english.tar.gz \
; mv phpMyAdmin-5.0.1-english phpmyadmin
COPY /srcs/config.inc.php phpmyadmin
RUN chown -R www-data:www-data * ; chmod -R 755 /var/www/*
 
WORKDIR /tmp/
RUN wget https://wordpress.org/latest.tar.gz > /dev/null \
; tar -xf latest.tar.gz > /dev/null \
; rm -rf latest.tar.gz && mv wordpress /var/www/html/
COPY /srcs/my_nginx.conf .
COPY /srcs/my_nginx_no_aid.conf .

RUN openssl req -x509 -nodes -days 365 \
-subj "/C=FR/ST=IDF/L=Paris/O=42 Paris/OU=student" \
-newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

WORKDIR /
COPY	./srcs/setup.sh .
COPY	./srcs/wp-config.php /var/www/html

EXPOSE 80 443
CMD sh setup.sh