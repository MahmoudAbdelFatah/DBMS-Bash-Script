#!/bin/bash
dbname=$1
if [ -z "$(ls /home/$USER/project/databases/$dbname)" ] ;then
    echo "There is no files in this database"
else
    ls -l /home/$USER/project/databases/$dbname
fi