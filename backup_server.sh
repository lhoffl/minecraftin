#!/bin/bash

backup_date_file="/home/ubuntu/minecraftin/last_date_backup.txt"

if [[ ! -f "$backup_date_file" ]]; then
  touch "$backup_date_file"
fi

last_date=$(/bin/cat $backup_date_file)
current=$(/bin/date +%Y%m%d%H)

difference=$((current-last_date))
echo $difference

lock_file="/home/ubuntu/minecraftin/backup.lock"

if [[  $difference > 60 ]] || [[ $1 > 0 ]]; then

    if [[ -f "$lock_file" ]]; then
      exit
    fi

    touch $lock_file

    /bin/bash /home/ubuntu/minecraftin/msg_all_outputs.sh "Server backup in progress"

	/bin/mv /home/ubuntu/backups/latest_backup.tar.gz /home/ubuntu/backups/old_.tar.gz
	cd /home/ubuntu/
	/bin/tar -czvf backups/latest_backup.tar.gz world/
	/usr/bin/aws s3 cp /home/ubuntu/backups/latest_backup.tar.gz s3://lhoffl.com/minecraftin_backups/$current-backup.tar.gz
	/usr/bin/aws s3 rm s3://lhoffl.com/minecraftin_backups/latest_backup.tar.gz
	/usr/bin/aws s3 cp /home/ubuntu/backups/latest_backup.tar.gz s3://lhoffl.com/minecraftin_backups/latest_backup.tar.gz
	/bin/date +%Y%m%d%H > $backup_date_file

    /bin/bash /home/ubuntu/minecraftin/msg_all_outputs.sh "Server backup completed"
    rm $lock_file
fi

