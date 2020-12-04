#! /bin/bash
# unset any variable which system may be using
# Author: Tecmint.com
# Edited: CHN-STUDENT
# clear the screen
clear


smtpserver='smtp.163.com'
smtpport=25
user='user@163.com'
token='password'
sendto='user@163.com'
dates=$(date +"%Y-%m-%d %H-%M-%S")
title="${dates} 172.16.172.2 Server Info"

unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage
rm /tmp/info.txt
fi

while getopts iv name
do
    case $name in
      i)iopt=1;;
      v)vopt=1;;
      *)echo "Invalid arg";;
    esac
done

if [[ ! -z $iopt ]]
then
{
  wd=$(pwd)
  basename "$(test -L "$0" && readlink "$0" || echo "$0")" > /tmp/scriptname
  scriptname=$(echo -e -n $wd/ && cat /tmp/scriptname)
  su -c "cp $scriptname /usr/bin/monitor" root && echo "Congratulations! Script Installed, now run monitor Command" || echo "Installation failed"
}
fi

if [[ ! -z $vopt ]]
then
{
  echo -e "tecmint_monitor version 0.1\nDesigned by Tecmint.com\nReleased Under Apache 2.0 License"
}
fi

if [[ $# -eq 0 ]]
then
{

  # Define Variable tecreset
  # tecreset=$(tput sgr0)
  tecreset='\033[0m'

  # Check if connected to Internet or not
  ping -c 1 baidu.com &> /dev/null && echo -e '\E[32m'"Internet: $tecreset Connected" | tee -a /tmp/info.txt || echo -e '\E[32m'"Internet: $tecreset Disconnected" | tee -a /tmp/info.txt

  # Check OS Type
  os=$(uname -o)
  echo -e '\E[32m'"Operating System Type :" $tecreset $os | tee -a /tmp/info.txt

  # Check OS Release Version and Name
  cat /etc/os-release | grep 'NAME\|VERSION' | grep -v 'VERSION_ID' | grep -v 'PRETTY_NAME' > /tmp/osrelease 
  echo -n -e '\E[32m'"OS Name :" $tecreset  && cat /tmp/osrelease | grep -v "VERSION" | cut -f2 -d\" | tee -a /tmp/info.txt
  echo -n -e '\E[32m'"OS Version :" $tecreset && cat /tmp/osrelease | grep -v "NAME" | cut -f2 -d\" | tee -a /tmp/info.txt

  # Check Architecture
  architecture=$(uname -m)
  echo -e '\E[32m'"Architecture :" $tecreset $architecture | tee -a /tmp/info.txt

  # Check Kernel Release
  kernelrelease=$(uname -r)
  echo -e '\E[32m'"Kernel Release :" $tecreset $kernelrelease | tee -a /tmp/info.txt

  # Check hostname
  echo -e '\E[32m'"Hostname :" $tecreset $HOSTNAME | tee -a /tmp/info.txt

  # Check Internal IP
  internalip=$(hostname -I)
  echo -e '\E[32m'"Internal IP :" $tecreset $internalip | tee -a /tmp/info.txt

  # Check External IP
  #externalip=$(curl -s ipecho.net/plain;echo)
  #echo -e '\E[32m'"External IP : $tecreset "$externalip | tee -a /tmp/info.txt

  # Check DNS
  nameservers=$(cat /etc/resolv.conf | sed '1 d' | awk '{print $2}')
  echo -e '\E[32m'"Name Servers :" $tecreset $nameservers | tee -a /tmp/info.txt

  # Check Logged In Users
  who>/tmp/who
  echo -e '\E[32m'"Logged In users :" $tecreset && cat /tmp/who | tee -a /tmp/info.txt

  # Check RAM and SWAP Usages
  #free -h | grep -v + > /tmp/ramcache
  echo -e '\E[32m'"Ram Usages :" $tecreset | tee -a /tmp/info.txt
  #cat /tmp/ramcache | grep -v "Swap"
  #echo -e '\E[32m'"Swap Usages :" $tecreset
  #cat /tmp/ramcache | grep -v "Mem"
  free -m -w | grep "Mem:" | awk ' BEGIN{ print "totalMem","usedMem","availableMem","Use"  }  END{  printf ("%-10s %-10s %-10s %-10s \n",$2,$3,$4,($2-$8)/$2)  }' | tee -a /tmp/info.txt



  # Check Disk Usages
  echo -e '\E[32m'"Disk Usages :" $tecreset | tee -a /tmp/info.txt

  df -m -x devtmpfs -x tmpfs -x debugfs -x overlay -x shm -l | awk ' BEGIN{ print "totalSpace","usedSpace","availableSpace","Use"   }  {  totalSpace+=$2 ; usedSpace+=$3 ; availableSpace+=$4  } END { printf ("%-10s %-10s %-10s %-10s \n",totalSpace,usedSpace,availableSpace,usedSpace/totalSpace)  }' | tee -a /tmp/info.txt
  


  PREV_TOTAL=0
  PREV_IDLE=0


  # Get the total CPU statistics, discarding the 'cpu ' prefix.
  CPU=(`sed -n 's/^cpu\s//p' /proc/stat`)
  IDLE=${CPU[3]} # Just the idle CPU time.

  # Calculate the total CPU time.
  TOTAL=0
  for VALUE in "${CPU[@]}"; do
  let "TOTAL=$TOTAL+$VALUE"
  done

  # Calculate the CPU usage since we last checked.
  let "DIFF_IDLE=$IDLE-$PREV_IDLE"
  let "DIFF_TOTAL=$TOTAL-$PREV_TOTAL"
  let "DIFF_USAGE=(1000*($DIFF_TOTAL-$DIFF_IDLE)/$DIFF_TOTAL+5)/10"
  echo -e '\E[32m'"CPU: " $tecreset $DIFF_USAGE "%" | tee -a /tmp/info.txt

  # Remember the total and idle CPU times for the next check.
  PREV_TOTAL="$TOTAL"
  PREV_IDLE="$IDLE"

  # Wait before checking again.

  # Check Load Average
  #loadaverage=$(uptime | cut -d ':' -f 5-)
  #echo -e '\E[32m'"Load Average :" $tecreset $loadaverage

  # Check System Uptime
  tecuptime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)
  echo -e '\E[32m'"System Uptime Days/(HH:MM) :" $tecreset $tecuptime | tee -a /tmp/info.txt

  # Unset Variables
  unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage DIFF_IDLE DIFF_TOTAL DIFF_USAGE

  # Remove Temporary Files
  rm /tmp/osrelease /tmp/who 
 
  # Remove all echo colors
  cat /tmp/info.txt | sed 's/\x1B[@A-Z\\\]^_]\|\x1B\[[0-9:;<=>?]*[-!"#$%&'"'"'()*+,.\/]*[][\\@A-Z^_`a-z{|}~]//g' > /tmp/send.txt 

  basepath=$(cd `dirname $0`; pwd)
  mailsendgo_path="${basepath}/mailsend-go"


  if [ -f "${mailsendgo_path}"  ];then
    # Give its permission
    if ! [ -x ${mailsendgo_path} ];then
      chmod a+x ${mailsendgo_path}
    fi
    echo "Send mail to your mail."
    ${mailsendgo_path} -sub "${title}" -smtp ${smtpserver} -port ${smtpport} auth  -user  ${user} -pass ${token} -to ${sendto} -from ${user}  -cs "utf8" body -file  "/tmp/send.txt" 
  else 
    echo -e "\033[31m ERROR!Can not find mailsend-go to send mail." ${tecreset}
  fi
  rm /tmp/send.txt
  rm /tmp/info.txt
}
fi
shift $(($OPTIND -1))
