MSSQL_SA_PASSWORD=$1

#Switch to Root
sudo su
# Install latest CFS
sudo apt-get -y install xfsprogs 

#######Format Disk#######
sudo echo "n
p



t
8e
w
"|fdisk /dev/sdc

# Configure the LVM and format using XFS filesystem:
sudo pvcreate /dev/sdc1
sudo vgcreate vg00 /dev/sdc1
sudo lvcreate -L 1023 -n lv00 /dev/vg00
sudo mkfs.xfs /dev/vg00/lv00
sudo mkdir -p /var/lib/sql

#Get the mounted device UUID by typing: 
UUID=`sudo blkid | grep -i "/dev/mapper/vg00-lv00" | cut -d ' ' -f2`
sudo echo "${UUID} /var/lib/sql xfs defaults,nofail,noatime 0 0" >> /etc/fstab
# Mount the new drive
sudo mount -a

##SQL Server Installation

mkdir /var/lib/sql/data
mkdir /var/lib/sql/log

# Product ID of the version of SQL server you're installing
# Must be evaluation, developer, express, web, standard, enterprise, or your 25 digit product key
# Defaults to developer
MSSQL_PID='evaluation'

# Install SQL Server Agent (recommended)
SQL_INSTALL_AGENT='y'

# Install SQL Server Full Text Search (optional)
# SQL_INSTALL_FULLTEXT='y'

# Create an additional user with sysadmin privileges (optional)
# SQL_INSTALL_USER='<Username>'
# SQL_INSTALL_USER_PASSWORD='<YourStrong!Passw0rd>'

if [ -z $MSSQL_SA_PASSWORD ]
then
  echo Environment variable MSSQL_SA_PASSWORD must be set for unattended install
  exit 1
fi

echo Adding Microsoft repositories...
sudo curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
repoargs="$(curl https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-2017.list)"
sudo add-apt-repository "${repoargs}"
repoargs="$(curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list)"
sudo add-apt-repository "${repoargs}"

sudo apt-get update -y

sudo apt-get install -y mssql-server

sudo MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD \
     MSSQL_PID=$MSSQL_PID \
     MSSQL_DATA_DIR=/var/lib/sql/data \
     MSSQL_LOG_DIR=/var/lib/sql/log \
     /opt/mssql/bin/mssql-conf -n setup accept-eula


sudo ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev

# Add SQL Server tools to the path by default:
echo PATH="$PATH:/opt/mssql-tools/bin" >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Optional SQL Server Agent installation:
if [ ! -z $SQL_INSTALL_AGENT ]
then
  sudo apt-get install -y mssql-server-agent
fi

# Optional SQL Server Full Text Search installation:
if [ ! -z $SQL_INSTALL_FULLTEXT ]
then
    sudo apt-get install -y mssql-server-fts
fi

# Configure firewall to allow TCP port 1433:
echo Configuring UFW to allow traffic on port 1433...
sudo ufw allow 1433/tcp
sudo ufw reload

# Change the owner and group of the data directory to the mssql user
sudo chown mssql /var/lib/sql/data
sudo chgrp mssql /var/lib/sql/data

# Change the owner and group of the log directory to the mssql user
sudo chown mssql /var/lib/sql/log
sudo chgrp mssql /var/lib/sql/log


sudo systemctl restart mssql-server

# Restart SQL Server after installing:
echo Restarting SQL Server...
sudo systemctl restart mssql-server


