#!/bin/bash


usage="Usage: ocupacio.sh [-g grup] max_permes"
expresion="^[0-9]+[KMGT]$"
p=0
tamanomax=0
tipusmax=""

if [ $# -ne 0 ]
then
	if [ $# -eq 1 ]
	then
		if [[ $1 =~ $expresion ]]
		then
			p=1
			tamanomax=`echo $1 | sed 's/.$//g'`
			tipusmax=`echo ${1: -1}`
			if [ $tipusmax == "T" ]
			then
				tamanomax=`expr $tamanomax \* 1024 \* 1024 \* 1024 \* 1024`
			elif [ $tipusmax == "G" ]
			then
				tamanomax=`expr $tamanomax \* 1024 \* 1024 \* 1024`
			elif [ $tipusmax == "M" ]
			then
				tamanomax=`expr $tamanomax \* 1024 \* 1024`
			elif [ $tipusmax == "K" ]
			then
				tamanomax=`expr $tamanomax \* 1024`
			fi
		else
			echo $usage
			exit 1
		fi
	else
		echo $usage
		exit 1
	fi
else
	echo $usage
	exit 1
fi

for user in `cat /etc/passwd | cut -d: -f1`
do
	home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`
	tamanoconletra=`du -ch $home | grep total | cut -d$'\t' -f1 2> /dev/null`
	tamano=`du -c $home | grep total | cut -d$'\t' -f1`

	if [ $tamanomax -gt $tamano ]
	then
		echo -e "$user \t $tamanoconletra"
	#else
	#	echo "Demasiado espacio. COmprime o elimina archivos. Gracias." >> $home/.bashrc
	fi
done