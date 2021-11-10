#!/bin/sh

DELAY=5

loss()
{
	echo 1 percent loss 
	ipfw pipe 2 config delay 300ms bw 8500Kbit/s queue 640KB plr 0.01 
}

noloss()
{
	echo no loss 
	ipfw pipe 2 config delay 300ms bw 8500Kbit/s queue 640KB plr 0
}

quit ()
{
	echo
	echo clearing loss
	ipfw pipe 2 config delay 300ms bw 8500Kbit/s queue 640KB plr 0
	exit
}

if [ "$1" == "loss" ]
then
	loss
	exit
fi

if [ "$1" == "noloss" ]
then
	noloss
	exit
fi

if [ "$1" == "loop" ]
then
	echo looping with loss/noloss
	trap quit INT
	while true
	do 
		loss
		sleep $DELAY
	
		noloss
		sleep $DELAY
	done  
	exit
fi

if [ "$1" == "period" ]
then
	sleep 5

	loss
	sleep 1
	noloss
	exit
fi


echo "usage ./confloss [loss|noloss|loop]"
