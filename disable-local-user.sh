#!/bin/bash
#how to use the program using 'usage' function
usage() {
		clear
        echo "Usage: ./$(basename $0) [-dra] USER [USERN]"
        echo "Disable a local Linux account."
        echo "  -d Deletes accounts instead of disabling them."
        echo "  -r Removes the home directory associated with the account(s)."
        echo "  -a Creates an archive of the home directory associated with account(s)."
}
# delete de user
d_del_user() {
        echo "User $1 is being deleted"
        userdel $1
        echo "User $1 was deleted of the system"
}

# delete the home of the user
r_del_home() {
		echo "Home of user $1 being 'force' deleted"
        rm -rf /home/$1
}
# archive the user home to a folder 'archive'
a_archive(){
        echo "Creating /archive directory."
        mkdir -P archive
        echo "Archiving /home/$1 to /archive/$1.tgz"
        tar fczP $1.tgz /home/$1
        mv $1.tgz /archive/
}
# detect if the user is using this script with 'root' account
if [[ "${UID}" -eq 0 ]]; then
        # if no parameters being set show 'usage'
        if [ "$#" -lt 1 ]; then
                usage
        # if begins with char 'a-z' or 'A-Z' using 1 parameter
        elif [[ $1 =~ ^[a-zA-Z] ]]; then
                # getting the uid of the user
				user_id=$(id -u $1)
                # check if the user is not less than 1000
                if [ "$user_id" -lt 1001 ]; then
                        echo "Processing user: $1"
                        echo "Refusing to remove the account with UID $user_id"
                else
                        # disable user account setting date '0000-01-01'
                        echo "Processing user: $1"
                        chage -E 0000-01-01 $1
                        echo "The account $1 was disabled"
                fi
        else
                # recolecting the prompted values to the vars
                op_a_arch=false
                op_a_arch_optarg=""
                op_r_del=false
                op_r_del_optarg=""
                op_d_user=false
                op_d_user_optarg=""
                while getopts ":a:r:d:" OPTION
                do
						case $OPTION in
                                a)
                                op_a_arch=true
                                op_a_arch_optarg=$OPTARG
                                ;;
                                r)
                                op_r_del=true
                                op_r_del_optarg=$OPTARG
                                ;;
                                d)
                                op_d_user=true
                                op_d_user_optarg=$OPTARG
                                ;;
                                \?)
                                usage
                                ;;
                                :)
                                usage
                                ;;
                        esac
                done
                # if function gets true as taked before it will do the taked option
				# needs to be in nice order to not delet the user or home before archive
                if $op_a_arch; then
                        a_archive $op_a_arch_optarg
                fi
                if $op_r_del; then
                        r_del_home $op_r_del_optarg
                fi
                if $op_d_user; then
                        d_del_user $op_d_user_optarg
                fi
        fi
else
	usr_try=$(echo $USER)
	uid_try=$(id -u)
    echo "You are not a 'root' user"
	echo "User executing this script: $usr_try"
	echo "User uid: $uid_try"
	echo "foo!"
fi
