#!/bin/bash

/usr/bin/python3 /home/ubuntu/minecraftin/sendMessage.py $1
SCREENDIR=/home/ubuntu/screens/
export SCREENDIR=/home/ubuntu/screens/
$(/usr/bin/screen -S minecraft -p 0 -X stuff "say $1 ^M")
/bin/echo $1
/usr/bin/logger $1
