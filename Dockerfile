FROM tomcat:10.1-jdk17

# Remove all default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR into Tomcat and rename to ROOT.war
COPY ./webapp/target/*.war /usr/local/tomcat/webapps/ROOT.war


# FROM openjdk:17-jdk-slim
# WORKDIR /app
# COPY ./server/target/server.jar app.jar
# EXPOSE 8080
# ENTRYPOINT ["java", "-jar", "app.jar"]
