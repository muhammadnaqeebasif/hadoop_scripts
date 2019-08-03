#!/bin/bash
eval "$(cat credentials.txt)"

if [ "$(whoami)" != "$HDUSER" ]; then
        echo "Script must be run as user: $HDUSER"
        exit
fi

#-----Change directory to the directory of the script------------------------
cd "$(dirname "$0")"
#----------------------------------------------------------------------------

#---------------------Downloading apache pig---------------------------
mkdir -p binaries/

if [ -e binaries/pig-0.17.0.tar.gz ]
then
	echo "OK"
else
	wget https://www-eu.apache.org/dist/pig/latest/pig-0.17.0.tar.gz \
	-P binaries/
fi
#------------------------------------------------------------------------------
#-----------------------Extracting the binary-----------------------------------
echo $PASS | sudo tar -xvzf binaries/pig-0.17.0.tar.gz -C /usr/local
echo $PASS | sudo mv /usr/local/pig-0.17.0 /usr/local/pig
#-------------------------------------------------------------------------------
#------------------------Setting up pig environment-----------------------------
echo "" >> $HDUSER_HOME/.bashrc
echo "# Set PIG_HOME" >> $HDUSER_HOME/.bashrc
echo "export PIG_HOME=/usr/local/pig" >> $HDUSER_HOME/.bashrc
echo "export PATH=\$PATH:\$PIG_HOME/bin" >> $HDUSER_HOME/.bashrc
echo "export HADOOP_CONF_DIR=\$HADOOP_INSTALL/etc/hadoop/" >> $HDUSER_HOME/.bashrc
echo "export PIG_CLASSPATH=\$HADOOP_CONF_DIR" >> $HDUSER_HOME/.bashrc
#------------------------------------------------------------------------------