#!/bin/bash

readData(){
    dbname=$1
    tname=$2
    colnumber=$(wc -l </home/$USER/project/databases/$dbname/$tname.type)
    colnames=($(cut -d: -f1 /home/$USER/project/databases/$dbname/$tname.type))
    coltype=($(awk -F: '{print  $2}' /home/$USER/project/databases/$dbname/$tname.type))

    i=0
    while [ $i -lt $((colnumber-1)) ] 
    do
        read -p "Enter the value of column ${colnames[$i]}: " data
        #when datatype is int
        if [ "${coltype[$i]}" == 'int' ] ;then
            chkIsNum=$(/home/$USER/project/scripts/chkint.sh $data)
            if [ $chkIsNum -eq 0 ] ;then
                #check PK in first column
                if [ $i -eq 0 ] ;then
                    result=$(grep -c -w ^$data /home/$USER/project/databases/$dbname/$tname)
                    if [  $result -gt 0 ] ;then
                        echo "$(tput setaf 1)$(tput setab 7)Primary key is not unique, please enter a different Primary key.$(tput sgr 0)"
                        continue
                    fi
                fi
                #check if it's the last column
                if [ $i -eq $((colnumber-2)) ] ;then
                    record+="$data"
                else
                    record+="$data:"
                fi
                i=$((i+1))
                
            elif [ $chkIsNum -eq 1 ] ;then
                echo "$(tput setaf 1)$(tput setab 7)Please Enter Numbers only$(tput sgr 0)"
                continue
            elif [ $chkIsNum -eq 2 ] ;then
                echo "$(tput setaf 1)$(tput setab 7)You didn't enter any thing, Please enter a number$(tput sgr 0)"
                continue
            fi
        #when datatype is varchar
        else
            checkname=$(/home/$USER/project/scripts/chkname.sh $data)
            if [ $checkname -eq 0 ] ;then
                #check PK in first column
                if [ $i -eq 0 ] ;then
                    result=$(grep -c -w ^$data /home/$USER/project/databases/$dbname/$tname)
                    if [  $result -gt 0 ] ;then
                        echo "$(tput setaf 1)$(tput setab 7)Primary key is not unique, please enter a different Primary key.$(tput sgr 0)"
                        continue
                    fi
                fi
                #check if it's the last column
                if [ $i -eq $((colnumber-2)) ] ;then
                    record+="$data"
                else
                    record+="$data:"
                fi
                i=$((i+1))
                
            elif [ $checkname -eq 1 ] ;then
                echo "$(tput setaf 1)$(tput setab 7)wrong data format$(tput sgr 0)"
                continue
            elif [ $checkname -eq 2 ] ;then
                echo "$(tput setaf 1)$(tput setab 7)You didn't enter any thing, Please enter a name$(tput sgr 0)"
                continue
            fi
        fi
    done
    echo "$record" >> /home/$USER/project/databases/$dbname/$tname
    echo "write into  $tname data $record"
}
checktable(){
    dbname=$1
    read -p "Enter table name: " tname
    checkname=$(/home/$USER/project/scripts/chkname.sh $tname)
    if [ $checkname -eq 0 ] ;then
        #check is this table name is already exist.
        echo "/home/$USER/project/databases/$dbname/$tname"
        if [ -f /home/$USER/project/databases/$dbname/$tname ] ;then
            echo "$(tput setaf 1)$(tput setab 7)This table name is Exist...$(tput sgr 0)"
            readData $dbname $tname
            return 0
        else
            echo "$(tput setaf 1)$(tput setab 7)This table name doesn't Exist...$(tput sgr 0)"
            checktable dbname
            return 0
        fi
    elif [ $checkname -eq 1 ] ;then
        echo "$(tput setaf 1)$(tput setab 7)wrong table name format$(tput sgr 0)"
        return 0 
    elif [ $checkname -eq 2 ] ;then
        echo "$(tput setaf 1)$(tput setab 7)You didn't enter any thing, Please enter a name$(tput sgr 0)"
        return 0
    fi

}

checktable $1
