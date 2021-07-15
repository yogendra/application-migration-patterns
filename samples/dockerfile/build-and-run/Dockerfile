FROM maven:3-openjdk-11 as build
RUN mkdir -p /tmp/app
WORKDIR /tmp/app
COPY . .
RUN mvn package

FROM tomcat:9 as run
ENV JAVA_OPTS "-Denvironment=production"
COPY --from=build myapp.war /usr/local/bin/webapps
