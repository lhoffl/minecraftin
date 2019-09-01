#!/bin/bash

last_date=$(/bin/cat last_date.txt)
current=$(/bin/date +%Y%m%d%H)

difference=$((current-last_date))
echo $difference

if [[  $difference > 1000 ]] || [[ $1 > 0 ]]; then
	/usr/bin/logger "Creating server backup"
	echo "Creating server backup"
	
	/bin/mv /home/ubuntu/backups/latest_backup.tar.gz /home/ubuntu/backups/old_.tar.gz
	/bin/tar -czvf "/home/ubuntu/backups/latest_backup.tar.gz" /home/ubuntu/world/
	/usr/bin/aws sync /home/ubuntu/backups/ s3://lhoffl.com/minecrafin_backups
	/bin/date +%Y%m%d%H > last_date.txt
fi

