#!/bin/bash

#check if length of string is zero
if [ -z $1 ]; then
    echo "${red}You didn't enter any thing, Please enter a name$end" >&2
    echo 1
elif [[ $1 =~ ^[a-zAZ09_]+ ]]; then
    if [[ ! $1 =~ ['!@#$%^&*/\?()-;:.,<>{}،؛÷+']+ ]]; then
        echo 0
    else
        echo "${red}Wrong name format$end" >&2
        echo 1
    fi
else
    echo "${red}Wrong name format$end" >&2
    echo 1
fi
