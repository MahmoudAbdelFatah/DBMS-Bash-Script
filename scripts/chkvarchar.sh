#!/bin/bash

#check if length of string is zero
if [ $# -gt 1 ]; then
    echo "${red}Name can't have space$end" >&2
    echo 2
elif [[ ! $1 =~ [:]+ ]]; then
    echo 0
else
    echo "${red}Wrong name format$end" >&2
    echo 1
fi


