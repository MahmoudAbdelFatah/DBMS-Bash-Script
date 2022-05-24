#!/bin/bash

confirmToDelDB() {
    dbname=$1
    read -p "Are you sure u want to drop $dbname db ? (y/n)" answer
    answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
    if [ $answer = "y" -o $answer = "yes" ]; then
        rm -r /home/$USER/project/databases/$dbname
        echo "$(tput setaf 1)$(tput setab 7)-----The Database $dbname is Deleted.-----$(tput sgr 0)"
    elif [ $answer = "n" -o $answer = "no" ]; then
        echo "$(tput setaf 1)$(tput setab 7)sorry, we can't delete this database without your confirmation.$(tput sgr 0)"
    else
        echo "please choose from this values (y/n)."
        confirmToDelDB $dbname
        return 0
    fi
}

dropDB() {
    read -p "Enter database name to delete it: " dbname
    checkname=$(/home/$USER/project/scripts/chkname.sh $dbname)
    if [ $checkname -eq 0 ]; then
        if [ -d /home/$USER/project/databases/$dbname ]; then
            echo "$(tput setaf 1)$(tput setab 7)Database $dbname is Exist$(tput sgr 0)"
            confirmToDelDB $dbname
        else
            echo "$(tput setaf 1)$(tput setab 7)Database $dbname wasn't found$(tput sgr 0)"
            dropDB
            return
        fi
    elif [ $checkname -eq 1 ]; then
        echo "$(tput setaf 1)$(tput setab 7)Wrong Database name format.$(tput sgr 0)"
        dropDB
        return 0
    elif [ $checkname -eq 2 ]; then
        echo "$(tput setaf 1)$(tput setab 7)You didn't enter any thing, Please enter a name$(tput sgr 0)"
        dropDB
        return 0
    fi
}

dropDB
