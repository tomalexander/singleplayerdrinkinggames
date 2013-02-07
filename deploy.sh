REMOTEUSER="theenablers"
HOST="singleplayerdrinkinggames.com"

rsync -rv backend/web_root/* $REMOTEUSER@$HOST:~/singleplayerdrinkinggames.com
HASH=`git rev-parse HEAD`
USER=`whoami`
DATE=`date`
echo "$HASH    $USER   $DATE" | ssh $REMOTEUSER@$HOST "cat >>  ~/singleplayerdrinkinggames.com/deploy.log" 