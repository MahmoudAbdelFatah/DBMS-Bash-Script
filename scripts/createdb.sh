#!/bin/bash


read -p "Enter Database name: " dbname
checkname=$(/home/$USER/project/scripts/chkname.sh $dbname)
if [ $checkname -eq 0 ]; then
    if [ ! -d /home/$USER/project/databases/$dbname ]; then
        mkdir /home/$USER/project/databases/$dbname
        chmod 755 /home/$USER/project/databases/*
        echo "Database created succesfuly." >&2 
        echo 0
    else
        echo "Database already exist, please enter another name: " >&2
        echo 1
    fi
else
    echo 1
fi