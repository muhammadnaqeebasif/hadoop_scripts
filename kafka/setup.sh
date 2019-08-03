#!/bin/bash

eval "$(cat credentials.txt)"

if [ "$(whoami)" != "$HDUSER" ]; then
        echo "Script must be run as user: $HDUSER"
        exit
fi

#-----Change directory to the directory of the script------------------------
cd "$(dirname "$0")"

#-------------------Downloading the sqoop binaries-------------------------------
if [ -e binaries/kafka_2.11-2.3.0.tgz ]
then
	echo "OK"
else
	wget http://mirrors.ukfast.co.uk/sites/ftp.apache.org/kafka/2.3.0/kafka_2.11-2.3.0.tgz \
	-P binaries
fi

#-------------------------------------------------------------------------------
#------------------Extracting the tar file--------------------------------------
echo $PASS | sudo tar -xvzf binaries/kafka_2.11-2.3.0.tgz -C /usr/local/
echo $PASS | sudo mv /usr/local/kafka_2.11-2.3.0/ /usr/local/kafka

#------------------Configuring bash ---------------------------------------
echo "" >> $HDUSER_HOME/.bashrc
echo "#Set KAFKA_HOME" >> $HDUSER_HOME/.bashrc
echo "export KAFKA_HOME=/usr/local/kafka" >> $HDUSER_HOME/.bashrc

echo "export PATH=\$PATH:\$KAFKA_HOME/bin/" >> $HDUSER_HOME/.bashrc
#sourcing the bash file
eval "$(cat $HDUSER_HOME/.bashrc)"
#----------------------------------------------------------------------------

#--------------------Starting kafka server-----------------------------------
sudo chown -R $HDUSER:hadoop $KAFKA_HOME
# Starting zookeeper-server
#zookeeper-server-start.sh -daemon $KAFKA_HOME/config/zookeeper.properties
#cp configs/server.properties $KAFKA_HOME/config/server.properties
# Starting kafka-server
kafka-server-start.sh -daemon $KAFKA_HOME/config/server.properties
#----------------------------------------------------------------------------
#--------------------Creating a topic in kafka-------------------------------
kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic testTopic

#------------------------------------------------------------------------------

#--------------------Sending message to Kafka----------------------------------
#kafka-console-producer.sh --broker-list localhost:9092 --topic testTopic
#------------------------------------------------------------------------------

#--------------------Using Kafka consumer--------------------------------------
#kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic testTopic --from-beginning