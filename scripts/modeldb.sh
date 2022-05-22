#!/bin/bash

if [ ! -d /home/$USER/project/databases ] ;then 
                echo create new dbs directory
                mkdir /home/$USER/project/databases
fi
dbMenu(){
    echo  $'\n' welcome to our Database engine $'\n' 
    echo "-------------------------------------------------------------------------"
    select choice in "Create Database" "List Databases" "Connect to Database" "Drop Database" "Exit"
    do
        case $REPLY in
            1)  read -p "Enter Database name: " dbname
                /home/$USER/project/scripts/createdb.sh $dbname ;;
            2)  /home/$USER/project/scripts/lsdb.sh ;;
            3) /home/$USER/project/scripts/checkdbExist.sh ;;
            4) /home/$USER/project/scripts/dropdb.sh $dbname ;;
            *) exit
                break;
        esac
    done
}
 dbMenu
