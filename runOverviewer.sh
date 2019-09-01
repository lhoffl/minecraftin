#!/bin/bash

last_date=$(/bin/cat last_date.txt)
current=$(/bin/date +%Y%m%d%H)

difference=$((current-last_date))
echo $difference

if [[  "$difference" -gt "60" ]] || [[ $1 > 0 ]]; then
	/usr/bin/logger "running overviewer"
	echo "running overviewer"
	/usr/bin/python3 /home/ubuntu/minecraftin/sendMessage.py "Generating an updated world map"
	/usr/bin/python3 /home/ubuntu/overviewer.py --config=/home/ubuntu/minecraftin/overviewer_conf.py
	/usr/bin/python3 /home/ubuntu/overviewer.py --config /home/ubuntu/minecraftin/overviewer_conf.py --genpoi --skip-players
	/usr/bin/aws s3 sync --delete /home/ubuntu/mcmap/ s3://lhoffl.com/

	/usr/bin/python3 /home/ubuntu/minecraftin/sendMessage.py "New world map available at http://lhoffl.com/minecraftin"
	/bin/date +%Y%m%d%H > last_date.txt
fi

/usr/bin/logger "skipped run"
echo "skipped run"

if [ $# -eq 0 ]; then
	echo "No args provided, not a manual run. Proceed with shutdown"
	$(sudo /sbin/shutdown -P +1)
fi
