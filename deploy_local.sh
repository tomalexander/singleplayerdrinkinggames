#!/bin/bash
cd frontend
for f in *.dart
do
    dart2js -o${f%.dart}.js --minify $f
done
cd ..

WEB_ROOT="/usr/share/nginx/html"

sudo rsync -rvz --copy-links backend/web_root/* $WEB_ROOT
sudo rsync -rvz --copy-links frontend/*.js frontend/*.html $WEB_ROOT/..
sudo rsync -avz backend/db_functions.php $WEB_ROOT
