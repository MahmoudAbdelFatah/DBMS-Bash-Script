#!/bin/bash

dbname=$1
tableMenu(){

    echo  $'\n' ----------------You are connected to $dbname database---------------- $'\n' 
    echo "-------------------------------------------------------------------------"
    select choice in "Create table" "List Tables" "Drop table" "Select table" "Insert into table" "Update table" "Delete from table" "Exit"
    do
        case $REPLY in
        1)  /home/$USER/project/scripts/createTable.sh $dbname
        tableMenu $dbname
        return 0
            ;;
        2)  /home/$USER/project/scripts/lstables.sh $dbname
        tableMenu $dbname
        return 0 
            ;;
        3)  read -p "Enter Table Name: " tname
            ;;
        4)  read -p "Enter Table Name: " tname
            ;;
        5)  read -p "Enter Table Name: " tname
            ;;
        6)  read -p "Enter Table Name: " tname
            ;;
        7) ;;
        
        8) return 0
            ;;
        esac
    done
}
tableMenu $dbname