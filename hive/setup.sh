#!/bin/bash
eval "$(cat credentials.txt)"

if [ "$(whoami)" != "$HDUSER" ]; then
        echo "Script must be run as user: $HDUSER"
        exit
fi

#-----Change directory to the directory of the script------------------------
cd "$(dirname "$0")"
#----------------------------------------------------------------------------

#---------------Downloading apache hive--------------------------------
mkdir -p binaries

if [ -e binaries/apache-hive-2.3.5-bin.tar.gz ]
then
	echo "OK"
else
	wget https://www-eu.apache.org/dist/hive/hive-2.3.5/apache-hive-2.3.5-bin.tar.gz \
	-P binaries/
fi
#----------------------------------------------------------------------
#-----------------Extracting the binary--------------------------------

echo -e "$PASS" | sudo tar -xvzf binaries/apache-hive-2.3.5-bin.tar.gz -C /usr/local/
#-----------------------------------------------------------------------
echo -e "$PASS" | sudo mv /usr/local/apache-hive-2.3.5-bin/ /usr/local/hive
#-----------------------------------------------------------------------
#----------------Setting up Hive environment----------------------------
echo "" >> $HDUSER_HOME/.bashrc
echo "# Set HIVE_HOME" >> $HDUSER_HOME/.bashrc
echo "export HIVE_HOME=/usr/local/hive" >> $HDUSER_HOME/.bashrc
echo "export PATH=\$PATH:\$HIVE_HOME/bin" >> $HDUSER_HOME/.bashrc
eval "$(cat $HDUSER_HOME/.bashrc)"
sudo cp configs/hive-config.sh $HIVE_HOME/conf/
sudo cp configs/hive-site.xml $HIVE_HOME/conf/
sudo chown -R $HDUSER:hadoop $HIVE_HOME
#-----------------------------------------------------------------------
#------------------Create a direcotry for hive warehouse into hdfs------
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir /tmp
hdfs dfs -chmod g+w /user/hive/warehouse
hdfs dfs -chmod g+w /tmp
cd $HDUSER_HOME
#-----------------------------------------------------------------------
#-----------------------------Using derby as a metastore----------------
$HIVE_HOME/bin/schematool -initSchema -dbType derby
