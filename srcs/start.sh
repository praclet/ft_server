#!/bin/sh

# Starting sevices
service mysql start 
service php7.3-fpm start

# Creating databases, tables and users
mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql
mysql -u root < /tmp/wordpress.sql

# Launching nginX (so it never releases control)
nginx -g "daemon off;"
