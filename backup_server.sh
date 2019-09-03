#!/bin/bash

backup_date_file="last_date_backup.txt"

if [[ ! -f "$backup_date_file" ]]; then
  touch "$backup_date_file"
fi

last_date=$(/bin/cat $backup_date_file)
current=$(/bin/date +%Y%m%d%H)

difference=$((current-last_date))
echo $difference

lock_file="backup.lock"

if [[  $difference > 60 ]] || [[ $1 > 0 ]]; then

    if [[ -f "$lock_file" ]]; then
      exit
    fi

    touch $lock_file

    /bin/bash msg_all_outputs "Server backup in progress"

	/bin/mv /home/ubuntu/backups/latest_backup.tar.gz /home/ubuntu/backups/old_.tar.gz
	/bin/tar -czvf backups/latest_backup.tar.gz world/
	/usr/bin/aws sync /home/ubuntu/backups/ s3://lhoffl.com/minecrafin_backups/
	/bin/date +%Y%m%d%H > $backup_date_file

    rm $lock_file
fi

