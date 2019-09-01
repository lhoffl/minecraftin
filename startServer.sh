#!/bin/bash
/usr/bin/python3 /home/ubuntu/sendMessage.py "Server starting"
sleep 20s
/usr/bin/screen -dmS minecraft /bin/bash -c '/usr/bin/sudo /usr/bin/java -Xmx4096M -Xms4096M -jar /home/ubuntu/fabric-server-launch.jar nogui'
