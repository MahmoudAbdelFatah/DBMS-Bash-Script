#!/bin/bash

if [ -z "$(ls $localdb)" ]; then
    echo "----------${red}There is no Databases$end----------"

else
    echo "----------$red${bg}List of Databases$end----------"
    ls  $localdb
fi
