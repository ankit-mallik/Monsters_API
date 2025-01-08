#!/bin/bash

export PSPASSWORD='node_password'

database="monstersdb"

echo "Configuring database: $database"

#check if the database exists

if psql -U node_user -lqt | cut -d \| -f 1 | grep -qw "$database"; then
    echo "Database $database already exists. Dropping it..."
    dropdb -U node_user "$database"
fi 

#Create the databse
createdb -U node_user "$database"

#Check if the sql file exists before executing

if [ -f ./bin/sql/monsters.sql ]; then
    psql -U node_user "$database" < ./bin/sql/monsters.sql > output.log 2> error.log
    if [ $? -ep 0 ]; then
        echo "SQL file executed successfully."
    else
        echo "Error executing SQL file."
        cat error.log 
    fi
else
    echo "SQL file ./bin/sql/monsters.sql not found!"
    exit 1
fi

echo "$database configured"

# dropdb -U node_user monstersdb
# createdb -U node_user monstersdb

# psql -U node_user monstersdb < ./bin/sql/monsters.sql

# echo "$database configured"