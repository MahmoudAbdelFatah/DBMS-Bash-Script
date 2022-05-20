#!/bin/bash
dbname=$1
#check rerurn is zero in case there are not any files to list them
if [ -z "$(ls /home/$USER/project/databases/$dbname)" ] ;then
        echo "$(tput setaf 1)$(tput setab 7)There is no files in this database$(tput sgr 0)"
else
    echo "-----$(tput setaf 1)$(tput setab 7)List of Tables$(tput sgr 0)-----"
    ls -l /home/$USER/project/databases/$dbname
fi