

# MySQL Server on Ubuntu VM - Performance Tuned and with DataDisks Attached

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftCoEX%2Fazure-templates%2Fmaster%2FMySQLVM-Template%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a> <a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftCoEX%2Fazure-templates%2Fmaster%2FMySQLVM-Template%2Fazuredeploy.json" target="_blank">
    <img src="http://armviz.io/visualizebutton.png"/>
</a>


This template uses deploys a Standalone MySQL server on a linux VM with a custom script extension to mount a data disk, install mysql server and apply some performance enhancmenets, <b>Execution time is less than 5 minutes</b>.
<br/>
<br/>
## Template Details
This Template creates the following:
<br/>
1) An Ubuntu VM
<br/>
2) P30 (1TB) SSD Data Disk attached
<br/>
3) Disk mounted and configured by LVM
<br/>
4) Performance Tuning applied per <a href="https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-linux-classic-optimize-mysql?toc=%2fazure%2fvirtual-machines%2flinux%2fclassic%2ftoc.json">  Microsoft Recommendations </a>
<br/>
5) Silent install of the latest MySQL server
<br/>
6) Network Security Group with MySQL and SSH ports opened
<br>
7) Creates a brand new Virtual Network (Working on having the option to select an existing one)
<br/>
8) IP is set to be Static

## Parameters
Accordingly, the parameters you fill are used for the following:

| Name| Type           | Description |
| ------------- | ------------- | ------------- |
| vmName  | String | Name for the Virtual Machine |
| adminUsername  | String | Username for SSH Login |
| adminPassword | SecureString | Password for the SSH Login |
| mysqlPasswrd | String | Password for the MySQL Server |
| Ubuntu Version  | List | 14.04 TLS / 16.04 TLS | 
| VM Size | List | Standard DS3_V2 to DS15_V2 |

## Next Steps
The MySQL server database is configured be accessed externaly by its static IP upon creation with the appropriate ports opened,
The remaining Steps would be for you to Create the approriate Database and its admin users like the below:
<br/>
```bash
$ mysql -u root -p
$ CREATE DATABASE TestDB;
$ GRANT ALL ON TestDB.* TO 'adminuser'@'%' IDENTIFIED BY 'pass@word1';
$ exit
```

## Validate
1) Instal MySQL Workbench
<br/>
2) Create a new connection
<ul>
<li>
    HostName: Type in the VM IP (Obtained from the Portal)
    </li>
    <li>
    Username and Password: Type in the ones you created form the above step that have access to a certain database or just login in with the root account
    </li>
</ul>
3) You will be successfully connected to the Server and start working on your Database
