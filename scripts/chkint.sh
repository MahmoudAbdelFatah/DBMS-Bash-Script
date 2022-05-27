#!/bin/bash

#check if lenth of string is zero
if [[ $1 =~ ^[0-9]+$ ]]; then
    echo 0
elif [ -z $1 ]; then
    echo "${red}You didn't enter any thing.$end" >&2
    echo 1
else
    echo "${red}Please Enter Numbers only.$end" >&2
    echo 2
fi
