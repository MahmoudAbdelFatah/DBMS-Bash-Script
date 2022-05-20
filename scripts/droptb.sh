#!/bin/bash
if [ "$(./chkname.sh $1)" -eq 0 ] ;then
    if [ -f /home/$USER/project/databases/$1/$2 ] ;then
        read -p "Are you sure you want to delete table(y/n) "
        if [ $REPLY == 'y' ] || [ $REPLY == 'Y' ] ;then
            rm /home/$USER/project/databases/$1/$2
            echo Table succesfuly removed 
        fi
    fi
else
    echo wrong name format
fi
