#!/bin/bash

confirmToDeltn() {
    tname=$1
    read -p "Are you sure u want to drop $tname table ? (y/n)" answer
    chechAnswer=$($scriptsPath/chkname.sh $answer)
    if [ $chechAnswer -eq 0 ]; then
        answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
        if [ $answer = "y" -o $answer = "yes" ]; then
            rm $path/$tname
            rm $path/.$tname.type
            echo -e "$red${bg}-----The Table $tname is Deleted.-----$end\n"
        elif [ $answer = "n" -o $answer = "no" ]; then
            echo "$red${bg}sorry, we can't delete this table without your confirmation.$end"
        else
            echo "please choose from this values (y/n)."
            confirmToDeltn $tname
        fi
    else 
        confirmToDelDB $dbname
    fi
}

droptb() {
    read -p "Enter table name to delete it: " tname
    checkname=$($scriptsPath/chkname.sh $tname)
    if [ $checkname -eq 0 ]; then
        if [ -f $path/$tname ]; then
            echo "$red${bg}Table $tname is Exist$end"
            confirmToDeltn $tname
        else
            echo "${red}Table $tname wasn't found$end"
            return
        fi
    else
        droptb
    fi
}

droptb
