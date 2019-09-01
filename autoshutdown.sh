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
			/usr/bin/python3 /home/ubuntu/minecraftin/sendMessage.py "Server shutting down. Restart it at http://minecraftin.herokuapp.com/"
			/bin/bash /home/ubuntu/minecraftin/runOverviewer.sh
			#$(sudo /sbin/shutdown -P +1)
		fi
	fi
else
	/usr/bin/logger "Screen does not exist briefly waiting before trying again"
	/usr/bin/logger "Running overviewer from autoshutdown"
	if ! ps ax | grep -v grep | grep $SERVICE > /dev/null; then
		/usr/bin/logger "Screen does not exist, shutting down"
		/usr/bin/python3 /home/ubuntu/minecraftin/sendMessage.py "Server shutting down. Restart it at http://minecraftin.herokuapp.com/"
		/bin/bash /home/ubuntu/minecraftin/runOverviewer.sh
		#$(sudo /sbin/shutdown -P +1)
	fi
fi
