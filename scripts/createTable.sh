#!/bin/bash

colDType=""
createTableFiles() {
    tname=$1

    if [ ! -f $path/$tname ]; then
        touch $path/$tname
        touch $path/.$tname.type
        chmod 755 $path/*
        echo "------$red${bg}Table has been created successfully$end-----"
    fi

}

#check the data type of the each column and enforce user to chose from select[int,varchar]
selectDType() {
    select dtype in "int" "varchar"; do
        case $REPLY in
        1)
            colDType=$dtype
            break
            ;;
        2)
            colDType=$dtype
            break
            ;;
        *)
            echo "Please enter one of these options."
            selectDType
            return
            ;;
        esac
    done

}

checkUniqueColName() {
    i=$1
    records=$2
    if [ $i -eq 0 ]; then
        echo "$red${bg}First column must be PRIMARY KEY.$end"
    fi
    read -p "Enter Column Name #$((i + 1)): " colName
    checkname=$($scriptsPath/chkname.sh $colName)
    if [ $checkname -eq 0 ]; then
        if [ $i -gt 0 ]; then
            #check if the column name is unique.
            result=$(echo -e $records | awk -v tmp=$colName -F: '{
                    if(tmp == $1) 
                    {
                        print $1;
                        exit;
                    }
                }')
            if [ ! -z $result ]; then
                echo "$red${bg}column name is not unique, please enter a different column name.$end"
                checkUniqueColName $i $records
                return
            fi
        fi
        selectDType
    else
        checkUniqueColName $i $records
    fi
}

setRecords() {
    tname=$1
    colNum=$2

    i=0
    record=""
    colDType=""
    while [ $i -lt $colNum ]; do
        checkUniqueColName $i $record        
        if [ $i -eq $(($colNum-1)) ] ;then
            record+="${colName}:${colDType}"
        else
            record+="${colName}:${colDType}\n"
        fi
        i=$((i + 1))
    done
    #create table files in case of all data is true only.
    createTableFiles $tname
    #The \n escape sequence indicates a line feed.
    #Passing the -e argument to echo enables interpretation of escape sequences.
    echo -e $record >>$path/.$tname.type

}

tableFormat() {
    tname=$1
    read -p "Enter the number of columns: " colNum
    chkIsNum=$($scriptsPath/chkint.sh $colNum)
    if [ $chkIsNum -eq 0 ]; then
        setRecords $tname $colNum
    else
        tableFormat $tname
    fi
}

createTable() {
    echo "----------$red${bg}Create Table$end----------"
    read -p "Enter table name: " tname
    checkname=$($scriptsPath/chkname.sh $tname)
    if [ $checkname -eq 0 ]; then
        #check is this table name is already exist.
        if [ -f $path/$tname ]; then
            echo "$red${bg}This table name is Exist...$end"
            createTable
            return 0
        else
            tableFormat $tname
            return 0
        fi
        tableFormat $tname
    else
        createTable
    fi

}

createTable 
