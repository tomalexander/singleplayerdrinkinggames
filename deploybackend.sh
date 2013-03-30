#!/bin/bash
DEBUG=false
HELP=false
while getopts dh option
do
    case "${option}"
        in
        d) DEBUG=true;;
        h) HELP=true;;
    esac
done

if [ $HELP == true ]
then
    echo "Usage: deploy.sh [-h] [-d]"
    echo "   -d: Debug build, does not run minify"
    exit
fi

REMOTEUSER="theenablers"
HOST="singleplayerdrinkinggames.com"

rsync -rvz --copy-links backend/web_root/* $REMOTEUSER@$HOST:~/singleplayerdrinkinggames.com
rsync -avz backend/db_functions.php $REMOTEUSER@$HOST:~/

HASH=`git rev-parse HEAD`
USER=`whoami`
DATE=`date`
echo "$HASH    $USER   $DATE" | ssh $REMOTEUSER@$HOST "cat >>  ~/singleplayerdrinkinggames.com/deploy.log" 
