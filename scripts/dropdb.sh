#!/bin/bash

confirmToDelDB() {
    dbname=$1
    
    read -p "Are you sure u want to drop $dbname db (y/n): " answer >&2
    chechAnswer=$($scriptsPath/chkname.sh $answer)
    if [ $chechAnswer -eq 0 ]; then
        answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
        if [ $answer = "y" -o $answer = "yes" ]; then
            rm -r $localdb/$dbname
            echo -e "$red${bg}-----The Database $dbname is Deleted.-----$end\n" >&2
            echo 0
        elif [ $answer = "n" -o $answer = "no" ]; then
            echo "${red}sorry, we can't delete this database without your confirmation.$end" >&2
            echo 1
        else
            echo "please choose from this values (y/n)." >&2
            confirmToDelDB $dbname
        fi
    else 
        confirmToDelDB $dbname
    fi
}

dropDB() {
    read -p "Enter database name to delete it: " dbname
    checkname=$($scriptsPath/chkname.sh $dbname)
    if [ $checkname -eq 0 ]; then
        if [ -d $localdb/$dbname ]; then
            echo "$bg${red}Database $dbname is Exist$end" >&2
            checkConfirm=$(confirmToDelDB $dbname)
            if [ $checkConfirm -eq 0 ] ;then
                echo 0
            else
                echo 1
            fi
        else
            echo "${red}Database $dbname wasn't found$end" >&2
            echo 1
        fi
    else 
        echo 1
    fi
}

dropDB
