#!/bin/sh

# Starting sevices
service mysql start 
service php7.3-fpm start

# Creating databases, tables and users
mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql
mysql -u root < /tmp/wordpress.sql

# Autoindex management 
if [ "${AUTOINDEX}" = "on" ]
then
	sed -ie "s/autoindex off;/autoindex on;/" /etc/nginx/sites-available/default;
fi

# Launching nginX (so it never releases control)
nginx -g "daemon off;"
