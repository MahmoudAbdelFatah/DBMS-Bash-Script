#!/bin/bash

dbname=$1
export path=$localdb/$dbname
chmod 755 $scriptsPath/*
tableMenu() {

    echo "----------$red$bg You are connected to $dbname database$end----------"
    echo "-----------------------------------------------------"
    select choice in "Create table" "List Tables" "Drop table" "Select table" "Insert into table" "Update table" "Delete from table" "Update table content" "Exit"; do
        case $REPLY in
        1)
            $scriptsPath/createTable.sh 
            tableMenu 
            return 0
            ;;
        2)
            $scriptsPath/lstables.sh 
            tableMenu 
            return 0
            ;;
        3)
            $scriptsPath/droptb.sh 
            tableMenu 
            return 0
            ;;
        4)
            $scriptsPath/selecttb.sh 
            tableMenu 
            return 0
            ;;
        5)
            $scriptsPath/inserttb.sh 
            tableMenu 
            return 0
            ;;
        6)
            $scriptsPath/updatetb.sh 
            tableMenu 
            return 0
            ;;
        7) $scriptsPath/deleteData.sh 
            tableMenu 
            return 0;;
        8) $scriptsPath/updateData.sh 
            tableMenu
            return 0;;
        9) return 0
            ;;
        esac
    done
}
tableMenu $dbname
