#!/bin/bash

#check rerurn is zero in case there are not any files to list them
if [ -z "$(ls $path)" ]; then
    echo "${red}There is no tables in this database$end"
else
    echo "-----$red${bg}List of Tables$end-----"
    ls  $path
fi
