FROM debian:buster

EXPOSE 80 443

# Installations
RUN apt-get -y update					&&	\
    apt-get -y upgrade					&&	\
    apt-get -y install nginx				\
        mariadb-server wget tar vim			\
        php-curl php-gd php-mbstring		\
        php-xml php-xmlrpc php-soap			\
        php-intl php-zip php-fpm			\
		php-mysql						&&	\
	rm -rf /var/www/html/index.nginx-debian.html

# Static files copy
COPY ./srcs/default /tmp/default
COPY ./srcs/default_autoindex_on /tmp/default_autoindex_on
COPY ./srcs/wp-config.php /var/www/html/wordpress/wp-config.php
COPY ./srcs/start.sh /var/start.sh
COPY ./srcs/wordpress.sql /tmp/wordpress.sql
COPY ./srcs/index.html /var/www/html/index.html

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048									\
	-subj "/C=FR/ST=Auvergne-Rhône-Alpes/L=Lyon"	\
	-keyout ./etc/ssl/localhost.key -out ./etc/ssl/localhost.crt


# MySQL initialisation
RUN service mysql start					&&	\
    echo -e "root\nn\ny\ny\ny\n" | mysql_secure_installation

# Wordpress installation
RUN mkdir -p /var/www/html						&&	\
    cd /var/www/html							&&	\
    wget https://wordpress.org/latest.tar.gz	&&	\
    tar -xvf latest.tar.gz						&&	\
    rm -rf html latest.tar.gz

# PhpMyAdmin installation
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.tar.gz	&&	\
	tar -xvf phpMyAdmin-5.1.0-all-languages.tar.gz					&&	\
	rm phpMyAdmin-5.1.0-all-languages.tar.gz						&&	\
	mv phpMyAdmin-5.1.0-all-languages/ /var/www/html/phpmyadmin/	&&	\
	mkdir -p /var/lib/phpmyadmin/tmp								&&	\
	chown -R www-data:www-data /var/lib/phpmyadmin					&&  \
    chown -R www-data:www-data /var/www/html

ENV AUTOINDEX="off"

CMD ["/var/start.sh"]
