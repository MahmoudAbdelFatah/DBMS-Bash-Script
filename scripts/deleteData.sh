#!/bin/bash
confirmToDelete(){
    answer=$1
    chechAnswer=$($scriptsPath/chkname.sh $answer)
    if [ $chechAnswer -le 1 ] ;then
        answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
        if [ $answer = "y" ] || [ $answer = "yes" ]; then
            echo 0
        elif [ $answer = "n" -o $answer = "no" ]; then
            echo "$red${bg}sorry, we can't delete table's data without your confirmation.$end" >&2
            echo 1
        else
            echo "${red}please choose from this values (y/n).$end" >&2
            echo 1
        fi
    fi
}
deleteByColName() {
    tname=$1
    read -d ' ' -a colnames <<<"$(cut -d: -f1 $path/.$tname.type)"
    #get number of records in a file
    recordNums=$(wc -l <$path/$tname)
    #if the files is not empty
    if [ $recordNums -gt 0 ] && [ "${#colnames[@]}" -gt 0 ]; then
        #get data type of the spacified column
        echo -e "columns of table are: $red${bg}${colnames[@]}$end"
        read -p "Enter column name you want to delete with: " colName
        check=$($scriptsPath/chkname.sh $colName)
        if [ $check -eq 0 ]; then
            colExist=$(grep -c $colName <<<"${colnames[@]}")
            if [ $colExist -gt 0 ]; then
                colType=$(grep -w $colName $path/.$tname.type | cut -d: -f2)

                read -p "Enter a value of type $colType to delete: " delSearch
                if [ $colType == 'int' ]; then
                    check=$($scriptsPath/chkint.sh $delSearch)
                else
                    check=$($scriptsPath/chkname.sh $delSearch)
                fi
                if [ $check -eq 0 ]; then
                    #search for required column and save new data without deleted items in file
                    colNumber=$(awk -F: -v coln=$colName '{if(coln==$1) print NR }' $path/.$tname.type)
                    DataAfterDel=($(awk -F: -v lncol=$colNumber -v word=$delSearch '{
                                                        if(word==$lncol)next;
                                                        else print $0;}' $path/$tname))
                    effectedRow=$(($recordNums - ${#DataAfterDel[@]}))
                    if [ $effectedRow -gt 0 ]; then
                        read -p "Are you sure u want to delete $colName: $delSearch from  $tname table ?(y/n)" answer
                        confirm=$(confirmToDelete $answer)
                        if [ $confirm -eq 0 ]; then
                            echo -n "" >$path/$tname
                            for i in "${DataAfterDel[@]}"; do
                                echo $i >>$path/$tname
                            done
                            echo "$red${bg}$effectedRow records was effected$end"
                            ## we update the table succesfuly

                        else
                            deleteByColName $tname
                            return 0
                        fi
                    else
                        echo "${red}There is no value match your input$end"
                    fi
                else
                    deleteByColName
                fi
            else
                echo "${red}You Entered wrong column name$end"
                deleteByColName $tname
            fi
        else
            deleteByColName $tname
        fi

    else
        echo "${red}No records to delete from them. Using inesert to add Records firstly...$end"
        return
    fi

}

deleteOneRecord() {
    #delete using pk
    tname=$1
    coltypes=($(cut -d: -f2 $path/.$tname.type))
    #get number of records in a file
    recordNums=$(wc -l <$path/$tname)
    colNums=$(wc -l <$path/.$tname.type)
    #if the files is not empty
    if [ $recordNums -gt 0 ]; then
        #get data type of first column as it is the PK column
        pkType=${coltypes[0]}
        read -p "Enter the PK of the column you want as a Data Type of $pkType: " pkId
        if [ "$pkType" == "int" ]; then
            check=$($scriptsPath/chkint.sh $pkId)
        else
            check=$($scriptsPath/chkname.sh $pkId)
        fi
        if [ $check -eq 0 ]; then
            #search for required PK
            isPk=$(grep -cw ^$pkId $path/$tname)
            if [ $isPk -eq 1 ]; then
                read -p "Are you sure u want to delete id : $pkId of $tname table? (y/n) " answer
                confirm=$(confirmToDelete $answer)
                if [ $confirm -eq 0 ]; then
                    sed -i "/^$pkId/"'d' $path/$tname
                    echo "$red$bg 1 records was effected$end"
                else
                    deleteOneRecord $tname
                    return 0
                fi
            else
                echo "${red}There is no ID match your input $end"
            fi
        else
            deleteOneRecord $tname
        fi

    else
        echo "$red No records to delete from them. Using inesert to add Records firstly...$end"
        return
    fi

}

deleteAllRecords() {
    tname=$1
    #display columns name
    colName=$(cut -d: -f1 $path/.$tname.type | tr '\n' "\t")
    #confirm to delete
    read -p "Are you sure u want to delete all data of $tname table ? (y/n) " answer
    confirm=$($confirmToDelete $answer)
    if [ $confirm -eq 0 ]; then
        recordNums=$(wc -l <$path/$tname)
        echo "" >$path/$tname
        echo "$recordNums records was effected"
    else
        deleteAllRecords $tname
        return 0
    fi
}

deleteMenu() {
    tname=$1
    select reply in "delete All Records." "delete using PK." "delete By Column Number." "Exit"; do
        case $REPLY in
        1)
            deleteAllRecords $tname
            deleteMenu $tname
            return
            ;;
        2)
            deleteOneRecord $tname
            deleteMenu $tname
            return
            ;;
        3)
            deleteByColName $tname
            deleteMenu $tname
            return
            ;;
        4)
            return
            ;;
        *)
            echo "Please enter one of these options."
            deleteMenu $tname
            return
            ;;
        esac
    done
}

main() {
    read -p "Enter table name: " tname
    checktable=$($scriptsPath/chkname.sh $tname)
    if [ "$checktable" -eq 0 ]; then
        if [ -f $path/$tname ]; then
            echo "$red$bg This table name is Exist...$end"
            deleteMenu $tname
        else
            echo "$red$bg This table name doesn't Exist...$end"
            main
        fi
    else
        main
    fi
}

main
