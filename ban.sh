#!/bin/bash

IP=$1

while read p; do #leser hver linje i whiteslist.db og gir dem variablen p
	if [[ "$p" == "$IP" ]] #sjekker om p og IP er samme
	then
		echo "$IP er whitelistet"
		exit #avslutter ban.sh slik som fører til at ipen er "whitelistet" eller kan ikke bannes
	fi
done <whitelist.db

echo "banner $IP"

sudo iptables -A INPUT -s $IP -j REJECT #legger til ip i iptables
sudo /sbin/iptables-save #lagrer iptables


echo "$IP",$(date +%s) >> miniban.db #legger til ip og tidspunkt for ban i miniban databasen. 












