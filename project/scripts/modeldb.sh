#!/bin/bash

if [ ! -d /home/$USER/project/databases ] ;then 
                echo create new dbs directory
                mkdir /home/$USER/project/databases
fi
while true; do
    echo  $'\n' welcome to our Database engine $'\n' 
    echo "-------------------------------------------------------------------------"
    select choice in "Create Database" "List Databases" "Connect to Database" "Drop Database" exit
    do
        case $REPLY in
            1)  read -p "Enter Database name: " dbname
                ./createdb $dbname
                break;;
            2) ./lsdb 
                break;;
            3) ./conndb 
                break;;
            4) read -p "Enter Database name: " dbname
                ./dropdb $dbname
                break;;
            *) exit
                break 2
        esac
    done
done
