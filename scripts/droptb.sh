#!/bin/bash

confirmToDeltn(){
    dbname=$1
    tname=$2
    read -p "Are you sure u want to drop $tname table ? (y/n)" answer
    answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
    if [ $answer = "y" -o $answer = "yes" ] ;then
        rm  /home/$USER/project/databases/$dbname/$tname
        rm  /home/$USER/project/databases/$dbname/$tname.type
        echo "$(tput setaf 1)$(tput setab 7)-----The Tables $tname and $tname.type are Deleted.-----$(tput sgr 0)"
    elif [ $answer = "n" -o $answer = "no" ] ;then
        echo "$(tput setaf 1)$(tput setab 7)sorry, we can't delete this table without your confirmation.$(tput sgr 0)"
    else
        echo "please choose from this values (y/n)."
        confirmToDeltb $dbname $tname
        return 0
    fi
}

droptb(){
    dbname=$1
    read -p "Enter table name to delete it: " tname
    checkname=$(/home/$USER/project/scripts/chkname.sh $tname)
    if [ $checkname -eq 0 ] ;then
        if [ -f /home/$USER/project/databases/$dbname/$tname ] ;then
                echo "$(tput setaf 1)$(tput setab 7)Table $tname is Exist$(tput sgr 0)"
                confirmToDeltn $dbname $tname
        else
                echo "$(tput setaf 1)$(tput setab 7)Table $tname wasn't found$(tput sgr 0)"
                droptb $dbname 
                return
        fi
    elif [ $checkname -eq 1 ] ;then
        echo "$(tput setaf 1)$(tput setab 7)Wrong Table name format.$(tput sgr 0)"
        droptb $dbname
        return 0
    elif [ $checkname -eq 2 ] ;then
        echo "$(tput setaf 1)$(tput setab 7)You didn't enter any thing, Please enter a name$(tput sgr 0)"
        droptb $dbname
        return 0
    fi
}

droptb $1