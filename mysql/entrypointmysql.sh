#!/bin/bash
set -e

###################################################################
#Starts mysqld in background and waits until it completely starts #
###################################################################
startMysqld(){
echo "MySQL server is starting."
mysqld --user=mysql &
while ! wget -q 127.0.0.1:3306; do
echo "Waiting for MySQL server start..."
 sleep 1 
done
echo "MySQL server started up succesfully."
}

############################################################
#Configure MySQL after installation                        #
############################################################
configureMySQL(){
echo "Configuring MySQL"
mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by "$ROOTPASS";
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE USER "$MYSQLUSERNAME"@"$MYSQLUSERNAMEIP" IDENTIFIED BY '$MYSQLUSERPASS';
GRANT ALL PRIVILEGES ON *.* TO "$MYSQLUSERNAME"@"$MYSQLUSERNAMEIP";
FLUSH PRIVILEGES;
EOF

mysql -u root --password="$ROOTPASS"<<EOF
CREATE USER 'pma'@'$MYSQLUSERNAMEIP' IDENTIFIED BY 'pmapassnew';
GRANT ALL PRIVILEGES ON phpmyadmin.* TO 'pma'@'$MYSQLUSERNAMEIP' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "MySQL was configured succesfully"
}
############################################################
#Load MySQL dump   if database "devops" exists             #
############################################################
loadMySQLdump(){
if `mysql -u root --password=$ROOTPASS  -e "SHOW DATABASES" | grep -q -w  devops`;
then
    echo "$RESULT database was founded"
    mysql -u root --password="$ROOTPASS" devops < devops.sql
    echo "dump file was loaded succesfully"
else
    echo "database does not exists, creating database"

   mysql -u root --password="$ROOTPASS" -e "create database if not exists devops"
   mysql -u root --password="$ROOTPASS" devops < devops.sql
   echo "dump file was loaded succesfully"
fi
}


############################################################
# Main program                                             #
############################################################

while getopts ":a:u:p:r:" option; do
   case $option in
      u) #reading MYSQLUSERNAME for MySQL user
         MYSQLUSERNAME=${OPTARG};;
      p) #reading password for MySQL user
         MYSQLUSERPASS=${OPTARG};;
      r) #reading password for MySQL root user
         ROOTPASS=${OPTARG};;
	  a) #  defining from where user can have access
          USERNAMEIP=${OPTARG};;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
 esac
done
if ! grep -q -i 'bullseye' /etc/os-release
then 
echo "This script must be run only on Debian 11 (bullseye) system"
exit 1
fi
startMysqld
#Here script checks if mysql was configure before
if `mysql -u root --password=$ROOTPASS  -e "SHOW DATABASES" | grep -q -w  devops`;
then
    echo "MySQL was configured before"
else
    echo "MySQL is not configured."
    configureMySQL
    loadMySQLdump
fi
echo "MYSQLUSERNAME is $MYSQLUSERNAME"
echo "user password is $MYSQLUSERPASS"
echo "root password is $ROOTPASS"
echo "user have permission to connect from $USERNAMEIP"
echo "MySQL connection port is 3306"
echo "IP adress of the system is $(hostname -I)"
mysqladmin --user=root --password=$ROOTPASS shutdown
exec mysqld --user=mysql