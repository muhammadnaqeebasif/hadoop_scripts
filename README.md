# hadoop_scripts
This repository contains script for installing different big data components in Ubuntu 18.04
This repository contains the following folders and files:
- **credentials.txt** this file contains the credentials for the hadoop user 
on default the user is set to "hadoop" and password is set to "hadoop" if you want to
change these settings you can change HDUSER and PASS variables accordingly.
- **user** this folder has shell script which setups the new user according to 
the variables set in credentials.txt. You need to run the script as root/sudo user. 
Run the script by typing the following command:<br>
	`sudo bash user/setup.sh` 
- **hadoop** this folder contains the files used for installing and configuring hadoop. 
Your user should be the user which was setted up in credentials.txt. To install and configure
hadoop run the following command:<br>
	`bash hadoop/setup.sh`
- **hive** this folder contains the files used for installing and configuring hive on hadoop cluster.
Your user should be the user which was setted up in credentials.txt. To install and configure
hive run the following command:<br>
	`bash hive/setup.sh`
- **sql-server** this folder contains the files used for installing and configuring sql-server.
Your user should be the user which was setted up in credentials.txt. To install and configure
sql-server run the following command:<br>
	`bash sql-server/setup.sh`

- **sqoop** this folder contains the files used for installing and configuring sqoop on hadoop cluster.
Your user should be the user which was setted up in credentials.txt. To install and configure
sqoop run the following command:<br>
	`bash sqoop/setup.sh`
	
- **pig** this folder contains the files used for installing and configuring apache pig.
Your user should be the user which was setted up in credentials.txt. To install and configure
apache pig run the following command:<br>
	`bash pig/setup.sh`
	
- **hbase** this folder contains the files used for installing and configuring hbase.
Your user should be the user which was setted up in credentials.txt. To install and configure
hbase run the following command:<br>
	`bash hbase/setup.sh`

- **flume** this folder contains the files used for installing and configuring flume.
Your user should be the user which was setted up in credentials.txt. To install and configure
flume run the following command:<br>
	`bash flume/setup.sh`

- **kafka** this folder contains the files used for installing and configuring kafka.
Your user should be the user which was setted up in credentials.txt. To install and configure
kafka run the following command:<br>
	`bash kafka/setup.sh`
	
- **nifi** this folder contains the files used for installing and configuring nifi.
Your user should be the user which was setted up in credentials.txt. To install and configure
nifi run the following command:<br>
	`bash nifi/setup.sh`
- **install.sh** it will setup all the components mentioned above.