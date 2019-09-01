#!/bin/bash


	/usr/bin/logger "running overviewer"
	echo "running overviewer"
	/usr/bin/python3 /home/ubuntu/overviewer.py --checktiles --config=/home/ubuntu/overviewer_conf.py
	/usr/bin/python3 /home/ubuntu/overviewer.py --config /home/ubuntu/overviewer_conf.py --genpoi --skip-players
	/usr/bin/aws s3 sync --delete /home/ubuntu/mcmap/ s3://lhoffl.com/

