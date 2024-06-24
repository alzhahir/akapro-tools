#!/bin/bash
# Main Menu

if [ "$EUID" -ne 0 ]
  then echo "This script would not work without root."
  exit
fi

echo "Welcome to the AkaKitsune Plugins Updater tool!"
echo
echo "Please choose from the choices below:"
echo "Update AkaKitsune Proxy - P"
echo "Update AkaKitsune Hub - H"
echo "Update AkaKitsune Survival - S"
echo "Update AkaKitsune Creative - C"
echo
echo "Exit - E"

while true; do

read -p "Chosen server: " choice

case $choice in 
	[pP] ) echo Updating AkaKitsune Proxy plugins...;
        cd ./proxy
        bash replaceplugins.sh
		break;;
    [hH] ) echo Updating AkaKitsune Hub plugins...;
        cd ./hub
        bash replaceplugins.sh
		break;;
    [sS] ) echo Updating AkaKitsune Survival plugins...;
        cd ./other/survival
        bash replaceplugins.sh
		break;;
    [cC] ) echo Updating AkaKitsune Creative plugins...;
        cd ./other/creative
        bash replaceplugins.sh
		break;;
    [eE] ) echo User aborted.;
		exit;;
	* ) echo Bad response.;;
esac

done

echo
echo Plugins updated successfully.