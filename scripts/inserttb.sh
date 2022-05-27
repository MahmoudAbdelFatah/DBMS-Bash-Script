#!/bin/bash

readData() {
    tname=$1
    colnumbers=$(wc -l <$path/.$tname.type)
    echo "num of col is: $colnumbers"
    colnames=($(cut -d: -f1 $path/.$tname.type))
    coltype=($(awk -F: '{print  $2}' $path/.$tname.type))

    i=0
    while [ $i -lt $((colnumbers)) ]; do
        read -p "Enter the value of column ${colnames[$i]} with Data Type of ${coltype[$i]}: " data
        #when datatype is int
        if [ "${coltype[$i]}" == 'int' ]; then
            check=$($scriptsPath/chkint.sh $data)
        else
            check=$($scriptsPath/chkvarchar.sh $data)
        fi
        if [ $check -eq 1 -a $i -eq 0 ] ;then
            continue
        fi
        if [ $check -lt 2 ]; then
            #check PK in first column is unique
            if [ $i -eq 0 ]; then
                result=$(grep -cw ^$data $path/$tname)
                if [ $result -gt 0 ]; then
                    echo "${red}Primary key is not unique, please enter a different Primary key.$end"
                    continue
                fi
            fi
            #check if it's the last column
            if [ $i -eq $((colnumbers - 1)) ]; then
                record+="$data"
            else
                record+="$data:"
            fi
            i=$((i + 1))

        else  
            continue
        fi
      
    done
    echo "$record" >>$path/$tname
    echo "write into  $tname data $record"
}

checktable() {
    read -p "Enter table name: " tname
    checkname=$($scriptsPath/chkname.sh $tname)
    if [ $checkname -eq 0 ]; then
        #check is this table name is already exist.
        if [ -f $path/$tname ]; then
            echo "$red${bg}This table name is Exist...$end"
            readData $tname
            return
        else
            echo "${red}This table name doesn't Exist...$end"
            checktable
            return
        fi
    else
        checktable
    fi
}

checktable
