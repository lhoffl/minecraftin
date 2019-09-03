#!/bin/sh
SERVICE='fabric-server-launch.jar'
if ps ax | grep -v grep | grep $SERVICE > /dev/null; then
    PLAYERSEMPTY=" There are 0 of a max 20 players online"
	$(screen -S minecraft -p 0 -X stuff "list^M")
	sleep 5
	$(screen -S minecraft -p 0 -X stuff "list^M")
	sleep 5
	PLAYERSLIST=$(tail -n 1 /home/ubuntu/logs/latest.log | cut -f2 -d"/" | cut -f2 -d":")
	echo $PLAYERSLIST
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
			/bin/bash /home/ubuntu/minecraftin/runOverviewer.sh
            /bin/bash /home/ubuntu/minecraftin/backup_server.sh true
            if [[ -f "overviewer.lock" ]]; then
		      /usr/bin/logger "Overviewer run currently in progress, waiting for the run to finish before shutting down."
              exit
            elif [[ -f "backup.lock" ]]; then
		      /usr/bin/logger "Server backup currently in progress, waiting for the run to finish before shutting down."
              exit
            else
		      $(screen -S minecraft -p 0 -X stuff "say Server powering down. ^M")
              /usr/bin/python3 /home/ubuntu/minecraftin/sendMessage.py "Server shutting down. Restart it at http://minecraftin.herokuapp.com/"
			  $(sudo /sbin/shutdown -P +1)
            fi
		fi
	fi
else
	/usr/bin/logger "Screen does not exist briefly waiting before trying again"
	/usr/bin/logger "Running overviewer from autoshutdown"
	if ! ps ax | grep -v grep | grep $SERVICE > /dev/null; then
          /bin/bash /home/ubuntu/minecraftin/runOverviewer.sh
          /bin/bash /home/ubuntu/minecraftin/backup_server.sh true
          if [[ -f "overviewer.lock" ]]; then
            /usr/bin/logger "Overviewer run currently in progress, waiting for the run to finish before shutting down."
            exit
          elif [[ -f "backup.lock" ]]; then
            /usr/bin/logger "Server backup currently in progress, waiting for the run to finish before shutting down."
            exit
          else
            $(screen -S minecraft -p 0 -X stuff "say Server powering down. ^M")
            /usr/bin/python3 /home/ubuntu/minecraftin/sendMessage.py "Server shutting down. Restart it at http://minecraftin.herokuapp.com/"
            $(sudo /sbin/shutdown -P +1)
          fi
	fi
fi
