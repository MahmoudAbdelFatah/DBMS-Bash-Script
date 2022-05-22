#!/bin/bash

checkDBExist() {
    read -p "Enter database name to connect it: " dbname
    checkname=$(/home/$USER/project/scripts/chkname.sh $dbname)
    if [ $checkname -eq 0 ]; then
        if [ -d /home/$USER/project/databases/$dbname ]; then
            echo "$(tput setaf 1)$(tput setab 7)Connected to $dbname Successfully$(tput sgr 0)"
            /home/$USER/project/scripts/tableMenu.sh $dbname
        else
            echo "$(tput setaf 1)$(tput setab 7)Database $dbname wasn't found$(tput sgr 0)"
            checkDBExist
            return
        fi
    elif [ $checkname -eq 1 ]; then
        echo "$(tput setaf 1)$(tput setab 7)Wrong Database name format.$(tput sgr 0)"
        checkDBExist
        return 0
    elif [ $checkname -eq 2 ]; then
        echo "$(tput setaf 1)$(tput setab 7)You didn't enter any thing, Please enter a name$(tput sgr 0)"
        checkDBExist
        return 0
    fi
}

checkDBExist
