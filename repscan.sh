#!/bin/bash

nmap -sL -n $1 | awk '/Nmap scan report/{print $NF}' > ip
#convert CIDR to ip


while read ip
#for each ip do scan 
    do

        sudo nmap -Pn -p- -sS $ip | head -n -2 | sed '1,5d'| cut -d "/" -f 1 >> temp_result
        echo "start at `date "+%D|%T"`" >> ./result/$ip


        while read line;
        do
            if grep -R $line ./result/$ip;
            then
                echo "no new port found"
            else
                echo $line >> ./result/$ip
                
                if grep -R finished ./result/$ip;
                #if signature in file, it means at least the ip scaned 1 time, so notify it
                then
                    echo notify
                    data="{\"username\": \"RepScan\", \"content\": \"[`date +%D\|%T`] Port $line open on $ip\"}"
                    curl -s "https://discord.com/api/webhooks/976212223368241193/j6IfnIEY2wwk9aAT5Z-kk2D4W-F33lQ0UU37zEzqmVKRSPc9I8xbEASE2_O3HGpK9RzG" \
                    -H "Content-Type: application/json" \
                    -d "$data"
                fi

            fi

        done < temp_result
        echo "finished at `date "+%D|%T"`" >> ./result/$ip
        rm temp_result
    done < ip

rm ip






#filter the result
cd result
for file in *;
do 
    # echo $file
    cat $file | grep -v finished | grep -v start > ./filter/$file
    if [ ! -s ./filter/$file ];
    then 
        rm ./filter/$file
        # :
    fi
    # rm $file
done