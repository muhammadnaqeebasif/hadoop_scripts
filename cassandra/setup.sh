#!/bin/bash
eval "$(cat credentials.txt)"

if [ "$(whoami)" != "$HDUSER" ]; then
        echo "Script must be run as user: $HDUSER"
        exit
fi

#-----Change directory to the directory of the script------------------------
cd "$(dirname "$0")"


# Add the Cassandra Repository File
echo "deb http://www.apache.org/dist/cassandra/debian 39x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list

# Add the GPG Key
sudo apt install -y curl
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -

# Install Cassandra on Ubuntu
sudo apt update
sudo apt install -y cassandra

# Copying the cassandrad configuration
sudo cp configs/cassandra-env.sh /etc/cassandra/cassandra-env.sh 

# Enable and Start Cassandra
sudo systemctl enable cassandra
sudo systemctl start cassandra

# Verify The Installation
sudo systemctl status cassandra
nodetool status
