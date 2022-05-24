#!/bin/bash
red="$(tput setaf 1)"
end="$(tput sgr 0)"
#check if lenth of string is zero
if [ -z $1 ]; then
    echo 2
    echo "$red You didn't enter any thing, Please enter a name$end" >&2
elif [[ $1 =~ ^[a-zAZ09]+ ]]; then
    if [[ ! $1 =~ ['!@#$%^&*/\?()-;:.,<>{}،؛÷+']+ ]]; then
        echo 0
    else
        echo 1
        echo "$red wrong name format$end" >&2
    fi
else
    echo 1
    echo "$red wrong name format$end" >&2
fi
