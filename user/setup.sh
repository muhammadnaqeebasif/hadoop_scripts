#!/bin/bash
#-----Createing group and user--------------#
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

eval "$(cat credentials.txt)"

# create hadoop group
addgroup hadoop
# create hduser in hadoop group
useradd -m -p $(openssl passwd -1 $PASS) -s /bin/bash -g hadoop $HDUSER 
# add hduser to sudo 
adduser $HDUSER sudo
usermod -G vboxsf -a $HDUSER
chmod -R 0777 .
