#!/bin/bash
colDType=""

lsColNames() {
    tname=$1
    echo -e "${red}Name\tDT$end"
    cat $path/.$tname.type | tr ":" "\t"

}

removeColumn() {
    tname=$1

    read -p "Enter the column name that u want to remove it: " colName
    checkname=$($scriptsPath/chkname.sh $colName)
    if [ $checkname -eq 0 ]; then
        #check if this colName is exist or not
        result=$(grep -cw ^$colName $path/.$tname.type)

        if [ $result -gt 0 ]; then
            #to get the line number of column name which will delete it
            lineNumber=$(awk -F: -v coln=$colName '{if(coln==$1) print NR }' $path/.$tname.type)
            echo "column number is: $lineNumber"
            if [ $lineNumber -ne 1 ]; then
                #delete specific line number that contain the column name
                sed -i "$lineNumber"'d' $path/.$tname.type

                #delete the associated data with this column
                #--complement: keeps columns other than the ones specified in -f
                outputAfterDel=$(cut --complement -d: -f$lineNumber $path/$tname)

                #redirect output of the undeleted columns to overwrite the file to store it
                echo $outputAfterDel >$path/$tname

                echo "$red${bg}The column $colName is removed with its data Successfully.$end"
            elif [ $lineNumber -eq 1 ]; then
                echo "${red}The PK column can't be deleted.$end"
            fi
        else
            echo "${red}There is no column with this name to remove it.$end"
        fi
    else
        removeColumn $tname
    fi

}

modifyDatatype() {
    #select using pk
    tname=$1
    colnames=($(cut -d: -f1 $path/.$tname.type))

    echo "The column names are: $red${colnames[@]}$end"

    read -p "Enter the column name that u want to modify its datatype: " colName

    coltype=($(awk -F: '{print  $2}' $path/.$tname.type))
    checkname=$($scriptsPath/chkname.sh $colName)

    if [ $checkname -eq 0 ]; then
        #check if this colName is exist or not
        result=$(grep -cw ^$colName $path/.$tname.type)

        if [ $result -gt 0 ]; then
            #get the line number of column name which will delete it
            lineNumber=$(awk -F: -v coln=$colName '{if(coln==$1) print NR }' $path/.$tname.type)
            echo "column number is: $lineNumber"
            if [ $lineNumber -ne 1 ]; then
                #check datatype before modify
                i=$((lineNumber - 1))
                if [ "${coltype[$i]}" == 'int' ]; then
                    echo "${red}You can't modify this column, you can't convert from int to varchar datatype$end"
                else
                    #update data type if its int to be varchar
                    #FS contains the file delimiter, by default the space is used to concatenate
                    getoutput=$(awk -F: -v coln=$lineNumber '{if(NR==coln)$2="int";}1' OFS=: $path/.$tname.type)
                    echo "$getoutput" >$path/.$tname.type
                    echo "$red${bg}The column $colName is modified the new datatype Successfully.$end"
                fi
            elif [ $lineNumber -eq 1 ]; then
                echo "${red}The PK column can't be Modified.$end"
            fi
        else
            echo "${red}There is no column with this name to modify its datatype.$end"
        fi
    else
        modifyDatatype $tname
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
        echo -e "$record" >>$path/.$tname.type
        echo "$red${bg}the new column $colName with datatype of $colDType is added successfully.$end"
        #should check the file is not empty
        lineNumbers=$(wc -l <$path/$tname)
        if [ $lineNumbers -gt 0 ]; then
            sed 's/$/:/' -i $path/$tname
        fi
    fi
}

addNewColumn() {
    tname=$1

    read -p "Please Enter the new column name: " colName
    checkName=$($scriptsPath/chkname.sh $colName)
    if [ $checkName -eq 0 ]; then
        #check column name is unique.
        checkUniqueColName $tname $colName
    fi

}

updateMenu() {
    tname=$1
    select reply in "Add New Column." "Modify DataType." "Remove Column." "List column names." "Exit"; do
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
            lsColNames $tname
            updateMenu $tname
            return
            ;;
        5)
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
