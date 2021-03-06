mysqlPassword=$1

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
sudo mkdir -p /var/lib/mysql

#Get the mounted device UUID by typing: 
UUID=`sudo blkid | grep -i "/dev/mapper/vg00-lv00" | cut -d ' ' -f2`
sudo echo "${UUID} /var/lib/mysql xfs defaults,nofail,noatime 0 0" >> /etc/fstab
# Mount the new drive
sudo mount -a

#####install mysql-server######
sudo apt-get -y update
echo "mysql-server mysql-server/root_password password $mysqlPassword" | sudo debconf-set-selections 
echo "mysql-server mysql-server/root_password_again password $mysqlPassword" | sudo debconf-set-selections 
sudo apt-get -y install mysql-server
sudo mysqladmin -u root password "$mysqlPassword"

#####Exposing the Server#######
sed -e '/bind-address/ s/^#*/#/' -i /etc/mysql/mysql.conf.d/mysqld.cnf

#####Performance Tuning#######
sed -e '/query_cache_size/ s/^#*/#/' -i /etc/mysql/mysql.conf.d/mysqld.cnf
sed -e '/query_cache_limit/ s/^#*/#/' -i /etc/mysql/mysql.conf.d/mysqld.cnf
sed -e '/thread_cache_size/ s/^#*/#/' -i /etc/mysql/mysql.conf.d/mysqld.cnf

sudo echo "max_connections = 5000
query_cache_size = 0
query_cache_limit = 64M
innodb_buffer_pool_size = 10G 

innodb_thread_concurrency = 6 # = 2 * [numberofCPUs] + 2
innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = 1

#innodb_log_file_size = 512M
innodb_autoextend_increment=512
innodb_log_buffer_size = 128M
thread_cache_size = 32
table_open_cache = 1024
max_heap_table_size = 256M
read_buffer_size = 2M" >> /etc/mysql/mysql.conf.d/mysqld.cnf

sudo echo "noop" >/sys/block/sda/queue/scheduler
sudo echo "noop" >/sys/block/sdc/queue/scheduler
sudo sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash elevator=noop"/g' /etc/default/grub
sudo update-grub

sudo service mysql restart

sudo echo "* soft nofile 65536" >> /etc/security/limits.conf 
sudo echo "* hard nofile 65536" >> /etc/security/limits.conf 
sudo echo "* soft nproc 65536" >> /etc/security/limits.conf 
sudo echo "* hard nproc 65536" >> /etc/security/limits.conf 

sudo ulimit -SHn 65536
sudo ulimit -SHu 65536

sudo echo “ulimit -SHn 65536” >>/etc/rc.local
sudo echo “ulimit -SHu 65536” >>/etc/rc.local

#######Finalization#######
service mysql restart


