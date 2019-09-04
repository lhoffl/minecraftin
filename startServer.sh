#!/bin/bash

cd /home/ubuntu/minecraftin/
git pull
sudo -u ubuntu (crontab -l 2>/dev/null; echo "*/30 * * * * /home/ubuntu/minecraftin/backup_server.sh true") | crontab -
