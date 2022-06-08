#!/bin/bash

confirmToModify() {
    answer=$1
    chechAnswer=$($scriptsPath/chkname.sh $answer)
    if [ $chechAnswer -eq 0 ]; then
        answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
        if [ $answer = "y" ] || [ $answer = "yes" ]; then
            echo 0
        elif [ $answer = "n" -o $answer = "no" ]; then
            echo "${red}sorry, we can't update table's data without your confirmation.$end" >&2
            echo 1
        else
            echo "${red}please choose from this values (y/n).$end" >&2
            read -p "Are you sure u want to update data in table ?(y/n)" answer >&2
            confirmToModify $answer
        fi
    else
        echo "${red}please choose from this values (y/n).$end" >&2
        read -p "Are you sure u want to update data in table ?(y/n)" answer >&2
        confirmToModify $answer
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
        if [ $(grep -cw ^$pk $path/$tname) -eq 1 ]; then
            echo 0
        else
            echo "${red}There is no ID match your input $end" >&2
            echo 1
        fi
    else
        echo 1
    fi
}

modifyByColName() {
    tname=$1
    colnames=($(cut -d: -f1 $path/.$tname.type))
    #get number of records in a file
    recordNums=$(wc -l <$path/$tname)
    #if the files is not empty
    if [ $recordNums -gt 0 ]; then
        #get data type of the spacified column
        echo -e "columns name : $red${bg}${colnames[@]}$end"
        read -p "Enter column name you want to update it: " colName
        check=$($scriptsPath/chkname.sh $colName)
        if [ $check -eq 0 ]; then
            colExist=$(grep -cw ^$colName $path/.$tname.type)
            if [ $colExist -gt 0 ]; then
                colNumber=$(awk -F: -v coln=$colName '{if(coln==$1) print NR }' $path/.$tname.type)
                colType=$(grep -w ^$colName $path/.$tname.type | cut -d: -f2)
#Get the old value that will be modified
                read -p "Enter a value of type $colType you want to modify: " oldValue
                if [ $colType == 'int' ]; then
                    check=$($scriptsPath/chkint.sh $oldValue)
                else
                    check=$($scriptsPath/chkvarchar.sh $oldValue)
                fi
                if [ $check -lt 2 ]; then
                    oldExist=($( awk -F: -v lncol=$colNumber -v old=$oldValue '{
                                                            if(old!=$lncol)next;
                                                            else print $0;}' $path/$tname))
                    if [ ${#oldExist[@]} -gt 0 ]; then
#Get the new value that will be added
                        read -p "Enter a new value of type $colType you want to add: " newValue
                        if [ $colType == 'int' ]; then
                            check=$($scriptsPath/chkint.sh $newValue)
                        else
                            check=$($scriptsPath/chkvarchar.sh $newValue)
                        fi
#accept null entry
                        if [ $check -lt 2 ]; then
                            if [ $colNumber -eq 1 ]; then
                                pkExist=($( awk -F: -v lncol=$colNumber -v new=$newValue '{
                                                                if(new==$lncol)next;
                                                                else print $0;}' $path/$tname))
                                pkRows=$(($recordNums - ${#pkExist[@]}))
                                if [ $pkRows -gt 0 ]; then
                                    echo "${red}This ID already exist$end"
                                    modifyMenu $tname
                                    return 1
                                fi
                            fi
# save updated data and wait to update it
                            dataAfterModify=$(awk -F: -v lncol=$colNumber -v new=$newValue -v old=$oldValue '{
                                $lncol = ($lncol==old ? new:$lncol)}1' OFS=: $path/$tname)
                            read -p "Are you sure u want to update $colName:from $oldValue to $newValue in $tname table? (y/n)" answer
                            confirm=$(confirmToModify $answer)
                            if [ $confirm -eq 0 ]; then
                                echo "$dataAfterModify" >$path/$tname
                                echo -e "$red${bg}${#oldExist[@]} records was effected$end\n"
                            else
                                modifyByColName $tname
                                return 0
                            fi
                        else
                            modifyByColName $tname
                        fi

                    else
                        echo "${red}There is no value match your input.$end"
                        modifyByColName $tname
                    fi
                else
                    modifyByColName $tname
                fi
            else
                echo "${red}column name Doesn't exist$end"
                modifyByColName $tname
            fi
        else
            modifyByColName $tname
        fi

    else
        echo "${red}No records to delete from them. Using insert to add Records firstly...$end"
        return
    fi

}

modifyByPk() {
    tname=$1
    colnames=($(cut -d: -f1 $path/.$tname.type))
    recordNums=$(wc -l <$path/$tname)
    coltypes=($(cut -d: -f2 $path/.$tname.type))
    pkType=${coltypes[0]}
    #if the files is not empty
    if [ $recordNums -gt 0 ]; then
#get data type of the column to be edit
        echo -e "columns name : $red${bg}${colnames[@]}$end"
        read -p "Enter column name you want to update it: " colName
        check=$($scriptsPath/chkname.sh $colName)
        if [ $check -eq 0 ]; then
            colExist=$(grep -c ^$colName $path/.$tname.type)
            if [ $colExist -gt 0 ]; then
                colNumber=$(awk -F: -v coln=$colName '{if(coln==$1) print NR }' $path/.$tname.type)
                colType=$(grep -w ^$colName $path/.$tname.type | cut -d: -f2)
#Get the PK for to determine row
                read -p "Enter a value of type $pkType for the primary key: " pk
                pkExist=$(chkPK $tname $pk $pkType) 
                if [ $pkExist -eq 0 ]; then
#Get the new value that will be added
                    read -p "Enter a value of type $colType you want to modify: " newValue
                    if [ $colType == 'int' ]; then
                        check=$($scriptsPath/chkint.sh $newValue)
                    else
                        check=$($scriptsPath/chkvarchar.sh $newValue)
                    fi
                    if [ $check -lt 2 ]; then
                        if [ $colNumber -eq 1 ]; then
                            newExist=$(grep -cw ^$newValue $path/$tname)
                            if [ $newExist -gt 0 ]; then
                                echo "${red}This ID already exist$end"
                                modifyMenu $tname
                                return
                            fi
                        fi
# save updated data and wait to update it
                        dataAfterModify=$(awk -F: -v lncol=$colNumber -v new=$newValue -v pk=$pk '{ 
                            $lncol = ($1==pk ? new:$lncol)}1' OFS=: $path/$tname)
                        read -p "Are you sure u want to update $colName: $newValue in $tname table? (y/n)" answer
                        confirm=$(confirmToModify $answer)
                        if [ $confirm -eq 0 ]; then
                            echo "$dataAfterModify" >$path/$tname
                            echo "$red${bg}1 records was effected$end"
# update the table succesfuly
                        else
                            return 0
                        fi
                    else
                        modifyByPk $tname
                    fi
                else
                    modifyByPk $tname
                fi

            else
                echo "${red}column name Doesn't exist$end"
                modifyByPk $tname
            fi
        else
            modifyByPk $tname
        fi

    else
        echo "${red}No records to update in them. Use insert to add Records firstly...$end"
        return
    fi
}

modifyMenu() {
    tname=$1
    select reply in "Modify using PK." "Modify By Column Name." "Exit"; do
        case $REPLY in
        1)
            modifyByPk $tname
            modifyMenu $tname
            return
            ;;
        2)
            modifyByColName $tname
            modifyMenu $tname
            return
            ;;

        3)
            return
            ;;
        *)
            echo "Please enter one of these options."
            modifyMenu $tname
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
            echo "$red${bg}This table name is Exist...$end"
            modifyMenu $tname
        else
            echo "$red$bg This table name doesn't Exist...$end"
            main
        fi
    else
        main
    fi
}

main
