#!/bin/bash
SERVICE='fabric-server-launch.jar'
SCREENDIR=/home/ubuntu/screens/
export SCREENDIR=/home/ubuntu/screens/

life=$(echo $(awk '{print $1}' /proc/uptime) / 60 | bc)
echo $life

if [[ "$life" -lt "15" ]]; then
	/usr/bin/logger "Looks like the server just started. It's only been online for $life minutes. Wait awhile to make sure DNS alias goes through and users can log in."
	exit
fi

if ps ax | grep -v grep | grep $SERVICE > /dev/null; then
    PLAYERSEMPTY=" There are 0 of a max 20 players online"
	$(/usr/bin/screen -S minecraft -p 0 -X stuff "list^M")
	sleep 5
	$(/usr/bin/screen -S minecraft -p 0 -X stuff "list^M")
	sleep 5
	PLAYERSLIST=$(tail -n 1 /home/ubuntu/logs/latest.log | cut -f2 -d"/" | cut -f2 -d":")
	echo $PLAYERSLIST
	/usr/bin/logger $PLAYERSLIST
	if [ "$PLAYERSLIST" = "$PLAYERSEMPTY" ]
	then
		/usr/bin/logger "Waiting for players to come back in 5m, otherwise shutdown"
		sleep 5m
		$(screen -S minecraft -p 0 -X stuff "list^M")
		sleep 5
		$(screen -S minecraft -p 0 -X stuff "list^M")
		sleep 5
		PLAYERSLIST=$(tail -n 1 /home/ubuntu/logs/latest.log | cut -f2 -d"/" | cut -f2 -d":")
		if [ "$PLAYERSLIST" = "$PLAYERSEMPTY" ]
		then
            		if [[ -f "/home/ubuntu/minecraftin/overviewer.lock" ]]; then
		      		/usr/bin/logger "Overviewer run currently in progress, waiting for the run to finish before shutting down."
              			exit
            		elif [[ -f "/home/ubuntu/minecraftin/backup.lock" ]]; then
		      		/usr/bin/logger "Server backup currently in progress, waiting for the run to finish before shutting down."
              	      		exit
            		else
                		/bin/bash /home/ubuntu/minecraftin/runOverviewer.sh
		
		   		PLAYERSEMPTY=" There are 0 of a max 20 players online"
				$(/usr/bin/screen -S minecraft -p 0 -X stuff "list^M")
				sleep 5	
				$(/usr/bin/screen -S minecraft -p 0 -X stuff "list^M")
				sleep 5
				PLAYERSLIST=$(tail -n 1 /home/ubuntu/logs/latest.log | cut -f2 -d"/" | cut -f2 -d":")
				echo $PLAYERSLIST
			
				if [ "$PLAYERSLIST" = "$PLAYERSEMPTY" ]; then
					/bin/bash /home/ubuntu/minecraftin/backup_server.sh true true
					$(/usr/bin/screen -S minecraft -p 0 -X stuff "say Server powering down. ^M")
					/bin/rm /home/ubuntu/minecraftin/server.lock
					$(sudo /sbin/shutdown -P +1)
				fi
            		fi
	    	fi
	fi
else
	/usr/bin/logger "Screen does not exist briefly waiting before trying again"
	/usr/bin/logger "Running overviewer from autoshutdown"
	if ! ps ax | grep -v grep | grep $SERVICE > /dev/null; then
          if [[ -f "overviewer.lock" ]]; then
            /usr/bin/logger "Overviewer run currently in progress, waiting for the run to finish before shutting down."
            exit
          elif [[ -f "backup.lock" ]]; then
            /usr/bin/logger "Server backup currently in progress, waiting for the run to finish before shutting down."
            exit
          else
            	/bin/bash /home/ubuntu/minecraftin/backup_server.sh true true
		
		$(/usr/bin/screen -S minecraft -p 0 -X stuff "say Server powering down. ^M")
		/bin/rm /home/ubuntu/minecraftin/server.lock
		$(sudo /sbin/shutdown -P +1)
				
          fi
	fi
fi
