#!/bin/bash
pazz=Atkin???

######################################################################
###     Function to test Sybase database is accessible
###     connecting to the port that sybase listens on for each server-
###     nc tests connections using tcp or udp protocols.
######################################################################

test_database() {
    while read server database; do
        nc -z -w6 ${server:2} 4100
                if [[ $? -eq 0 ]]; then
                    existing_user
                    create_user
                        else
                    echo -e "$database innaccessible!"
                    exit
                fi
    done < db_info_grp11.txt
    return 1
}

#####################################################
###     Function to see if user already exists
#####################################################

existing_user() {
                my_name=$(sqsh ${server} "-Usa" ${database} -P${pazz} -h  <<- _END_
                        select name from master..syslogins where name="$new_userid"
                        go
                exit
        _END_
        )

        new_my_name=`echo $my_name | tr -s " "`


        if [[ "$new_my_name" == "$new_userid" ]]; then
                echo -e "User:" $new_userid "already exists in "  ${server:2}
        elif [[ -z "$my_name" ]]; then
                echo -e "User:" $new_userid "Does not exists in  ${server:2}  continuing with setup...."
#               create_user
        fi
        return 1
}

############################################################################
###             Function to create new user in database and write to the log
############################################################################

create_user() {
              database2="${database:2}"
              connect_string=$(sqsh ${server} "-Usa" ${database} -P${pazz} -h  <<- _END_
              USE master
              go
              sp_addlogin "$new_userid",'ch4ng3m3!','master','us_english',"$new_userid"
              go
                PRINT ' <<< CREATED LOGIN $new_userid >>>'
                go
              use `echo $database2`
              go
                Print ' <<< Now using $database >>>'
                go
              sp_adduser "$new_userid","$new_userid","$dept"
              go
                Print ' <<< $new_userid created in $database >>>'
                go
              exit
        _END_
           )
           echo -e "users:" $new_userid "added to the database  ${server:2}"
           return 1


}

###########################################################
###     read-menu: a menu driven system information program
###########################################################


     clear
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
#                 read -p "Enter Temporary Password: " temp_password
     echo "
     Please choose the departmental access required for this user
     G_accounting
     G_application
     G_datafeed
     G_develop
     G_migrations
     G_nt_readonly
     G_nt_readwrite
     G_readonly
     G_sa
"
                  read -p "Enter Employees Department: " dept
                  if [[ "$dept" == "G_"* ]]; then
                        test_database
                  else
                        exit
                  fi

           exit
         fi
else
        echo "Invalid entry." >&2
        exit 1
fi

exit