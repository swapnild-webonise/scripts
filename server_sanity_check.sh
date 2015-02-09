############################ Server Sanity Check Script ###########################################
###  Created By : Swapnil Dahiphale
##   Created On : 25 Dec 2014
##################################################################################################
##This script shows following details :
#	1. IP Details
#	2. Os Details
#	3. RAM Details
#	4. Load Average Details
#	5. Disk Utilization Details
#	6. Process/Daemons Details
#	7. Port Details
#	8. Cron job Details
#	9. Database Details
#	10. Virtual Host Details

#################################################################################################
#!/bin/bash

# IP Address
echo "------------------------------IP Details-----------------------------------------------------"
echo -e "\nIP `ifconfig eth1 | grep inet | awk '{ print $2 }' | head -1` "

#OS details
echo -e "\n------------------------------Os Details----------------------------------------------------"
#echo -e "\n\nOS Details :"
lsb_release -idc

#cpu details
echo -e "\nCPU cores : ` nproc --all`"
echo -e "\nCPU cores Available : ` nproc`"


#RAM details
echo -e "\n------------------------------RAM Details---------------------------------------------------"
#echo -e "\nRAM Details (in MB) :"
TOTAL=$(free -m |grep Mem | awk '{ print $2 }')
USED=$(free -m |grep Mem | awk '{ print $3 }')
FREE=$(free -m |grep Mem | awk '{ print $4 }')

echo "Total : $TOTAL"
echo "Used :  $USED" 
echo "Free : $FREE" 


#Load avg
echo -e "\n------------------------------Load Average Details------------------------------------------"
echo -e "\nLoad Average of last 1,5 and 15 minutes : "
uptime | awk -F'[a-z]:' '{ print $2}'


#Disk utilization
echo -e "\n------------------------------Disk Utilization Details--------------------------------------"
echo -e "\nDisk Utilization (in GB) :"
echo -e "\nTotal : `df | grep '^/dev/' | awk '{print $1 "  " $2/1048576 " GB"}'`"
echo -e "\nUsed : `df | grep '^/dev/' | awk '{print $1 "  " $3/1048576 " GB"}'`"
echo -e "\nAvailable : `df | grep '^/dev/' | awk '{print $1 "  " $4/1048576 " GB"}'`"

#echo -e "\nRunning services/daemons : \n"
#sudo initctl list


#Processes/Daemons
echo -e "\n------------------------------Process/Daemons Details---------------------------------------"
echo -e "\nRunning Daemons/processes : "
echo  "Port number : Process ID / Process name"
sudo netstat -tulpn | awk '{print $4 ":" $7}' | cut -d ":" -f 2,3 |tr -s [:space:] | grep  ^[0-9]


#ports
echo -e "\n------------------------------Port Details--------------------------------------------------"
echo -e "\n\nOpen Ports \n"
sudo netstat -ntlp | grep LISTEN | awk {'print $4'} | cut -d : -f 2,4


#cron jobs for root and deploy user
echo -e "\n------------------------------Cron job Details----------------------------------------------"
#echo -e "\n\nCrontab info : "
echo "Cron jobs for user root"
sudo crontab -l -u root | grep -v '^#'
echo "Cron jobs for user deploy"
sudo crontab -l -u deploy |  grep -v '^#'


#######################  Check Mysql database connection ################################
# user : root
# password : swapnil123

echo -e "\n------------------------------Database Details----------------------------------------------"
DB_con_ok=$(mysql -u root -p'machine' -e "show databases;"|grep "mysql")
  if [[ $DB_con_ok != "mysql" ]]
     then
        echo
        echo -e "\n\nThe DB connection could not be established. Check you username and password and try again."
        echo
      else
        echo -e "\n\nMysql Connection Ok"
  fi
#############################################################################################

#Application running on apache and nginx
echo -e "\n------------------------------Virtual Host Details-----------------------------------------"
echo -e "\nVirtual Hosts running on apache2"
apache2ctl -S | grep sites-enabled

########## End of script

