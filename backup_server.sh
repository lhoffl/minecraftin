#!/bin/bash

source /home/ubuntu/minecraftin/secret.conf
lock_file="/home/ubuntu/minecraftin/backup.lock"
alternate_run_file="/home/ubuntu/minecraftin/alternate_backup_run.lock"

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

	# push spare backups every other hour, don't if pushing latest
	if [[ ! -f "$alternate_run_file" ]] && [[ $# -eq 1 ]]; then
		/usr/bin/aws s3 cp /home/ubuntu/backups/latest_backup.tar.gz s3://$BUCKET/old_backups/$current-backup.tar.gz
		rm $alternate_run_file
	elif [[ $# -eq 1 ]]; then
		touch $alternate_run_file
	fi
	
	# if server is shutting down, back it up as latest
	if [[ $2 > 0 ]]; then
		/usr/bin/aws s3 rm s3://$BUCKET/minecraftin_backups/latest_backup.tar.gz
		/usr/bin/aws s3 cp /home/ubuntu/backups/latest_backup.tar.gz s3://$BUCKET/minecraftin_backups/latest_backup.tar.gz
	fi
fi

/bin/bash /home/ubuntu/minecraftin/msg_all_outputs.sh "Server backup completed"	
rm $lock_file
