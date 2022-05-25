#!/bin/bash
export scriptsPath=/home/$USER/project/scripts
export localdb=/home/$USER/project/databases
export red="$(tput setaf 1)" 
export end="$(tput sgr 0)" 
export bg="$(tput setab 7)"


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
                    read -p "Do you want to create another Database (y/n) " answer
                    answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
                    if [ $answer = "y" ] || [ $answer = "yes" ]; then
                            create=$($scriptsPath/createdb.sh)
                    elif [ $answer = "n" -o $answer = "no" ]; then
                        break
                    else
                        echo "$red$bg please chose from this values only (y/n).$end"
                    fi
                elif [ $create -eq 1 ]; then
                    read -p "Do you still want to create a Database? (y/n) " answer
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
            dropdb=$($scriptsPath/dropdb.sh)
            while true
            do
                if [ $dropdb -eq 0 ]; then
                    read -p "Do you want to Drop another Database? (y/n) " answer
                    answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
                    if [ $answer = "y" ] || [ $answer = "yes" ]; then
                            dropdb=$($scriptsPath/dropdb.sh)
                    elif [ $answer = "n" -o $answer = "no" ]; then
                        break
                    else
                        echo "$red$bg please choose from this values (y/n).$end"
                    fi
                elif [ $dropdb -eq 1 ]; then
                    read -p "Do you still want to Drop a Database? (y/n) " answer
                    answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
                    if [ $answer = "y" ] || [ $answer = "yes" ]; then
                            create=$($scriptsPath/dropdb.sh)
                    elif [ $answer = "n" -o $answer = "no" ]; then
                        break
                    else
                        echo "$red${bg}Please choose from this values (y/n).$end"
                    fi
                fi
            done
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
