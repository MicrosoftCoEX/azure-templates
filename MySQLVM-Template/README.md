# MySQL Server on Ubuntu VM - Perfomance Tuned and with DataDisks Attached

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMicrosoftCoEX%2Fazure-templates%2Fmaster%2FMySQLVM-Template%2Fazuredeploy.json" target="_blank"><img src="http://azuredeploy.net/deploybutton.png"/></a>

This template uses the Azure Linux CustomScript extension to deploy a MySQL server. 
It creates the following:
<br/>
1) An Ubuntu VM
<br/>
2) P30 Data Disk attached (1TB)
<br/>
3) Disk mounted and configured by LVM
<br/>
4) Perfoemance Recommandations applied per Microsoft Recommendations: URL=
<br/>
5) Silent install of the latest MySQL server
<br/>
6) Network Security Group with MySQL and SSH ports opened

The root password is defined by yourself during the deployment.

The MySQL server database can be accessed only from localhost by default, you should update the privileges settings based on your own requirement.
