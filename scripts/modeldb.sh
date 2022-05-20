#!/bin/bash

if [ ! -d /home/$USER/project/databases ] ;then 
                echo create new dbs directory
                mkdir /home/$USER/project/databases
fi
while true; do
    echo  $'\n' welcome to our Database engine $'\n' 
    echo "-------------------------------------------------------------------------"
    select choice in "Create Database" "List Databases" "Connect to Database" "Drop Database" "Exit"
    do
        case $REPLY in
            1)  read -p "Enter Database name: " dbname
                /home/$USER/project/scripts/createdb.sh $dbname
                break;;
            2)  /home/$USER/project/scripts/lsdb.sh
                break;;
            3) /home/$USER/project/scripts/checkdbExist.sh
                break;;
            4) /home/$USER/project/scripts/dropdb.sh $dbname
                break;;
            *) exit
                break 2
        esac
    done
done
