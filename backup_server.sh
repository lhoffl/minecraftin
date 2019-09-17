#!/bin/bash

source /home/ubuntu/minecraftin/secret.conf
lock_file="/home/ubuntu/minecraftin/backup.lock"

if [[ -f "$lock_file" ]]; then
	exit
fi

if [[ ! -d "/home/ubuntu/world" ]]; then
	echo "WORLD DOESN'T EXIST"
	exit
fi

touch $lock_file

/bin/bash /home/ubuntu/minecraftin/msg_all_outputs.sh "Server backup in progress"

/bin/mv /home/ubuntu/backups/latest_backup.tar.gz /home/ubuntu/backups/old_.tar.gz
cd /home/ubuntu/
/bin/tar -czvf backups/latest_backup.tar.gz world/

current=$(date +%Y%d%m)

if [[ $1 > 0 ]]; then
	/usr/bin/aws s3 cp /home/ubuntu/backups/latest_backup.tar.gz s3://$BUCKET/old_backups/$current-backup.tar.gz
	/usr/bin/aws s3 rm s3://$BUCKET/minecraftin_backups/latest_backup.tar.gz
	/usr/bin/aws s3 cp /home/ubuntu/backups/latest_backup.tar.gz s3://$BUCKET/minecraftin_backups/latest_backup.tar.gz

fi

/bin/bash /home/ubuntu/minecraftin/msg_all_outputs.sh "Server backup completed"	
rm $lock_file
