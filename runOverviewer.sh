#!/bin/bash

last_date_overviewer="last_date_overviewer.txt"
if [[ ! -f "$last_date_overviewer" ]]; then
  touch $last_date_overviewer
fi

last_date=$(/bin/cat $last_date_overviewer)
current=$(/bin/date +%Y%m%d%H)

difference=$((current-last_date))
echo $difference

lock_file="overviewer.lock"

if [[ "$difference" -gt "60" ]] || [[ $1 > 0 ]]; then
    if [[ -f "$lock_file" ]]; then
      exit
    fi  

    touch $lock_file
    
    /bin/bash msg_all_outputs "Generating an updated world map."    

	/usr/bin/python3 /home/ubuntu/overviewer.py --config=/home/ubuntu/minecraftin/overviewer_conf.py
	/usr/bin/python3 /home/ubuntu/overviewer.py --config /home/ubuntu/minecraftin/overviewer_conf.py --genpoi --skip-players
	/usr/bin/aws s3 sync --delete /home/ubuntu/mcmap/ s3://lhoffl.com/minecraftin/
	
    /bin/date +%Y%m%d%H > $last_date_overviewer
    rm $lock_file
    
    /bin/bash msg_all_outputs "New world map available at http://lhoffl.com/minecraftin"    
    exit
fi

/usr/bin/logger "Skipped Overviewer run"
echo "Skipped"
