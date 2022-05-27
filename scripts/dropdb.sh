#!/bin/bash

confirmToDelDB() {
    dbname=$1
    read -p "Are you sure u want to drop $dbname db ? (y/n)" answer
    answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
    if [ $answer = "y" -o $answer = "yes" ]; then
        rm -r $localdb/$dbname
        echo "$red${bg}-----The Database $dbname is Deleted.-----$end" >&2
        echo 0
    elif [ $answer = "n" -o $answer = "no" ]; then
        echo "${red}sorry, we can't delete this database without your confirmation.$end" >&2
        echo 1
    else
        echo "please choose from this values (y/n)." >&2
        confirmToDelDB $dbname
        return
    fi
}

dropDB() {
    read -p "Enter database name to delete it: " -a dbname
    if [ ${#dbname[@]} -ne 1 ] ;then
        echo "Illegal number of parameters" >&2
        echo 1
    else
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
                dropDB
                return
            fi
        else
            echo 1
        fi
    fi

    
}

dropDB
