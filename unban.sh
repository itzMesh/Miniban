#!/bin/bash


	while IFS="," read IP TIMESTAMP < miniban.db; do #leser miniban.db og hvis det står noe det legger dette inn i variablene IP og TIMESTAMP


		TID=$(date +%s) #finner irl-tid
		SEK=$((TID- TIMESTAMP)) #finner ut hvor mange sekunder som har gått
		MIN=$((SEK/60)) #finner antall minutter som har gått
		
		if [ $MIN -ge 1 ]; then #setter igang unbann prosessen etter en vis tid
	       		sudo sed -i /$IP/d miniban.db #fjerner ip og resten av linjen ip står på
			sudo iptables -D INPUT -s $IP -j REJECT #fjerner ip fra iptables
			sudo /sbin/iptables-save #lagrer iptables
		        echo "ubanner $IP"
		        
		        
		else #nødvedig med else, hvis ikke klarer programmet ikke å se andre iper som prøver å logge seg inn etter at den har bannet første og venter på å unbanne denne. 
			break 
		fi
done



