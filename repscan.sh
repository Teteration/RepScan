#!/bin/bash

nmap -sL -n $1 | awk '/Nmap scan report/{print $NF}' > ip
#convert CIDR to ip


while read ip
#for each ip do scan 
    do

        # echo $ip
        sudo nmap -Pn -sS $ip | head -n -2 | sed '1,5d'| cut -d "/" -f 1 >> temp_result
        echo " " >> $ip
        while read line;
        do
            if grep -R $line $ip;
            then
                echo "no new port found"
            else
                echo $line >> $ip


                data="{\"username\": \"RepScan\", \"content\": \"[`date +%y/%m/%d`] Port $line open on $1\"}"
                curl -s "https://discord.com/api/webhooks/976212223368241193/j6IfnIEY2wwk9aAT5Z-kk2D4W-F33lQ0UU37zEzqmVKRSPc9I8xbEASE2_O3HGpK9RzG" \
                -H "Content-Type: application/json" \
                -d "$data"

            fi

        done < temp_result


        rm temp_result



    done < ip