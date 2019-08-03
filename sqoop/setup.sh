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

echo $PASS | sudo tar -xvzf binaries/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz -C /usr/local/
echo $PASS | sudo mv /usr/local/sqoop-1.4.7.bin__hadoop-2.6.0/ /usr/local/sqoop
#-------------------------------------------------------------------------------
#------------------Configuring bash ---------------------------------------
echo "" >> $HDUSER_HOME/.bashrc
echo "#Set SQOOP_HOME" >> $HDUSER_HOME/.bashrc
echo "export SQOOP_HOME=/usr/local/sqoop" >> $HDUSER_HOME/.bashrc
echo "export PATH=\$PATH:\$SQOOP_HOME/bin" >> $HDUSER_HOME/.bashrc
#---------------------------------------------------------------------
#------------------Configuring Sqoop----------------------------------------
sudo cp configs/sqoop-env.sh /usr/local/sqoop/conf/
sudo rm mv /usr/local/sqoop/conf/sqoop-env-template.sh
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
echo $PASS | sudo tar -xvzf binaries/mysql-connector-java-5.1.47.tar.gz -C /usr/local/sqoop/lib
echo $PASS | sudo mv /usr/local/sqoop/lib/mysql-connector-java-5.1.47/mysql-connector-java-5.1.47-bin.jar \
/usr/local/sqoop/lib
#----------------------------------------------------------------------------------
#--------------------------Importing sample----------------------------------------
#sqoop-import-all-tables --connect jdbc:mysql://localhost/employees --username root --password hadoop -m 1
