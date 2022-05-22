#!/bin/bash
path=/home/$USER/project/databases
red="$(tput setaf 1)"
end="$(tput sgr 0)"
bg="$(tput setab 7)"

selectByColNum() {
    dbname=$1
    tname=$2

    colNums=$(wc -l <$path/$dbname/$tname.type)
    #get number of records in a file
    recordNums=($(wc -l $path/$dbname/$tname))

    #if the files is not empty
    if [ $recordNums -gt 0 ]; then
        read -p "Enter the Column name: " colNum
        checkNum=$(/home/$USER/project/scripts/chkint.sh $colNum)

        if [ $checkNum -eq 0 ]; then
            if [ $colNum -lt $colNums -a $colNum -gt 0 ]; then
                #go to line number n with sed and return it, then get the first field as the col name
                colName=$(sed -n ${colNum}p $path/$dbname/$tname.type | cut -d: -f1)
                echo "$red$colName$end"
                cut -d: -f$colNum $path/$dbname/$tname
            else
                echo "the number of Columns is only: $colNums, Please input a number in this range 1:$colNums"
                selectByColNum $dbname $tname
            fi
        elif [ $checkNum -eq 1 ]; then
            echo "$red$bg wrong data input format, Must be int$end"
            selectByColNum $dbname $tname
            return
        elif [ $checkNum -eq 2 ]; then
            echo "$red$bg You didn't enter any thing, Please enter a name$end"
            selectByColNum $dbname $tname
            return
        fi

    else
        echo "$red No records to select from them. Using inesert to add Records firstly...$end"
        return
    fi

}

selectOneRecord() {
    #select using pk
    dbname=$1
    tname=$2
    colNums=$(wc -l <$path/$dbname/$tname.type)
    #get number of records in a file to loop searching for PK
    recordNums=($(wc -l $path/$dbname/$tname))

    #if the files is not empty
    if [ $recordNums -gt 0 ]; then
        #get data type of first column as it is the PK column
        colDtype=($(head -1 $path/$dbname/$tname.type | cut -d: -f2))
        read -p "Enter the PK of the column you want as a Data Type of $colDtype: " pkId

        #get all records to loop searching for PK input
        records=($(cat $path/$dbname/$tname))
        i=0
        #loop on number of records to search for the input pk
        while [ $i -lt $((recordNums)) ]; do
            recordsId=($(cut -d: -f1 $path/$dbname/$tname))
            if [ $colDtype == 'int' ]; then
                chkIsNum=$(/home/$USER/project/scripts/chkint.sh $pkId)
                if [ $chkIsNum -eq 0 ]; then
                    if [ "${recordsId[$i]}" == "$pkId" ]; then
                        result=$(echo ${records[$i]} | tr ': ' '\t')
                        echo -e "The Record with PK $red $pkId $end is:\n $red $result $end"
                        return
                    fi
                    if [ $i -eq $((recordNums - 1)) ]; then
                        echo "$red No records with this PK to display.$end"
                        return
                    fi
                elif [ $chkIsNum -eq 1 ]; then
                    echo "$red$bg Please Enter Numbers only$end"
                    selectOneRecord $dbname $tname
                    return
                elif [ $chkIsNum -eq 2 ]; then
                    echo "$red$bg You didn't enter any thing, Please enter a number$end"
                    selectOneRecord $dbname $tname
                    return
                fi
            #when datatype is varchar
            else
                checkname=$(/home/$USER/project/scripts/chkname.sh $pkId)
                if [ $checkname -eq 0 ]; then
                    if [ "${recordsId[$i]}" == "$pkId" ]; then
                        result="${records[$i]}"
                        echo "The Record with PK $red $pkId $end is: $red $result $end"
                        return
                    fi
                    if [ $i -eq $((recordNums - 1)) ]; then
                        echo "$red No records with this PK to display.$end"
                        return
                    fi
                elif [ $checkname -eq 1 ]; then
                    echo "$red$bg wrong data input format, Must be String$end"
                    selectOneRecord $dbname $tname
                    return
                elif [ $checkname -eq 2 ]; then
                    echo "$red$bg You didn't enter any thing, Please enter a name$end"
                    selectOneRecord $dbname $tname
                    return
                fi
            fi
            i=$((i + 1))
        done
    else
        echo "$red No records to select from them. Using inesert to add Records firstly...$end"
        return
    fi

}

selectAllRecords() {
    dbname=$1
    tname=$2
    echo "$red$bg ALL RECORDS OF TABLE $tname$end"
    #TODO: display columns names before the data, it is an option
    #using tr to translate the delimiter of : to \t2
    colName=$(cut -d: -f1 $path/$dbname/$tname.type | tr '\n' "\t")
    echo -e "$red$colName$end"
    records=$(cat $path/$dbname/$tname | tr ':' '\t')
    echo -e "$records"
    echo -e "-------------------------\n"
}

selectMenu() {
    dbname=$1
    tname=$2
    select reply in "Select All Records." "Select A Record." "Select By Column Number." "Exit"; do
        case $REPLY in
        1)
            selectAllRecords $dbname $tname
            selectMenu $dbname $tname
            return
            ;;
        2)
            selectOneRecord $dbname $tname
            selectMenu $dbname $tname
            return
            ;;
        3)
            selectByColNum $dbname $tname
            selectMenu $dbname $tname
            return
            ;;
        4)
            return
            ;;
        *)
            echo "Please enter one of these options."
            selectMenu $dbname $tname
            return
            ;;
        esac
    done
}

selecttb() {
    dbname=$1
    read -p "Enter table name to select from it: " tname
    checkname=$(/home/$USER/project/scripts/chkname.sh $tname)
    if [ $checkname -eq 0 ]; then
        if [ -f /home/$USER/project/databases/$dbname/$tname ]; then
            echo "$red$bg Table $tname is Exist$end"
            selectMenu $dbname $tname
        else
            echo "$red$bg Table $tname wasn't found$end"
            selecttb $dbname
            return
        fi
    elif [ $checkname -eq 1 ]; then
        echo "$red$bg Wrong Table name format.$end"
        selecttb $dbname
        return 0
    elif [ $checkname -eq 2 ]; then
        echo "$red$bg You didn't enter any thing, Please enter a name$end"
        selecttb $dbname
        return 0
    fi
}

selecttb $1
