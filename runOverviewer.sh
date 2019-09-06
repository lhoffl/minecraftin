#!/bin/bash

last_date_overviewer="/home/ubuntu/minecraftin/last_date_overviewer.txt"
if [[ ! -f "$last_date_overviewer" ]]; then
  touch $last_date_overviewer
fi

last_date=$(/bin/cat $last_date_overviewer)
current=$(/bin/date +%Y%m%d%H)

difference=$((current-last_date))
echo $difference

lock_file="/home/ubuntu/minecraftin/overviewer.lock"

if [[ "$difference" -gt "60" ]] || [[ $1 > 0 ]]; then
    if [[ -f "$lock_file" ]]; then
      exit
    fi  

    touch $lock_file
    
    	/bin/bash msg_all_outputs "Generating an updated world map."    
	/usr/bin/aws s3 sync s3://lhoffl.com/minecraftin/ /home/ubuntu/mcmap/

	/usr/bin/python3 /home/ubuntu/overviewer.py --config=/home/ubuntu/minecraftin/overviewer_conf.py
	/usr/bin/python3 /home/ubuntu/overviewer.py --config /home/ubuntu/minecraftin/overviewer_conf.py --genpoi --skip-players
	/usr/bin/aws s3 sync --delete /home/ubuntu/mcmap/ s3://lhoffl.com/minecraftin/
	
    /bin/date +%Y%m%d%H > $last_date_overviewer
    rm $lock_file
    
    /bin/bash msg_all_outputs "New world map available at http://lhoffl.com/minecraftin"    
fi

$(sudo /sbin/shutdown -P +1)
