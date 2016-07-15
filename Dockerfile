FROM ubuntu

RUN apt-get update && apt-get -y upgrade && apt-get -y install apache2 php7.0 php7.0-mysql libapache2-mod-php7.0 curl lynx-cur php-xml acl

RUN export DEBIAN_FRONTEND=noninteractive && apt-get -y install mysql-server

ADD congeapp.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod php7.0
RUN a2enmod rewrite

EXPOSE 80
EXPOSE 443

ADD . /var/www/html

WORKDIR /var/www/html

CMD chmod 777 -R app/cache
CMD chmod 777 -R app/logs

CMD setfacl -R -m u:www-data:rwX -m u:`whoami`:rwX app/cache app/logs
CMD setfacl -dR -m u:www-data:rwx -m u:`whoami`:rwx app/cache app/logs

RUN service mysql start
RUN php app/console doctrine:database:create

CMD /usr/sbin/apache2ctl -D FOREGROUND
