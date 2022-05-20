#!/bin/bash

if [ -z "$(ls /home/$USER/project/databases)" ] ;then
    echo There is no database
else
    ls -l /home/$USER/project/databases
fi