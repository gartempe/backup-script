Backup script
=============

This backup script was created for Linux to be used with Samba (CIFS), LUKS and rsync. I’ve created it to backup my Synology NAS. I want to avoid that the backup is stored in a proprietary format.

Requirements (on Debian/Ubuntu):
--------------------------------
`apt-get install rsync cryptsetup cifs-utils`

I highly recommend to create a key file for your encrypted volume, also, you should put your Samba credentials into ~/.smbcredentials. You should avoid to save 

There are quite some things you have to edit in the backupnas.sh.
    [NAME]                 name of your encrypted volume like /dev/mapper/usb-crypt
    [NAS IP]               the IP of your NAS
    [NAS FOLDER]           folder of your data on your NAS, e.g. /data           
    [KEY]                  your LUKS key file
    [VOLUME]               the path of your physical device, like /dev/sdb1 or /dev/md2
    [LOCAL BACKUP FOLDER]  mountpoint for your BACKUP, e.g. /backup
    [LOCAL NAS FOLDER]     mountpoint for your NAS, e.g. /nas
    [BACKUP SIZE]          you should check if the backup volume is really mounted to
                           avoid fillung up your / folder. Check the size with "df -H"`
