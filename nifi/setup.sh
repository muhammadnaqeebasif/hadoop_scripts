#!/bin/bash

eval "$(cat credentials.txt)"

if [ "$(whoami)" != "$HDUSER" ]; then
        echo "Script must be run as user: $HDUSER"
        exit
fi

#-----Change directory to the directory of the script------------------------
cd "$(dirname "$0")"

mkdir -p binaries

if [ -e binaries/nifi-1.9.2-bin.tar.gz ]
then
	echo "OK"
else
	wget wget https://www-eu.apache.org/dist/nifi/1.9.2/nifi-1.9.2-bin.tar.gz \
	-P binaries
fi

#------------------Extracting the tar file--------------------------------------
echo $PASS | sudo tar -xvzf binaries/nifi-1.9.2-bin.tar.gz -C /usr/local/
echo $PASS | sudo mv /usr/local/nifi-1.9.2/ /usr/local/nifi

#------------------Configuring bash ---------------------------------------
echo "" >> $HDUSER_HOME/.bashrc
echo "#Set NIFI_HOME" >> $HDUSER_HOME/.bashrc
echo "export NIFI_HOME=/usr/local/nifi" >> $HDUSER_HOME/.bashrc

echo "export PATH=\$PATH:\$NIFI_HOME/bin/" >> $HDUSER_HOME/.bashrc

#sourcing the bash file
eval "$(cat $HDUSER_HOME/.bashrc)"
#-------------------Starting Nifi-------------------------------------------
sudo chown -R $HDUSER:hadoop $NIFI_HOME
#Setting up the nifi web port to 9999
sed -i "s|nifi.web.http.port=8080|nifi.web.http.port=9999|g" $NIFI_HOME/conf/nifi.properties
#Starting nifi 
nifi.sh start