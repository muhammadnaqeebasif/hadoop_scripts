#!/bin/bash
eval "$(cat credentials.txt)"

if [ "$(whoami)" != "$HDUSER" ]; then
        echo "Script must be run as user: $HDUSER"
        exit
fi


#-----Change directory to the directory of the script------------------------
cd "$(dirname "$0")"

#installing mysql-server
echo $PASS | sudo apt update
echo $PASS | sudo apt-get install -y mysql-server
#securing mysql
#echo $PASS | sudo mysql_secure_installation
echo $PASS | sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'hadoop'; FLUSH PRIVILEGES;"
#Downloading Employee DB
git clone https://github.com/datacharmer/test_db.git
#Changing the directory to test_db
cd test_db
#Installing the database
mysql -u root -phadoop -t <employees.sql