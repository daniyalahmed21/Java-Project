# Step 1: Build stage using Maven
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copy Maven configuration and source code
COPY pom.xml .
COPY src ./src

# Build the WAR file (skip tests for faster build)
RUN mvn clean package -DskipTests

# Step 2: Run stage using Tomcat
FROM tomcat:10.1.15-jdk17

# Remove default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR into Tomcat's webapps folder as ROOT.war
COPY --from=build /app/target/myapp.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]