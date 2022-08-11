FROM debian:bullseye

RUN echo "Installing Apache and PHPMyAdmin" &&\
 apt-get update &&\
 apt install -y wget nano  iputils-ping&&\
 wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz &&\
 tar xvf phpMyAdmin-*-all-languages.tar.gz &&\
 mv phpMyAdmin-*-all-languages /usr/share/phpMyAdmin &&\
 rm *gz 
RUN apt install -y apache2 apache2-utils php libapache2-mod-php \
 php-pdo php-zip php-json php-common php-fpm php-mbstring php-cli \
 php-xml php-mysql php-json php-mbstring php-xml
ARG GITTOKEN=none
ARG MYSQLUSERNAME=intern
ARG MYSQLUSERPASS=onix
ARG MYSQLIP=mysql

ENV MYSQLUSERNAME=$MYSQLUSERNAME
ENV MYSQLUSERPASS=$MYSQLUSERPASS
ENV MYSQLIP=$MYSQLIP

#COPY entrypointphpmyadmin.sh /usr/local/bin/

RUN     chmod +x ~/phpMyAdmin/entrypointphpmyadmin.sh &&\
	cp ~/phpMyAdmin/entrypointphpmyadmin.sh /usr/local/bin/

ENTRYPOINT ["entrypointphpmyadmin.sh"]

EXPOSE 80
