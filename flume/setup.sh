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
echo $PASS | sudo tar -xvzf binaries/apache-flume-1.9.0-bin.tar.gz -C /usr/local/
echo $PASS | sudo mv /usr/local/apache-flume-1.9.0-bin/ /usr/local/flume

#------------------Configuring bash ---------------------------------------
echo "" >> $HDUSER_HOME/.bashrc
echo "#Set FLUME_HOME" >> $HDUSER_HOME/.bashrc
echo "export FLUME_HOME=/usr/local/flume" >> $HDUSER_HOME/.bashrc
echo "export PATH=\$PATH:\$FLUME_HOME/bin/" >> $HDUSER_HOME/.bashrc
#sourcing the bash file
eval "$(cat $HDUSER_HOME/.bashrc)"

sudo cp $FLUME_HOME/conf/flume-env.sh.template $FLUME_HOME/conf/flume-env.sh
echo "export JAVA_HOME=$JAVA_HOME" | sudo tee -a  $FLUME_HOME/conf/flume-env.sh
echo 'export JAVA_OPTS="-Xms100m -Xmx200m -Dcom.sun.management.jmxremote"' | sudo tee -a $FLUME_HOME/conf/flume-env.sh

#----------------------------------------------------------------------------


#-----------------Verify flume installation----------------------------------
flume-ng version

#-----------------Create an access.log file home directory-------------------
touch $HDUSER_HOME/access.log
#----------------------------------------------------------------------------

#-----------------Creating the configuration file-----------------------------
mkdir -p $HDUSER_HOME/flume/conf

cp configs/flume.conf $HDUSER_HOME/flume/conf
sed -i "s|HDUSER_HOME|$HOME|g" $HDUSER_HOME/flume/conf/flume.conf
#-----------------------------------------------------------------------------
#flume-ng agent --conf $FLUME_HOME/conf/ -f $FLUME_HOME/conf/flume.conf -n FileAgent

