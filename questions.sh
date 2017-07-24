#!/bin/bash
# Prompting Five Questions and storing input
echo "1. Please type in the four digit year you were born in followed by [Enter]:"
read YEAR
echo "2. Please type in the two digit month you were born in followed by [Enter]:"
read MONTH
echo "3. Please type in the two digit day you were born in followed by [Enter]:"
read DAY
echo "4. Please type in the city you were born in followed by [Enter]:"
read CITY
echo "5. Please type in the state you were born in followed by [Enter]:"
read STATE
#Putting date stamp
INPUT_DATE=`date --iso-8601=seconds`
#create unique identifier
UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
#write data to tmp.csv
echo "$YEAR,$MONTH,$DAY,$CITY,$STATE,$INPUT_DATE,$UUID" >./tmp.csv
#Read out the data in the CSV file
cat tmp.csv
#write data to database
bash ./$write-to-db.sh
