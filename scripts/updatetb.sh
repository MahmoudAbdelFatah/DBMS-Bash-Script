#!/bin/bash
colDType=""

removeColumn(){
    tname=$1

    read -p "Enter the column name that u want to remove it: " colName
    checkname=$($scriptsPath/chkname.sh $colName)
    if [ $checkname -eq 0 ] ;then
        #check if this colName is exist or not
        result=$(grep -cw ^$colName $path/.$tname.type)

        if [ $result -gt 0 ] ;then
            #to get the line number of column name which will delete it
            # awk 'match($0,v){print NR; exit}' v=$external_variable input-file
            lineNumber=$(awk -F: -v coln=$colName '{if(coln==$1) print NR }' $path/.$tname.type)
            echo "column number is: $lineNumber"
            if [ $lineNumber -ne 1 ] ;then
                #delete specific line number that contain the column name
                sed -i "$lineNumber"'d' $path/.$tname.type
                
                #--complement: keeps columns other than the ones specified in -f
                outputAfterDel=$(cut --complement -d: -f$lineNumber $path/$tname)
                
                #redirect output of the undeleted columns to overwrite the file to store it
                echo $outputAfterDel > $path/$tname
                
                echo "$red${bg}The column $colName is removed with its data Successfully.$end"
            elif [ $lineNumber -eq 1 ] ;then
                echo "${red}The PK column can't be deleted.$end"
            fi
        else
            echo "${red}There is no column with this name to remove it.$end"
        fi
    else
        removeColumn $tname
    fi
    
}

modifyDatatype(){
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
            check=$($scriptsPath/chkname.sh $pkId)
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
    tname=$1
    colName=$2
    record=""
    #calc number of words to check if the new column name is exirt already or not
    result=$(grep -cw ^$colName $path/.$tname.type)
    #echo "the result is: $result"
    if [ $result -gt 0 ]; then
        echo "${red}This column name is already exist, please enter another one.$end"
    else
        record+="$colName:"
        selectDType
        record+="$colDType"
        echo "new record is: $record"
        echo -e "$record" >> $path/.$tname.type
        echo "$red${bg}the new column $colName with datatype of $colDType is added successfully.$end"
        #should check the file is not empty
        lineNumbers=$(wc -l <$path/$tname)
        if [ $lineNumbers -gt 0 ] ;then
            sed 's/$/:/' -i $path/$tname
        fi
    fi
}

addNewColumn() {
    tname=$1

    read -p "Please Enter the new column name: " colName
    checkName=$($scriptsPath/chkname.sh $colName)
    if [ $checkName -eq 0 ] ;then
        #check column name is unique.
        checkUniqueColName $tname $colName
    fi

}

updateMenu() {
    tname=$1
    select reply in "Add New Column." "Modify DataType." "Remove Column." "Exit"; do
        case $REPLY in
        1)
            addNewColumn $tname
            updateMenu $tname
            return
            ;;
        2)
            modifyDatatype $tname
            updateMenu $tname
            return
            ;;
        3)
            removeColumn $tname
            updateMenu $tname
            return
            ;;
        4)
            return
            ;;
        *)
            echo "Please enter one of these options."
            updateMenu $tname
            return
            ;;
        esac
    done
}

updatetb() {
    read -p "Enter table name to update it: " tname
    checkname=$($scriptsPath/chkname.sh $tname)
    if [ $checkname -eq 0 ]; then
        if [ -f $path/$tname ]; then
            echo "$red$bg Table $tname is Exist$end"
            updateMenu $tname
        else
            echo "${red}Table $tname wasn't found$end"
            updatetb
            return
        fi
    else
        updatetb
        return
    fi
}

updatetb
