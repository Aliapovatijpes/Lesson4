FROM debian:bullseye

RUN apt-get update &&\
 apt-get install -y gnupg wget lsb-release procps
 
RUN export DEBIAN_FRONTEND=noninteractive &&\
 wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb &&\
 dpkg -i mysql-apt-config_0.8.22-1_all.deb &&\
 apt update &&\
 apt install -y mysql-server &&\
 rm mysql-apt-config_0.8.22-1_all.deb


ARG GITTOKEN=none
ARG MYSQLUSERNAME=intern
ARG MYSQLUSERPASS=onix
ARG ROOTPASS=rootpass
ARG USERNAMEIP=%

ENV MYSQLUSERNAME=$MYSQLUSERNAME
ENV MYSQLUSERPASS=$MYSQLUSERPASS
ENV ROOTPASS=$ROOTPASS
ENV USERNAMEIP=$USERNAMEIP

#COPY entrypointmysql.sh /usr/local/bin/
#COPY devops.sql /

RUN apt-get install -y git 
RUN git clone https://Aliapovatijpes:$GITTOKEN@github.com/Aliapovatijpes/Lesson4.git &&\
    cp /Lesson4/mysql/* / &&\
	rm -r -f /Lesson4/ &&\
	chmod +x /entrypointmysql.sh &&\
	cp entrypointmysql.sh /usr/local/bin/
	
ENTRYPOINT ["entrypointmysql.sh"]