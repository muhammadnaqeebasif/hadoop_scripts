#!/bin/bash
eval "$(cat credentials.txt)"

if [ "$(whoami)" != "$HDUSER" ]; then
        echo "Script must be run as user: $HDUSER"
        exit
fi


#-----Change directory to the directory of the script------------------------
cd "$(dirname "$0")"

#-------------------Downloading the hbase binaries-------------------------------
mkdir -p binaries

if [ -e binaries/hbase-2.2.0-bin.tar.gz ]
then
	echo "OK"
else
	wget http://mirror.vorboss.net/apache/hbase/2.2.0/hbase-2.2.0-bin.tar.gz \
	-P binaries/
fi

#-------------------------------------------------------------------------------
#------------------Extracting the tar file--------------------------------------
echo $PASS | sudo tar -xvzf binaries/hbase-2.2.0-bin.tar.gz -C /usr/local/
echo $PASS | sudo mv /usr/local/hbase-2.2.0/ /usr/local/HBase
#--------------------------------------------------------------------------------

#------------------Configuring bash ---------------------------------------
echo "" >> $HDUSER_HOME/.bashrc
echo "# Set HBASE_HOME" >> $HDUSER_HOME/.bashrc
echo "export HBASE_HOME=/usr/local/HBase" >> $HDUSER_HOME/.bashrc
echo "export PATH=\$PATH:\$HBASE_HOME/bin/" >> $HDUSER_HOME/.bashrc
#sourcing the bash file
eval "$(cat $HDUSER_HOME/.bashrc)"
#---------------------------------------------------------------------------

#-------------------------Add JAVA_HOME in shell script hbase-env.sh-----------
echo $PASS | sudo echo "" >> $HBASE_HOME/conf/hbase-env.sh
echo $PASS | sudo echo "# Adding JAVA_HOME" >> $HBASE_HOME/conf/hbase-env.sh
echo $PASS | sudo echo "export JAVA_HOME=$JAVA_HOME" >> $HBASE_HOME/conf/hbase-env.sh

#-------------------------------------------------------------------------------

#------------------Configuring HBase-------------------------------------------
sudo chown -R $HDUSER:hadoop $HBASE_HOME
cp configs/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml
# Creating zookeeper directory
sudo mkdir -p /hadoop/zookeeper
sudo chown -R $HDUSER:hadoop /hadoop/

#--------------------------------------------------------------------------------
start-hbase.sh
