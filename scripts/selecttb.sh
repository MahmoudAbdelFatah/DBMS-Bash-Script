#!/bin/bash

selectByColNum() {
    tname=$1
    colnames=($(cut -d: -f1 $path/.$tname.type))

    #get number of records in a file
    colNums=$(wc -l <$path/.$tname.type)
    
    #get number of records in a file
    recordNums=$(wc -l <$path/$tname)

    #if the files is not empty
    if [ $recordNums -gt 0 ]; then
        echo "The column names are: $red${colnames[@]}$end"
        read -p "Enter the Column name from the columns above: " colName
        checkName=$($scriptsPath/chkname.sh $colName)
        if [ $checkName -eq 0 ]; then
            #<<< is meaning here string, take input as string
            #colExist=$(grep -cw $colName $path/.$tname.type) =
            colExist=$(grep -cw $colName <<< "${colnames[@]}")
            if [ $colExist -gt 0 ]; then
                colNum=$(awk -F: -v coln=$colName '{if(coln==$1) print NR }' $path/.$tname.type)
                #go to line number n with sed and return it, then get the first field as the col name
                echo "$red$colName$end"
                cut -d: -f$colNum $path/$tname
                echo -e "-------------------------\n"
                
            else
                echo "${red}Column doesn't Exist$end"
            fi
        else
            selectByColNum $tname
            return
        fi

    else
        echo "${red}No records to select from them. Using inesert to add Records firstly...$end"
        return
    fi

}

selectOneRecord() {
    #select using pk
    tname=$1
    colNums=$(wc -l <$path/.$tname.type)
    #get number of records in a file to loop searching for PK
    recordNums=$(wc -l <$path/$tname)

    #if the files is not empty
    if [ $recordNums -gt 0 ]; then
        #get data type of first column as it is the PK column
        colDtype=($(head -1 $path/.$tname.type | cut -d: -f2))
        read -p "Enter the PK of the column you want as a Data Type of $colDtype: " pkId

        #get all records to loop searching for PK input
        records=$(cat $path/$tname)
        #loop on number of records to search for the input pk
        if [ $colDtype == 'int' ]; then
            check=$($scriptsPath/chkint.sh $pkId)
        else
            check=$($scriptsPath/chkvarchar.sh $pkId)
        fi
        if [ $check -eq 0 ]; then
            #search for required PK
            isPk=$(grep -cw ^$pkId $path/$tname)
            if [ $isPk -eq 1 ]; then
                colName=$(cut -d: -f1 $path/.$tname.type | tr '\n' "\t")
                echo -e "$red$colName$end"
                sed -n "/^$pkId/p" $path/$tname | tr ':' '\t' 
                echo -e "-------------------------\n"
            else
                echo "${red}There is no ID match your input$end"  
            fi 
        else
            selectOneRecord $tname
        fi
    else
        echo "${red}No records to select from them. Using inesert to add Records firstly...$end"
        return
    fi

}

selectAllRecords() {
    tname=$1
    echo "$red${bg}ALL RECORDS OF TABLE $tname$end"
    #using tr to translate the delimiter of : to \t2
    colName=$(cut -d: -f1 $path/.$tname.type | tr '\n' "\t")
    echo -e "$red$colName$end"
    records=$(cat $path/$tname | tr ':' '\t')
    echo -e "$records"
    echo -e "-------------------------\n"
}

selectMenu() {
    tname=$1
    select reply in "Select All Records." "Select A Record." "Select By Column Number." "Exit"; do
        case $REPLY in
        1)
            selectAllRecords $tname
            selectMenu $tname
            return
            ;;
        2)
            selectOneRecord $tname
            selectMenu $tname
            return
            ;;
        3)
            selectByColNum $tname
            selectMenu $tname
            return
            ;;
        4)
            return
            ;;
        *)
            echo "Please enter one of these options."
            selectMenu $tname
            return
            ;;
        esac
    done
}

selecttb() {
    read -p "Enter table name to select from it: " tname
    checkname=$($scriptsPath/chkname.sh $tname)
    if [ $checkname -eq 0 ]; then
        if [ -f $path/$tname ]; then
            echo "$red$bg Table $tname is Exist$end"
            selectMenu $tname
        else
            echo "${red}Table $tname wasn't found$end"
            selecttb
            return
        fi
    else
        selecttb
        return 0
    fi
}

selecttb 
