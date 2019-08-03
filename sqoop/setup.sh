#!/bin/bash
eval "$(cat credentials.txt)"

if [ "$(whoami)" != "$HDUSER" ]; then
        echo "Script must be run as user: $HDUSER"
        exit
fi

#-----Change directory to the directory of the script------------------------
cd "$(dirname "$0")"

#-------------------Downloading the sqoop binaries-------------------------------
mkdir -p binaries

if [ -e binaries/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz ]
then
	echo "OK"
else
  wget http://mirror.vorboss.net/apache/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz \
  -P binaries/
fi
#-------------------------------------------------------------------------------
#------------------Extracting the tar file--------------------------------------

echo $PASS | sudo tar -xvzf binaries/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz -C /usr/lib/
echo $PASS | sudo mv /usr/lib/sqoop-1.4.7.bin__hadoop-2.6.0/ /usr/lib/sqoop
#-------------------------------------------------------------------------------
#------------------Configuring bash ---------------------------------------
echo "" >> $HDUSER_HOME/.bashrc
echo "#Set SQOOP_HOME" >> $HDUSER_HOME/.bashrc
echo "export SQOOP_HOME=/usr/lib/sqoop" >> $HDUSER_HOME/.bashrc
echo "export PATH=\$PATH:\$SQOOP_HOME/bin" >> $HDUSER_HOME/.bashrc
#---------------------------------------------------------------------
#------------------Configuring Sqoop----------------------------------------
sudo cp configs/sqoop-env.sh /usr/lib/sqoop/conf/
sudo rm mv /usr/lib/sqoop/conf/sqoop-env-template.sh
#-------------------------------------------------------------------------
#----------------------Checking sqoop version ------------------------------
#sourcing the bash file
eval "$(cat $HDUSER_HOME/.bashrc)"
sqoop-version
#----------------------------------------------------------------------------
#---------------------- Adding mysql java connector----------------------------
if [ -e binaries/mysql-connector-java-5.1.47.tar.gz ]
then
	echo "OK"
else
  wget wget http://www.mirrorservice.org/sites/ftp.mysql.com/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz \
  -P binaries/
fi
echo $PASS | sudo tar -xvzf binaries/mysql-connector-java-5.1.47.tar.gz -C /usr/lib/sqoop/lib
echo $PASS | sudo mv /usr/lib/sqoop/lib/mysql-connector-java-5.1.47/mysql-connector-java-5.1.47-bin.jar \
/usr/lib/sqoop/lib
#----------------------------------------------------------------------------------
#--------------------------Importing sample----------------------------------------
#sqoop-import-all-tables --connect jdbc:mysql://localhost/employees --username root --password hadoop -m 1
