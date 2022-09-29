#!/bin/bash

echo "hei og velkommen til miniban.sh"
echo "">failIP.txt #fjerner alle tidligere midlertidige tildligere forsøk
ipA=$(journalctl -u ssh | tail -n 1 | grep Failed) #ser på forrige mislykkete innlogging når scriptet starter opp


while true; do #kjører heile tida
	./unban.sh #kjører shell scriptet hver gang while løkken looper
	ipB=$(journalctl -u ssh | tail -n 1 | grep Failed) #ser på forrige mislykkeete innlogging

	if [[ "$ipA" != "$ipB" ]] #sjekker om forrige mislykkete innlogging er anderledes, hvis den er det vil det bli loggført og evnt. bannet
	then
		if [[ "$ipB" != "" ]] #trenger denne for å ikke få veldige mange tomme linjer i failIP.txt
		then
			IP=$(echo $ipB | grep -oP '(\d{1,3}\.){3}\d{1,3}') #henter ut selve IPadressen fra ipB
			echo $IP >> failIP.txt #appender inn i failIP som er en midlertidig lagrinsplass for misslykkete IPer
			antall=$(grep -o $IP failIP.txt | wc -l) #teller hvor mange ganger en ip ligger i failIP

			echo "$IP antall forsøk $antall "
			
			if [[ $antall == 3 ]] #hvis antall iper i failIP er 3 sendes IP-en til ban for banning
			then
				sudo sed -i /$IP/d failIP.txt #fjerner alle gangene IP står i failIP
				./ban.sh $IP #kjører skritet og sender samtidig IP til det 
			fi
		fi
		ipA=$ipB #hvis denne ikke er det vil første ipsetning få i en loop
	fi
	
done

trap 'kill $(jobs -p)' EXIT

	



	

