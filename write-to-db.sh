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
#chech if database exists, and if not make database
DATABASE_CHECK=`mysql -u"$USER" -p"$PASSWORD" -e "show databases;" | grep -Fo $DATABASE`
if [ "$DATABASE_CHECK" == "$DATABASE" ]; then
   echo "Database does exists"
else
   echo "Database does not exist. Currently Making database..."
   mysql -u"$USER" -p"$PASSWORD" -e "CREATE DATABASE $DATABASE"
fi
# Check if table exists, and if not, make table
echo "Checking for table..."
TABLE_CHECK=`mysql -u"$USER" -p"$PASSWORD" -e "show tables;" $DATABASE | grep -Fo $TABLE`
if [ "$TABLE_CHECK" == "$TABLE" ]; then
   echo "Table does exists"
else
   echo "Table does not exist. Currently Making table..."
   mysql -u"$USER" -p"$PASSWORD" -e "CREATE TABLE $TABLE (ID VARCHAR(255), Year INT, Month INT, Day INT, City VARCHAR(255), State VARCHAR(255), Date TIMESTAMP); ALTER TABLE $TABLE ADD PRIMARY KEY (ID);" $DATABASE
fi
# Put data from tmp.csv into proper table in the proper databse
echo "Writing new data to $TABLE in database $DATABASE."
mysql -u"$USER" -p"$PASSWORD" -e "LOAD DATA INFILE '/var/lib/mysql-files/tmp.csv' INTO TABLE $TABLE FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';" $DATABASE
echo "Data written successfully."
# Dump current version of database into export file named by date
echo "Survey data dumped to file `date --iso-8601`-$DATABASE.sql"
mysqldump -u"$USER" -p"$PASSWORD" $DATABASE > `date --iso-8601`-$DATABASE.sql
# removing data from mysql secure directory
sudo rm /var/lib/mysql-files/tmp.csv
