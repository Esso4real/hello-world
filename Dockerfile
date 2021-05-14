# Pull base image 
From tomcat:latest

# Maintainer 
MAINTAINER "esso4realh@gmail.com" 
COPY ./webapp.war /usr/local/tomcat/webapps
RUN cp -r /usr/local/tomcat/webapps.dist/* /usr/local/tomcat/webapps 

