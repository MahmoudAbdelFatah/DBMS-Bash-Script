#!/bin/bash

if [ -z "$(ls /home/$USER/project/databases)" ] ;then
    echo There is no database
else
    ls /home/$USER/project/databases
fi