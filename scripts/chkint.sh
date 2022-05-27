#!/bin/bash


if [ $# -gt 1 ]; then
    echo "${red}Input can't have space.$end" >&2
    echo 2
elif [[ $1 =~ ^[0-9]+$ ]]; then
    echo 0
elif [ -z $1 ]; then
    echo "${red}You didn't enter any thing.$end" >&2
    echo 1
else
    echo "${red}Please Enter Numbers only.$end" >&2
    echo 2
fi
