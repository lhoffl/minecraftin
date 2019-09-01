#!/bin/bash

last_date=$(/bin/cat last_date.txt)
current=$(/bin/date +%Y%m%d%H)

difference=$((current-last_date))
echo $difference

if [[  $difference > 1000 ]] || [[ $1 > 0 ]]; then
	/usr/bin/logger "Creating server backup"
	echo "Creating server backup"

	/bin/tar -czvf "/home/ubuntu/backups/$date-tar.gz" /home/ubuntu/world/
	/bin/date +%Y%m%d%H > last_date.txt
fi

