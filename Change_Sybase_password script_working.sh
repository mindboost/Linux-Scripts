#!/bin/bash
pazz=Atkins43

existing_user() {
	# Test to see if user already exists

    while read server database; do
    echo "Connecting to $server ....."
    my_name=$(isql ${server} "-Usa" ${database} -P${pazz} -b <<- _END_
    
		set nocount on
		go
		use master
		go
		select name from syslogins where name="$new_userid"
		go
_END_
)
if [[ -n $my_name ]]; then
       echo "User:" $new_userid "already exists in"  $database
else
       echo "User:" $new_userid "Does not exists in" $database "you may continuing with setup...."
fi
done < db_info.txt 
return 1
}




    
# Verify .bashrc exists

if [[ -f ~/.bashrc ]]; then
      echo "The .bashrc file exists."
              else
              echo "The .bashrc file does not exists."
        exit 1
        fi

grep "grp" ~/.bashrc > db_info_tmp.txt

#This version cleaned the text file using the cut command
#cut -f 2 -d ' ' db_info_tmp.txt | cut -c 1-5 > db_info.txt
#Pulls Group Only from .basharc






# Pulls Entire sqlsh connection string using sed to clean the file

sed -r 's/.{18}//;s/.$//' db_info_tmp.txt > db_info.txt

# read-menu: a menu driven system information program
#     clear
     echo "
     Please Select:
     1. To create a new user
     0. Quit - Exit Immediately
"
read -p "Enter selection [0-2] > "
if [[ $REPLY =~ ^[0-2]$ ]]; then
        if [[ $REPLY == 0 ]]; then
                  echo "Program terminated."
                  exit
        fi
        if [[ $REPLY == 1 ]]; then
                  read -p "Enter New Account as it will appear in database: " new_userid
                  read -p "Enter Temporary Password: " temp_password
                  existing_user
           exit
         fi
else
        echo "Invalid entry." >&2
        exit 1
fi

exit



