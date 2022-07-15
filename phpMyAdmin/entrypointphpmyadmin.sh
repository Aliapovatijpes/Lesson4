#!/bin/bash
set -e

############################################################
# Apache server, PHP and PHP MyAdmin do configuration      #
############################################################
ApacheAndPHPMyAdminConfig(){
echo "Configuring Apache and PHPMyAdmin"
PHPMyAdminPort=80
 cp -pr /usr/share/phpMyAdmin/config.sample.inc.php /usr/share/phpMyAdmin/config.inc.php
blowfish_pass=$(head -c 300 /dev/urandom | tr -dc A-Za-z0-9=+*/.,- | head -c32)
OLD_BLOW_FISH_CONF="\['blowfish_secret'\] = '';"
NEW_BLOW_FISH_CONF="\['blowfish_secret'\] = '$blowfish_pass';"
sed -i "s|$OLD_BLOW_FISH_CONF|$NEW_BLOW_FISH_CONF|g" /usr/share/phpMyAdmin/config.inc.php
sed -i "s|\['host'\] = 'localhost'|\['host'\] = '$MYSQLIP'|g" /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['Servers'] = '$MYSQLIP'; " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['controlhost'] = '$MYSQLIP'; " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['controluser'] = 'pma'; " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['controlpass'] = 'pmapassnew';  " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['pmadb'] = 'null';  " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['bookmarktable'] = 'pma__bookmark';  " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['relation'] = 'pma__relation'; " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['table_info'] = 'pma__table_info';  " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['table_coords'] = 'pma__table_coords';  " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['pdf_pages'] = 'pma__pdf_pages';  " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['column_info'] = 'pma__column_info'; " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['history'] = 'pma__history'; " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['table_uiprefs'] = 'pma__table_uiprefs';  " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['tracking'] = 'pma__tracking';  " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['userconfig'] = 'pma__userconfig';  " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['recent'] = 'pma__recent'; " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['favorite'] = 'pma__favorite';  " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['users'] = 'pma__users';   " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['usergroups'] = 'pma__usergroups';   " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['navigationhiding'] = 'pma__navigationhiding';   " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['savedsearches'] = 'pma__savedsearches';   " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['central_columns'] = 'pma__central_columns';   " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['designer_settings'] = 'pma__designer_settings';   " /usr/share/phpMyAdmin/config.inc.php
sed -i "$ a \ \n \$cfg['Servers'][\$i]['export_templates'] = 'pma__export_templates'; " /usr/share/phpMyAdmin/config.inc.php

touch /etc/apache2/sites-available/phpmyadmin.conf

PHP_MY_ADMIN_CONF_CONTENT=$(
  cat <<-END
<VirtualHost *:$PHPMyAdminPort>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

Alias /phpmyadmin /usr/share/phpMyAdmin

<Directory /usr/share/phpMyAdmin/>
   AddDefaultCharset UTF-8

   <IfModule mod_authz_core.c>
     # Apache 2.4
     <RequireAny> 
      Require all granted
     </RequireAny>
   </IfModule>
   <IfModule !mod_authz_core.c>
     # Apache 2.2
     Order Deny,Allow
     Deny from All
     Allow from 127.0.0.1
     Allow from ::1
   </IfModule>
</Directory>

<Directory /usr/share/phpMyAdmin/setup/>
   <IfModule mod_authz_core.c>
     # Apache 2.4
     <RequireAny>
       Require all granted
     </RequireAny>
   </IfModule>
   <IfModule !mod_authz_core.c>
     # Apache 2.2
     Order Deny,Allow
     Deny from All
     Allow from 127.0.0.1
     Allow from ::1
   </IfModule>
</Directory>
END
)
echo "$PHP_MY_ADMIN_CONF_CONTENT" |  tee -a /etc/apache2/sites-available/phpmyadmin.conf >/dev/null
 a2ensite phpmyadmin
 mkdir /usr/share/phpMyAdmin/tmp
 chmod 777 /usr/share/phpMyAdmin/tmp
 chown -R www-data:www-data /usr/share/phpMyAdmin
 echo "ServerName PHPMyAdmin" >> /etc/apache2/apache2.conf
 apachectl configtest
echo "Apache, PHP and PHPMyAdmin was installed succesfully"
PHPMyAdminPort=$(grep -w "VirtualHost" /etc/apache2/sites-available/phpmyadmin.conf | grep -o '[[:digit:]]*')
echo "PHPMyAdmin connection port is $PHPMyAdminPort"
}


############################################################
# Main program                                             #
############################################################


while getopts ":u:p:m:" option; do
   case $option in
      u) #reading MYSQLUSERNAME for MySQL user
         MYSQLUSERNAME=${OPTARG};;
      p) #reading password for MySQL user
         MYSQLUSERPASS=${OPTARG};;
      m) #defines IP adress of mysql database
         MYSQLIP=${OPTARG};;  
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
#Here script checks if PHPMyAdmin was configure before
if [ ! -d "/usr/share/phpMyAdmin/tmp" ]
then
ApacheAndPHPMyAdminConfig
fi
echo "MYSQLUSERNAME is $MYSQLUSERNAME"
echo "user password is $MYSQLUSERPASS"
echo "Trying to connect database on IP $MYSQLIP"
echo "IP adress of the system is $(hostname -I)"
exec apache2ctl -D FOREGROUND