#!/bin/bash

while getopts ":d:r:a:" opt; do
    case $opt in
        d)
            	echo "Deletes Account ${OPTARG}"
		id=`id -u ${OPTARG}`
		if [ $id -le 1000 ]; then
			echo "Not deleted"
		else
			echo "User deleted"
		fi
		;;
        r)
            	echo "Removes home directory"
           	 ;;
        a)
            	echo "Creates an archive" 
            	;;
        ?)
            echo "Invalid option: ${OPTARG}"
            ;;
    esac
done

shift $((OPTIND-1))


#echo "Remaining args are: <${@}>"
