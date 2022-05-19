
read -p "Enter database name to connect it: " dbname

cd /home/$USER/project/databases/$dbname 2> /dev/null
if [ $? -eq 0 ] ;then
    echo "Connected to $dbname Successfully"
    /home/$USER/project/scripts/tableMenu.sh $dbname
else
    echo "Database $dbname wasn't found"

fi
