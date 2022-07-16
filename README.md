# Lesson4
 This repository contains two folders with dockerfiles, which serves to make docker containers with PHPMyAdmin and MySQL services. Both containers use Debian 11 as base system. During start, containers checks if it is first start, and starts configuration, if it is first start and applications are not configred yet.
If you want to use run commands described below, you must create docker network "lamp". Example:
  docker network create lamp
  
  
## MySQL
To create a dockerimage  with mysql, you must to download Dockerfile and start docker build command in folder mysql, or specify path to Dockerfile in build command. Docker will automatically download  all necessary files from git repository. Using argument with gittoken is mandatory. Example of using : 
docker build --build-arg GITTOKEN=yourgittoken -t bek:mysql .
To create and run container with mysql, use docker run command. Example:
docker run -d --env-file ./.env --network lamp --name MysqlServer bek:mysql
This will create and run container in deattached mode, will use variables from env file, will connect container to network "lamp" and sets a MysqlServer  name to container.
## PHPMyAdmin
To create a dockerimage  with phpmyadmin, you must to download Dockerfile and start docker build command in folder phpmyadmin, or specify path to Dockerfile in build command. Docker will automatically download  all necessary files from git repository. Using argument with gittoken is mandatory. Example of using : 
docker build -t --build-arg GITTOKEN=yourgittoken bek:phpmyadmin .
To create and run container with phpmyadmin, use docker run command. Example:
docker run -d --env-file ./.env --network lamp -p 80:80 --name PHPMyAdmin bek:phpmyadmin
This will create and run container in deattached mode, will use variables from env file, will connect container, with opened port 80, to network "lamp" and sets a PHPMyAdmin  name to container.
