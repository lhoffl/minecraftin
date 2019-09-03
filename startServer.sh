#!/bin/bash
if [[ -f "server.lock" ]]; then
  echo "The server is currently running."
  exit
fi

touch server.lock
/bin/bash msg_all_outputs "Server starting."
sleep 20s
/usr/bin/screen -dmS minecraft /bin/bash -c '/usr/bin/sudo /usr/bin/java -Xmx4096M -Xms4096M -jar /home/ubuntu/fabric-server-launch.jar nogui'
