#!/bin/bash

dbname=$1
tableMenu() {

    echo "----------$red$bg You are connected to $dbname database$end----------"
    echo "-----------------------------------------------------"
    select choice in "Create table" "List Tables" "Drop table" "Select table" "Insert into table" "Update table" "Delete from table" "Exit"; do
        case $REPLY in
        1)
            /home/$USER/project/scripts/createTable.sh $dbname
            tableMenu $dbname
            return 0
            ;;
        2)
            /home/$USER/project/scripts/lstables.sh $dbname
            tableMenu $dbname
            return 0
            ;;
        3)
            /home/$USER/project/scripts/droptb.sh $dbname
            tableMenu $dbname
            return 0
            ;;
        4)
            /home/$USER/project/scripts/selecttb.sh $dbname
            tableMenu $dbname
            return 0
            ;;
        5)
            /home/$USER/project/scripts/inserttb.sh $dbname
            tableMenu $dbname
            return 0
            ;;
        6)
            read -p "Enter Table Name: " tname
            ;;
        7) /home/$USER/project/scripts/deleteData.sh $dbname
            tableMenu $dbname
            return 0;;
        
        8) return 0
            ;;
        esac
    done
}
tableMenu $dbname
