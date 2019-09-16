#!/bin/bash

cd /home/ubuntu/minecraftin/
git pull | /usr/bin/logger
mv /home/ubuntu/minecraftin/server.properties /home/ubuntu/server.properties
/bin/bash /home/ubuntu/minecraftin/start.sh
