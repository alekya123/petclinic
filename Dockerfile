FROM tfennelly/tomcat7
//test line
ADD target/petclinic.war /tomcat7/webapps/petclinic.war
EXPOSE 8080
