#!/bin/bash
#setting credentials as variables
USER=root
PASSWORD=root
#setting datbase and table names
DATABASE=input
TABLE=tblInput
#moving the input to the mysql secure directory
sudo cp ./tmp.csv /var/lib/mysql-files/
echo "The input has been copied over to a secure directory"
#check if the database exists, and if not make the database
DATABASE_CHECK=`mysql -u"$USER" -p"$PASSWORD" -e "show databases;" | grep -Fo $DATABASE`
if [ "$DATABASE_CHECK" == "$DATABASE" ]; then
   echo "The database does exists"
else
   echo " The database does not exist. Currently making the database..."
   mysql -u"$USER" -p"$PASSWORD" -e "CREATE DATABASE $DATABASE"
fi
# Check if the table exists, and if not, make the table
echo "Checking for table..."
TABLE_CHECK=`mysql -u"$USER" -p"$PASSWORD" -e "show tables;" $DATABASE | grep -Fo $TABLE`
if [ "$TABLE_CHECK" == "$TABLE" ]; then
   echo "The table does exists"
else
#create the table with the proper sub titles and make ID the primary key
   echo "The table does not exist. Currently making the table..."
   mysql -u"$USER" -p"$PASSWORD" -e "CREATE TABLE $TABLE (ID VARCHAR(255), Year INT, Month INT, Day INT, City VARCHAR(255), State VARCHAR(255), Date TIMESTAMP); ALTER TABLE $TABLE ADD PRIMARY KEY (ID);" $DATABASE
fi
# Put the input from tmp.csv into the table tblInput in databse "input"
echo "Writing new data to $TABLE in the database $DATABASE."
mysql -u"$USER" -p"$PASSWORD" -e "LOAD DATA INFILE '/var/lib/mysql-files/tmp.csv' INTO TABLE $TABLE FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';" $DATABASE
echo "The input was written successfully."
# Dump current version of the database into file named by the date
echo "The input was dumped to file `date --iso-8601`-$DATABASE.sql"
mysqldump -u"$USER" -p"$PASSWORD" $DATABASE > `date --iso-8601`-$DATABASE.sql
# removing the input from the mysql secure directory
sudo rm /var/lib/mysql-files/tmp.csv
echo "Thank you for participating in this data collection."