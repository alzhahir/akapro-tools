#!/bin/bash
# Get current directory
HOMEDIR="$(pwd)"
UUID="f753656c-65fc-41e3-9693-5fbc0cffa8bc"
PTERODIR="/media/sdb/pterodactyl/volumes/"

echo "Downloading latest plugin versions..."
bash dlscript.sh > /dev/null 2>&1
chown -R ubuntu ./plugins
cd ./plugins
echo
echo "These files will be copied to the server folder:"
find . -maxdepth 1 -name "*.jar" -type f

while true; do

read -p "Do you want to proceed with the update? (y/n) " yn

case $yn in
        [yY] ) echo Scanning current versions...;
                break;;
        [nN] ) echo User aborted.;
                exit;;
        * ) echo Bad response.;;
esac

done

cd "$PTERODIR$UUID"/plugins

echo
echo "These files will be deleted:"
find . -maxdepth 1 -name "*.jar" -type f

while true; do

read -p "Do you want to proceed with deletion? (y/n) " yn

case $yn in 
	[yY] ) echo Deleting files...;
		break;;
	[nN] ) echo User aborted.;
		exit;;
	* ) echo Bad response.;;
esac

done

find . -maxdepth 1 -name "*.jar" -type f -delete

echo Copying new files...
cp "$HOMEDIR"/plugins/* ./
echo
echo Done.
