#!/bin/bash

# MySQL docker container linking detection.
# If this KIE container is linked with the official MySQL container, the following environemnt variables will be present.
if [ -n "$MYSQL_PORT_3306_TCP_ADDR" ] &&  [ -n "$MYSQL_PORT_3306_TCP_PORT" ] &&  [ -n "$MYSQL_ENV_MYSQL_ROOT_PASSWORD" ]; then
    
    # MySQL docker container integartion, check database name variable exists.
    if [[ -z "$KIE_CONNECTION_DATABASE" ]] ; then
        echo "[ERROR] - Detected database container linking with a MySQL container, but no $KIE_CONNECTION_DATABASE variable is set with the name of the database to use. Exiting!"
        exit 1
    fi
    
    # MySQL environment variables are set. Proceed with automatic configuration.
    echo "Detected successfull MySQL database container linked. Applying automatic configuration..."
    export KIE_CONNECTION_URL=jdbc:mysql://$MYSQL_PORT_3306_TCP_ADDR:$MYSQL_PORT_3306_TCP_PORT/$KIE_CONNECTION_DATABASE
    export KIE_CONNECTION_DRIVER=mysql
    export KIE_CONNECTION_USER=root
    export KIE_CONNECTION_PASSWORD=$MYSQL_ENV_MYSQL_ROOT_PASSWORD
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
    export KIE_CONNECTION_URL=jdbc:postgresql://$POSTGRES_PORT_5432_TCP_ADDR:$POSTGRES_PORT_5432_TCP_PORT/$KIE_CONNECTION_DATABASE
    export KIE_CONNECTION_DRIVER=postgres
    export KIE_CONNECTION_USER=postgres
    export KIE_CONNECTION_PASSWORD=$POSTGRES_ENV_POSTGRES_PASSWORD
fi

# Check if necessary to change the default hibernate dialect for JPA descriptor.
./update-jpa-config.sh $CATALINA_HOME/webapps/kie-wb/WEB-INF/classes/META-INF/persistence.xml

# Default driver class for different supported dbms.
DB_H2_DRIVER=org.h2.Driver
DB_MYSQL_DRIVER=com.mysql.jdbc.Driver
DB_POSTGRES_DRIVER=org.postgresql.Driver
DB_DRIVER=org.h2.Driver

# Check MySQL database.
if [[ $KIE_CONNECTION_DRIVER == *mysql* ]]; 
then
    echo "Using MySQL driver for kie-wb datasource connection. "
    DB_DRIVER=$DB_MYSQL_DRIVER
fi

# Check MySQL database.
if [[ $KIE_CONNECTION_DRIVER == *postgre* ]]; 
then
    echo "Using PostgreSQL driver for kie-wb datasource connection. "
    DB_DRIVER=$DB_POSTGRES_DRIVER
fi

# Update the datasource properties file using the selected database connection properties.
DS_PROPERTIES_PATH=$CATALINA_HOME/conf/resources.properties
if [ -f $DS_PROPERTIES_PATH ]; then
    rm -f $DS_PROPERTIES_PATH
fi
sed -e "s;%DB_DRIVER%;$DB_DRIVER;" -e "s;%DB_URL%;$KIE_CONNECTION_URL;" -e "s;%DB_USER%;$KIE_CONNECTION_USER;" -e "s;%DB_PWD%;$KIE_CONNECTION_PASSWORD;" $DS_PROPERTIES_PATH.template > $DS_PROPERTIES_PATH

# Start Tomcat.
sh $CATALINA_HOME/bin/catalina.sh run
exit $?