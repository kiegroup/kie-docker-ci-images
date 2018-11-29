#!/usr/bin/env bash

# MySQL container linking detection.
# If this KIE container is linked with the official MySQL container, the following environemnt variables will be present.
if [ -n "$MYSQL_PORT_3306_TCP_ADDR" ] &&  [ -n "$MYSQL_PORT_3306_TCP_PORT" ] &&  [ -n "$MYSQL_ENV_MYSQL_ROOT_PASSWORD" ]; then
    
    # MySQL docker container integartion, check database name variable exists.
    if [[ -z "$KIE_CONNECTION_DATABASE" ]] ; then
        echo "[ERROR] - Detected database container linking with a MySQL container, but no $KIE_CONNECTION_DATABASE variable is set with the name of the database to use. Exiting!"
        exit 1
    fi
    
    # MySQL environment variables are set. Proceed with automatic configuration.
    echo "Detected successfull MySQL database container linked. Applying automatic configuration..."
    export KIE_CONNECTION_URL="jdbc:mysql://$MYSQL_PORT_3306_TCP_ADDR:$MYSQL_PORT_3306_TCP_PORT/$KIE_CONNECTION_DATABASE"
    export KIE_CONNECTION_DRIVER="mysql"
    export KIE_CONNECTION_USER="root"
    export KIE_CONNECTION_PASSWORD="$MYSQL_ENV_MYSQL_ROOT_PASSWORD"
fi

# PostgreSQL container linking detection.
# If this KIE container is linked with the official PostgreSQL container, the following environemnt variables will be present.
if [ -n "$POSTGRES_PORT_5432_TCP_ADDR" ] &&  [ -n "$POSTGRES_PORT_5432_TCP_PORT" ] &&  [ -n "$POSTGRES_ENV_POSTGRES_PASSWORD" ]; then

    # PostgreSQL docker container integartion, check database name variable exists.
    if [[ -z "$KIE_CONNECTION_DATABASE" ]] ; then
        echo "[ERROR] - Detected database container linking with a PostgreSQL container, but no $KIE_CONNECTION_DATABASE variable is set with the name of the database to use. Exiting!"
        exit 1
    fi
    
    # MySQL environment variables are set. Proceed with automatic configuration.
    echo "Detected successfull PostgreSQL database container linked. Applying automatic configuration..."
    export KIE_CONNECTION_URL="jdbc:postgresql://$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT/$KIE_CONNECTION_DATABASE"
    export KIE_CONNECTION_DRIVER="postgres"
    export KIE_CONNECTION_USER="postgres"
    export KIE_CONNECTION_PASSWORD="$POSTGRES_ENV_POSTGRES_PASSWORD"
fi

# Check if necessary to change the default hibernate dialect for JPA descriptor.
./update-jpa-config.sh $JBOSS_HOME/standalone/deployments/business-central.war/WEB-INF/classes/META-INF/persistence.xml

# Start WildFly with some parameters.
# ActiveMQ Artemis Client by default creates a fixed thread pool with 500 threads. This is way too much
# and WildFly will fail with java.lang.OutOfMemoryError: unable to create new native thread. Using the property
# 'activemq.artemis.client.global.thread.pool.max.size' to decrease the pool size.
# See https://issues.jboss.org/browse/JBEAP-2947 for more info.
./standalone.sh -b $JBOSS_BIND_ADDRESS -Dactivemq.artemis.client.global.thread.pool.max.size=30 -Djboss.kie.connection_url=$KIE_CONNECTION_URL -Djboss.kie.driver="$KIE_CONNECTION_DRIVER" -Djboss.kie.username="$KIE_CONNECTION_USER" -Djboss.kie.password="$KIE_CONNECTION_PASSWORD" --server-config=standalone-full-business-central.xml
exit $?