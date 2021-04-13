#!/bin/sh

bash index_setup.sh

# start services
service nginx start
/etc/init.d/mysql start
service php7.3-fpm start

# create and configure a wordpress database
# we flush privileges to reload the grant tables
echo "CREATE DATABASE wordpress;"| mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'root'@'localhost' WITH GRANT OPTION;"| mysql -u root --skip-password
echo "FLUSH PRIVILEGES;"| mysql -u root --skip-password
echo "update mysql.user set plugin='' where user='root';"| mysql -u root --skip-password

bash
