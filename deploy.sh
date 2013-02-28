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

cd frontend
for f in *.dart
do
    echo $f
    if ! grep -Fq "main()" $f # Only compile dart files that contain main()
    then
        continue
    fi
    if [ $DEBUG == true ]
    then
        dart2js -o${f%.dart}.js $f
    else
        dart2js -o${f%.dart}.js --minify $f
    fi
done
cd ..

REMOTEUSER="theenablers"
HOST="singleplayerdrinkinggames.com"

rsync -rvz --copy-links backend/web_root/* $REMOTEUSER@$HOST:~/singleplayerdrinkinggames.com
rsync -rvz --copy-links frontend/*.js frontend/*.html frontend/*.less frontend/*.css $REMOTEUSER@$HOST:~/singleplayerdrinkinggames.com
rsync -avz backend/db_functions.php $REMOTEUSER@$HOST:~/

HASH=`git rev-parse HEAD`
USER=`whoami`
DATE=`date`
echo "$HASH    $USER   $DATE" | ssh $REMOTEUSER@$HOST "cat >>  ~/singleplayerdrinkinggames.com/deploy.log" 
