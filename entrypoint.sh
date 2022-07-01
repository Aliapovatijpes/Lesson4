#!/bin/bash
set -e

############################################################
#Configure MySQL after installation                        #
############################################################
configureMySQL(){
echo "Configuring MySQL"
echo "username is $MYSQLUSERNAME"
echo "user password is $MYSQLUSERPASS"
echo "root password is $ROOTPASS"
echo "user have permission to connect from $USERNAMEIP"
echo "IP adress of the system is $(hostname -I)"
mysql --version
#mysql -u root --password="$ROOTPASS"<<EOF
#ALTER USER 'root'@'127.0.0.1' IDENTIFIED WITH mysql_native_password by "$ROOTPASS";
#DELETE FROM mysql.user WHERE User='';
#DROP DATABASE IF EXISTS test;
#DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
#CREATE USER "$MYSQLUSERNAME"@"$USERNAMEIP" IDENTIFIED BY '$MYSQLUSERPASS';
#GRANT ALL PRIVILEGES ON *.* TO "$MYSQLUSERNAME"@"$USERNAMEIP";
#FLUSH PRIVILEGES;
#EOF
#echo "Configuring PHPMyAdmin user"
# mysql -h 127.0.0.1 -u root --password="$ROOTPASS"<<EOF
#CREATE USER 'pma'@'$USERNAMEIP' IDENTIFIED BY 'pmapassnew';
#GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'pma'@'$USERNAMEIP' WITH GRANT OPTION;
#FLUSH PRIVILEGES;
#EOF

echo "MySQL was configured succesfully"
}
############################################################
#Load MySQL dump   if database "devops" exists             #
############################################################
#loadMySQLdump(){
#if `mysql -u root --password=$ROOTPASS  -e "SHOW DATABASES" | grep -q -w  devops`;
#then
#    echo "$RESULT database was founded"
#    mysql -u root --password="$ROOTPASS" devops < devops.sql
#    echo "dump file was loaded succesfully"
#else
 #   echo "database does not exists, creating database"
#   mysql -u root --password="$ROOTPASS" -e "create database if not exists devops"
#   mysql -u root --password="$ROOTPASS" devops < devops.sql
#   echo "dump file was loaded succesfully"
#fi
#}

############################################################
# Main program                                             #
############################################################


# Set variables
#MYSQLUSERPASS=$(head -c 100 /dev/urandom | tr -dc A-Za-z0-9 | head -c6)
#MYSQLUSERNAME="username"
#USERNAMEIP="localhost"
#ROOTPASS="rootpass"


 apt-get update
configureMySQL
#loadMySQLdump
echo "username is $username"
echo "user password is $userpass"
echo "root password is $rootpass"
echo "user have permission to connect from $useraccessIP"
echo "MySQL connection port is 3306"
echo "IP adress of the system is $(hostname -I)"


exec mysqld
