FROM tomcat:latest

ADD **/*.war /opt/apache-tomcat-8.5.66/webapps

RUN cp -r /usr/local/tomcat/webapps.dist/* /opt/apache-tomcat-8.5.66/webapps 

EXPOSE 8080

CMD ["catalina.sh","run"]