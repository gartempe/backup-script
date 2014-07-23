#!/bin/bash
# ------------------------------------------
# - Synology NAS to encrypted drive backup -
# -					   -
# -    by Dennis Klein dennis@klein2.de    -
# -            under MIT license           -
# ------------------------------------------
#
# v0.1.0 - 22.07.2014 - Basic build
# v0.1.1 - 23.07.2014 - debug mode, extended logs

echo 
echo Checking if the encrypted backup drive is available
crypt=`mount | grep /dev/mapper/[NAME] | wc -l`
nas=`mount | grep //[NAS IP]/[NAS FOLDER] | wc -l`
starttime=`date '+%d.%m.%Y %H:%M:%S'`

echo "------------------------------------------------------------------" >> /var/log/backup.log
echo "Started at: $starttime" >> /var/log/backup.log
echo " " >> /var/log/backup.log

if [ $crypt == "1" ] ; then
	echo "BACKUP decrypted."
else
	echo "BACKUP not decrypted."
	echo "Unlocking encrypted backup drive."
	cryptsetup luksOpen -d [KEY] [VOLUME] [NAME]
	echo "Mounting backup drive."
	mount [VOLUME] /[LOCAL BACKUP FOLDER]
	echo "Mounted backup drive to /backup"
	crypt="1"
fi

if [ $nas == "1" ] ; then
	echo "NAS mounted."
else
	echo "NAS not mounted."
	echo "Mounting NAS."
	mount.cifs //[NAS IP]/[NAS FOLDER] /[LOCAL NAS FOLDER] -o credentials=~/.smbcredentials
	nas="1"
fi

if [ $nas == "1" ] && [ $crypt == "1" ] ; then
	checksize=`df -H | grep /dev/mapper/[VOLUME] | cut -d' ' -f3`
	if [ $checksize == "[BACKUP SIZE]" ] ; then
		echo "Ready for backup."
		df -H | egrep -ie '/[LOCAL NAS FOLDER]|/[LOCAL BACKUP FOLDER]' >> /var/log/backup.log
		echo " " >> /var/log/backup.log
		if [ $1 != "-d" ] ; then
			rsync -vapog /[LOCAL NAS FOLDER] /[LOCAL BACKUP FOLDER] >> /var/log/backup.log
		else
			echo "! Debug mode. No actual backup is running." | tee -a /var/log/backup.log
		fi
	else
		echo "BACKUP is not mounted."
	fi	
fi

echo 
echo Backup completed.
echo Unmounting and locking devices.
umount /[LOCAL NAS FOLDER]
umount /[LOCAL BACKUP FOLDER]
cryptsetup luksClose [NAME]

endtime=`date '+%d.%m.%Y %H:%M:%S'`
echo "Completed at: $endtime" >> /var/log/backup.log
echo " " >> /var/log/backup.log

echo Done.
echo
