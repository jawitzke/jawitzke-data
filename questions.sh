#!/bin/bash
# Prompting Five Questions
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
INPUT_DATE=`date -I`

echo "$YEAR, $MONTH, $DAY, $CITY, $STATE, $INPUT_DATE"