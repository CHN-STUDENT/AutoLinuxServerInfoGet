#! /bin/bash
# unset any variable which system may be using
# Author: Tecmint.com
# Edited: CHN-STUDENT
# clear the screen
clear

unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage

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
  tecreset=$(tput sgr0)

  # Check if connected to Internet or not
  ping -c 1 baidu.com &> /dev/null && echo -e '\E[32m'"Internet: $tecreset Connected" || echo -e '\E[32m'"Internet: $tecreset Disconnected"

  # Check OS Type
  os=$(uname -o)
  echo -e '\E[32m'"Operating System Type :" $tecreset $os

  # Check OS Release Version and Name
  cat /etc/os-release | grep 'NAME\|VERSION' | grep -v 'VERSION_ID' | grep -v 'PRETTY_NAME' > /tmp/osrelease
  echo -n -e '\E[32m'"OS Name :" $tecreset  && cat /tmp/osrelease | grep -v "VERSION" | cut -f2 -d\"
  echo -n -e '\E[32m'"OS Version :" $tecreset && cat /tmp/osrelease | grep -v "NAME" | cut -f2 -d\"

  # Check Architecture
  architecture=$(uname -m)
  echo -e '\E[32m'"Architecture :" $tecreset $architecture

  # Check Kernel Release
  kernelrelease=$(uname -r)
  echo -e '\E[32m'"Kernel Release :" $tecreset $kernelrelease

  # Check hostname
  echo -e '\E[32m'"Hostname :" $tecreset $HOSTNAME

  # Check Internal IP
  internalip=$(hostname -I)
  echo -e '\E[32m'"Internal IP :" $tecreset $internalip

  # Check External IP
  #externalip=$(curl -s ipecho.net/plain;echo)
  #echo -e '\E[32m'"External IP : $tecreset "$externalip

  # Check DNS
  nameservers=$(cat /etc/resolv.conf | sed '1 d' | awk '{print $2}')
  echo -e '\E[32m'"Name Servers :" $tecreset $nameservers

  # Check Logged In Users
  who>/tmp/who
  echo -e '\E[32m'"Logged In users :" $tecreset && cat /tmp/who

  # Check RAM and SWAP Usages
  #free -h | grep -v + > /tmp/ramcache
  echo -e '\E[32m'"Ram Usages :" $tecreset
  #cat /tmp/ramcache | grep -v "Swap"
  #echo -e '\E[32m'"Swap Usages :" $tecreset
  #cat /tmp/ramcache | grep -v "Mem"
  free -m -w | grep "Mem:" | awk ' BEGIN{ print "totalMem","usedMem","availableMem","Use%" }  END{  printf ("%-10s %-10s %-10s %-10s \n",$2,$3,$4,($2-$8)/$2)}'



  # Check Disk Usages
  echo -e '\E[32m'"Disk Usages :" $tecreset

  df -m -x devtmpfs -x tmpfs -x debugfs -l | awk ' BEGIN{ print "totalSpace","usedSpace","availableSpace","Use%" }  {  totalSpace+=$2 ; usedSpace+=$3 ; availableSpace+=$4  } END { printf ("%-10s %-10s %-10s %-10s \n",totalSpace,usedSpace,availableSpace,usedSpace/totalSpace) }'
  


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
  echo -e '\E[32m'"CPU: " $tecreset $DIFF_USAGE "%"

  # Remember the total and idle CPU times for the next check.
  PREV_TOTAL="$TOTAL"
  PREV_IDLE="$IDLE"

  # Wait before checking again.

  # Check Load Average
  #loadaverage=$(uptime | cut -d ':' -f 5-)
  #echo -e '\E[32m'"Load Average :" $tecreset $loadaverage

  # Check System Uptime
  tecuptime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)
  echo -e '\E[32m'"System Uptime Days/(HH:MM) :" $tecreset $tecuptime

  # Unset Variables
  unset tecreset os architecture kernelrelease internalip externalip nameserver loadaverage DIFF_IDLE DIFF_TOTAL DIFF_USAGE

  # Remove Temporary Files
  rm /tmp/osrelease /tmp/who 
}
fi
shift $(($OPTIND -1))