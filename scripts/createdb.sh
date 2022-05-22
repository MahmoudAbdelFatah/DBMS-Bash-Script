#!/bin/bash

createdb() {
    read -p "Enter Database name: " dbname
    checkname=$(/home/$USER/project/scripts/chkname.sh $dbname)
    if [ $checkname -eq 0 ]; then
        if [ ! -d /home/$USER/project/databases/$dbname ]; then
            mkdir /home/$USER/project/databases/$dbname
            chmod 755 /home/$USER/project/databases/*
            echo "Database created succesfuly."
        else
            echo "Database already exist, please enter another name: "
            createdb
            return
        fi
    elif [ $checkname -eq 1 ]; then
        echo "Wrong Name format"
        createdb
        return
    elif [ $checkname -eq 2 ]; then
        echo "You didn't enter any thing, Please enter a database name"
        createdb
        return
    fi

}

createdb
