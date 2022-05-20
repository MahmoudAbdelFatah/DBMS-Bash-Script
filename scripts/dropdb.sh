#!/bin/bash

confirmToDelDB(){
    dbname=$1
    read -p "Are you sure u want to drop $dbname db ? (y/n)" answer
    answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
    if [ $answer = "y" -o $answer = "yes" ] ;then
        rm -r /home/$USER/project/databases/$dbname
        echo "$(tput setaf 1)$(tput setab 7)-----The Database $dbname is Deleted.-----$(tput sgr 0)"
    elif [ $answer = "n" -o $answer = "no" ] ;then
        echo "$(tput setaf 1)$(tput setab 7)sorry, we can't delete this database without your confirmation.$(tput sgr 0)"
    else
        echo "please choose from this values (y/n)."
        confirmToDelDB $dbname
        return 0
    fi
}

read -p "Enter database name to delete it: " dbname
cd /home/$USER/project/databases/$dbname 2> /dev/null
if [ $? -eq 0 ] ;then
    echo "$(tput setaf 1)$(tput setab 7)Database $dbname is Exist$(tput sgr 0)"
    confirmToDelDB $dbname
else
    echo "$(tput setaf 1)$(tput setab 7)Database $dbname wasn't found$(tput sgr 0)"
fi

