#!/bin/bash

#check if lenth of string is zero
if [[ $1 =~ ^[0-9] ]]; then
    echo 0
elif [ -z $1 ]; then
    echo "$red$bg You didn't enter any thing, Please enter a name$end" >&2
    echo 2
else
    echo "$red$bg wrong name format$end" >&2
    echo 1
fi
