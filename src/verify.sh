#!/bin/bash

#uncomment this if you have a laptop drive that can't insert itself
LAPTOP_DRIVE=1

# INIT

if [ -z "$1" ]
then
	CD="/media/cdrom"
else
	CD=$1
fi

if [ -z "2" ]
then
	DISK=$PWD
else
	DISK=$2
fi

IFS="
"

# FUNCTIONS

function reload()
{
	cd "$DISK"
	sleep 2
	echo -e "\tUnmounting CD"
	umount -l "$CD"
	sleep 1
	echo -e "\tEjecting CD"
	eject "$CD"
	sleep 1

	if [ -n "$LAPTOP_DRIVE" ]
	then
		dialog --msgbox "Please reinsert the media and hit enter." 0 0
	fi

	echo -e "\tRemounting CD"
	mount "$CD"

	if [ $? -ne 0 ]
	then
		echo -e "\t\tMount failed with error code $?"
		return 1
	fi

	cd "$CD"

	return 0
}

function dover()
{
	cd "$CD"
	echo -e "\tcalculating sum in $CD..."
	CM=`md5sum $1`

	if [ $? != 0 ]
	then
		echo -e "\tmd5sum failed! Reloading media and trying again."
		reload
		CM=`md5sum $1`

		if [ $? != 0 ]
		then
			echo -e "\tmd5sum failed again. Trying one last time."
			reload
			CM=`md5sum $1`

			if [ $? != 0 ]
			then
				echo -e "Unable to get a match. Giving up"
				return 1
			fi
		fi
	fi

	cd "$DISK"
	echo -e "\tcalculating sum in $DISK..."
	DM=`md5sum $1`

	if [ "$DM" = "$CM" ]
	then
		return 0
	else
		return 1
	fi
}

# MAIN PROGRAM

echo "Beginning verify procedure."
reload

if [ $? -ne 0 ]
then
	echo "Unable to mount the disk! Aborting."
	touch /tmp/baddisk
	exit 1
fi

cd "$CD"
rm -f /tmp/baddisk

for i in `find . -type f -follow | sort -r`
do
	echo "Checking $i"
	dover $i

	if [ $? != 0 ]
	then
		echo -e "File $i differs!"
		touch /tmp/baddisk
		exit 1
	fi
done

echo "All files are identical."

cd "$DISK"
exit 0
