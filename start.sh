#!/bin/bash
if [[ -f "/home/ubuntu/minecraftin/server.lock" ]]; then
  echo "The server is currently running."
  exit
fi

source /home/ubuntu/minecraftin/secret.conf
source /home/ubuntu/minecraftin/mem.conf

touch /home/ubuntu/minecraftin/server.lock
/bin/bash /home/ubuntu/minecraftin/msg_all_outputs.sh "Server starting."

sleep 20s

/bin/rm -rf /home/ubuntu/world
/usr/bin/aws s3 cp s3://$BUCKET/minecraftin_backups/$current-backup.tar.gz /home/ubuntu/
cd /home/ubuntu
/bin/tar xzf /home/ubuntu/latest_backup.tar.gz 

cd /home/ubuntu/minecraftin/
/bin/bash create_new_alias.sh
cd /home/ubuntu
export SCREENDIR=/home/ubuntu/screens/
chmod 700 /home/ubuntu/screens/
/usr/bin/screen -dmS minecraft /bin/bash -c "/usr/bin/sudo /usr/bin/java -Xmx$MEMORY -Xms$MEMORY -jar /home/ubuntu/fabric-server-launch.jar nogui"
