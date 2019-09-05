#!/bin/bash
if [[ -f "/home/ubuntu/minecraftin/server.lock" ]]; then
  echo "The server is currently running."
  exit
fi

touch /home/ubuntu/minecraftin/server.lock
/bin/bash /home/ubuntu/minecraftin/msg_all_outputs.sh "Server starting."

sleep 20s

/bin/rm -rf /home/ubuntu/world
/usr/bin/wget -P /home/ubuntu/ https://s3.amazonaws.com/lhoffl.com/minecraftin_backups/latest_backup.tar.gz
cd /home/ubuntu
/bin/tar xzf /home/ubuntu/latest_backup.tar.gz 

cd /home/ubuntu/minecraftin/
/bin/bash create_new_alias.sh
cd /home/ubuntu
export SCREENDIR=/home/ubuntu/screens/
chmod 700 /home/ubuntu/screens/
/usr/bin/screen -dmS minecraft /bin/bash -c '/usr/bin/sudo /usr/bin/java -Xmx4096M -Xms4096M -jar /home/ubuntu/fabric-server-launch.jar nogui'

/usr/bin/aws s3 cp s3://lhoffl.com /home/ubuntu/mcmap
