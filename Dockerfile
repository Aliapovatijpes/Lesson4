FROM debian:bullseye

COPY entrypoint.sh /usr/local/bin/
COPY task2.sh /usr/local/bin/
COPY devops.sql /usr/local/bin/ 
#RUN apt-get update && apt-get install -y git
ARG GITTOKEN=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
ARG MYSQLUSERNAME=intern
ARG MYSQLUSERPASS=onix
ARG ROOTPASS=rootpass
ARG USERNAMEIP=172.0.0.2

ENV MYSQLUSERNAME=$MYSQLUSERNAME
ENV MYSQLUSERPASS=$MYSQLUSERPASS
ENV ROOTPASS=$ROOTPASS
ENV MYSQLIP=$MYSQLIP
ENV USERNAMEIP=$USERNAMEIP
RUN apt-get update && apt-get install -y wget lsb-release screen
#RUN git clone -b vagrant --single-branch https://Aliapovatijpes:$GITTOKEN@github.com/Aliapovatijpes/Lesson2.git\
# && cd Lesson2/\
RUN bash /usr/local/bin/task2.sh -s -u $MYSQLUSERNAME -p $MYSQLUSERPASS -r $ROOTPASS -a $USERNAMEIP
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]