#!/bin/bash
cd frontend
for f in *.dart
do
    dart2js -o${f%.dart}.js --minify $f
done
cd ..

REMOTEUSER="theenablers"
HOST="singleplayerdrinkinggames.com"

rsync -rvz --copy-links backend/web_root/* $REMOTEUSER@$HOST:~/singleplayerdrinkinggames.com
rsync -rvz --copy-links frontend/*.js frontend/*.html $REMOTEUSER@$HOST:~/singleplayerdrinkinggames.com
rsync -avz backend/db_functions.php $REMOTEUSER@$HOST:~/

HASH=`git rev-parse HEAD`
USER=`whoami`
DATE=`date`
echo "$HASH    $USER   $DATE" | ssh $REMOTEUSER@$HOST "cat >>  ~/singleplayerdrinkinggames.com/deploy.log" 
