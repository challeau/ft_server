#! bin/bash

# loads nginx configuration files according to the value of AUTOINDEX.
# reloads nginx if necessary.

if [ "$AUTOINDEX" = "off" ] ; then
  cp /tmp/my_nginx_no_aid.conf /etc/nginx/sites-available/localhost
else
    cp /tmp/my_nginx.conf /etc/nginx/sites-available/localhost
fi

if [ -e /var/run/nginx.pid ] ; then service nginx reload ; fi
