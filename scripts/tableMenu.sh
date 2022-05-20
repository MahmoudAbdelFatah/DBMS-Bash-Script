#!/bin/bash

dbname=$1
tableMenu(){

    echo  $'\n' ----------------You are connected to $dbname database---------------- $'\n' 
    echo "-------------------------------------------------------------------------"
    select choice in "Create table" "Drop table" "Select table" "Insert into table" "Update table" "Delete from table" "Exit"
    do
        case $REPLY in
        1)  /home/$USER/project/scripts/createTable.sh $dbname
        tableMenu $dbname
            ;;
        2)  read -p "Enter Table Name: " tname 
            ;;
        3)  read -p "Enter Table Name: " tname
            ;;
        4)  read -p "Enter Table Name: " tname
            ;;
        5)  read -p "Enter Table Name: " tname
            ;;
        6)  read -p "Enter Table Name: " tname
            ;;
        7) exit
            ;;
        esac
    done
}
tableMenu $dbname