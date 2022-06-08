#!/bin/bash
confirmToDelete() {
    answer=$1
    chechAnswer=$($scriptsPath/chkname.sh $answer)
    if [ $chechAnswer -eq 0 ]; then
        answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
        if [ $answer = "y" ] || [ $answer = "yes" ]; then
            echo 0
        elif [ $answer = "n" -o $answer = "no" ]; then
            echo "${red}sorry, we can't delete table's data without your confirmation.$end" >&2
            echo 1
        else
            echo "${red}please choose from this values (y/n).$end" >&2
            read -p "Are you sure u want to delete data from table ?(y/n)" answer >&2
            confirmToDelete $answer
        fi
    else
        echo "${red}please choose from this values (y/n).$end" >&2
        read -p "Are you sure u want to delete data from table ?(y/n)" answer >&2
        confirmToDelete $answer
    fi
}
deleteByColName() {
    tname=$1
    colnames=($(cut -d: -f1 $path/.$tname.type))
    recordNums=$(wc -l <$path/$tname)
    #if the files is not empty
    if [ $recordNums -gt 0 ] && [ "${#colnames[@]}" -gt 0 ]; then
#get data type of the spacified column
        echo "columns of table are: $red${bg}${colnames[@]}$end"
        read -p "Enter column name you want to delete with: " colName
        check=$($scriptsPath/chkname.sh $colName)
        if [ $check -eq 0 ]; then
            colExist=$(grep -c ^$colName <<<"${colnames[@]}")
            if [ $colExist -gt 0 ]; then
                colType=$(grep -w ^$colName $path/.$tname.type | cut -d: -f2)
                colNumber=$(awk -F: -v coln=$colName '{if(coln==$1) print NR }' $path/.$tname.type)
#Get the column you want to delete in it
                read -p "Enter a value of type $colType to delete: " delSearch
                if [ $colType == 'int' ]; then
                    check=$($scriptsPath/chkint.sh $delSearch)
                else
                    check=$($scriptsPath/chkname.sh $delSearch)
                fi
                if [ $check -eq 0 ]; then
#search for required column and save new data without deleted items in file
                    DataAfterDel=($(awk -F: -v lncol=$colNumber -v word=$delSearch '{
                                                        if(word==$lncol)next; else print $0;}' $path/$tname))
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
# update the table succesfuly
                        else
                            return 0
                        fi
                    else
                        echo "${red}There is no value match your input$end"
                        deleteByColName $tname
                    fi
                else
                    deleteByColName $tname
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
chkPK(){
    tname=$1
    pk=$2
    pkType=$3
    if [ "$pkType" == "int" ]; then
            check=$($scriptsPath/chkint.sh $pk)
    else
            check=$($scriptsPath/chkvarchar.sh $pk)
    fi
    if [ $check -eq 0 ]; then
#search for required PK
        isPk=$(grep -cw ^$pkId $path/$tname)
        if [ $isPk -eq 1 ]; then
            echo 0
        else
            echo "${red}There is no ID match your input $end" >&2
            echo 1
        fi
    else
        echo 1
    fi
}
deleteOneRecord() {
    #delete using pk
    tname=$1
    recordNums=$(wc -l <$path/$tname)
    coltypes=($(cut -d: -f2 $path/.$tname.type))
    #if the files is not empty
    if [ $recordNums -gt 0 ]; then
#get data type of first column as it is the PK column
        read -p "Enter the PK of the column you want as a Data Type of $pkType: " pkId
        isPk=$(chkPK $tname $pkId ${coltypes[0]})
        if [ $isPk -eq 0 ]; then
            read -p "Are you sure u want to delete id : $pkId of $tname table? (y/n) " answer
            confirm=$(confirmToDelete $answer)
            if [ $confirm -eq 0 ]; then
                sed -i "/^$pkId/"'d' $path/$tname
                echo "$red$bg 1 records was effected$end"
            fi
        else
            deleteOneRecord $tname
        fi

    else
        echo "$red No records to delete from them. Using insert to add Records firstly...$end"
        return
    fi

}

deleteAllRecords() {
    tname=$1
    #confirm to delete
    read -p "Are you sure u want to delete all data of $tname table ? (y/n) " answer
    confirm=$(confirmToDelete $answer)
    if [ $confirm -eq 0 ]; then
        recordNums=$(wc -l <$path/$tname)
        echo -n "" >$path/$tname
        echo "$red ${bg}$recordNums records was effected$end"
    else
        deleteAllRecords $tname
        return 0
    fi
}

deleteMenu() {
    tname=$1
    select reply in "delete All Records." "delete using PK." "delete By Column Name." "Exit"; do
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
        fi
    fi
}

main
