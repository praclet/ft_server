#!/bin/sh

service mysql start 
service php7.3-fpm start
mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql
mysql -u root < /tmp/wordpress.sql

if [ "${AUTOINDEX}" = "off" ]
then
    cp /tmp/default /etc/nginx/sites-available/default
else
    cp /tmp/default_autoindex_on /etc/nginx/sites-available/default
fi

nginx -g "daemon off;"
