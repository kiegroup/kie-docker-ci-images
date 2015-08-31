#!/bin/bash

#################################################################################################################
# This script is executed before running the server and it does:
# 1.- Read KIE_CONNECTION_DRIVER env variable.
# 2.- If driver used for database connection is different that the default one for H2, 
#     it updates the persistence.xml hibernate dialect value, using the dialect for the current driver in use.
#################################################################################################################

# Check callback script path argument.
if [ $# -ne 1 ]; then
  echo "Missing argument: JPA descriptor absolute path. Exiting."
  exit 65
fi

JPA_FILE_PATH=$1
DEFAULT_DIALECT=org.hibernate.dialect.H2Dialect
DIALECT=

# If not jpa descriptor found, do nothing.
if [ ! -f $JPA_FILE_PATH ]; then
    exit 0
fi

# Check MySQL database.
if [[ $KIE_CONNECTION_DRIVER == *mysql* ]]; 
then
    echo "Using MySQL dialect for kie-drools-wb webapp. "
    DIALECT=org.hibernate.dialect.MySQLDialect
fi

# Check MySQL database.
if [[ $KIE_CONNECTION_DRIVER == *postgre* ]]; 
then
    echo "Using PostgreSQL dialect for kie-drools-wb webapp. "
    DIALECT=org.hibernate.dialect.PostgreSQLDialect
fi

# Override the webapp persistence descriptor using the dialect specified, if different that the webapp default for H2.
if [[ ! -z "$DIALECT" ]] ; then
    echo "Modifying jpa descriptor at '$JPA_FILE_PATH' to set the Hibernate dialect as '$DIALECT'."
    mv $JPA_FILE_PATH $JPA_FILE_PATH.tmp
    sed -e "s;$DEFAULT_DIALECT;$DIALECT;" $JPA_FILE_PATH.tmp > $JPA_FILE_PATH
    rm -f $JPA_FILE_PATH.tmp
    exit $?
fi

# Exit without errors.
exit 0

