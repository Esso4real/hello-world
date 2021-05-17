FROM tomcat:latest

MAINTAINER Ernest Awangya

ADD **/*.war /opt/apache-tomcat-8.5.66/webapps

RUN cp -r /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps 

EXPOSE 8080

CDM ["catalina.sh","run"]


