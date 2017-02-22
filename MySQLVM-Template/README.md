# MySQL Server on Ubuntu VM - Perfomance Tuned and with DataDisks Attached

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftCoEX%2Fazure-templates%2Fmaster%2FMySQLVM-Template%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>

This template uses deploys a Standalone MySQL server on a linux VM with a custom script extension to mount a data disk, install mysql server and apply some performance enhancmenets, <b>Exection time is less than 5 minutes</b>.
<br/>
<br/>
This Template creates the following:
<br/>
1) An Ubuntu VM
<br/>
2) P30 (1TB) SSD Data Disk attached
<br/>
3) Disk mounted and configured by LVM
<br/>
4) Performance Recommandations applied per <a href="https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-linux-classic-optimize-mysql?toc=%2fazure%2fvirtual-machines%2flinux%2fclassic%2ftoc.json">  Microsoft Recommendations </a>
<br/>
5) Silent install of the latest MySQL server
<br/>
6) Network Security Group with MySQL and SSH ports opened
<br>
7) Creates a brand new Virtual Network (Working on having the option to select an existing one)
<br/>
8) IP is set to be Static

Accordingly, the parameters you fill are used for the following:
<br/>
1) New or Existing Resource Group
<br/>
2) VM Admin Username
<br/>
3) VM user Password
<br/>
4) VM MySQL Password
<br/>
5) Ubunut Version (14.04 TLS or 16.04 TLS)
<br/>
6) VM Size (Standard DS3_V2 to DS15_V2)

The MySQL server database is configured be accessed externaly by its static IP upon creation with the appropriate ports opened.

The remaining Steps would be for you to Create the approriate Database and its admin users like the below:
<br/>
$ mysql -u root -p
<br/>
$ CREATE DATABASE TestDB;
<br/>
$ GRANT ALL ON TestDB.* TO 'adminuser'@'%' IDENTIFIED BY 'pass@word1';
<br/>
$ exit

