#!/bin/bash

#check if length of string is zero
if [ $# -gt 1 ]; then
    echo "${red}Name can't have space$end" >&2
    echo 2
elif [ -z $1 ]; then
    echo "${red}You didn't enter any thing, Please enter a name$end" >&2
    echo 1
elif [[ $1 =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
    echo 0
else
    echo "${red}Wrong name format$end" >&2
    echo 2
fi
