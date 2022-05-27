#!/bin/bash

read -p "Enter Database name: " dbname
checkname=$($scriptsPath/chkname.sh $dbname)
if [ $checkname -eq 0 ]; then
    if [ ! -d $localdb/$dbname ]; then
        mkdir $localdb/$dbname
        chmod 755 $localdb/*
        echo "$red${bg}Database created succesfuly.$end" >&2
        echo 0
    else
        echo "${red}Database already exist, please enter another name.$end " >&2
        echo 1
    fi
else
    echo 1
fi
