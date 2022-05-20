#!/bin/bash
#red=`tput setaf 1`

if [ -z "$(ls /home/$USER/project/databases)" ] ;then
    echo "----------$(tput setaf 1)$(tput setab 7)There is no Databases$(tput sgr 0)----------"

else
    echo "----------$(tput setaf 1)$(tput setab 7)List of Databases$(tput sgr 0)----------"
    ls -l /home/$USER/project/databases
fi