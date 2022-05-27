#!/bin/bash

#check if length of string is zero
if [ $# -gt 1 ]; then
    echo "${red}varchar can't have spaces.$end" >&2
    echo 2
elif [ -z $1 ]; then
    echo "${red}You didn't enter any thing.$end" >&2
    echo 1
elif [[ ! $1 =~ [:]+ ]]; then
    #accept all special characters except :
    echo 0
else
    echo "${red}Wrong name format.$end" >&2
    echo 1
fi


