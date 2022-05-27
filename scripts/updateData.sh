#!/bin/bash

modifyByColName() {
    tname=$1
    read -d ' ' -a colnames <<< "$( cut -d: -f1 $path/.$tname.type )"
    #get number of records in a file
    recordNums=$(wc -l <$path/$tname )
    #if the files is not empty
    if [ $recordNums -gt 0 ]; then
        #get data type of the spacified column 
        echo -e "columns name : $red${bg}${colnames[@]}$end"
        read -p "Enter column name you want to update in it: " colName
        check=$($scriptsPath/chkname.sh $colName)
        if [ $check -eq 0 ]; then
            colExist=$(grep -c $colName <<< "${colnames[@]}")
            if [ $colExist -gt 0 ]; then
                colNumber=$(awk -F: -v coln=$colName '{if(coln==$1) print NR }' $path/.$tname.type)                
                colType=$(grep -w $colName $path/.$tname.type |cut -d: -f2)
                read -p "Enter a value of type $colType you want to modify: " oldValue
                if [ $colType == 'int' ]; then
                    check=$($scriptsPath/chkint.sh $oldValue)
                else
                    check=$($scriptsPath/chkname.sh $oldValue)
                fi
                if [ $check -eq 0 ]; then        
                    oldExist=($(cat $path/$tname |awk -F: -v lncol=$colNumber -v old=$oldValue '{
                                                            if(old!=$lncol)next;
                                                            else print $0;}'))
                    if [ ${#oldExist[@]} -gt 0 ]; then
                        read -p "Enter a new value of type $colType you want to add: " newValue
                        if [ $colType == 'int' ]; then
                            check=$($scriptsPath/chkint.sh $newValue)
                        else
                            check=$($scriptsPath/chkname.sh $newValue)
                        fi
                        if [ $check -eq 0 ]; then
                            if [ $colNumber -eq 1 ]; then
                                newExist=($(cat $path/$tname |awk -F: -v lncol=$colNumber -v new=$newValue '{
                                                                if(new==$lncol)next;
                                                                else print $0;}'))
                                neweffectedRow=$(($recordNums - ${#newExist[@]}))
                                if [ $neweffectedRow -gt 0 ]; then
                                    echo "${red}This ID already exist$end"
                                    updateMenu $tname 
                                    return 1
                                fi
                            fi
                            # save updated data and wait to update it
                            dataAfterModify=$(awk -F: -v lncol=$colNumber -v new=$newValue -v old=$oldValue '{ $lncol = ($lncol==old ? new:$lncol)}1' OFS=: $path/$tname)
                            read -p "Are you sure u want to update $colName: $newValue from  $tname table ? (y/n) " answer
                            answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
                            if [ $answer = "y" ] || [ $answer = "yes" ]; then
                                    echo  "$dataAfterModify" > $path/$tname
                                echo "$red${bg}${#oldExist[@]} records was effected$end"
                                ## we update the table succesfuly

                            elif [ $answer = "n" -o $answer = "no" ]; then
                                echo "$red$bg sorry, we can't delete table's data without your confirmation.$end"
                                modifyByColName $tname
                            else
                                echo "${red}please choose from this values (y/n).$end"
                                modifyByColName $tname
                                return 0
                            fi 
                        fi
                    else
                        echo "${red}There is no value match your input$end"
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
        echo "${red}No records to delete from them. Using inesert to add Records firstly...$end"
        return
    fi

}

main()
{
    read -p "Enter table name: " tname
    checktable=$($scriptsPath/chkname.sh $tname)
    if [ "$checktable" -eq 0 ];then
        if [ -f $path/$tname ] ;then
            echo "$red$bg This table name is Exist...$end"
            modifyByColName $tname
        else
            echo "$red$bg This table name doesn't Exist...$end"
            main
        fi
    else
        main
    fi
}

main