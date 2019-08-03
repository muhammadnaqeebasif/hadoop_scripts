#!/bin/bash
#-----Createing group and user--------------#
# create hadoop group
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

eval "$(cat credentials.txt)"

#-----------Creating hadoop user-------------
bash user/setup.sh

#-----------Installing hadoop----------------
sudo -u $HDUSER bash hadoop/setup.sh

#-----------Installing hive-------------------
sudo -u $HDUSER bash hive/setup.sh

#-----------Installing apache pig-------------
sudo -u $HDUSER bash pig/setup.sh

#-----------Installing sql-server-------------
sudo -u $HDUSER bash sql/setup.sh

#-----------Installing sqoop------------------
sudo -u $HDUSER bash sqoop/setup.sh

#-----------Installing hbase-------------------
sudo -u $HDUSER bash hbase/setup.sh

#-----------Installing flume------------------
sudo -u $HDUSER bash flume/setup.sh

#-----------Installing Kafka------------------
sudo -u $HDUSER bash kafka/setup.sh

#-----------Installing Nifi------------------
sudo -u $HDUSER bash nifi/setup.sh