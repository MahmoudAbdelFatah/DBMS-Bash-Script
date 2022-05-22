#!/bin/bash

#check if lenth of string is zero
if [ -z $1 ]; then
    echo 2
elif [[ $1 =~ ^[0-9] ]]; then
    echo 0
else
    echo 1
fi
