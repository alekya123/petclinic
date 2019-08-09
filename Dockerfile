FROM tfennelly/tomcat7

ADD target/petclinic.war /tomcat7/webapps/petclinic.war
EXPOSE 8080
