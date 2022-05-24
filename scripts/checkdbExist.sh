#!/bin/bash

checkDBExist() {
    read -p "Enter database name to connect it: " dbname
    checkname=$($scriptsPath/chkname.sh $dbname)
    if [ $checkname -eq 0 ]; then
        if [ -d /home/$USER/project/databases/$dbname ]; then
            echo "$(tput setaf 1)$(tput setab 7)Connected to $dbname Successfully$(tput sgr 0)"
            $scriptsPath/tableMenu.sh $dbname
        else
            echo "$(tput setaf 1)$(tput setab 7)Database $dbname wasn't found$(tput sgr 0)"
            checkDBExist
            return
        fi
    else
        checkDBExist
        return 0
    fi
}

checkDBExist
