#!/bin/bash
#setting credentials as variables
USER=root
PASSWORD=root
#setting datbase and table names
DATABASE=input
TABLE=tblInput
#moving data to mysql secure directory
sudo cp ./tmp.csv /var/lib/mysql-files/
echo "The data has been copied to a secure directory"
#chech if database exists, and if not create database
DBCHECK=`mysql -u"$USER" -p"$PASSWORD" -e "show databases;" | grep -Fo $DATABASE`
if [ "$DBCHECK" == "$DATABASE" ]; then
   echo "Database exists"
else
   echo "Database does not exist. Creating database..."
   mysql -u"$USER" -p"$PASSWORD" -e "CREATE DATABASE $DATABASE"
fi
# Check if table exists, and if not, create table
echo "Checking for table..."
DBCHECK=`mysql -u"$USER" -p"$PASSWORD" -e "show tables;" $DATABASE | grep -Fo $TABLE`
if [ "$DBCHECK" == "$TABLE" ]; then
   echo "Table exists"
else
   echo "Table does not exist. Creating table..."
   mysql -u"$USER" -p"$PASSWORD" -e "CREATE TABLE $TABLE (ID VARCHAR(255), Year INT, Month INT, Day INT, City VARCHAR(255), State VARCHAR(255), Date TIMESTAMP); ALTER TABLE $TABLE ADD PRIMARY KEY (ID);" $DATABASE
fi
# Write data from tmp.csv into database table
echo "Writing new data to $TABLE in database $DATABASE."
mysql -u"$USER" -p"$PASSWORD" -e "LOAD DATA INFILE '/var/lib/mysql-files/tmp.csv' INTO TABLE $TABLE FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';" $DATABASE
echo "Data written successfully."
# Dump current version of database into export file
echo "Survey data dumped to file `date --iso-8601`-$DATABASE.sql"
mysqldump -u"$USER" -p"$PASSWORD" $DATABASE > `date --iso-8601`-$DATABASE.sql
# remove /var/lib/mysql-files/tmp.csv
sudo rm /var/lib/mysql-files/tmp.csv
