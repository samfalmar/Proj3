#! /bin/bash
clear
#Make sure the script is being executed with superuser privileges
	if ! [ $(id -u) = 0 ];
	then
		echo "No sou root"
		echo "Executeu-lo amb privilegis"
	exit 1
	fi
