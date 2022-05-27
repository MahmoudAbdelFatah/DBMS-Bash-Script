#!/bin/bash

checkDBExist() {
    read -p "Enter database name to connect it: " dbname
    checkname=$($scriptsPath/chkname.sh $dbname)
    if [ $checkname -eq 0 ] ;then
        if [ -d $localdb/$dbname ] ;then
            echo -e "$red${bg}You are connected to $dbname Successfully$end\n"
            $scriptsPath/tableMenu.sh $dbname
        else
            echo "$red${bg}Database $dbname wasn't found$end"
            checkDBExist
            return
        fi
    else
        checkDBExist
        return
    fi
}

checkDBExist
