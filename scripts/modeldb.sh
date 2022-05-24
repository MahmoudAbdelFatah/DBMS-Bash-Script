#!/bin/bash
export scriptsPath=/home/$USER/project/scripts red="$(tput setaf 1)" end="$(tput sgr 0)" bg="$(tput setab 7)"


if [ ! -d /home/$USER/project/databases ]; then
    mkdir /home/$USER/project/databases
fi
dbMenu() {
    echo $'\n' $red$bg welcome to our Database engine$end 
    echo "-------------------------------------------------------------------------"$'\n'
    select choice in "Create Database" "List Databases" "Connect to Database" "Drop Database" "Exit"; do
        case $REPLY in
        1)
            create=$($scriptsPath/createdb.sh)
            while true
            do
                if [ $create -eq 0 ]; then
                    read -p "Do you want to create another DataBase (y/n) " answer
                    answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
                    if [ $answer = "y" ] || [ $answer = "yes" ]; then
                            create=$($scriptsPath/createdb.sh)
                    elif [ $answer = "n" -o $answer = "no" ]; then
                        break
                    else
                        echo "$red$bg please choose from this values (y/n).$end"
                    fi
                elif [ $create -eq 1 ]; then
                    read -p "Do you want to create DataBase (y/n) " answer
                    answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
                    if [ $answer = "y" ] || [ $answer = "yes" ]; then
                            create=$($scriptsPath/createdb.sh)
                    elif [ $answer = "n" -o $answer = "no" ]; then
                        break
                    else
                        echo "$red$bg please choose from this values (y/n).$end"
                    fi
                fi
            done
            dbMenu
            ;;
        2)
            $scriptsPath/lsdb.sh
            dbMenu
            ;;
        3)
            $scriptsPath/checkdbExist.sh
            dbMenu
            ;;
        4)
            /home/$USER/project/scripts/dropdb.sh $dbname
            dbMenu
            ;;
        5)
            exit
            break
            ;;
        6)
            echo "Please Enter a correct number"
        esac
    done
}
dbMenu
