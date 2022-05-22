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
            1)  /home/$USER/project/scripts/createdb.sh $dbname
                dbMenu
                ;;
            2)  /home/$USER/project/scripts/lsdb.sh 
                dbMenu
                ;;
            3)  /home/$USER/project/scripts/checkdbExist.sh 
                dbMenu
                ;;
            4)  /home/$USER/project/scripts/dropdb.sh $dbname 
                dbMenu
                ;;
            *)  exit
                break;
        esac
    done
}
 dbMenu
