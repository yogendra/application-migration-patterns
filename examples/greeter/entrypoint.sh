#!/bin/bash
STAGING=/tmp/configuration
if [[ -d $STAGING ]];
then
echo "Copy configuration from staging"
cp $STAGING/* /opt/jboss/wildfly/standalone/configuration
fi

/opt/jboss/wildfly/bin/standalone.sh, -b, 0.0.0.0, -bmanagement, 0.0.0.0
