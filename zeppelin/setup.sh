#!/bin/bash
eval "$(cat credentials.txt)"

if [ "$(whoami)" != "$HDUSER" ]; then
        echo "Script must be run as user: $HDUSER"
        exit
fi

#-----Change directory to the directory of the script------------------------
cd "$(dirname "$0")"

#-------------------Downloading the sqoop binaries-------------------------------
if [ -e binaries/zeppelin-0.8.2-bin-all.tgz ]
then
	echo "OK"
else
	wget http://apache.mirror.anlx.net/zeppelin/zeppelin-0.8.2/zeppelin-0.8.2-bin-all.tgz \
	-P binaries/
fi

#-------------------------------------------------------------------------------
#------------------Extracting the tar file--------------------------------------
sudo tar -xvzf binaries/zeppelin-0.8.2-bin-all.tgz  -C /opt/
sudo mv /opt/zeppelin-0.8.2-bin-all /opt/zeppelin

#------------------Configuring bash ---------------------------------------
echo "" >> $HDUSER_HOME/.bashrc
echo "#Set ZEPPELIN_HOME" >> $HDUSER_HOME/.bashrc
echo "export ZEPPELIN_HOME=/opt/zeppelin" >> $HDUSER_HOME/.bashrc
echo "export PATH=\$PATH:\$ZEPPELIN_HOME/bin/" >> $HDUSER_HOME/.bashrc
#sourcing the bash file
eval "$(cat $HDUSER_HOME/.bashrc)"

sudo chown -R hadoop:hadoop $ZEPPELIN_HOME

cp configs/zeppelin-env.sh $ZEPPELIN_HOME/conf
cp configs/zeppelin-site.xml $ZEPPELIN_HOME/conf
#-------------------Starting zeppelin-----------------------------------------
zeppelin-daemon.sh start
