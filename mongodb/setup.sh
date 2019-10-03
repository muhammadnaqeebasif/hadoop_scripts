#!/bin/bash

eval "$(cat credentials.txt)"

if [ "$(whoami)" != "$HDUSER" ]; then
        echo "Script must be run as user: $HDUSER"
        exit
fi

#-----Change directory to the directory of the script------------------------
cd "$(dirname "$0")"


# Setting up the apt repository
echo $PASS | sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo $PASS | echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb.list

# Installing mongodb
echo $PASS | sudo apt update
echo $PASS | sudo apt install -y mongodb-org

# Manage MongoDB Service
echo $PASS | sudo systemctl enable mongod
echo $PASS | sudo systemctl start mongod 

# Verify MongoDB Installation
mongod --version

