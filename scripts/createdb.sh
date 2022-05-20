#!/bin/bash

checkname=$(/home/$USER/project/scripts/chkname.sh $1)
if [ $checkname -eq 0 ] ;then
    if [ ! -d /home/$USER/project/databases/$1 ] ;then
        mkdir /home/$USER/project/databases/$1
        echo Database created succesfuly
    else
        echo Database already exist
    fi
elif [ $checkname -eq 1 ] ;then
    echo wrong name format
elif [ $checkname -eq 2 ] ;then
    echo "You didn't enter any thing, Please enter a database name"
fi