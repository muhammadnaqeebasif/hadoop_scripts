#!/bin/bash
eval "$(cat credentials.txt)"

if [ "$(whoami)" != "$HDUSER" ]; then
        echo "Script must be run as user: hduser"
        exit
fi

#-----Change directory to the directory of the script------------------------
cd "$(dirname "$0")"

#-------------------Downloading the sqoop binaries-------------------------------
if [ -e binaries/apache-flume-1.9.0-bin.tar.gz ]
then
	echo "OK"
else
	wget http://apache.mirror.anlx.net/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz \
	-P binaries/
fi

#-------------------------------------------------------------------------------
#------------------Extracting the tar file--------------------------------------
tar -xvzf binaries/apache-flume-1.9.0-bin.tar.gz -C $HDUSER_HOME/
mv $HDUSER_HOME/apache-flume-1.9.0-bin/ $HDUSER_HOME/flume

#------------------Configuring bash ---------------------------------------
echo "" >> $HDUSER_HOME/.bashrc
echo "#Set FLUME_HOME" >> $HDUSER_HOME/.bashrc
echo "export FLUME_HOME=$HDUSER_HOME/flume" >> $HDUSER_HOME/.bashrc
echo "export FLUME_CONF=\$FLUME_HOME/conf" >> $HDUSER_HOME/.bashrc
echo "export PATH=\$PATH:\$FLUME_HOME/bin/" >> $HDUSER_HOME/.bashrc
#sourcing the bash file
eval "$(cat $HDUSER_HOME/.bashrc)"

cp $FLUME_HOME/conf/flume-env.sh.template $FLUME_HOME/conf/flume-env.sh
echo "export JAVA_HOME=$JAVA_HOME" | tee -a  $FLUME_HOME/conf/flume-env.sh
echo 'export JAVA_OPTS="-Xms100m -Xmx200m -Dcom.sun.management.jmxremote"' | tee -a $FLUME_HOME/conf/flume-env.sh

#----------------------------------------------------------------------------


#-----------------Verify flume installation----------------------------------
flume-ng version

#-----------------Create an access.log file home directory-------------------
touch $HDUSER_HOME/access.log
#----------------------------------------------------------------------------

#-----------------Creating the configuration file-----------------------------

cp configs/* $FLUME_HOME/conf/
sed -i "s|HDUSER_HOME|$HOME|g" $FLUME_HOME/conf/local_*.conf

cp configs/netcat_hbase.conf $FLUME_HOME/conf/

# creating directory for twitter data in hdfs
hdfs dfs -mkdir -p /user/hadoop/twitter_data 
#-----------------------------------------------------------------------------

#flume-ng agent --conf $FLUME_HOME/conf/ -f $FLUME_HOME/conf/local_hadoop.conf -n FileAgent

#flume-ng agent --conf $FLUME_HOME/conf/ --conf-file $FLUME_HOME/conf/netcat-hbase.conf --name agent1 -Dflume.root.logger=DEBUG,console
