#!/bin/bash


p=0
t=0
temps=0
tipus=""
usage="Usage: BadUsers.sh [-p] [-t parameter]"
expresion="^[0-9]+[dm]$"

# detecció de opcions d'entrada: només son vàlids: sense paràmetres i -p
if [ $# -ne 0 ]
then
	if [ $# -eq 1 ]
	then
		if [ $1 == "-p" ]
		then
			p=1
		else
			echo $usage
			exit 1
		fi
	elif [ $# -eq 2 ]
	then
		if [ $1 == "-t" ]
		then
			if [[ $2 =~ $expresion ]]
			then
				t=1
				temps=`echo $2 | sed 's/.$//g'`
				tipus=`echo ${2: -1}`
				if [[ $tipus == "m" ]]
				then
					temps=`expr $temps \* 30`
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
fi

# afegiu una comanda per llegir el fitxer de password i només agafar el camp de # nom de l'usuari
for user in `cat /etc/passwd | cut -d: -f1`
do
	home=`cat /etc/passwd | grep "^$user\>" | cut -d: -f6`
	if [ -d $home ]; then
		num_fich=`find $home -type f -user $user | wc -l` > /dev/null
	else
		num_fich=0
	fi
	
	if [ $num_fich -eq 0 ]
	then
		if [ $p -eq 1 ]
		then
			# afegiu una comanda per detectar si l'usuari te processos en execució,
			# si no te ningú la variable $user_proc ha de ser 0
			user_proc=`ps -ef | grep "^$user\>" | cut -d " " -f1 | wc -l`

			if [ $user_proc -eq 0 ]
			then
				echo "$user" 2> /dev/null
			fi
		elif [ $t -eq 1 ]
		then
			user2=`lastlog -t "$temps" | grep "^$user\>" | cut -d " " -f1`
			if [ x$user2 != x$user ]
			then
				echo "$user" 2> /dev/null
			fi
		fi
	elif [ $t -eq 1 ]
	then
		user2=`lastlog -t "$temps" | grep "^$user\>" | cut -d " " -f1`
		if [ x$user2 != x$user ]
		then
			echo "$user" 2> /dev/null
		fi
	fi
done
