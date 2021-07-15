FROM jboss/wildfly:24.0.0.Final

ADD https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.25/mysql-connector-java-8.0.25.jar /opt/jboss/wildfly/modules/system/layers/base/com/mysql/driver8/main/
ADD deployment/wildfly/modules/system/layers/base/com/mysql/driver8/main/module.xml /opt/jboss/wildfly/modules/system/layers/base/com/mysql/driver8/main/module.xml
ADD deployment/wildfly/welcome-content/favicon.ico /opt/jboss/wildfly/welcom-content/
USER root
RUN chown -R jboss /opt/jboss/wildfly/modules/system/layers/base/com/mysql
USER jboss
# ADD deployment/wildfly/standalone/configuration/standalone.xml /opt/jboss/wildfly/standalone/configuration/standalone.xml
ADD target/greeter.war /opt/jboss/wildfly/standalone/deployments/greeter.war

VOLUME /opt/jboss/wildfly/standalone/configuration/staging
RUN echo 'if [[ -d "/opt/jboss/wildfly/standalone/configuration/staging" ]]; then cp /opt/jboss/wildfly/standalone/configuration/staging/* /opt/jboss/wildfly/standalone/configuration/ ; fi' >> /opt/jboss/wildfly/bin/common.sh
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
